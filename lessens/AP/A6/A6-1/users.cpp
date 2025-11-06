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
    post_id += 1;
    int id = post_id;

    Post *new_post = new Post{id, title, message};
    posts.push_back(new_post);
}

void User::add_notification(string id, string name, string message)
{
    Notification *new_notification = new Notification{id, name, message};
    notifications.push_back(new_notification);
}

void User::add_friend(string new_friend)
{
    for (int i = 0; i < friends.size(); i++)
    {
        if (new_friend == friends[i])
            throw runtime_error(WRONG_REQUEST_MESSAGE);
    }
    friends.push_back(new_friend);
}

void User::delete_post(int id)
{
    for (auto post : posts)
    {
        if (post->id == id)
        {
            posts.erase(remove(posts.begin(), posts.end(), post), posts.end());
            delete post;
            return;
        }
    }
    throw runtime_error(NOT_FOUND_MESSAGE);
}

void User::view_post(int id)
{
    for (auto post : posts)
    {
        if (post->id == id)
        {
            cout << post->id << " " << post->title << " " << post->message << endl;
            return;
        }
    }
    throw runtime_error(NOT_FOUND_MESSAGE);
}

void User::view_notifications()
{
    if (notifications.empty())
        throw runtime_error(EMPTY_MESSAGE);

    for (int i = notifications.size() - 1; i >= 0; i--)
    {
        cout << notifications[i]->id << " " << notifications[i]->name << ": " << notifications[i]->message << endl;
    }

    for (auto notif : notifications)
    {
        delete notif;
    }
    notifications.clear();
}

Student::Student(string i, string n, int m_i, string p, int s, string majors_file)
    : User(i, n, m_i, p, majors_file)
{
    semester = s;
}

void Student::print_information()
{
    string courses_names;
    for (int i = 0; i < selected_lessons.size(); i++)
    {
        courses_names += selected_lessons[i]->course_name;
        if (i != selected_lessons.size() - 1)
        {
            courses_names += ",";
        }
    }
    cout << name << " " << major_name << " " << semester << " " << courses_names << endl;
    for (int i = 0; i < posts.size(); i++)
    {
        cout << posts[posts.size() - 1 - i]->id << " " << posts[posts.size() - 1 - i]->title << endl;
    }
}

void Student::print_post(int post_id)
{
    bool is_post_exist = false;

    for (auto post : posts)
    {
        if (post->id == post_id)
            is_post_exist = true;
    }

    if (!is_post_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);

    string courses_names;
    for (int i = 0; i < selected_lessons.size(); i++)
    {
        courses_names += selected_lessons[i]->course_name;
        if (i != selected_lessons.size() - 1)
        {
            courses_names += ",";
        }
    }

    cout << name << " " << major_name << " " << semester << " " << courses_names << endl;
    for (auto post : posts)
    {
        if (post->id == post_id)
            cout << post->id << " " << post->title << " " << post->message << endl;
    }
}

void Student::add_course(OfferedLesson *wanted_course)
{
    int id = wanted_course->id;
    string course_name = wanted_course->course_name;
    int capacity = wanted_course->capacity;
    string professor_id = wanted_course->professor_id;
    string professor_name = wanted_course->professor_name;
    string time = wanted_course->time;
    string exam_date = wanted_course->exam_date;
    int class_number = wanted_course->class_number;
    int prerequisite = wanted_course->prerequisite;
    vector<int> major_ids = wanted_course->major_ids;
    OfferedLesson *new_lesson = new OfferedLesson{id, course_name, capacity, professor_id, professor_name, time, exam_date, class_number, prerequisite, major_ids};

    bool is_major_allowed = false;
    for (int i = 0; i < wanted_course->major_ids.size(); i++)
    {
        if (major_id == wanted_course->major_ids[i])
            is_major_allowed = true;
    }
    if (!is_major_allowed)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);

    if (semester < wanted_course->prerequisite)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);

    if (selected_lessons.empty())
    {
        selected_lessons.push_back(new_lesson);
        return;
    }

    Time new_time = convert_string_to_Time(wanted_course->time);
    Date new_date = convrt_string_to_Date(wanted_course->exam_date);
    for (auto lesson : selected_lessons)
    {
        Time past_time = convert_string_to_Time(lesson->time);
        Date past_date = convrt_string_to_Date(lesson->exam_date);

        if (new_time.day == past_time.day && past_time.start_time <= new_time.start_time && new_time.start_time < past_time.end_time)
            throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
        if (new_time.day == past_time.day && past_time.start_time < new_time.end_time && new_time.end_time <= past_time.end_time)
            throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
        if (new_date.year == past_date.year && new_date.month == past_date.month && new_date.day == past_date.day)
            throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    }
    selected_lessons.push_back(new_lesson);
}

void Student::delete_course(int id)
{
    for (auto lesson : selected_lessons)
    {
        if (lesson->id == id)
        {
            selected_lessons.erase(remove(selected_lessons.begin(), selected_lessons.end(), lesson), selected_lessons.end());
            delete lesson;
            return;
        }
    }
    throw runtime_error(NOT_FOUND_MESSAGE);
}

void Student::view_own_courses()
{
    if (selected_lessons.empty())
        throw runtime_error(EMPTY_MESSAGE);
    for (auto lesson : selected_lessons)
    {
        cout << lesson->id << " " << lesson->course_name << " " << lesson->capacity << " " << lesson->professor_name
             << " " << lesson->time << " " << lesson->exam_date << " " << lesson->class_number << endl;
    }
}

Professor::Professor(string i, string n, int m_i, string p, string po, string majors_file)
    : User(i, n, m_i, p, majors_file)
{
    position = po;
}

void Professor::print_information()
{
    string courses_names;
    for (int i = 0; i < selected_lessons.size(); i++)
    {
        courses_names += selected_lessons[i]->course_name;
        if (i != selected_lessons.size() - 1)
        {
            courses_names += ",";
        }
    }
    cout << name << " " << major_name << " " << position << " " << courses_names << endl;
    for (int i = 0; i < posts.size(); i++)
    {
        cout << posts[posts.size() - 1 - i]->id << " " << posts[posts.size() - 1 - i]->title << endl;
    }
}

void Professor::print_post(int post_id)
{
    bool is_post_exist = false;

    for (auto post : posts)
    {
        if (post->id == post_id)
            is_post_exist = true;
    }

    if (!is_post_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);

    string courses_names;
    for (int i = 0; i < selected_lessons.size(); i++)
    {
        courses_names += selected_lessons[i]->course_name;
        if (i != selected_lessons.size() - 1)
        {
            courses_names += ",";
        }
    }

    cout << name << " " << major_name << " " << position << " " << courses_names << endl;
    for (auto post : posts)
    {
        if (post->id == post_id)
            cout << post->id << " " << post->title << " " << post->message << endl;
    }
}

void Professor::add_course(OfferedLesson *wanted_course)
{
    selected_lessons.push_back(wanted_course);
}

Manager::Manager(string i, string n, int m_i, string p, string majors_file)
    : User(i, n, m_i, p, majors_file) {}

void Manager::print_information()
{
    cout << name << endl;
    for (int i = 0; i < posts.size(); i++)
    {
        cout << posts[posts.size() - 1 - i]->id << " " << posts[posts.size() - 1 - i]->title << endl;
    }
}

void Manager::print_post(int post_id)
{
    bool is_post_exist = false;

    for (auto post : posts)
    {
        if (post->id == post_id)
            is_post_exist = true;
    }

    if (!is_post_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);

    cout << name << endl;
    for (auto post : posts)
    {
        if (post->id == post_id)
            cout << post->id << " " << post->title << " " << post->message << endl;
    }
}

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