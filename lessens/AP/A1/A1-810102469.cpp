#include <iostream>
#include <vector>
#include <string>

using namespace std;

struct next_term
{
    string name;
    int units;
    string pre;
    vector<string> std_pre;
};

struct past_term
{
    string name;
    int units;
    float grade;
};

float Average(vector<past_term> past) // This function returnes GPA
{
    int n = past.size();
    float sum_grades = 0.0;
    int sum_units = 0;
    for (int i = 0; i < n; i++)
    {
        sum_grades += past[i].grade * past[i].units;
        sum_units += past[i].units;
    }
    return (sum_grades / sum_units);
}

vector<string> Standardize_pre(string pre) // This function removes ',' and saves lessons in a vector
{
    vector<string> std_pre; // Vector to store updated strings

    size_t start = 0;
    size_t end = pre.find(",");
    while (end != string::npos)
    {
        std_pre.push_back(pre.substr(start, end - start));
        start = end + 1;
        end = pre.find(",", start);
    }
    std_pre.push_back(pre.substr(start, end - start)); // Add the last substring

    return std_pre;
}

int In_Next_Term(vector<next_term> next, vector<string> requests)
// This function checks the existence of lessons in the next semester.
{
    int m = next.size();
    int k = requests.size();
    int counter = 0;
    for (int i = 0; i < k; i++)
    {
        for (int j = 0; j < m; j++)
        {
            if (requests[i] == next[j].name)
            {
                counter += 1;
            }
        }
    }
    if (counter == k)
    {
        return 1;
    }
    else
    {
        cout << "Course Not Offered!";
        return 0;
    }
}

int Minimum(vector<next_term> next, vector<string> requests)
// This function checks the minimum units
{
    int m = next.size();
    int k = requests.size();
    int sum_units = 0;
    for (int i = 0; i < k; i++)
    {
        for (int j = 0; j < m; j++)
        {
            if (requests[i] == next[j].name)
            {
                sum_units += next[j].units;
            }
        }
    }
    if (sum_units >= 12)
    {
        return 1;
    }
    else
    {
        cout << "Minimum Units Validation Failed!";
        return 0;
    }
}

int Maximum(float GPA, vector<next_term> next, vector<string> requests)
// This function checks the maximum units
{
    int m = next.size();
    int k = requests.size();
    int sum_units = 0;
    for (int i = 0; i < k; i++)
    {
        for (int j = 0; j < m; j++)
        {
            if (requests[i] == next[j].name)
            {
                sum_units += next[j].units;
            }
        }
    }
    if (GPA >= 17)
    {
        if (sum_units <= 24)
        {
            return 1;
        }
        else
        {
            cout << "Maximum Units Validation Failed!";
            return 0;
        }
    }
    if (GPA < 17 && GPA >= 12)
    {
        if (sum_units <= 20)
        {
            return 1;
        }
        else
        {
            cout << "Maximum Units Validation Failed!";
            return 0;
        }
    }
    if (GPA < 12)
    {
        if (sum_units <= 14)
        {
            return 1;
        }
        else
        {
            cout << "Maximum Units Validation Failed!";
            return 0;
        }
    }
    return 0;
}

int In_Past_Term(vector<past_term> past, vector<string> requests)
// This function checks whether you have already passed the course or not
{
    int n = past.size();
    int k = requests.size();
    for (int i = 0; i < k; i++)
    {
        for (int j = 0; j < n; j++)
        {
            if (requests[i] == past[j].name && past[j].grade >= 10)
            {
                cout << "Course Already Taken!";
                return 0;
            }
        }
    }
    return 1;
}

int Prerequisites(vector<next_term> next, vector<past_term> past, vector<string> requests)
// This function checks the prerequisites
{
    int m = next.size();
    int n = past.size();
    int k = requests.size();
    int counter;
    int num_of_pre;
    for (int i = 0; i < k; i++)
    {
        for (int j = 0; j < m; j++)
        {
            if (requests[i] == next[j].name)
            {
                num_of_pre = next[j].std_pre.size();
                counter = 0;
                for (int p = 0; p < num_of_pre; p++)
                {
                    for (int x = 0; x < n; x++)
                    {
                        if (next[j].std_pre[p] == past[x].name && past[x].grade >= 10)
                        {
                            counter += 1;
                        }
                    }
                }
                if (counter != num_of_pre)
                {
                    cout << "Prerequisites Not Met!";
                    return 0;
                }
            }
        }
    }
    return 1;
}
int main()
{
    int m; // m is the number of courses for the next semester
    int n; // n is the number of courses for the past semester
    int k; // k is the number of requested courses
    int i;
    float GPA;

    cin >> m;
    vector<next_term> next(m);

    for (i = 0; i < m; i++)
    {
        cin >> next[i].name >> next[i].units >> next[i].pre;
        next[i].std_pre = Standardize_pre(next[i].pre);
    }

    cin >> n;
    vector<past_term> past(n);

    for (i = 0; i < n; i++)
    {
        cin >> past[i].name >> past[i].units >> past[i].grade;
    }
    GPA = Average(past);

    cin >> k;
    vector<string> requests(k);

    for (i = 0; i < k; i++)
    {
        cin >> requests[i];
    }

    int err1 = In_Next_Term(next, requests);
    int err2 = Minimum(next, requests);
    int err3 = Maximum(GPA, next, requests);
    int err4 = In_Past_Term(past, requests);
    int err5 = Prerequisites(next, past, requests);

    if (err1 && err2 && err3 && err4 && err5)
    {
        cout << "OK!";
    }
}