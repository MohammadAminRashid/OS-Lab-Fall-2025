#include "system.hpp"

using namespace std;

System::System(string majors_file, string students_file, string lessons_file, string professors_file)
{
    create_users(users, students_file, professors_file, majors_file);
    create_lessons(lessons, lessons_file);
    users.push_back(new Manager(MANAGER_ID, MANAGER_NAME, INVALID_MAJOR_ID, MANAGER_PASSWORD, majors_file));
    entered_person.user = NONE;
}

void System::login(string id, string password)
{
    is_arithmetic_number(id);
    for (size_t i = 0; i < users.size(); i++)
    {
        if (id == users[i]->get_id() && password != users[i]->get_password())
            throw Permission_Exception();
        if (id == users[i]->get_id() && password == users[i]->get_password())
        {
            entered_person.id = id;
            entered_person.name = users[i]->get_name();
            entered_person.major = users[i]->get_major_name();

            if (dynamic_cast<Student *>(users[i])) {
                entered_person.user = STUDENT;
                return;
            }
            else if (dynamic_cast<Professor *>(users[i])) {
                entered_person.user = PROFESSOR;
                return;
            }
            else if (dynamic_cast<Manager *>(users[i])) {
                entered_person.user = MANAGER;
                return;
            }
        }
    }
    throw NotFound_Exception();
}


void System::posting(string title, string message)
{
    if (title.empty() || message.empty())
        throw Request_Exception();
    for (auto user : users)
    {
        if (user->get_id() == entered_person.id)
        {
            user->add_post(title, message);
        }
    }
}

void System::check_course_id(int coures_id)
{
    for (auto lesson : lessons)
    {
        if (lesson->id == coures_id)
            return;
    }
    throw NotFound_Exception();
}

void System::check_professor_id(int coures_id, string professor_id)
{
    int index = -1;
    vector<int> majors;

    for (size_t i = 0; i < users.size(); i++)
    {
        if (users[i]->get_id() == professor_id)
            index = i;
    }

    if (index == -1)
        throw NotFound_Exception();
    if (!dynamic_cast<Professor *>(users[index]))
        throw Permission_Exception();

    for (auto lesson : lessons)
    {
        if (lesson->id == coures_id)
            majors = lesson->major_ids;
    }

    for (size_t i = 0; i < majors.size(); i++)
    {
        if (users[index]->get_major_id() == majors[i])
            return;
    }
    throw Permission_Exception();
}

void System::check_course_time(string professor_id, string course_time)
{
    Time new_time = convert_string_to_Time(course_time);
    for (auto lesson : offered_courses)
    {
        if (lesson->professor_id == professor_id)
        {
            Time past_time = convert_string_to_Time(lesson->time);
            if (new_time.day == past_time.day && past_time.start_time <= new_time.start_time && new_time.start_time < past_time.end_time)
                throw Permission_Exception();
            if (new_time.day == past_time.day && past_time.start_time < new_time.end_time && new_time.end_time <= past_time.end_time)
                throw Permission_Exception();
        }
    }
}

void System::add_offered_lesson(string professor_id, string time, string exam_date, int course_id, int capacity, int class_number)
{
    int id;
    string course_name;
    string professor_name;
    int prerequisite;
    vector<int> major_ids;

    id = offered_courses.size() + 1;

    for (auto lesson : lessons)
    {
        if (lesson->id == course_id)
        {
            course_name = lesson->name;
            major_ids = lesson->major_ids;
            prerequisite = lesson->prerequisite;
        }
    }

    for (auto user : users)
    {
        if (user->get_id() == professor_id)
            professor_name = user->get_name();
    }
    Course *new_lesson = new Course{id, course_name, capacity, professor_id, professor_name, time, exam_date, class_number, prerequisite, major_ids};
    offered_courses.push_back(new_lesson);
}

void System::course_offering(string course_id_str, string professor_id, string time, string exam_date, string capacity_str, string class_number_str)
{
    is_natural_number(course_id_str);
    is_natural_number(professor_id);
    is_natural_number(capacity_str);
    is_natural_number(class_number_str);

    int course_id = stoi(course_id_str);
    int capacity = stoi(capacity_str);
    int class_number = stoi(class_number_str);

    check_course_id(course_id);
    check_professor_id(course_id, professor_id);
    check_course_time(professor_id, time);
    add_offered_lesson(professor_id, time, exam_date, course_id, capacity, class_number);
}

void System::register_for_lesson(string id_str)
{
    is_natural_number(id_str);
    int id = stoi(id_str);
    bool is_id_exist = false;
    Course *wanted_course;
    for (auto lesson : offered_courses)
    {
        if (lesson->id == id)
        {
            wanted_course = lesson;
            is_id_exist = true;
        }
    }
    if (!is_id_exist)
        throw NotFound_Exception();
    for (auto user : users)
    {
        if (user->get_id() == entered_person.id)
            user->add_course(wanted_course);
    }
}

void System::delete_course(string id_str)
{
    is_natural_number(id_str);
    int id = stoi(id_str);

    for (auto user : users)
    {
        if (user->get_id() == entered_person.id)
            user->delete_course(id);
    }
}

void System::setting_profile(string profile_path)
{
    for (auto user : users)
    {
        if (user->get_id() == entered_person.id)
            user->set_profile_path(profile_path);
    }
}

User* System::find_wanted_user()
{
    is_arithmetic_number(wanted_user);

    for (auto user : users)
    {
        if (user->get_id() == wanted_user)
            return user;
    }

    throw NotFound_Exception();
}

User* System::find_current_user()
{
    for (auto user : users)
    {
        if (user->get_id() == entered_person.id)
            return user;
    }
    throw NotFound_Exception();
}

string System::who_are_you(string id)
{
    User* wanted_user;
    for (auto user : users) {
        if (user->get_id() == id)
            wanted_user = user;
    }
    if (dynamic_cast<Student *>(wanted_user))
        return "student";
    else if (dynamic_cast<Professor *>(wanted_user))
        return "professor";
    else
        return "manager";
    
}