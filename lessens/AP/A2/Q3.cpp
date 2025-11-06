#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>

using namespace std;

struct Metro
{
    int num_station;
    vector<int> stations;
};

int position_of_number_in_vector(vector<int> a, int n)
{
    for (int i = 0; i < a.size(); i++)
    {
        if (n == a[i])
        {
            return (i + 1);
        }
    }
    return -1;
}

int calculate_time(int station1, int station2, vector<int> solution, vector<Metro> &metros)
{
    int n = solution.size();
    int time = 0;
    time = abs(position_of_number_in_vector(metros[solution[0] - 1].stations, solution[1]) - station1);
    for (int i = 1; i < n - 1; i++)
    {
        time += abs(position_of_number_in_vector(metros[solution[i] - 1].stations, solution[i - 1]) - position_of_number_in_vector(metros[solution[i] - 1].stations, solution[i + 1]));
    }
    time += abs(position_of_number_in_vector(metros[solution[n - 1] - 1].stations, solution[n - 2]) - station2);
    time += 2 * (n - 1);
    return time;
}

void recursive_solve(int line1, int line2, int station1, int station2, vector<Metro> &metros, vector<int> &temp_solution, vector<int> &solution)
{
    temp_solution.push_back(line1);

    if (line1 == line2)
    {
        if (solution.empty() || calculate_time(station1, station2, temp_solution, metros) < calculate_time(station1, station2, solution, metros))
        {
            solution = temp_solution;
        }
        temp_solution.pop_back();
        return;
    }

    for (int i = 0; i < metros[line1 - 1].num_station; i++)
    {
        int next_line = metros[line1 - 1].stations[i];
        if (next_line == 0)
            continue;
        if (find(temp_solution.begin(), temp_solution.end(), next_line) == temp_solution.end())
        {
            recursive_solve(next_line, line2, station1, station2, metros, temp_solution, solution);
        }
    }

    temp_solution.pop_back();
}

int main()
{
    int num_lines;
    cin >> num_lines;
    vector<Metro> metros(num_lines);

    for (int i = 0; i < num_lines; i++)
    {
        cin >> metros[i].num_station;
        for (int j = 0; j < metros[i].num_station; j++)
        {
            int station;
            cin >> station;
            metros[i].stations.push_back(station);
        }
    }
    int line1, station1, line2, station2;
    cin >> line1 >> station1 >> line2 >> station2;

    vector<int> solution;
    vector<int> temp_solution;
    recursive_solve(line1, line2, station1, station2, metros, temp_solution, solution);
    cout << calculate_time(station1, station2, solution, metros);

    return 0;
}