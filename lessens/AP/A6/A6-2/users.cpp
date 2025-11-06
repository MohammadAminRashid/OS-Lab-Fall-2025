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

void User::add_post(string title, string message, string course_inf, string image_address)
{
    post_id += 1;
    int id = post_id;
    Post *new_post = new Post{id, title, message, course_inf, image_address};
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

bool Student::checking_have_course(int course_id)
{
    for (auto course : selected_courses) {
        if (course->get_id() == course_id)
            return true;
    }
    return false;
}


bool Student::checking_TA(int course_id)
{
    for (auto course : course_TAs) {
        if (course == course_id)
            return true;
    }
    return false;
}

Student::Student(string i, string n, int m_i, string p, int s, string majors_file)
    : User(i, n, m_i, p, majors_file)
{
    semester = s;
}

void Student::print_information()
{
    string courses_names;
    for (int i = 0; i < selected_courses.size(); i++)
    {
        courses_names += selected_courses[i]->get_name();
        if (i != selected_courses.size() - 1)
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
    for (int i = 0; i < selected_courses.size(); i++)
    {
        courses_names += selected_courses[i]->get_name();
        if (i != selected_courses.size() - 1)
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

void Student::add_course(Course *wanted_course)
{
    Course *new_lesson = new Course(*wanted_course);
    bool is_major_allowed = false;
    for (int i = 0; i < wanted_course->get_major_ids().size(); i++)
    {
        if (major_id == wanted_course->get_major_ids()[i])
            is_major_allowed = true;
    }
    if (!is_major_allowed)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);

    if (semester < wanted_course->get_prerequisite())
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);

    if (selected_courses.empty())
    {
        selected_courses.push_back(new_lesson);
        return;
    }
    Time new_time = convert_string_to_Time(wanted_course->get_time());
    Date new_date = convrt_string_to_Date(wanted_course->get_exam_date());
    for (auto lesson : selected_courses)
    {
        Time past_time = convert_string_to_Time(lesson->get_time());
        Date past_date = convrt_string_to_Date(lesson->get_exam_date());

        if (new_time.day == past_time.day && past_time.start_time <= new_time.start_time && new_time.start_time < past_time.end_time)
            throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
        if (new_time.day == past_time.day && past_time.start_time < new_time.end_time && new_time.end_time <= past_time.end_time)
            throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
        if (new_date.year == past_date.year && new_date.month == past_date.month && new_date.day == past_date.day)
            throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    }
    selected_courses.push_back(new_lesson);
}

void Student::delete_course(int id)
{
    for (auto lesson : selected_courses)
    {
        if (lesson->get_id() == id)
        {
            selected_courses.erase(remove(selected_courses.begin(), selected_courses.end(), lesson), selected_courses.end());
            delete lesson;
            return;
        }
    }
    throw runtime_error(NOT_FOUND_MESSAGE);
}

void Student::view_own_courses()
{
    if (selected_courses.empty())
        throw runtime_error(EMPTY_MESSAGE);
    for (auto lesson : selected_courses)
    {
        lesson->view_the_specific_lesson();
    }
}

void Student::add_course_TA(int course_id)
{
    if (find(course_TAs.begin(), course_TAs.end(), course_id) == course_TAs.end()) {
        course_TAs.push_back(course_id);
    }
}

Professor::Professor(string i, string n, int m_i, string p, string po, string majors_file)
    : User(i, n, m_i, p, majors_file)
{
    position = po;
}

bool Professor::checking_have_course(int course_id)
{
    for (auto course : selected_courses) {
        if (course->get_id() == course_id)
            return true;
    }
    return false;
}

void Professor::print_information()
{
    string courses_names;
    for (int i = 0; i < selected_courses.size(); i++)
    {
        courses_names += selected_courses[i]->get_name();
        if (i != selected_courses.size() - 1)
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
    for (int i = 0; i < selected_courses.size(); i++)
    {
        courses_names += selected_courses[i]->get_name();
        if (i != selected_courses.size() - 1)
        {
            courses_names += ",";
        }
    }

    cout << name << " " << major_name << " " << position << " " << courses_names << endl;
    for (auto post : posts)
    {
        if (post->id == post_id) {
            if (post->course_info == INVALID_COURSE_INFO)
                cout << post->id << " " << post->title << " " << post->message << endl;
            else
                cout << post->id << " " << post->title << endl << post->course_info << endl << post->message << endl;
        }
    }
}

void Professor::add_course(Course *wanted_course)
{
    selected_courses.push_back(wanted_course);
}


void Professor::posting_TA_form(int course_id, string course_name, string message)
{
    string course_inf = INVALID_COURSE_INFO;
    string title;
    for (auto course : selected_courses) {
        if (course_id == course->get_id()) {
            course_inf = course->create_course_inf();
        }
    }
    if (course_inf == INVALID_COURSE_INFO)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    title = TA_FORM_TITLE + " " + course_name + " " + "course";
    add_post(title, message, course_inf, INVALID_IMAGE_ADDRESS);
}

void Professor::add_TA_request(int form_id, string student_id, string student_name, int student_semester)
{
    bool is_form_exist = false;
    int course_id;
    int prerequisite;

    for (auto post : posts) {
        if (post->id == form_id && post->course_info != INVALID_COURSE_INFO) {
            is_form_exist = true;
            course_id = extract_course_id(post->course_info);
        }
    }
    if (!is_form_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);

    for (auto course : selected_courses) {
        if (course->get_id() == course_id)
            prerequisite = course->get_prerequisite();
    }

    if (student_semester <= prerequisite)
        throw runtime_error(ILLEGAL_ACCESS_MESSAGE);
    
    TA_requests.push_back(new TA_Request{form_id, course_id, student_id, student_name, student_semester});
}

void Professor::send_notification_for_TA_requests(vector<User*> &users, string student_id, int course_id, string status)
{
    string course_id_str = to_string(course_id);

    string message;
    if (status == REQUEST_ACCEPTION) 
        message = TA_NOTIF + " " + REQUEST_ACCEPTION + "ed.";
    if (status == REQUEST_REJECTION)
        message = TA_NOTIF + " " + REQUEST_REJECTION + "ed.";

    string course_name;
    for (auto course : selected_courses) {
        if (course->get_id() == course_id)
            course_name = course->get_name();
    }

    for (auto user : users) {
        if (user->get_id() == student_id)
            user->add_notification(course_id_str, course_name, message);
    }
}

void Professor::check_TA_requests(vector<User*> &users, vector<Course*> &offered_courses, int form_id)
{
    bool is_form_exist = false;
    for (auto post : posts) {
        if (post->id == form_id && post->course_info != INVALID_COURSE_INFO) 
            is_form_exist = true;
    }
    if (!is_form_exist)
        throw runtime_error(NOT_FOUND_MESSAGE);

    vector<TA_Request*> form_requests;
    for (auto request : TA_requests) {
        if (request->form_id == form_id)
            form_requests.push_back(request);
    }

    cout << "We have received " << form_requests.size() << " requests for the teaching assistant position" << endl;
    for (int i = 0; i < form_requests.size(); i++) {
        string request_status;
        cout << form_requests[i]->student_id << " " << form_requests[i]->student_name << " " << form_requests[i]->student_semester << ": ";
        getline(cin, request_status);

        if (request_status != REQUEST_ACCEPTION && request_status!= REQUEST_REJECTION) {
            i = i - 1;
            continue;
        }
        
        if (request_status == REQUEST_ACCEPTION) {
            for (auto user : users) {
                if (user->get_id() == form_requests[i]->student_id) {
                    user->add_course_TA(form_requests[i]->course_id);
                }
            }
        }

        send_notification_for_TA_requests(users, form_requests[i]->student_id, form_requests[i]->course_id, request_status);
    }
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