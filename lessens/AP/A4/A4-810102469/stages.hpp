#include <iostream>
#include <vector>
#include <fstream>
#include <string>

using namespace std;

class Stage {
public:
    Stage(int id, int price, int washed_cars, int in_queue_cars, int in_stage_cars, long income);
    int getId();
    int getPrice();
    void set_washed_cars();
    void set_in_queue_cars(int num);
    void set_in_stage_cars(int num);
    void set_income();
    void printing_informations();
private:
    int id;
    int price;
    int washed_cars;
    int in_queue_cars;
    int in_stage_cars;
    long income;
};

void converting_stages_file_to_vector(vector<string> &stages,const string stagesFile);
void create_stages(vector<string>& stages_lines, vector<Stage>& stages);
int finding_stage_from_id(vector<Stage>& stages, int id);