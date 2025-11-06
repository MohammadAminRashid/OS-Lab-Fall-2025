#include "register.hpp"
#include "server.hpp"

#include <unordered_map>
#include <string>

using namespace std;


string handleRegister(const vector<string>& tok) {
    if (tok.size() != 4) {
        return "ERROR Usage: REGISTER <role> <username> <password>\n";
    }
    const string& role  = tok[1];
    const string& uname = tok[2];
    const string& pass  = tok[3];

    if (g_users.count(uname)) {
        return "ERROR UsernameAlreadyExists\n";
    }

    g_users[uname] = User{uname, pass, role};

    return "REGISTERED OK\n";
}
