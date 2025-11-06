#include "generals.hpp"

using namespace std;

void trim_string(string &str)
{
    str.erase(str.begin(), find_if(str.begin(), str.end(), [](unsigned char ch)
                                   { return !isspace(ch); }));
    str.erase(find_if(str.rbegin(), str.rend(), [](unsigned char ch)
                      { return !isspace(ch); })
                  .base(),
              str.end());
}

vector<string> convert_file_to_vector(string file_path)
{
    vector<string> lines;

    ifstream file(file_path);
    if (!file.is_open())
    {
        cerr << FILE_ERROR << endl;
    }
    string header;
    getline(file, header);

    string line;
    while (getline(file, line))
    {
        trim_string(line);
        lines.push_back(line);
    }
    file.close();

    return lines;
}


void is_arithmetic_number(string id)
{
    for (char c : id)
    {
        if (!isdigit(c))
        {
            throw Request_Exception();
        }
    }
}

void is_natural_number(string id)
{
    for (char c : id)
    {
        if (!isdigit(c))
        {
            throw Request_Exception();
        }
    }
    if (id == "0")
        throw Request_Exception();
}

Time convert_string_to_Time(string time)
{
    Time new_time;

    size_t colon_pos = time.find(':');
    size_t dash_pos = time.find('-');

    new_time.day = time.substr(0, colon_pos);
    new_time.start_time = stof(time.substr(colon_pos + 1, dash_pos - colon_pos - 1));
    new_time.end_time = stof(time.substr(dash_pos + 1));

    return new_time;
}

Date convrt_string_to_Date(std::string date)
{
    Date new_date;

    size_t first_slash_pos = date.find('/');
    size_t second_slash_pos = date.find('/', first_slash_pos + 1);

    new_date.year = date.substr(0, first_slash_pos);
    new_date.month = date.substr(first_slash_pos + 1, second_slash_pos - first_slash_pos - 1);
    new_date.day = date.substr(second_slash_pos + 1);

    return new_date;
}
