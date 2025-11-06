#include "add_flight.hpp"
#include "server.hpp"

#include <sstream>

using namespace std;

unordered_map<string, Flight> g_flights;

string handleAddFlight(const vector<string>& tok) {
    if (tok.size() != 7) {
        return "ERROR Usage: ADD_FLIGHT <flight_id> <origin> <destination> <time> <column_count> <row_count>\n";
    }

    string fid  = tok[1];
    string orig = tok[2];
    string dest = tok[3];
    string t = tok[4];
    string cols = tok[5];
    string rows = tok[6];


    if (g_flights.count(fid))                    
        return "ERROR FlightAlreadyExists\n";

    Flight f;
    f.id = fid;
    f.origin = orig;
    f.destination = dest;
    f.time = t;
    f.columns = cols;
    f.rows = rows;

    g_flights.emplace(fid, move(f));


    return "FLIGHT_ADDED OK\n";
}