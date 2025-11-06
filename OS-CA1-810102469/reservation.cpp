#include "reservation.hpp"
#include "add_flight.hpp"

#include <algorithm>
#include <cctype>
#include <ctime>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <signal.h>
#include <unistd.h>
#include <atomic>

using namespace std;

struct TempReservation {
    string id;
    string flight_id;
    vector<string> seats;
    time_t expires_at;
};

struct FinalReservation {
    string id;
    string flight_id;
    vector<string> seats;
};

vector<TempReservation> temp_reservations;
vector<FinalReservation> reservations;

static atomic<bool> alarm_fired{false};

Flight* findFlight(const string& fid) {
    auto it = g_flights.find(fid);
    if (it == g_flights.end()) 
        return nullptr;
    return &it->second;
}

void parseSeat(const string& s, char& col, int& row) {
    col = toupper(static_cast<unsigned char>(s[0]));
    row = 0;
    for (int i = 1; i < s.size(); ++i) {
        row = row * 10 + (s[i] - '0');
    }
}

bool seatExistsInFlight(const Flight& flight, const string& seat) {
    char col; 
    int row;
    parseSeat(seat, col, row);
    if (flight.columns.empty()) 
        return false;
    char lastCol = toupper(static_cast<unsigned char>(flight.columns[0]));
    int maxRow = stoi(flight.rows);
    if (!(lastCol >= 'A' && lastCol <= 'Z')) 
        return false;
    if (col < 'A' || col > lastCol) 
        return false;
    if (row < 1 || row > maxRow) 
        return false;

    return true;
}

string newReservationId() {
    static int ctr = 0;
    return to_string(++ctr);
}

void writeSeatsToFlight(Flight& flight, const vector<string>& seats) {
    for (const auto& s : seats) {
        if (find(flight.reserved.begin(), flight.reserved.end(), s) == flight.reserved.end())
            flight.reserved.push_back(s);
    }
}

void eraseSeatsFromFlight(Flight& flight, const vector<string>& seats) {
    for (const auto& seat : seats) {
        auto it = find(flight.reserved.begin(), flight.reserved.end(), seat);
        if (it != flight.reserved.end())
            flight.reserved.erase(it);
    }
}

bool seatsTaken(const string& fid, const vector<string>& seats) {
    unordered_set<string> want(seats.begin(), seats.end());
    for (const auto& r : temp_reservations) {
        if (r.flight_id != fid) 
            continue;
        for (const auto& s : r.seats) 
            if (want.count(s)) 
                return true;
    }
    for (const auto& r : reservations) {
        if (r.flight_id != fid)    
            continue;
        for (const auto& s : r.seats) 
            if (want.count(s)) 
                return true;
    }
    return false;
}

void schedule_next_alarm() {
    if (temp_reservations.empty()) { 
        alarm(0);
        return;
    }
    time_t now = time(nullptr);
    time_t next = 0;
    for (const auto& reserve : temp_reservations) {
        if (next == 0 || reserve.expires_at < next) 
            next = reserve.expires_at;
    }
    unsigned sec;
    if (next > now)
        sec = next - now;
    else 
        sec = 1;

    alarm(sec == 0 ? 1 : sec);
}

void sigalrm_handler(int) {
    alarm_fired.store(true, memory_order_relaxed);
}

void process_expirations() {
    time_t now = time(nullptr);

    for (int i = 0; i < temp_reservations.size(); ) {
        if (temp_reservations[i].expires_at <= now)
            temp_reservations.erase(temp_reservations.begin() + i);
        else
            ++i;
    }

    schedule_next_alarm();
}

void reservations_init() {
    signal(SIGALRM, sigalrm_handler);
    schedule_next_alarm();
}

void reservations_tick() {
    if (alarm_fired.exchange(false)) {
        process_expirations();
    }
}

string handleReserve(const vector<string>& tok) {
    if (tok.size() < 3) 
        return "ERROR Usage: RESERVE <flight_id> <seat...>\n";

    string fid = tok[1];
    vector<string> seats(tok.begin() + 2, tok.end());

    Flight* flight = findFlight(fid);
    if (!flight) 
        return "ERROR FlightNotFound\n";
    for (const auto& s : seats)
        if (!seatExistsInFlight(*flight, s))
            return "ERROR InvalidSeat\n";

    if (seatsTaken(fid, seats)) 
        return "ERROR SeatTaken\n";

    TempReservation tr;
    tr.id = newReservationId();
    tr.flight_id = fid;
    tr.seats = seats;
    tr.expires_at = time(nullptr) + 30;
    temp_reservations.push_back(move(tr));

    schedule_next_alarm();

    ostringstream oss;
    oss << "RESERVED TEMP " << temp_reservations.back().id << " EXPIRES_IN 30\n";
    return oss.str();
}

string handleConfirm(const vector<string>& tok) {
    if (tok.size() != 2) 
        return "ERROR Usage: CONFIRM <reservation_id>\n";
    const string& rid = tok[1];

    for (int i = 0; i < temp_reservations.size(); ++i) {
        if (temp_reservations[i].id == rid) {
            time_t now = time(nullptr);
            if (temp_reservations[i].expires_at <= now) {
                temp_reservations.erase(temp_reservations.begin() + i);
                schedule_next_alarm();
                return "ERROR ReservationExpired\n";
            }
            Flight* flight = findFlight(temp_reservations[i].flight_id);
            if (!flight) {
                temp_reservations.erase(temp_reservations.begin() + i);
                schedule_next_alarm();
                return "ERROR FlightNotFound\n";
            }
            FinalReservation fr;
            fr.id = temp_reservations[i].id;
            fr.flight_id = temp_reservations[i].flight_id;
            fr.seats = temp_reservations[i].seats;

            writeSeatsToFlight(*flight, fr.seats);
            reservations.push_back(move(fr));
            temp_reservations.erase(temp_reservations.begin() + i);

            schedule_next_alarm();
            return "CONFIRMATION OK\n";
        }
    }
    return "ERROR ReservationExpired\n";
}

string handleCancel(const vector<string>& tok) {
    if (tok.size() != 2) 
        return "ERROR Usage: CANCEL <reservation_id>\n";
    const string& rid = tok[1];

    for (int i = 0; i < temp_reservations.size(); ++i) {
        if (temp_reservations[i].id == rid) {
            temp_reservations.erase(temp_reservations.begin() + i);
            schedule_next_alarm();
            return "CANCELLED OK\n";
        }
    }

    for (int i = 0; i < reservations.size(); ++i) {
        if (reservations[i].id == rid) {
            Flight* flight = findFlight(reservations[i].flight_id);
            if (flight) eraseSeatsFromFlight(*flight, reservations[i].seats);
            reservations.erase(reservations.begin() + i);
            return "CANCELLED OK\n";
        }
    }

    return "ERROR ReservationExpired\n";
}