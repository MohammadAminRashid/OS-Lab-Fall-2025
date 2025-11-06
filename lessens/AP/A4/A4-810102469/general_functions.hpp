#include "cars.hpp"
#include "workers.hpp"
#include "stages.hpp"
#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <sstream>
#include <limits>

using namespace std;

struct Request {
    string situation;
    int finish_time;
    int car_id;
    int stage_id;
    int worker_id;
};

void get_input(string& input, int& order_number);
void printing_car_arrival(vector<Car>& cars, vector<Worker>& workers, int time);
int find_best_worker(Car car, vector<Worker>& workers);
void add_request(vector<Request>& requests, vector<Car>& cars, vector<Worker>& workers, vector<Stage>& stages, int current_time);
void pass_time(string input, int& pervious_time, int& current_time);
void printing_pass_time(Request last_request, Request next_request, int time);
void update_requests(vector<Request>& requests, vector<Worker>& workers, vector<Car>& cars, vector<Stage>& stages, int pervious_time, int current_time);
void printing_stage_status(vector<Request>& requests, vector<Stage>& stages, string input);
void printing_worker_status(vector<Request>& requests, vector<Worker>& workers, string input);
void printing_car_status(vector<Request>& requests, vector<Car>& cars, string input);
bool errors_handling(vector<Stage>& stages, vector<Worker>& workers, vector<Car>& cars, int order_number, string input);
void handling_orders (vector<Stage>& stages, vector<Worker>& workers, vector<Car>& cars, vector<Request>& requests);
