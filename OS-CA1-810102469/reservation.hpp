#pragma once
#include <string>
#include <vector>

using namespace std;

string handleReserve(const vector<string>& tok);
string handleConfirm(const vector<string>& tok);
string handleCancel(const vector<string>& tok);

void reservations_init();
void reservations_tick();  