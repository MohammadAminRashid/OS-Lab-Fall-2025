#ifndef GENERALS_HPP
#define GENERALS_HPP

#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <cmath>
#include <algorithm>
#include <cctype>
#include <sstream>

using namespace std;

const int INVALID_MAJOR_ID = 0;
const string MANAGER_ID = "0";
const string MANAGER_NAME = "UT_account";
const string MANAGER_PASSWORD = "UT_account";
const string CONFIRMATION_MESSAGE = "OK";
const string EMPTY_MESSAGE = "Empty";
const string NOT_FOUND_MESSAGE = "Not Found";
const string WRONG_REQUEST_MESSAGE = "Bad Request";
const string ILLEGAL_ACCESS_MESSAGE = "Permission Denied";
const string FILE_ERROR = "Unable to open file: ";
const string INVALID_VALUE = "-1";

enum Person
{
    NONE,
    STUDENT,
    PROFESSOR,
    MANAGER,
};

struct Post
{
    string title;
    string message;
};

struct EnteredPerson {
    Person user;
    string id;
    string name;
    string major;
};

struct Course
{
    int id;
    string name;
    int capacity;
    string professor_id;
    string professor_name;
    string time;
    string exam_date;
    int class_number;
    int prerequisite;
    vector<int> major_ids;
};

struct Lesson
{
    int id;
    string name;
    int credit;
    int prerequisite;
    vector<int> major_ids;
};

struct Time
{
    string day;
    float start_time;
    float end_time;
};

struct Date
{
    string year;
    string month;
    string day;
};

class Exception {};
class Empty_Exception : public Exception {};
class Permission_Exception : public Exception {};
class Request_Exception : public Exception {};
class NotFound_Exception : public Exception {};

void trim_string(string &str);
vector<string> convert_file_to_vector(string file_path);
void is_arithmetic_number(string id);
void is_natural_number(string id);
Time convert_string_to_Time(string time);
Date convrt_string_to_Date(string date);

#endif