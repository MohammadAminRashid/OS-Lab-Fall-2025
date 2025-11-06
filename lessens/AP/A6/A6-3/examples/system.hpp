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

class System
{
public:
    System(string majors_file, string students_file, string lessons_file, string professors_file);
    void login(string id, string password);
    void posting(string title, string message);
    void course_offering(string course_id_str, string professor_id, string time, string exam_date, string capacity_str, string class_number_str);
    void check_course_id(int coures_id);
    void check_professor_id(int coures_id, string professor_id);
    void check_course_time(string professor_id, string course_time);
    void add_offered_lesson(string professor_id, string time, string exam_date, int course_id, int capacity, int class_number);
    void register_for_lesson(string id_str);
    void delete_course(string id_str);
    void setting_profile(string profile_path);
    void set_wanted_user(string w_u) { wanted_user = w_u; }
    EnteredPerson get_entered_person() { return entered_person; }
    User* find_wanted_user();
    User* find_current_user();
    string who_are_you(string id);
    vector<Course *> get_offered_courses() { return offered_courses; }

private:
    vector<Lesson *> lessons;
    vector<User *> users;
    vector<Course *> offered_courses;
    EnteredPerson entered_person;
    string wanted_user;
};

#endif