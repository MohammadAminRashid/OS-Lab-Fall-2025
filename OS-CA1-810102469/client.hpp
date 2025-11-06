#pragma once
#include <string>
#include <vector>

using namespace std;

void die(const char* msg);
void sendAll(int fd, const string& s);
string recvLine(int fd);
string makeRegisterCmd(const string& role, const string& user, const string& pass);
string makeLoginCmd(const string& user, const string& pass);
string makeAddFlightCmd(const string& fid, const string& orig, const string& dest, const string& timeStr, const string& cols, const string& rows) ;
string makeReserveCmd(const string& fid, const vector<string>& seats);
string makeConfirmCmd(const string& rid);
string makeCancelCmd(const string& rid);
void interactiveLoop(int fd);
void writeAll(int fd, const string& s);
void setUdpSocket();
void udpRecvLoop(int udp_sock);
bool starts_with(const string& s, const char* pfx);