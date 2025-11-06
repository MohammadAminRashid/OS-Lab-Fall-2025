#ifndef COURSE_HPP
#define COURSE_HPP

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

class Course
{
public:
    Course(int i, string cn, int c, string pi, string pn, string t, string ed, int cu, int p, vector<int>mi);
    int get_id() { return id; }
    string get_name() { return name; }
    int get_prerequisite() { return prerequisite; }
    string get_professor_id() { return professor_id; }
    string get_time() { return time; }
    string get_exam_date() { return exam_date; }
    vector<int> get_major_ids() { return major_ids; }
    void view_all_lessons();
    void view_the_specific_lesson();
    string create_course_inf();
    void add_post_in_channel(string user_name, string title, string message, string image_address);
    void view_channel();
    void view_post(int post_id);

private:
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
    vector<Channel_Post*> channel;
    int post_id = 0;
};

#endif
