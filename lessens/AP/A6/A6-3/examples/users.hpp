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
#include "generals.hpp"

using namespace std;

class User
{
public:
    User(string i, string n, int m_i, string p, string majors_file);
    string get_id() { return id; }
    string get_password() { return password; }
    string get_name() { return name; }
    string get_profile_path() { return profile_path; }
    string get_major_name() { return major_name; }
    vector<Post*> get_posts() { return posts; }
    vector<Course *> get_courses() { return selected_courses; }
    int get_major_id() { return major_id; }
    void add_post(string title, string message);
    void set_profile_path(string profile_path);
    virtual void add_course(Course *wanted_course) {};
    virtual void delete_course(int id) {};
    virtual void view_own_courses() {};
protected:
    string id;
    string name;
    string password;
    string profile_path = INVALID_VALUE;
    int major_id;
    string major_name;
    vector<Post *> posts;
    vector<Course *> selected_courses;
};

class Student : public User
{
public:
    Student(string i, string n, int m_i, string p, int s, string majors_file);
    int get_semester() { return semester; }
    void add_course(Course *wanted_course);
    void delete_course(int id);

private:
    int semester;
};

class Professor : public User
{
public:
    Professor(string i, string n, int m_i, string p, string po, string majors_file);
    string get_position() { return position; }

private:
    string position;
};

class Manager : public User
{
public:
    Manager(string i, string n, int m_i, string p, string majors_file);

private:
};

void create_users(vector<User *> &users, const string students_file, const string professors_file, const string majors_file);
void create_lessons(vector<Lesson *> &lessons, const string lessons_file);

#endif