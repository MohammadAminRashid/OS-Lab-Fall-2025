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
const string FIRST_NOTIF = "New Post";
const string SECOND_NOTIF = "New Course Offering";
const string THIRD_NOTIF = "Get Course";
const string FORTH_NOTIF = "Delete Course";
const string FIFTH_NOTIF = "New Form";
const string SIXTH_NOTIF = "New Course Post";
const string FILE_ERROR = "Unable to open file: ";
const string TA_FORM_TITLE = "TA form for";
const string CREATE_FORM = "ta_form";
const string TA_REQUEST = "ta_request";
const string CLOSE_FORM = "close_ta_form";
const string TA_NOTIF = "Your request to be a teaching assistant has been";
const string REQUEST_ACCEPTION = "accept";
const string REQUEST_REJECTION = "reject";
const string COURSE_POSTING = "course_post";
const string SHOW_CHANNEL = "course_channel";
const string SHOW_CHANNEL_POST = "course_post";
const string SET_PROFILE = "profile_photo";
const string INVALID_COURSE_INFO = "0";
const string INVALID_IMAGE_ADDRESS = "0";
const string INVALID_USER_ID = "-1";
const string DELIMITER = "?";

struct Post
{
    int id;
    string title;
    string message;
    string course_info;
    string image_address;
};

struct Channel_Post
{
    int id;
    string name;
    string title;
    string message;
    string image_address;
};

struct Notification
{
    string id;
    string name;
    string message;
};

struct TA_Request
{
    int form_id;
    int course_id;
    string student_id;
    string student_name;
    int student_semester;
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

void trim_string(string &str);
vector<string> convert_file_to_vector(string file_path);
vector<string> get_input_and_convert_to_string();
void is_arithmetic_number(string id);
void is_natural_number(string id);
string find_the_word_in_words_vector(vector<string> words, string word);
Time convert_string_to_Time(string time);
Date convrt_string_to_Date(string date);
int extract_course_id(string course_info);

#endif