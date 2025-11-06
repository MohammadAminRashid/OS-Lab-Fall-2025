#pragma once
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

using namespace std;

struct Flight {
    string id;
    string origin;
    string destination;
    string time;      
    string columns;     
    string rows;          
    vector <string> reserved; 
};

extern unordered_map<string, Flight> g_flights;

string handleAddFlight(const vector<string>& tok);
