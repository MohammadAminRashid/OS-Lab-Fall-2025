#include <iostream>
#include <vector>
#include <fstream>
#include <string>

using namespace std;

class Car {
public:
    Car(int id, vector<int>& stages_id);
    int getId();
    vector<int>& getStagesId();
    void removeFirstStage();
    bool isStagesEmpty();
    void set_stage_id(int id);
    void set_condition(string str);
    void printing_information();
private:
    int id;
    vector<int> stages_id;
    int stage_id;
    string condition;
};

vector<int> specify_requested_stages(string input);
void add_car(vector<Car>& cars, string input);
int finding_car_from_id(vector<Car>& cars, int id);