#ifndef USERS_HPP
#define USERS_HPP

#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <cmath>
#include <algorithm>
#include <cctype>
#include <sstream>
#include "course.hpp"

using namespace std;

class User
{
public:
    User(string i, string n, int m_i, string p, string majors_file);
    string get_id() { return id; }
    string get_password() { return password; }
    string get_name() { return name; }
    vector<string> get_friends() { return friends; }
    int get_major_id() { return major_id; }
    void add_post(string title, string message, string course_inf, string image_address);
    void add_notification(string id, string name, string message);
    void add_friend(string new_friend);
    void delete_post(int id);
    virtual void print_post(int post_id) = 0;
    virtual void print_information() = 0;
    void view_notifications();
    virtual void add_course(Course *wanted_course) {};
    virtual void delete_course(int id) {};
    virtual void view_own_courses() {};
    virtual void posting_TA_form(int course_id, string course_name, string message) {};
    virtual void add_TA_request(int form_id, string student_id, string student_name, int student_semester) {};
    virtual void check_TA_requests(vector<User*> &users, vector<Course*> &offered_courses, int form_id) {};
    virtual void add_course_TA(int course_id) {};
protected:
    string id;
    string name;
    int major_id;
    string major_name;
    int post_id = 0;
    string password;
    vector<Post *> posts;
    vector<Notification *> notifications;
    vector<string> friends;
    vector<Course *> selected_courses;
};

class Student : public User
{
public:
    Student(string i, string n, int m_i, string p, int s, string majors_file);
    int get_semester() { return semester; }
    void add_course_TA(int course_id);
    void print_information();
    void add_course(Course *wanted_course);
    void print_post(int post_id);
    void delete_course(int id);
    void view_own_courses();
    bool checking_have_course(int course_id);
    bool checking_TA(int course_id);

private:
    int semester;
    vector<int> course_TAs;
};

class Professor : public User
{
public:
    Professor(string i, string n, int m_i, string p, string po, string majors_file);
    void add_TA_request(int form_id, string student_id, string student_name, int student_semester);
    void check_TA_requests(vector<User*> &users, vector<Course*> &offered_courses, int form_id);
    void send_notification_for_TA_requests(vector<User*> &users, string student_id, int course_id, string message);
    void print_information();
    void add_course(Course *wanted_course);
    void print_post(int post_id);
    void posting_TA_form(int course_id, string course_name, string message);
    bool checking_have_course(int course_id);

private:
    string position;
    vector<TA_Request*> TA_requests;
};

class Manager : public User
{
public:
    Manager(string i, string n, int m_i, string p, string majors_file);
    void print_information();
    void print_post(int post_id);

private:
};

void create_users(vector<User *> &users, const string students_file, const string professors_file, const string majors_file);
void create_lessons(vector<Lesson *> &lessons, const string lessons_file);

#endif