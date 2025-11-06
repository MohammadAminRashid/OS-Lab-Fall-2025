#include "general_functions.hpp"
#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <sstream>
#include <limits>

using namespace std;

const string ERROR_MESSAGE = "NOT FOUND"; 
const string FIRST_CONDITION = "Queue";
const string SECOND_CONDITION = "Stage";
const string THIRD_CONDITION = "Done";
const string FIRST_ORDER = "pass_time";
const string SECOND_ORDER = "car_arrival";
const string THIRD_ORDER = "get_stage_status";
const string FORTH_ORDER = "get_worker_status";
const string FIFTH_ORDER = "get_car_status";

void get_input(string& input, int& order_number)
{
    input.clear();
    getline(cin, input);
    if (input.empty()) 
        exit(0);
    int pos = input.find(' ');
    string order_type = input.substr(0, pos);
    if (order_type == FIRST_ORDER) 
        order_number = 1;
    if (order_type == SECOND_ORDER) 
        order_number = 2;
    if (order_type == THIRD_ORDER) 
        order_number = 3;
    if (order_type == FORTH_ORDER) 
        order_number = 4;
    if (order_type == FIFTH_ORDER) 
        order_number = 5;
}

void printing_car_arrival(vector<Car>& cars, vector<Worker>& workers, int time)
{
    int requested_stage = cars.back().getStagesId()[0];
    for (int i = 0 ; i < workers.size() ; i++) {
        if (!workers[i].getIsBusy() && workers[i].getStageId() == requested_stage) {
            cout << time << " Car " << cars.back().getId() << ": Arrived -> "  << SECOND_CONDITION << " " << requested_stage << endl;
            return;
        }
    }
    cout << time << " Car " << cars.back().getId() << ": Arrived -> " << FIRST_CONDITION << requested_stage << endl;
}

int find_best_worker(Car car, vector<Worker>& workers)
{
    int requested_stage = car.getStagesId()[0];
    int index = 0;
    bool is_worker_exist = false;
    Worker best_worker(0, 0, 0, false);
    for (int i = 0 ; i < workers.size() ; i++) {
        if (!workers[i].getIsBusy() && workers[i].getStageId() == requested_stage) {
            is_worker_exist = true;
            best_worker = workers[i];
            index = i;
            break;
        }
    }
    for (int i = 0 ; i < workers.size() ; i++) {
        if (!workers[i].getIsBusy() && workers[i].getStageId() == requested_stage && workers[i].getTime() < best_worker.getTime()) {
            is_worker_exist = true;
            best_worker = workers[i];
            index = i;
        }
    }
    
    if (!is_worker_exist)
        return -1;
    
    workers[index].setIsBusy();

    return best_worker.getId();
}

void add_request(vector<Request>& requests, vector<Car>& cars, vector<Worker>& workers, vector<Stage>& stages, int current_time)
{
   Request request;
   request.car_id = cars.back().getId();
   request.worker_id = find_best_worker(cars.back(), workers);
   request.stage_id = cars.back().getStagesId()[0];

    if (request.worker_id == -1) {
        request.finish_time = -1;
        request.situation = FIRST_CONDITION;
    }
    else {
        int time_to_finish;
        for (Worker worker : workers) {
                if (worker.getId() == request.worker_id) 
                    time_to_finish = worker.getTime();
        }

        request.finish_time = current_time + time_to_finish;
        request.situation = SECOND_CONDITION;
    }
    requests.push_back(request);
}

void pass_time(string input, int& pervious_time, int& current_time)
{
    int digit_pos = input.find(' ') + 1;
    pervious_time = current_time;
    current_time += stoi(input.substr(digit_pos));
}

void printing_pass_time(Request last_request, Request next_request, int time)
{
    if (next_request.situation == THIRD_CONDITION)
        cout << time << " Car " << next_request.car_id << ": " << last_request.situation << " " << last_request.stage_id << " -> " << next_request.situation << endl;
    else
        cout << time << " Car " << next_request.car_id << ": " << last_request.situation << " " << last_request.stage_id << " -> " << next_request.situation << " " << next_request.stage_id << endl;
}

void update_requests(vector<Request>& requests, vector<Worker>& workers, vector<Car>& cars, vector<Stage>& stages, int pervious_time, int current_time)
{
    pervious_time = pervious_time + 1;
    while (pervious_time <= current_time) {
        int requests_number = requests.size();
        for (int i = 0; i < requests_number; i++) {
            if (requests[i].situation == THIRD_CONDITION)
                continue;

            if (requests[i].situation == SECOND_CONDITION && requests[i].finish_time == pervious_time) {
                Request unupdated_request = requests[i];
                int woeker_id = requests[i].worker_id;
                int worker_index = finding_worker_from_id(workers, woeker_id);
                workers[worker_index].setIsFree();
                int stage_id = requests[i].stage_id;
                int stage_index = finding_stage_from_id(stages, stage_id);
                stages[stage_index].set_washed_cars();
                int car_id = requests[i].car_id;
                int car_index = finding_car_from_id(cars, car_id);
                cars[car_index].removeFirstStage();

                if (cars[car_index].isStagesEmpty()) {
                    requests[i].situation = THIRD_CONDITION;
                    printing_pass_time(unupdated_request, requests[i], pervious_time);
                    continue;
                }
                int new_worker_id = find_best_worker(cars[car_index], workers);
                if (new_worker_id == -1) {
                    requests[i].situation = FIRST_CONDITION;
                    requests[i].stage_id = cars[car_index].getStagesId()[0];
                    printing_pass_time(unupdated_request, requests[i], pervious_time);
                    continue;
                }
                requests[i].stage_id = cars[car_index].getStagesId()[0];
                requests[i].worker_id = new_worker_id;
                requests[i].finish_time = pervious_time + workers[finding_worker_from_id(workers, new_worker_id)].getTime();
                printing_pass_time(unupdated_request, requests[i], pervious_time);
            }

            if (requests[i].situation == FIRST_CONDITION) {
                int car_id = requests[i].car_id;
                int car_index = finding_car_from_id(cars, car_id);
                int worker_id = find_best_worker(cars[car_index], workers);
                if (worker_id == -1)
                    continue;
                else {
                    Request unupdated_request = requests[i];
                    requests[i].situation = SECOND_CONDITION;
                    requests[i].worker_id = worker_id;
                    requests[i].finish_time = pervious_time + workers[finding_worker_from_id(workers, worker_id)].getTime();
                    printing_pass_time(unupdated_request, requests[i], pervious_time);
                }
            }
        }
        pervious_time ++;
    }
}

void printing_stage_status(vector<Request>& requests, vector<Stage>& stages, string input)
{
    int requested_stage = stoi(input.substr((input.find(' ') + 1)));
    int stage_index = finding_stage_from_id(stages, requested_stage);
    int counter1 = 0;
    int counter2 = 0;

    for (int i = 0; i < requests.size(); i++) {
        if (requests[i].situation == FIRST_CONDITION && requests[i].stage_id == requested_stage)
            counter1 += 1;
        else if (requests[i].situation == SECOND_CONDITION && requests[i].stage_id == requested_stage)
            counter2 += 1;
    }

    stages[stage_index].set_in_queue_cars(counter1);
    stages[stage_index].set_in_stage_cars(counter2);
    stages[stage_index].set_income();
    stages[stage_index].printing_informations();
}

void printing_worker_status(vector<Request>& requests, vector<Worker>& workers, string input)
{
    int requested_worker = stoi(input.substr((input.find(' ') + 1)));
    int worker_index = finding_worker_from_id(workers, requested_worker);

    for (int i = 0; i < requests.size(); i++) {
        if (requests[i].situation == SECOND_CONDITION && requests[i].worker_id == requested_worker)
            workers[worker_index].set_working_car_id(requests[i].car_id);
    }

    workers[worker_index].printing_information();
}

void printing_car_status(vector<Request>& requests, vector<Car>& cars, string input)
{
    int requested_car = stoi(input.substr((input.find(' ') + 1)));
    int car_index = finding_car_from_id(cars, requested_car);
    for (int i = 0; i < requests.size(); i++) {
        if (requests[i].car_id == requested_car) {
            cars[car_index].set_condition(requests[i].situation);
            cars[car_index].set_stage_id(requests[i].stage_id);
        }
    }
    cars[car_index].printing_information();
}

bool errors_handling(vector<Stage>& stages, vector<Worker>& workers, vector<Car>& cars, int order_number, string input)
{
    if (order_number == 2) {
        vector<int> requested_stages = specify_requested_stages(input);
        for (int i = 0; i < requested_stages.size(); i++) {
            if (finding_stage_from_id(stages, requested_stages[i]) == -1) {
                cout << ERROR_MESSAGE << endl;
                return true;
            }
        }
    }
    else if (order_number == 3) {
        int requested_stage = stoi(input.substr((input.find(' ') + 1)));
        if (finding_stage_from_id(stages, requested_stage) == -1) {
            cout << ERROR_MESSAGE << endl;
            return true;
        }
    }
    else if (order_number == 4) {
        int requested_worker = stoi(input.substr((input.find(' ') + 1)));
        if (finding_worker_from_id(workers, requested_worker) == -1) {
            cout << ERROR_MESSAGE << endl;
            return true;
        }
    }
    else if (order_number == 5) {
        int requested_car = stoi(input.substr((input.find(' ') + 1)));
        if (finding_car_from_id(cars, requested_car) == -1) {
            cout << ERROR_MESSAGE << endl;
            return true;
        }
    }
    return false;
}

void handling_orders (vector<Stage>& stages, vector<Worker>& workers, vector<Car>& cars, vector<Request>& requests)
{
        int pervious_time = 0;
        int current_time = 0;
        string input;
        int order_number;

    while (true) {
        get_input(input, order_number);
        if (errors_handling(stages, workers, cars, order_number, input))
            continue;
        switch (order_number)
        {
        case 1:
            pass_time(input, pervious_time, current_time);
            update_requests(requests, workers, cars, stages, pervious_time, current_time);
            break;
        case 2:
            add_car(cars, input);
            printing_car_arrival(cars, workers, current_time);
            add_request(requests, cars, workers, stages, current_time);
            break;
        case 3:
            printing_stage_status(requests, stages, input);
            break;
        case 4:
            printing_worker_status(requests, workers, input);
            break;
        case 5:
            printing_car_status(requests, cars, input);
            break;
        }
    }

}