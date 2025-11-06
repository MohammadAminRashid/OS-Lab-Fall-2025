#ifndef GENERAL_FUNCTIONS_HPP
#define GENERAL_FUNCTIONS_HPP

#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <cmath>
#include <algorithm>
#include <cctype>
#include <sstream>

using namespace std;

const string POST_ORDER = "POST";
const string GET_ORDER = "GET";
const string PUT_ORDER = "PUT";
const string DELETE_ORDER = "DELETE";
const string LOGIN_ORDER = "login";
const string LOGOUT_ORDER = "logout";
const string SHOW_COURSES = "courses";
const string POSTING = "post";
const string SHOW_PAGE = "personal_page";
const string GET_CONNECT = "connect";
const string SHOW_NOTIFICATION = "notification";
const string COURSE_OFFERING = "course_offer";
const string COURSE_ORDERS = "my_courses";
const string CONFIRMATION_MESSAGE = "OK";
const string EMPTY_MESSAGE = "Empty";
const string NOT_FOUND_MESSAGE = "Not Found";
const string WRONG_REQUEST_MESSAGE = "Bad Request";
const string ILLEGAL_ACCESS_MESSAGE = "Permission Denied";
const string DELIMITER = "?";
const string FIRST_NOTIF = "New Post";
const string SECOND_NOTIF = "New Course Offering";
const string THIRD_NOTIF = "Get Course";
const string FORTH_NOTIF = "Delete Course";
const string FILE_ERROR = "Unable to open file: ";

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

void trim_string(string &str);
vector<string> convert_file_to_vector(string file_path);
vector<string> get_input_and_convert_to_string();
void is_arithmetic_number(string id);
void is_natural_number(string id);
string find_the_word_in_words_vector(vector<string> words, string word);
Time convert_string_to_Time(string time);
Date convrt_string_to_Date(string date);

#endif