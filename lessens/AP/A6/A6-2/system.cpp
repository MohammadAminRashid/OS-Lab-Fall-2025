#include "system.hpp"

using namespace std;

System::System(string majors_file, string students_file, string lessons_file, string professors_file)
{
    create_users(users, students_file, professors_file, majors_file);
    create_lessons(lessons, lessons_file);
    users.push_back(new Manager(MANAGER_ID, MANAGER_NAME, INVALID_MAJOR_ID, MANAGER_PASSWORD, majors_file));
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

            if (dynamic_cast<Student *>(users[i])) {
                person = STUDENT;
                return;
            }
            else if (dynamic_cast<Professor *>(users[i])) {
                person = PROFESSOR;
                return;
            }
            else if (dynamic_cast<Manager *>(users[i])) {
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
        for (auto user : users) {
            user->add_notification(user_id, user_name, message);
        }
    }
}

void System::posting(vector<string> order_words)
{
    if (condition == LOGOUT)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 7 && order_words.size() != 9)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string title = find_the_word_in_words_vector(order_words, "title");
    string message = find_the_word_in_words_vector(order_words, "message");

    string image_address;
    if (order_words.size() == 7)
        image_address = INVALID_IMAGE_ADDRESS;
    if (order_words.size() == 9)
        image_address = find_the_word_in_words_vector(order_words, "image");

        for (auto user : users)
        {
            if (user->get_id() == entered_id)
            {
                user->add_post(title, message, INVALID_COURSE_INFO, image_address);
                send_notification(entered_id, FIRST_NOTIF);
            }
        }

    cout << CONFIRMATION_MESSAGE << endl;
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
    for (auto lesson : offered_courses)
    {
        if (lesson->get_professor_id() == professor_id)
        {
            Time past_time = convert_string_to_Time(lesson->get_time());
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
        if (offered_courses.empty())
            throw runtime_error(EMPTY_MESSAGE);
        for (int i = 0; i < offered_courses.size(); i++)
        {
            offered_courses[i]->view_all_lessons();
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
    for (auto lesson : offered_courses)
    {
        if (lesson->get_id() == id)
        {
            is_id_exist = true;
            lesson->view_the_specific_lesson();
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
    Course *wanted_course;
    for (auto lesson : offered_courses)
    {
        if (lesson->get_id() == id)
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

void System::setting_profile(vector<string> order_words)
{
    if (condition == LOGOUT || person == MANAGER)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 5)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    profile_address = find_the_word_in_words_vector(order_words, "photo");
    cout << CONFIRMATION_MESSAGE << endl;
}

void System::send_TA_form(vector<string> order_words)
{
    if (condition == LOGOUT || person != PROFESSOR)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 7)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string course_id_str = find_the_word_in_words_vector(order_words, "course_id");
    string message = find_the_word_in_words_vector(order_words, "message");
    is_natural_number(course_id_str);
    int course_id = stoi(course_id_str);

    string course_name;
    bool is_id_exist = false;
    for (auto course : offered_courses) {
        if (course->get_id() == course_id) {
            is_id_exist = true;
            course_name = course->get_name();
        }
    }
    if (!is_id_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);
    for (auto user : users) {
        if (user->get_id() == entered_id)
            user->posting_TA_form(course_id, course_name, message);
    }
    send_notification(entered_id, FIFTH_NOTIF);
    cout << CONFIRMATION_MESSAGE << endl;
}

void System::send_TA_request(vector<string> order_words)
{
    if (condition == LOGOUT || person != STUDENT)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 7)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string professor_id = find_the_word_in_words_vector(order_words, "professor_id");
    string form_id_str = find_the_word_in_words_vector(order_words, "form_id");
    is_natural_number(form_id_str);
    is_arithmetic_number(professor_id);
    int form_id = stoi(form_id_str);

    bool is_professor_exist = false;
    for (auto user : users) {
        if (user->get_id() == professor_id && dynamic_cast<Professor *>(user))
            is_professor_exist = true;
    }
    if (!is_professor_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);

    string student_id;
    string student_name;
    int student_semester;
    for (auto user : users) {
        if (entered_id == user->get_id()) {
            student_id = user->get_id();
            student_name = user->get_name();
            student_semester = dynamic_cast<Student *>(user)->get_semester();
        }
    }
    for (auto user : users) {
        if (user->get_id() == professor_id)
            user->add_TA_request(form_id, student_id, student_name, student_semester);
    }
    cout << CONFIRMATION_MESSAGE << endl;
}

void System::close_TA_form(vector<string> order_words)
{
    if (condition == LOGOUT || person != PROFESSOR)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 5)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string form_id_str = find_the_word_in_words_vector(order_words, "id");
    is_natural_number(form_id_str);
    int form_id = stoi(form_id_str);

    for (auto user : users) {
        if (user->get_id() == entered_id) {
            user->check_TA_requests(users, offered_courses, form_id);
            user->delete_post(form_id);
        }
    }
}

void System::find_professor_and_TAs(int course_id, vector<string> &TAs_professor)
{
    for (auto user : users) {
        if(dynamic_cast<Professor *>(user)) {
            if (dynamic_cast<Professor *>(user)->checking_have_course(course_id)) 
                TAs_professor.push_back(user->get_id());
        }
        if(dynamic_cast<Student *>(user)) {
            if (dynamic_cast<Student *>(user)->checking_TA(course_id))
                TAs_professor.push_back(user->get_id());
        }
    }
}

void System::find_connected_users(int course_id, vector<string> &connected_users)
{
    for (auto user : users) {
        if(dynamic_cast<Professor *>(user)) {
            if (dynamic_cast<Professor *>(user)->checking_have_course(course_id))
                connected_users.push_back(user->get_id());
        }
        if(dynamic_cast<Student *>(user)) {
            if (dynamic_cast<Student *>(user)->checking_TA(course_id)) {
                if (find(connected_users.begin(), connected_users.end(), user->get_id()) == connected_users.end())
                    connected_users.push_back(user->get_id());
            }
            if (dynamic_cast<Student *>(user)->checking_have_course(course_id)) {
                if (find(connected_users.begin(), connected_users.end(), user->get_id()) == connected_users.end())
                    connected_users.push_back(user->get_id());
            }
        }
    }
}

void System::send_notification_for_course_posting(int course_id, string course_name)
{
    string course_id_str = to_string(course_id);
    
    vector<string> connected_users;
    
    find_connected_users(course_id, connected_users);

    for (auto connected_user : connected_users) {
        if (connected_user == entered_id)
            continue;
        for (auto user : users) {
            if (connected_user == user->get_id())
                user->add_notification(course_id_str, course_name, SIXTH_NOTIF);
        }
    }
}

void System::course_posting(vector<string> order_words)
{
    if (condition == LOGOUT || person == MANAGER)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 9 && order_words.size() != 11)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string course_id_str = find_the_word_in_words_vector(order_words, "id");
    string title = find_the_word_in_words_vector(order_words, "title");
    string message = find_the_word_in_words_vector(order_words, "message");
    is_natural_number(course_id_str);
    int course_id = stoi(course_id_str);

    string image_address;
    if (order_words.size() == 9)
        image_address = INVALID_IMAGE_ADDRESS;
    if (order_words.size() == 11)
        image_address = find_the_word_in_words_vector(order_words, "image");

    string user_name;
    for (auto user : users) {
        if (user->get_id() == entered_id) 
            user_name = user->get_name();
    }

    bool is_id_exist = false;
    for (auto course : offered_courses) {
        if (course->get_id() == course_id) 
            is_id_exist = true;
    }
    if (!is_id_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);
    vector<string> TAs_professor;
    find_professor_and_TAs(course_id, TAs_professor);
    bool can_posting = false;
    for (auto person : TAs_professor) {
        if (entered_id == person)
            can_posting = true;
    }
    if (!can_posting)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    for (auto course : offered_courses) {
        if (course->get_id() == course_id) {
            course->add_post_in_channel(user_name, title, message, image_address);
            send_notification_for_course_posting(course->get_id(), course->get_name());
        }
    }
    cout << CONFIRMATION_MESSAGE << endl;
}

void System::view_channel(vector<string> order_words)
{
    if (condition == LOGOUT || person == MANAGER)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 5)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string course_id_str = find_the_word_in_words_vector(order_words, "id");
    is_natural_number(course_id_str);
    int course_id = stoi(course_id_str);

    bool is_id_exist = false;
    for (auto course : offered_courses) {
        if (course->get_id() == course_id) 
            is_id_exist = true;
    }
    if (!is_id_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);

    vector<string> connected_users;
    find_connected_users(course_id, connected_users);
    bool can_see_channel = false;
    for (auto person : connected_users) {
        if (entered_id == person)
            can_see_channel = true;
    }
    if (!can_see_channel)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);

    for (auto course : offered_courses) {
        if (course->get_id() == course_id)
            course->view_channel();
    }
}

void System::view_a_post_in_channel(vector<string> order_words)
{
    if (condition == LOGOUT || person == MANAGER)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    if (order_words.size() != 7)
        throw runtime_error(WRONG_REQUEST_MESSAGE);

    string course_id_str = find_the_word_in_words_vector(order_words, "id");
    string post_id_str = find_the_word_in_words_vector(order_words, "post_id");
    is_natural_number(course_id_str);
    is_natural_number(post_id_str);
    int course_id = stoi(course_id_str);
    int post_id = stoi(post_id_str);

    bool is_courseId_exist = false;
    for (auto course : offered_courses) {
        if (course->get_id() == course_id) 
            is_courseId_exist = true;
    }
    if (!is_courseId_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);

    vector<string> connected_users;
    find_connected_users(course_id, connected_users);
    bool can_see_post = false;
    for (auto person : connected_users) {
        if (entered_id == person)
            can_see_post = true;
    }
    if (!can_see_post)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);

    for (auto course : offered_courses) {
        if (course->get_id() == course_id)
            course->view_post(post_id);
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
    else if (order_words[1] == CREATE_FORM)
        send_TA_form(order_words);
    else if (order_words[1] == TA_REQUEST)
        send_TA_request(order_words);
    else if (order_words[1] == CLOSE_FORM)
        close_TA_form(order_words);
    else if (order_words[1] == COURSE_POSTING)
        course_posting(order_words);
    else if (order_words[1] == SET_PROFILE)
        setting_profile(order_words);
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
    else if (order_words[1] == SHOW_CHANNEL)
        view_channel(order_words);
    else if (order_words[1] == SHOW_CHANNEL_POST)
        view_a_post_in_channel(order_words);
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