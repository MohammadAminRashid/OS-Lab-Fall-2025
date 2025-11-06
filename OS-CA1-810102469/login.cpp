#include "login.hpp"
#include "server.hpp"

#include <unordered_map>
#include <string>

using namespace std;

string handleLogin(const vector<string>& tok) {
    if (tok.size() != 3) {
        return "ERROR Usage: LOGIN <username> <password>\n";
    }
    string uname = tok[1];
    string pass  = tok[2];

    auto requested_user = g_users.find(uname);
    if (requested_user == g_users.end()) {
        return "ERROR UserNotFound\n";
    }
    if (requested_user->second.password != pass) {
        return "ERROR InvalidPassword\n";
    }
    return "LOGIN OK\n";
}