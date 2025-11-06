#pragma once
#include <string>
#include <unordered_map>
#include <netinet/in.h>
#include <vector>

using namespace std;

struct ClientInfo {
    int fd;
    string readBuf;
    string connect_id;
    string username;
};
struct User {
    string username;
    string password;
    string role; 
    bool has_udp = false;
    sockaddr_in udp_addr{};
};

extern unordered_map<string, User> g_users;

void setSigpipeIgnored();
void die(const char* msg);
int createListeningSocket(const char* hostIp, int port);
vector<string> splitTokens(const string& line);
void udp_broadcast_to_role(const string& role, const string& payload);
string dispatchCommand(ClientInfo& c, const string& line);


