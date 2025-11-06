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
#include "general_functions.hpp"

using namespace std;

struct Post
{
    int id;
    string title;
    string message;
};

struct Notification
{
    string id;
    string name;
    string message;
};

struct Lesson
{
    int id;
    string name;
    int credit;
    int prerequisite;
    vector<int> major_ids;
};

struct OfferedLesson
{
    int id;
    string course_name;
    int capacity;
    string professor_id;
    string professor_name;
    string time;
    string exam_date;
    int class_number;
    int prerequisite;
    vector<int> major_ids;
};

class User
{
public:
    User(string i, string n, int m_i, string p, string majors_file);
    string get_id() { return id; }
    string get_password() { return password; }
    string get_name() { return name; }
    vector<string> get_friends() { return friends; }
    int get_major_id() { return major_id; }
    void add_post(string title, string message);
    void add_notification(string id, string name, string message);
    void add_friend(string new_friend);
    void delete_post(int id);
    void view_post(int id);
    virtual void print_post(int post_id) = 0;
    virtual void print_information() = 0;
    void view_notifications();
    virtual void add_course(OfferedLesson *wanted_course) {};
    virtual void delete_course(int id) {};
    virtual void view_own_courses() {};

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
    vector<OfferedLesson *> selected_lessons;
};

class Student : public User
{
public:
    Student(string i, string n, int m_i, string p, int s, string majors_file);
    void print_information();
    void add_course(OfferedLesson *wanted_course);
    void print_post(int post_id);
    void delete_course(int id);
    void view_own_courses();

private:
    int semester;
};

class Professor : public User
{
public:
    Professor(string i, string n, int m_i, string p, string po, string majors_file);
    void print_information();
    void add_course(OfferedLesson *wanted_course);
    void print_post(int post_id);

private:
    string position;
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