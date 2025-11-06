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

vector<string> get_input_and_convert_to_string()
{
    string input_line;
    getline(cin, input_line);

    vector<string> words;
    string word;
    bool in_quotes = false;
    stringstream ss;

    for (char ch : input_line)
    {
        if (ch == '"')
        {
            in_quotes = !in_quotes;
            ss << ch;
        }
        else if (isspace(ch) && !in_quotes)
        {
            if (!ss.str().empty())
            {
                words.push_back(ss.str());
                ss.str("");
                ss.clear();
            }
        }
        else
        {
            ss << ch;
        }
    }

    if (!ss.str().empty())
    {
        words.push_back(ss.str());
    }

    return words;
}

void is_arithmetic_number(string id)
{
    for (char c : id)
    {
        if (!isdigit(c))
        {
            throw runtime_error(WRONG_REQUEST_MESSAGE);
        }
    }
}

void is_natural_number(string id)
{
    for (char c : id)
    {
        if (!isdigit(c))
        {
            throw runtime_error(WRONG_REQUEST_MESSAGE);
        }
    }
    if (id == "0")
        throw runtime_error(WRONG_REQUEST_MESSAGE);
}

string find_the_word_in_words_vector(vector<string> words, string word)
{
    bool is_exist = false;
    for (int i = 0; i < words.size(); i++)
    {
        if (words[i] == word)
            is_exist = true;
    }
    if (!is_exist)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    for (int i = 0; i < words.size(); i++)
    {
        if (words[i] == word)
        {
            if (i == words.size() - 1)
                throw runtime_error(WRONG_REQUEST_MESSAGE);
            else
                return words[i + 1];
        }
    }
    return NOT_FOUND_MESSAGE;
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

int extract_course_id(string course_info)
{
    size_t spaceIndex = course_info.find(' ');

    string numberStr = course_info.substr(0, spaceIndex);

    int number = stoi(numberStr);

    return number;
}
