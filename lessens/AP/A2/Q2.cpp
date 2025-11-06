#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>

using namespace std;

const string first_sign = "|__";
const string second_sign = "|  ";
const string third_sign = "   ";

vector<pair<string, vector<int>>> organize_items(vector<pair<string, vector<int>>> &items, vector<int> &heads)
{
    int num_of_items = items.size();
    for (int i = 0; i < num_of_items; i++)
    {
        int num = items[i].second[0];
        if (num == 0)
        {
            heads.push_back(i);
            continue;
        }
        items[num - 1].second.push_back(i);
    }

    for (int j = 0; j < num_of_items; j++)
    {
        items[j].second.erase(items[j].second.begin());
    }

    return items;
}

void find_fathers_of_each_item(vector<pair<string, vector<int>>> &items, int head, int n, vector<int> &fathers)
{
    vector<int> temp;
    for (int i = 0; i < items.size(); i++)
    {
        for (int j = 0; j < items[i].second.size(); j++)
        {
            if (items[i].second[j] == n)
            {
                fathers.push_back(i);
                find_fathers_of_each_item(items, head, i, fathers);
                break;
            }
        }
    }

    if (head == n)
    {
        temp = fathers;
        fathers.clear();
        for (int i = temp.size() - 1; i >= 0; i--)
        {
            fathers.push_back(temp[i]);
        }
        return;
    }
}

bool checking_last_son(vector<pair<string, vector<int>>> &items, int num1, int num2)
{
    if (items[num1].second.back() == num2)
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool recursive_solve(vector<pair<string, vector<int>>> &items, vector<int> fathers, vector<int> &heads, int n, int head, int max_depth, int depth = 1)
{
    for (int i = 0; i < items[n].second.size(); i++)
    {
        if (depth >= max_depth)
            break;

        if (heads.back() == head)
            cout << third_sign;
        else
            cout << second_sign;
        find_fathers_of_each_item(items, head, items[n].second[i], fathers);
        for (int i = 0; i < fathers.size() - 1; i++)
        {
            if (checking_last_son(items, fathers[i], fathers[i + 1]))
                cout << third_sign;
            else
                cout << second_sign;
        }
        fathers.clear();
        cout << first_sign << items[items[n].second[i]].first << endl;

        if (items[n].second.size() == 0)
            return false;
        recursive_solve(items, fathers, heads, items[n].second[i], head, max_depth, depth + 1);
    }
    return true;
}

int main()
{
    int num_of_items;
    int max_depth;
    cin >> num_of_items >> max_depth;
    vector<pair<string, vector<int>>> items(num_of_items);
    vector<int> heads;

    for (int i = 0; i < num_of_items; i++)
    {
        cin >> items[i].first;
        int num;
        cin >> num;
        items[i].second.push_back(num);
    }

    items = organize_items(items, heads);

    vector<int> fathers;

    for (int i = 0; i < heads.size(); i++)
    {
        cout << first_sign << items[heads[i]].first << endl;
        if (items[heads[i]].second.size() == 0)
            continue;
        recursive_solve(items, fathers, heads, heads[i], heads[i], max_depth);
    }

    return 0;
}