#include <iostream>
#include <vector>
#include <fstream>
#include <string>

using namespace std;

class Worker {
public:
    Worker(int id, int stage_id, int time_to_finish, bool is_busy);
    int getId();
    int getStageId();
    int getTime();
    bool getIsBusy();
    void setIsBusy();
    void setIsFree();
    void set_working_car_id(int id);
    void printing_information();
private:
    int id;
    int stage_id;
    int time_to_finish;
    bool is_busy;
    int working_car_id;
};

void converting_workers_file_to_vector(vector<string> &workers,const string workersFile);
void create_workers(vector<string>& workers_lines, vector<Worker>& workers);
int finding_worker_from_id(vector<Worker>& workers, int id);
