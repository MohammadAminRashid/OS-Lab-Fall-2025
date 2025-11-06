#include "cars.hpp"
#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <sstream>
#include <limits>

const string FIRST_CONDITION = "Queue";
const string SECOND_CONDITION = "Stage";
const string THIRD_CONDITION = "Done";

using namespace std;

Car:: Car(int id, vector<int>& stages_id) {
    this->id = id;
    this->stages_id = stages_id;
}
int Car:: getId() {
    return id;
}
vector<int>& Car:: getStagesId() {
    return stages_id;
}
void Car:: removeFirstStage() {
    if (!stages_id.empty()) {
        stages_id.erase(stages_id.begin());
    }
}
bool Car:: isStagesEmpty() {
    if (stages_id.empty())
        return true;
    else
        return false;
}
void Car:: set_stage_id(int id) {
    stage_id = id;
}
void Car:: set_condition(string str) {
    condition = str;
}
void Car:: printing_information() {
    if (condition == THIRD_CONDITION)
        cout << condition << endl;
    if (condition == SECOND_CONDITION) {
        condition = "In service";
        cout << condition << ": " << stage_id << endl;
    }
    if (condition == FIRST_CONDITION) {
        condition = "In line";
        cout << condition << ": " << stage_id << endl;
    }
}

vector<int> specify_requested_stages(string input)
{
    stringstream ss;
    ss << input;
    char ch;
    int number;
    vector<int> numbers;
    while (ss.get(ch)) {
        if (isdigit(ch)) {
            ss.unget();
            ss >> number;
            numbers.push_back(number);
        }
    }
    return numbers;
}

void add_car(vector<Car>& cars, string input)
{
    int id = cars.size() + 1;
    vector<int> stages_id;

    stages_id = specify_requested_stages(input);

    cars.push_back(Car(id, stages_id));

}

int finding_car_from_id(vector<Car>& cars, int id)
{
    for (int i = 0; i < cars.size(); i++) {
        if (id == cars[i].getId())
            return i;
    }
    return -1;
}