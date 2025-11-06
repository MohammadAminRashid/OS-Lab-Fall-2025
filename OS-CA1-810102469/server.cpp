#include "server.hpp"
#include "register.hpp"
#include "login.hpp"
#include "add_flight.hpp"
#include "list_flights.hpp"
#include "reservation.hpp"

#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#include <cerrno>
#include <csignal>
#include <cstring>
#include <cstdlib>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

using namespace std;


unordered_map<string, User> g_users;
unordered_map<int, ClientInfo> clients;

int g_udp_sock = -1;


void writeAll(int fd, const string& s) {
    const char* p = s.data();
    size_t left = s.size();
    while (left > 0) {
        ssize_t n = write(fd, p, left);
        if (n < 0) {
            if (errno == EINTR) continue;
            string err = string("[FATAL] write: ") + strerror(errno) + "\n";
            ::write(STDERR_FILENO, err.c_str(), err.size());
            exit(1);
        }
        left -= n;
        p += n;
    }
}

void die(const char* msg) {
    string err = string("[FATAL] ") + msg + ": " + strerror(errno) + "\n";
    writeAll(STDERR_FILENO, err);
    exit(1);
}

void setSigpipeIgnored() {
    signal(SIGPIPE, SIG_IGN);
}

int createListeningSocket(int port) {
    int listenFd = socket(AF_INET, SOCK_STREAM, 0);
    if (listenFd < 0) 
        die("socket");

    int yes = 1;
    if (setsockopt(listenFd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) < 0)
        die("setsockopt(SO_REUSEADDR)");

    sockaddr_in addr {};
    addr.sin_family = AF_INET;
    addr.sin_port   = htons((uint16_t)port);

    addr.sin_addr.s_addr = htonl(INADDR_ANY);

    if (bind(listenFd, (sockaddr*)&addr, sizeof(addr)) < 0)
        die("bind");

    if (listen(listenFd, SOMAXCONN) < 0)
        die("listen");

    return listenFd;
}

vector<string> splitTokens(const string& line) {
    istringstream iss(line);
    vector<string> toks;
    string t;
    while (iss >> t) 
        toks.push_back(t);
    return toks;
}

void udp_broadcast_to_role(const string& role, const string& payload) {
    for (auto &kv : g_users) {
        User &u = kv.second;
        if (!u.has_udp) 
            continue;
        if (u.role != role) 
            continue;
        sendto(g_udp_sock, payload.c_str(), payload.size(), 0,
               (const sockaddr*)&u.udp_addr, sizeof(u.udp_addr));
    }
}

string dispatchCommand(ClientInfo& c, const string& line) {
    auto tok = splitTokens(line);
    if (tok.empty()) 
        return "ERROR EmptyCommand\n";

    const string& cmd = tok[0];

    if (cmd == "REGISTER") {
        return handleRegister(tok);
    }

    if (cmd == "LOGIN") {
        string reply = handleLogin(tok);
        if (reply == "LOGIN OK\n" && tok.size() >= 2) {
            c.username = tok[1];

            auto it = g_users.find(c.username);
            string roll = it->second.role;
            string payload = "NEW_USER " + c.username + " " + roll + "\n";
            udp_broadcast_to_role("airline", payload);
        }
        return reply;
    }

    if (cmd == "SET_UDP") {
        if (c.username.empty()) {
            return "ERROR NotLoggedIn\n";
        }

        int port = stoi(tok[1]);

        sockaddr_in peer{};
        socklen_t plen = sizeof(peer);
        if (getpeername(c.fd, (sockaddr*)&peer, &plen) < 0) {
            return "ERROR GetPeerFailed\n";
        }

        auto it = g_users.find(c.username);
        if (it == g_users.end()) {
            return "ERROR NotLoggedIn\n";
        }

        sockaddr_in addr{};
        addr.sin_family = AF_INET;
        addr.sin_addr = peer.sin_addr;
        addr.sin_port = htons((uint16_t)port);

        it->second.udp_addr = addr;
        it->second.has_udp = true;

        return "SET_UDP OK\n";
    }

    if (cmd == "ADD_FLIGHT") {
        if (c.username.empty()) 
            return "ERROR NotLoggedIn\n";

        auto itUser = g_users.find(c.username);
        if (itUser == g_users.end()) 
            return "ERROR NotLoggedIn\n";
        if (itUser->second.role != "airline") 
            return "ERROR Forbidden\n";

        string reply = handleAddFlight(tok);

        if (reply == "FLIGHT_ADDED OK\n" && tok.size() >= 7) {
            string payload = "NEW_FLIGHT " + tok[1] + " " + tok[2] + " " + tok[3] + " " + tok[4] + "\n";
            udp_broadcast_to_role("customer", payload);
        }

        return reply;
    }

    if (cmd == "LIST_FLIGHTS") {
        return handleListFlights(tok);
    }

    if (cmd == "RESERVE") {
        if (c.username.empty())
            return "ERROR NotLoggedIn\n";

        auto itUser = g_users.find(c.username);
        if (itUser == g_users.end())
            return "ERROR NotLoggedIn\n";
        if (itUser->second.role != "customer")
            return "ERROR Forbidden\n";
        return handleReserve(tok);
    }

    if (cmd == "CONFIRM") {
        if (c.username.empty())
            return "ERROR NotLoggedIn\n";

        auto itUser = g_users.find(c.username);
        if (itUser == g_users.end())
            return "ERROR NotLoggedIn\n";
        if (itUser->second.role != "customer")
            return "ERROR Forbidden\n";
        return handleConfirm(tok);
    }

    if (cmd == "CANCEL") {
        if (c.username.empty())
            return "ERROR NotLoggedIn\n";

        auto itUser = g_users.find(c.username);
        if (itUser == g_users.end())
            return "ERROR NotLoggedIn\n";
        if (itUser->second.role != "customer")
            return "ERROR Forbidden\n";
        return handleCancel(tok);
    }

    return "ERROR UnknownCommand\n";
}

int main(int argc, char* argv[]) {
    if (argc < 3) {
        return 1;
    }
    const char* hostIp = argv[1];
    int port = stoi(argv[2]);

    setSigpipeIgnored();

    int listenFd = createListeningSocket(port);
    string info = "Server listening on " + string(hostIp) + ":" + to_string(port) + "\n";
    writeAll(STDOUT_FILENO, info);

    g_udp_sock = ::socket(AF_INET, SOCK_DGRAM, 0);
    if (g_udp_sock < 0) die("udp socket");

    reservations_init();

    while (true) {
        fd_set readfds;
        FD_ZERO(&readfds);
        FD_SET(listenFd, &readfds);
        int maxfd = listenFd;

        for (const auto& kv : clients) {
            FD_SET(kv.first, &readfds);
            if (kv.first > maxfd) maxfd = kv.first;
        }

        int ready = select(maxfd + 1, &readfds, nullptr, nullptr, nullptr);
        if (ready < 0) {
            if (errno == EINTR) {
                reservations_tick();
                continue;
            }
            die("select");
        }

        reservations_tick();

        if (FD_ISSET(listenFd, &readfds)) {
            sockaddr_in cliAddr {};
            socklen_t len = sizeof(cliAddr);
            int cliFd = accept(listenFd, (sockaddr*)&cliAddr, &len);

            char ipstr[INET_ADDRSTRLEN] = {0};
            inet_ntop(AF_INET, &cliAddr.sin_addr, ipstr, sizeof(ipstr));
            int cport = ntohs(cliAddr.sin_port);
            string connect_id = string(ipstr) + ":" + to_string(cport);
            clients.emplace(cliFd, ClientInfo{cliFd, "", connect_id, ""});

            string msg = "New client fd=" + to_string(cliFd) + " id=" + connect_id + "\n";
            writeAll(STDOUT_FILENO, msg);
        }

        vector<int> toClose;
        for (auto& kv : clients) {
            int cfd = kv.first;
            ClientInfo& c = kv.second;
            if (!FD_ISSET(cfd, &readfds)) continue;

            char buf[4096];
            ssize_t n = recv(cfd, buf, sizeof(buf), 0);
            if (n <= 0) {
                toClose.push_back(cfd);
                continue;
            }

            c.readBuf.append(buf, (size_t)n);

            size_t pos;
            while ((pos = c.readBuf.find('\n')) != string::npos) {
                string line = c.readBuf.substr(0, pos);
                c.readBuf.erase(0, pos + 1);
                if (!line.empty() && line.back() == '\r') line.pop_back();

                string reply = dispatchCommand(c, line);
                send(cfd, reply.c_str(), reply.size(), 0);
            }
        }

        for (int fd : toClose) {
            close(fd);
            clients.erase(fd);
        }
    }

    close(listenFd);
    return 0;
}