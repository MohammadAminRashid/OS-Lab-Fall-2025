#include "course.hpp"

using namespace std;

Course::Course(int i, string cn, int c, string pi, string pn, string t, string ed, int cu, int p, vector<int>mi)
{
    id = i;
    name = cn;
    capacity = c;
    professor_id = pi;
    professor_name = pn;
    time = t;
    exam_date = ed;
    class_number = cu;
    prerequisite = p;
    major_ids = mi;
}

void Course::view_all_lessons()
{
    cout << id << " " << name << " " << capacity << " " << professor_name << endl;
}

void Course::view_the_specific_lesson()
{
    cout << id << " " << name << " " << capacity << " " << professor_name << " " << time << " " << exam_date << " " << class_number << endl;
}

string Course::create_course_inf()
{
    string course_info;
    course_info = to_string(id) + " " + name + " " + to_string(capacity) + " " + professor_name + " " + time + " " + exam_date + " " + to_string(class_number);
    return course_info;
}

void Course::add_post_in_channel(string user_name, string title, string message, string image_address)
{
    post_id += 1;
    int id = post_id;
    Channel_Post* new_post = new Channel_Post{id, user_name, title, message, image_address};
    channel.push_back(new_post);
}

void Course::view_channel()
{
    view_the_specific_lesson();
    for (int i = channel.size() - 1; i >= 0; i--) {
        cout << channel[i]->id << " " << channel[i]->name << " " << channel[i]->title << endl;
    }
}

void Course::view_post(int post_id)
{
    bool is_postId_exist = false;
    for (auto post : channel) {
        if (post->id == post_id) {
            is_postId_exist = true;
            view_the_specific_lesson();
            cout << post->id << " " << post->name << " " << post->title << " " << post->message << endl;
        }
    }
    if (!is_postId_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);
}