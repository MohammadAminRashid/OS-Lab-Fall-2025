#ifndef SYSTEM_HPP
#define SYSTEM_HPP

#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <cmath>
#include <algorithm>
#include <cctype>
#include <sstream>
#include "users.hpp"

using namespace std;

enum Condition
{
    LOGIN,
    LOGOUT,
};

enum Person
{
    NONE,
    STUDENT,
    PROFESSOR,
    MANAGER,
};

class System
{
public:
    System(string majors_file, string students_file, string lessons_file, string professors_file);
    void run();
    void handle_POST_orders(vector<string> order_words);
    void handle_GET_orders(vector<string> order_words);
    void handle_PUT_orders(vector<string> order_words);
    void handle_DELETE_orders(vector<string> order_words);
    void login(vector<string> order_words);
    void logout(vector<string> order_words);
    void send_notification(string id, string message);
    void posting(vector<string> order_words);
    void get_connect(vector<string> order_words);
    void course_offering(vector<string> order_words);
    void check_course_id(int coures_id);
    void check_professor_id(int coures_id, string professor_id);
    void check_course_time(string professor_id, string course_time);
    void add_offered_lesson(string professor_id, string time, string exam_date, int course_id, int capacity, int class_number);
    void view_lessons(vector<string> order_words);
    void delete_post(vector<string> order_words);
    void view_posts(vector<string> order_words);
    void register_for_lesson(vector<string> order_words);
    void view_personal_page(vector<string> order_words);
    void view_notifications(vector<string> order_words);
    void delete_course(vector<string> order_words);
    void view_own_courses(vector<string> order_words);

private:
    vector<Lesson *> lessons;
    vector<User *> users;
    vector<OfferedLesson *> offered_lessons;
    Condition condition;
    Person person;
    string entered_id;
};

#endif