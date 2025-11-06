#include "stages.hpp"
#include <iostream>
#include <vector>
#include <fstream>
#include <string>

const string FILE_ERROR = "Unable to open file: ";

using namespace std;

Stage::Stage(int id, int price, int washed_cars = 0, int in_queue_cars = 0, int in_stage_cars = 0, long income = 0) {
    this->id = id;
    this->price = price;
    this->washed_cars = washed_cars;
    this->in_queue_cars = in_queue_cars;
    this->in_stage_cars = in_stage_cars;
    this->income = income;
}
int Stage:: getId() {
    return id;
}
int Stage::getPrice() {
    return price;
}
void Stage::set_washed_cars() {
    washed_cars = washed_cars + 1;
}
void Stage::set_in_queue_cars(int num) {
    in_queue_cars = num;
}
void Stage::set_in_stage_cars(int num) {
    in_stage_cars = num;
}
void Stage::set_income() {
    income = washed_cars * price;
}
void Stage::printing_informations() {
    cout << "Number of washed cars: " << washed_cars << endl;
    cout << "Number of cars in queue: " << in_queue_cars << endl;
    cout << "Number of cars being washed: " << in_stage_cars << endl;
    cout << "Income: " << income << endl;
}

void converting_stages_file_to_vector(vector<string> &stages,const string stagesFile)
{
    ifstream file(stagesFile);
    if (!file.is_open())
    {
        cerr << FILE_ERROR << stagesFile << endl;
        return;
    }

    string header;
    getline(file, header);

    string stage;
    while (getline(file, stage))
    {
        stages.push_back(stage);
    }

    file.close();
}

void create_stages(vector<string>& stages_lines, vector<Stage>& stages)
{
    for (string stageInfo : stages_lines) {
        int pos = stageInfo.find(',');
        string idStr = stageInfo.substr(0, pos);
        string priceStr = stageInfo.substr(pos + 1);
        int id = stoi(idStr);
        int price = stoi(priceStr);
        stages.push_back(Stage(id, price));
    }
}

int finding_stage_from_id(vector<Stage>& stages, int id)
{
    for (int i = 0; i < stages.size(); i++) {
        if (id == stages[i].getId())
            return i;
    }
    return -1;
}
