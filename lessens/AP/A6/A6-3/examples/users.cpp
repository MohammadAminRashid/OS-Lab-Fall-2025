#include "users.hpp"

using namespace std;

User::User(string i, string n, int m_i, string p, string majors_file)
{
    id = i;
    name = n;
    major_id = m_i;
    password = p;
    vector<string> lines = convert_file_to_vector(majors_file);
    for (const auto &line : lines)
    {
        stringstream ss(line);
        string id_str, name;
        int id;
        getline(ss, id_str, ',');
        getline(ss, name, ',');
        id = stoi(id_str);
        if (m_i == id)
            major_name = name;
    }
}

void User::add_post(string title, string message)
{
    Post *new_post = new Post{title, message};
    posts.push_back(new_post);
}

void User::set_profile_path(string this_profile_path)
{
    profile_path = this_profile_path;
}

Student::Student(string i, string n, int m_i, string p, int s, string majors_file)
    : User(i, n, m_i, p, majors_file)
{
    semester = s;
}

void Student::add_course(Course *wanted_course)
{
    Course *new_lesson = new Course(*wanted_course);
    bool is_major_allowed = false;
    for (size_t i = 0; i < wanted_course->major_ids.size(); i++)
    {
        if (major_id == wanted_course->major_ids[i])
            is_major_allowed = true;
    }
    if (!is_major_allowed)
        throw Permission_Exception();

    if (semester < wanted_course->prerequisite)
        throw Permission_Exception();

    if (selected_courses.empty())
    {
        selected_courses.push_back(new_lesson);
        return;
    }
    Time new_time = convert_string_to_Time(wanted_course->time);
    Date new_date = convrt_string_to_Date(wanted_course->exam_date);
    for (auto lesson : selected_courses)
    {
        Time past_time = convert_string_to_Time(lesson->time);
        Date past_date = convrt_string_to_Date(lesson->exam_date);

        if (new_time.day == past_time.day && past_time.start_time <= new_time.start_time && new_time.start_time < past_time.end_time)
            throw Permission_Exception();
        if (new_time.day == past_time.day && past_time.start_time < new_time.end_time && new_time.end_time <= past_time.end_time)
            throw Permission_Exception();
        if (new_date.year == past_date.year && new_date.month == past_date.month && new_date.day == past_date.day)
            throw Permission_Exception();
    }
    selected_courses.push_back(new_lesson);
}

void Student::delete_course(int id)
{
    for (auto lesson : selected_courses)
    {
        if (lesson->id == id)
        {
            selected_courses.erase(remove(selected_courses.begin(), selected_courses.end(), lesson), selected_courses.end());
            delete lesson;
            return;
        }
    }
    throw NotFound_Exception();
}

Professor::Professor(string i, string n, int m_i, string p, string po, string majors_file)
    : User(i, n, m_i, p, majors_file)
{
    position = po;
}

Manager::Manager(string i, string n, int m_i, string p, string majors_file)
    : User(i, n, m_i, p, majors_file) {}


void create_users(vector<User *> &users, const string students_file, const string professors_file, const string majors_file)
{
    vector<string> lines;
    lines = convert_file_to_vector(students_file);

    for (const auto line : lines)
    {
        stringstream ss(line);
        string id, name, major_id_str, semester_str, password;
        int major_id, semester;

        getline(ss, id, ',');
        getline(ss, name, ',');
        getline(ss, major_id_str, ',');
        getline(ss, semester_str, ',');
        getline(ss, password, ',');
        major_id = stoi(major_id_str);
        semester = stoi(semester_str);

        users.push_back(new Student(id, name, major_id, password, semester, majors_file));
    }
    lines = convert_file_to_vector(professors_file);

    for (const auto line : lines)
    {
        stringstream ss(line);
        string id, name, major_id_str, position, password;
        int major_id;

        getline(ss, id, ',');
        getline(ss, name, ',');
        getline(ss, major_id_str, ',');
        getline(ss, position, ',');
        getline(ss, password, ',');
        major_id = stoi(major_id_str);

        users.push_back(new Professor(id, name, major_id, password, position, majors_file));
    }
}

void create_lessons(vector<Lesson *> &lessons, const string lessons_file)
{
    vector<string> lines = convert_file_to_vector(lessons_file);

    for (const auto &line : lines)
    {
        stringstream ss(line);
        string id_str, name, credit_str, prerequisite_str, major_ids_str;
        int id, credit, prerequisite;
        vector<int> major_ids;

        getline(ss, id_str, ',');
        getline(ss, name, ',');
        getline(ss, credit_str, ',');
        getline(ss, prerequisite_str, ',');
        getline(ss, major_ids_str);

        id = stoi(id_str);
        credit = stoi(credit_str);
        prerequisite = stoi(prerequisite_str);

        stringstream major_ss(major_ids_str);
        string major_id_str;
        while (getline(major_ss, major_id_str, ';'))
        {
            major_ids.push_back(stoi(major_id_str));
        }

        lessons.push_back(new Lesson{id, name, credit, prerequisite, major_ids});
    }
}