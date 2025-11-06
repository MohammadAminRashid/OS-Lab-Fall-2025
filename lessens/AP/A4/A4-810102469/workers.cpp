#include "workers.hpp"
#include <iostream>
#include <vector>
#include <fstream>
#include <string>

const string FILE_ERROR = "Unable to open file: ";

using namespace std;

Worker::Worker(int id, int stage_id, int time_to_finish, bool is_busy = false) {
    this->id = id;
    this->stage_id = stage_id;
    this->time_to_finish = time_to_finish;
    this->is_busy = is_busy;
}

int Worker:: getId() {
    return id;
}
int Worker:: getStageId() {
    return stage_id;
}
int Worker:: getTime() {
    return time_to_finish;
}
bool Worker:: getIsBusy() {
    return is_busy;
}
void Worker:: setIsBusy() {
    is_busy = true;
}
void Worker:: setIsFree() {
    is_busy = false;
}
void Worker:: set_working_car_id(int id) {
    working_car_id = id;
}
void Worker:: printing_information() {
    if (!is_busy)
        cout << "Idle" << endl;
    else 
        cout << "Working: " << working_car_id << endl;
}

void converting_workers_file_to_vector(vector<string> &workers,const string workersFile)
{
    ifstream file(workersFile);
    if (!file.is_open())
    {
        cerr << FILE_ERROR << workersFile << endl;
        return;
    }

    string header;
    getline(file, header);

    string worker;
    while (getline(file, worker))
    {
        workers.push_back(worker);
    }

    file.close();
}

void create_workers(vector<string>& workers_lines, vector<Worker>& workers)
{
    for (string workerInfo : workers_lines) {
        int pos1 = workerInfo.find(',');
        int pos2 = workerInfo.find(',', pos1 + 1);
        int pos3 = workerInfo.rfind(',');
        string idStr = workerInfo.substr(0, pos1);
        string stage_idStr = workerInfo.substr(pos1 + 1, pos2 - pos1 - 1);
        string timeStr = workerInfo.substr(pos2 + 1, pos3 - pos2 - 1);
        int id = stoi(idStr);
        int stage_id = stoi(stage_idStr);
        int time_to_finish = stoi(timeStr);
        workers.push_back(Worker(id, stage_id, time_to_finish));
    }
}

int finding_worker_from_id(vector<Worker>& workers, int id)
{
    for (int i = 0; i < workers.size(); i++) {
        if (id == workers[i].getId())
            return i;
    }
    return -1;
}