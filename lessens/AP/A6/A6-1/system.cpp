#include "system.hpp"

using namespace std;

System::System(string majors_file, string students_file, string lessons_file, string professors_file)
{
    create_users(users, students_file, professors_file, majors_file);
    create_lessons(lessons, lessons_file);
    users.push_back(new Manager("0", "UT_account", 0, "UT_account", majors_file));
    condition = LOGOUT;
    person = NONE;
}

void System::login(vector<string> order_words)
{
    if (condition == LOGIN)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 7)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string id = find_the_word_in_words_vector(order_words, "id");
    string password = find_the_word_in_words_vector(order_words, "password");
    is_arithmetic_number(id);

    for (int i = 0; i < users.size(); i++)
    {
        if (id == users[i]->get_id() && password != users[i]->get_password())
            throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
        if (id == users[i]->get_id() && password == users[i]->get_password())
        {
            cout << CONFIRMATION_MESSAGE << endl;
            entered_id = id;
            condition = LOGIN;

            if (dynamic_cast<Student *>(users[i]))
            {
                person = STUDENT;
                return;
            }
            else if (dynamic_cast<Professor *>(users[i]))
            {
                person = PROFESSOR;
                return;
            }
            else if (dynamic_cast<Manager *>(users[i]))
            {
                person = MANAGER;
                return;
            }
        }
    }
    throw runtime_error(NOT_FOUND_MESSAGE);
}

void System::logout(vector<string> order_words)
{
    if (condition == LOGOUT)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() > 3)
        throw runtime_error(WRONG_REQUEST_MESSAGE);
    cout << CONFIRMATION_MESSAGE << endl;
    condition = LOGOUT;
    person = NONE;
}

void System::send_notification(string id, string message)
{
    vector<string> user_friends;
    string user_id = id;
    string user_name;

    for (auto user : users)
    {
        if (user->get_id() == id)
        {
            user_name = user->get_name();
            user_friends = user->get_friends();
        }
    }

    if (person == STUDENT || person == PROFESSOR)
    {
        for (int i = 0; i < user_friends.size(); i++)
        {
            for (int j = 0; j < users.size(); j++)
            {
                if (user_friends[i] == users[j]->get_id())
                    users[j]->add_notification(user_id, user_name, message);
            }
        }
    }

    if (person == MANAGER)
    {
        for (auto user : users)
        {
            user->add_notification(user_id, user_name, message);
        }
    }
}

void System::posting(vector<string> order_words)
{
    if (condition == LOGOUT)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 7)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string title = find_the_word_in_words_vector(order_words, "title");
    string message = find_the_word_in_words_vector(order_words, "message");

    for (auto user : users)
    {
        if (user->get_id() == entered_id)
        {
            user->add_post(title, message);
            send_notification(entered_id, FIRST_NOTIF);
            cout << CONFIRMATION_MESSAGE << endl;
        }
    }
}

void System::get_connect(vector<string> order_words)
{
    if (condition == LOGOUT || person == MANAGER)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words[4] == entered_id)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string requested_id = find_the_word_in_words_vector(order_words, "id");
    is_natural_number(requested_id);

    bool is_user_exist = false;

    for (auto user : users)
    {
        if (requested_id == user->get_id())
        {
            user->add_friend(entered_id);
            is_user_exist = true;
        }
    }
    if (!is_user_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);
    for (auto user : users)
    {
        if (entered_id == user->get_id())
        {
            user->add_friend(requested_id);
            cout << CONFIRMATION_MESSAGE << endl;
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
    throw runtime_error(NOT_FOUND_MESSAGE);
}

void System::check_professor_id(int coures_id, string professor_id)
{
    int index = -1;
    vector<int> majors;

    for (int i = 0; i < users.size(); i++)
    {
        if (users[i]->get_id() == professor_id)
            index = i;
    }

    if (index == -1)
        throw runtime_error(NOT_FOUND_MESSAGE);
    if (!dynamic_cast<Professor *>(users[index]))
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);

    for (auto lesson : lessons)
    {
        if (lesson->id == coures_id)
            majors = lesson->major_ids;
    }

    for (int i = 0; i < majors.size(); i++)
    {
        if (users[index]->get_major_id() == majors[i])
            return;
    }
    throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
}

void System::check_course_time(string professor_id, string course_time)
{
    Time new_time = convert_string_to_Time(course_time);
    for (auto lesson : offered_lessons)
    {
        if (lesson->professor_id == professor_id)
        {
            Time past_time = convert_string_to_Time(lesson->time);
            if (new_time.day == past_time.day && past_time.start_time <= new_time.start_time && new_time.start_time < past_time.end_time)
                throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
            if (new_time.day == past_time.day && past_time.start_time < new_time.end_time && new_time.end_time <= past_time.end_time)
                throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
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

    id = offered_lessons.size() + 1;

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
    OfferedLesson *new_lesson = new OfferedLesson{id, course_name, capacity, professor_id, professor_name, time, exam_date, class_number, prerequisite, major_ids};
    offered_lessons.push_back(new_lesson);
    for (auto user : users)
    {
        if (user->get_id() == professor_id)
            user->add_course(new_lesson);
    }
}

void System::course_offering(vector<string> order_words)
{
    if (condition == LOGOUT || person != MANAGER)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 15)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string course_id_str = find_the_word_in_words_vector(order_words, "course_id");
    string professor_id = find_the_word_in_words_vector(order_words, "professor_id");
    string time = find_the_word_in_words_vector(order_words, "time");
    string exam_date = find_the_word_in_words_vector(order_words, "exam_date");
    string capacity_str = find_the_word_in_words_vector(order_words, "capacity");
    string class_number_str = find_the_word_in_words_vector(order_words, "class_number");

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
    send_notification(professor_id, SECOND_NOTIF);
    cout << CONFIRMATION_MESSAGE << endl;
}

void System::view_lessons(vector<string> order_words)
{
    if (condition == LOGOUT || person == MANAGER)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 5 && order_words.size() != 3)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    if (order_words.size() == 3)
    {
        if (offered_lessons.empty())
            throw runtime_error(EMPTY_MESSAGE);
        for (int i = 0; i < offered_lessons.size(); i++)
        {
            cout << offered_lessons[i]->id << " " << offered_lessons[i]->course_name << " " << offered_lessons[i]->capacity << " " << offered_lessons[i]->professor_name << endl;
        }
        return;
    }
    int id;
    if (order_words.size() == 5)
    {
        string id_str = find_the_word_in_words_vector(order_words, "id");
        is_natural_number(id_str);
        id = stoi(id_str);
    }
    bool is_id_exist = false;
    for (auto lesson : offered_lessons)
    {
        if (lesson->id == id)
        {
            is_id_exist = true;
            cout << lesson->id << " " << lesson->course_name << " " << lesson->capacity << " " << lesson->professor_name
                 << " " << lesson->time << " " << lesson->exam_date << " " << lesson->class_number << endl;
        }
    }
    if (!is_id_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);
}

void System::delete_post(vector<string> order_words)
{
    if (condition == LOGOUT)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 5)
        throw runtime_error(WRONG_REQUEST_MESSAGE);
    string id_str;
    int id;
    id_str = find_the_word_in_words_vector(order_words, "id");
    is_natural_number(id_str);
    id = stoi(id_str);

    for (auto user : users)
    {
        if (user->get_id() == entered_id)
            user->delete_post(id);
    }
    cout << CONFIRMATION_MESSAGE << endl;
}

void System::view_posts(vector<string> order_words)
{
    if (condition == LOGOUT || person == MANAGER)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 7)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string id = find_the_word_in_words_vector(order_words, "id");
    string post_id_str = find_the_word_in_words_vector(order_words, "post_id");
    is_arithmetic_number(id);
    is_natural_number(post_id_str);

    int post_id = stoi(post_id_str);
    bool is_id_exist = false;

    for (auto user : users)
    {
        if (user->get_id() == id)
            is_id_exist = true;
    }
    if (!is_id_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);

    for (auto user : users)
    {
        if (user->get_id() == id)
            user->print_post(post_id);
    }
}

void System::view_personal_page(vector<string> order_words)
{
    if (condition == LOGOUT || person == MANAGER)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 5)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string id = find_the_word_in_words_vector(order_words, "id");
    is_arithmetic_number(id);

    bool is_id_exist = false;

    for (auto user : users)
    {
        if (user->get_id() == id)
            is_id_exist = true;
    }
    if (!is_id_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);

    for (auto user : users)
    {
        if (user->get_id() == id)
            user->print_information();
    }
}

void System::view_notifications(vector<string> order_words)
{
    if (condition == LOGOUT || person == MANAGER)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 3)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    for (auto user : users)
    {
        if (user->get_id() == entered_id)
            user->view_notifications();
    }
}

void System::register_for_lesson(vector<string> order_words)
{
    if (condition == LOGOUT || person != STUDENT)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 5)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string id_str = find_the_word_in_words_vector(order_words, "id");
    is_natural_number(id_str);
    int id = stoi(id_str);
    bool is_id_exist = false;
    OfferedLesson *wanted_course;
    for (auto lesson : offered_lessons)
    {
        if (lesson->id == id)
        {
            wanted_course = lesson;
            is_id_exist = true;
        }
    }
    if (!is_id_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);
    for (auto user : users)
    {
        if (user->get_id() == entered_id)
            user->add_course(wanted_course);
    }
    send_notification(entered_id, THIRD_NOTIF);
    cout << CONFIRMATION_MESSAGE << endl;
}

void System::delete_course(vector<string> order_words)
{
    if (condition == LOGOUT || person != STUDENT)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 5)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string id_str = find_the_word_in_words_vector(order_words, "id");
    is_natural_number(id_str);
    int id = stoi(id_str);

    for (auto user : users)
    {
        if (user->get_id() == entered_id)
            user->delete_course(id);
    }
    send_notification(entered_id, FORTH_NOTIF);
    cout << CONFIRMATION_MESSAGE << endl;
}

void System::view_own_courses(vector<string> order_words)
{
    if (condition == LOGOUT || person != STUDENT)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 3)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    for (auto user : users)
    {
        if (user->get_id() == entered_id)
            user->view_own_courses();
    }
}

void System::handle_POST_orders(vector<string> order_words)
{
    if (order_words[1] == LOGIN_ORDER)
        login(order_words);
    else if (order_words[1] == LOGOUT_ORDER)
        logout(order_words);
    else if (order_words[1] == POSTING)
        posting(order_words);
    else if (order_words[1] == GET_CONNECT)
        get_connect(order_words);
    else if (order_words[1] == COURSE_OFFERING)
        course_offering(order_words);
    else
        throw runtime_error(NOT_FOUND_MESSAGE);
}

void System::handle_GET_orders(vector<string> order_words)
{
    if (order_words[1] == SHOW_COURSES)
        view_lessons(order_words);
    else if (order_words[1] == POSTING)
        view_posts(order_words);
    else if (order_words[1] == SHOW_PAGE)
        view_personal_page(order_words);
    else if (order_words[1] == SHOW_NOTIFICATION)
        view_notifications(order_words);
    else if (order_words[1] == COURSE_ORDERS)
        view_own_courses(order_words);
    else
        throw runtime_error(NOT_FOUND_MESSAGE);
}

void System::handle_PUT_orders(vector<string> order_words)
{
    if (order_words[1] == COURSE_ORDERS)
        register_for_lesson(order_words);
    else
        throw runtime_error(NOT_FOUND_MESSAGE);
}

void System::handle_DELETE_orders(vector<string> order_words)
{
    if (order_words[1] == POSTING)
        delete_post(order_words);
    else if (order_words[1] == COURSE_ORDERS)
        delete_course(order_words);
    else
        throw runtime_error(NOT_FOUND_MESSAGE);
}

void System::run()
{
    while (true)
    {
        try
        {
            vector<string> order_words = get_input_and_convert_to_string();
            if (order_words[2] != DELIMITER)
                throw runtime_error(WRONG_REQUEST_MESSAGE);
            if (order_words[0] == POST_ORDER)
                handle_POST_orders(order_words);
            else if (order_words[0] == GET_ORDER)
                handle_GET_orders(order_words);
            else if (order_words[0] == PUT_ORDER)
                handle_PUT_orders(order_words);
            else if (order_words[0] == DELETE_ORDER)
                handle_DELETE_orders(order_words);
            else
                throw runtime_error(WRONG_REQUEST_MESSAGE);
        }
        catch (runtime_error &error)
        {
            cout << error.what() << endl;
        }
    }
}