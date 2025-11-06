#include "client.hpp"

#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <cerrno>
#include <cstring>
#include <string>
#include <vector>
#include <thread>
#include <atomic>

using namespace std;

static int g_udp_sock = -1;
static int g_udp_port = -1;

void die(const char* msg) {
    string err = string("[FATAL] ") + msg + ": " + strerror(errno) + "\n";
    write(STDERR_FILENO, err.c_str(), err.size());
    exit(1);
}

void sendAll(int fd, const string& s) {
    const char* p = s.data();
    size_t left = s.size();
    while (left > 0) {
        ssize_t n = send(fd, p, left, 0);
        if (n < 0) {
            if (errno == EINTR)
                continue;  
            string err = "send failed: " + string(strerror(errno)) + "\n";
            write(STDERR_FILENO, err.c_str(), err.size());
            exit(1);
        }
        left -= static_cast<size_t>(n);
        p += n;
    }
}

void writeAll(int fd, const string& s) {
    const char* p = s.data();
    size_t left = s.size();
    while (left > 0) {
        ssize_t n = write(fd, p, left);
        if (n <= 0) return;
        left -= static_cast<size_t>(n);
        p += n;
    }
}

string recvLine(int fd) {
    string out;
    char ch;
    while (true) {
        ssize_t n = recv(fd, &ch, 1, 0);
        if (n < 0) {
            if (errno == EINTR) continue;   
            return {};                      
        }
        if (n == 0) {
            return {};
        }
        out.push_back(ch);
        if (ch == '\n') {
            return out;            
        }
    }
}

string makeRegisterCmd(const string& role, const string& user, const string& pass) {
    return "REGISTER " + role + " " + user + " " + pass + "\n";
}
string makeLoginCmd(const string& user, const string& pass) {
    return "LOGIN " + user + " " + pass + "\n";
}
string makeAddFlightCmd(const string& fid, const string& orig, const string& dest,
                        const string& timeStr, const string& cols, const string& rows) {
    return "ADD_FLIGHT " + fid + " " + orig + " " + dest + " " +
           timeStr + " " + cols + " " + rows + "\n";
}

string makeListFlightsCmd(void) {
    return "LIST_FLIGHTS\n";
}

string makeReserveCmd(const string& fid, const vector<string>& seats) {
    string cmd = "RESERVE " + fid;
    for (const auto& s : seats) cmd += " " + s;
    cmd.push_back('\n');
    return cmd;
}

string makeConfirmCmd(const string& rid) {
    return "CONFIRM " + rid + "\n";
}

string makeCancelCmd(const string& rid) {
    return "CANCEL " + rid + "\n";
}


void setUdpSocket() {
    g_udp_sock = ::socket(AF_INET, SOCK_DGRAM, 0);
    if (g_udp_sock < 0) 
        die("udp socket");

    sockaddr_in local{};
    local.sin_family = AF_INET;
    local.sin_addr.s_addr = htonl(INADDR_ANY);
    local.sin_port = 0; 

    if (bind(g_udp_sock, (sockaddr*)&local, sizeof(local)) < 0) {
        die("udp bind");
    }

    socklen_t slen = sizeof(local);
    if (getsockname(g_udp_sock, (sockaddr*)&local, &slen) < 0) {
        die("getsockname");
    }
    g_udp_port = ntohs(local.sin_port);
}

void udpRecvLoop(int udp_sock) {
    char buf[2048];
    while (true) {
        sockaddr_in from{};
        socklen_t flen = sizeof(from);
        ssize_t n = recvfrom(udp_sock, buf, sizeof(buf)-1, 0, (sockaddr*)&from, &flen);
        if (n < 0) {
            if (errno == EINTR) continue;
            continue;
        }
        buf[n] = '\0';
        string s = string("BROADCAST ") + buf;
        writeAll(STDOUT_FILENO, s);
    }
}

bool starts_with(const string& s, const char* pfx) {
    size_t L = strlen(pfx);
    return s.size() >= L && memcmp(s.data(), pfx, L) == 0;
}

void interactiveLoop(int fd) {
    string line;
    char buf[1];

    while (true) {
        line.clear();

        while (true) {
            ssize_t n = read(STDIN_FILENO, buf, 1);
            if (n < 0) {
                if (errno == EINTR) continue;
                writeAll(STDERR_FILENO, "read failed\n");
                return;
            }
            if (n == 0) { 
                writeAll(STDOUT_FILENO, "\nEOF\n");
                return;
            }
            char c = buf[0];
            if (c == '\n') 
                break;
            line.push_back(c);
        }

        if (line.empty()) 
            continue;
        if (line == "exit") 
            break;

        line.push_back('\n');

        sendAll(fd, line);

        if (line == "LIST_FLIGHTS\n") {
            while (true) {
                string resp = recvLine(fd);
                if (resp.empty()) {
                    writeAll(STDERR_FILENO, "server closed connection\n");
                    return;
                }
                if (resp == "END_OF_LIST\n") {
                    break;
                }
                writeAll(STDOUT_FILENO, resp);
            }
        } else {
            string resp = recvLine(fd);
            if (resp.empty()) {
                writeAll(STDERR_FILENO, "server closed connection\n");
                break;
            }
            writeAll(STDOUT_FILENO, resp);

            if (starts_with(line, "LOGIN ") && resp == "LOGIN OK\n") {
                string setUdp = "SET_UDP " + to_string(g_udp_port) + "\n";
                sendAll(fd, setUdp);
                string r2 = recvLine(fd);
                if (!r2.empty() && r2.rfind("ERROR", 0) == 0) 
                    writeAll(STDOUT_FILENO, r2);
            }
        }
    }
}

int main(int argc, char* argv[]) {
    if (argc < 3) {
        return 1;
    }

    const char* serverIp = argv[1];
    int port = stoi(argv[2]);

    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) die("socket");

    sockaddr_in addr {};
    addr.sin_family = AF_INET;
    addr.sin_port   = htons(static_cast<uint16_t>(port));
    if (inet_pton(AF_INET, serverIp, &addr.sin_addr) != 1) {
        die("inet_pton");
    }
    if (connect(fd, reinterpret_cast<sockaddr*>(&addr), sizeof(addr)) < 0)
        die("connect");

    string msg = "Connected to " + string(serverIp) + ":" + to_string(port) + "\n";
    writeAll(STDOUT_FILENO, msg);

    setUdpSocket();
    thread(udpRecvLoop, g_udp_sock).detach();

    if (argc == 7 && string(argv[3]) == "register") {
        string role = argv[4], uname = argv[5], pass = argv[6];
        string cmd = makeRegisterCmd(role, uname, pass);
        return 0;
    }

    if (argc == 6 && string(argv[3]) == "login") {
        string uname = argv[4], pass = argv[5];
        string cmd = makeLoginCmd(uname, pass);
        string resp = recvLine(fd);

        if (resp == "LOGIN OK\n") {
            string setUdp = "SET_UDP " + to_string(g_udp_port) + "\n";
            sendAll(fd, setUdp);
            string r2 = recvLine(fd);
            if (!r2.empty() && r2.rfind("ERROR", 0) == 0) 
                writeAll(STDOUT_FILENO, r2);
        }
        close(fd);
        return 0;
    }

    if (argc == 10 && string(argv[3]) == "addflight") {
        string fid = argv[4], orig = argv[5], dest = argv[6], t = argv[7], cols = argv[8], rows = argv[9];
        string cmd = makeAddFlightCmd(fid, orig, dest, t, cols, rows);
        return 0;
    }

    if (argc == 4 && string(argv[3]) == "listflights") {
        string cmd = makeListFlightsCmd();
        return 0;
    }

    if (argc >= 6 && string(argv[3]) == "reserve") {
        string fid = argv[4];
        vector<string> seats;
        for (int i = 5; i < argc; ++i) seats.push_back(argv[i]);
        string cmd = makeReserveCmd(fid, seats);
        return 0;
    }

    if (argc == 5 && string(argv[3]) == "confirm") {
        string rid = argv[4];
        string cmd = makeConfirmCmd(rid);
        return 0;
    }

    if (argc == 5 && string(argv[3]) == "cancel") {
        string rid = argv[4];
        string cmd = makeCancelCmd(rid);
        return 0;
    }

    interactiveLoop(fd);
    close(fd);
    return 0;
}