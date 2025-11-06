#include "general_functions.hpp"
#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <sstream>
#include <limits>

using namespace std;

int main(int argc, char* argv[]) {
    const string stagesFile = argv[1];
    const string workersFile = argv[2];

    vector<string> stages_lines;
    vector<string> workers_lines;
    converting_stages_file_to_vector(stages_lines, stagesFile);
    converting_workers_file_to_vector(workers_lines, workersFile);

    vector<Stage> stages;
    create_stages(stages_lines, stages);

    vector<Worker> workers;
    create_workers(workers_lines, workers);

    vector<Car> cars;
    vector<Request> requests;
    handling_orders(stages, workers, cars, requests);
}