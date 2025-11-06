#include "list_flights.hpp"
#include "add_flight.hpp"  

#include <unordered_map>
#include <sstream>
#include <iostream>
#include <string>

using namespace std;


string handleListFlights(const vector<string>& tok) {
    if (tok.size() != 1) {
        return "ERROR Usage: LIST_FLIGHTS\n";
    }

    ostringstream out;

    for (auto& kv : g_flights) {
        Flight& flight = kv.second;

        int cols = flight.columns[0] - 'A' + 1;
        int rows = stoi(flight.rows);
        int total = rows * cols;
        int free = total - flight.reserved.size();

        out << "FLIGHT " << flight.id << ' ' << flight.origin << ' ' << flight.destination << ' ' << flight.time << ' ' << "SEATS_AVAILABLE=" << free << "/" << total << "\n";
    }

    out << "END_OF_LIST\n";
    return out.str();
}