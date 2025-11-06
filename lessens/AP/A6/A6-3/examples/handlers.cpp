#include "handlers.hpp"

#include <cstdlib>
#include <iostream>

using namespace std;

void set_the_head_of_users_pages(string &body)
{
    body += "<!DOCTYPE html>";
    body += "<html lang=\"en\">";

    body += "<head>";
    body += "  <title>Student Page</title>";
    body += "  <style>";
    body += "    body {";
    body += "      text-align: center;";
    body += "      font-family: 'Arial', sans-serif;";
    body += "      background-color: #f8f9fa;";
    body += "      margin: 0;";
    body += "      padding: 0;";
    body += "    }";
    body += "    .container {";
    body += "      width: 60%;";
    body += "      margin: 40px auto;";
    body += "      padding: 20px;";
    body += "      background-color: #ffffff;";
    body += "      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);";
    body += "      border-radius: 10px;";
    body += "    }";
    body += "    h1 {";
    body += "      color: #333;";
    body += "    }";
    body += "    .profile {";
    body += "      margin-bottom: 20px;";
    body += "    }";
    body += "    .profile img {";
    body += "      width: 150px;";
    body += "      height: 150px;";
    body += "      border-radius: 50%;";
    body += "      border: 4px solid #ddd;";
    body += "      margin-bottom: 5px;";
    body += "    }";
    body += "    h4 {";
    body += "      color: #666;";
    body += "      margin: 5px 0;";
    body += "    }";
    body += "    .actions a {";
    body += "      display: block;";
    body += "      margin: 10px 0;";
    body += "      padding: 10px;";
    body += "      background-color: #007bff;";
    body += "      color: white;";
    body += "      text-decoration: none;";
    body += "      border-radius: 5px;";
    body += "      transition: background-color 0.3s;";
    body += "    }";
    body += "    .actions a:hover {";
    body += "      background-color: #0056b3;";
    body += "    }";
    body += "    .upload-delete {";
    body += "      display: flex;";
    body += "      align-items: center;";
    body += "      justify-content: center;";
    body += "      gap: 10px;";
    body += "      margin-bottom: 10px;";
    body += "    }";
    body += "    .file-input-label, .delete-button {";
    body += "      display: inline-block;";
    body += "      padding: 10px;";
    body += "      background-color: #f0f0f0;";
    body += "      border: 1px solid #ccc;";
    body += "      border-radius: 5px;";
    body += "      cursor: pointer;";
    body += "      font-size: 14px;";
    body += "      transition: background-color 0.3s;";
    body += "    }";
    body += "    .file-input-label:hover, .delete-button:hover {";
    body += "      background-color: #ddd;";
    body += "    }";
    body += "    .file-input {";
    body += "      display: none;";
    body += "    }";
    body += "  </style>";
    body += "</head>";
}

void set_the_head_of_personal_pages(string &body, string page_title)
{
    body += "<!DOCTYPE html>";
        body += "<html lang=\"en\">";

        body += "<head>";
        body += "  <title>" + page_title + "</title>";
        body += "  <style>";
        body += "    body {";
        body += "      text-align: center;";
        body += "      font-family: 'Arial', sans-serif;";
        body += "      background-color: #f8f9fa;";
        body += "      margin: 0;";
        body += "      padding: 0;";
        body += "    }";
        body += "    .container {";
        body += "      width: 60%;";
        body += "      margin: 40px auto;";
        body += "      padding: 20px;";
        body += "      background-color: #ffffff;";
        body += "      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);";
        body += "      border-radius: 10px;";
        body += "    }";
        body += "    h1 {";
        body += "      color: #333;";
        body += "      margin-bottom: 20px;";
        body += "    }";
        body += "    .profile {";
        body += "      margin-bottom: 5px;";
        body += "    }";
        body += "    .profile img {";
        body += "      width: 150px;";
        body += "      height: 150px;";
        body += "      border-radius: 50%;";
        body += "      border: 4px solid #ddd;";
        body += "      margin-bottom: 5px;";
        body += "    }";
        body += "    .details {";
        body += "      margin-bottom: 20px;";
        body += "    }";
        body += "    .details h4 {";
        body += "      color: #666;";
        body += "      margin: 5px 0;";
        body += "    }";
        body += "    .post {";
        body += "      border: 1px solid #ccc;";
        body += "      padding: 10px;";
        body += "      margin-bottom: 10px;";
        body += "      border-radius: 5px;";
        body += "      background-color: #f0f0f0;";
        body += "    }";
        body += "    .post-title {";
        body += "      font-weight: bold;";
        body += "      display: block;";
        body += "      margin-bottom: 5px;";
        body += "    }";
        body += "    .post-message {";
        body += "      display: block;";
        body += "      color: #555;";
        body += "    }";
        body += "  </style>";
        body += "</head>";
}

void set_the_show_courses_pages(string &body, vector<Course*> courses)
{
    body += "<!DOCTYPE html>";
    body += "<html lang=\"en\">";
    body += "<head>";
    body += "  <title>Offered Courses</title>";
    body += "  <style>";
    body += "    body { font-family: Arial, sans-serif; text-align: center; background-color: #f4f4f9; color: #333; margin: 0; padding: 0; }";
    body += "    .container { width: 80%; margin: auto; padding: 20px; }";
    body += "    h1 { color: #333; margin-bottom: 20px; }";
    body += "    table { width: 100%; border-collapse: collapse; margin: 20px 0; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); }";
    body += "    th, td { border: 1px solid #ddd; padding: 12px; text-align: center; }";
    body += "    th { background-color: #4CAF50; color: white; font-weight: bold; }";
    body += "    tr:nth-child(even) { background-color: #f9f9f9; }";
    body += "    tr:hover { background-color: #f1f1f1; }";
    body += "    td { color: #555; }";
    body += "    @media (max-width: 768px) {";
    body += "      .container { width: 95%; }";
    body += "      th, td { padding: 8px; font-size: 14px; }";
    body += "    }";
    body += "  </style>";
    body += "</head>";
    body += "<body>";
    body += "  <div class=\"container\">";
    body += "    <h1>Offered Courses</h1>";
    body += "    <table>";
    body += "      <thead>";
    body += "        <tr>";
    body += "          <th>Course ID</th>";
    body += "          <th>Professor ID</th>";
    body += "          <th>Capacity</th>";
    body += "          <th>Time</th>";
    body += "          <th>Exam Date</th>";
    body += "          <th>Class Number</th>";
    body += "        </tr>";
    body += "      </thead>";
    body += "      <tbody>";

    for (Course* course : courses) {
        body += "        <tr>";
        body += "          <td>" + to_string(course->id) + "</td>";
        body += "          <td>" + course->professor_id + "</td>";
        body += "          <td>" + to_string(course->capacity) + "</td>";
        body += "          <td>" + course->time + "</td>";
        body += "          <td>" + course->exam_date + "</td>";
        body += "          <td>" + to_string(course->class_number) + "</td>";
        body += "        </tr>";
    }

    body += "      </tbody>";
    body += "    </table>";
    body += "  </div>";
    body += "</body>";
    body += "</html>";
}

Response* show_message(string message, string directory) 
{
    Response* res = new Response();

    res->setHeader("Content-Type", "text/html");

    string color;
    if (message == CONFIRMATION_MESSAGE)
        color = "green";
    else 
        color = "red";

    string body;
    body += "<!DOCTYPE html>";
    body += "<html lang=\"en\">";
    body += "<head>";
    body += "  <title>Notification</title>";
    body += "  <style>";
    body += "    .notification {";
    body += "      display: none;";
    body += "      position: fixed;";
    body += "      top: 0;";
    body += "      left: 50%;";
    body += "      transform: translateX(-50%);";
    body += "      width: 60%;";
    body += "      background-color: " + color + ";";
    body += "      color: white;";
    body += "      text-align: center;";
    body += "      padding: 20px;";
    body += "      font-size: 20px;";
    body += "      z-index: 1000;";
    body += "    }";
    body += "  </style>";
    body += "</head>";
    body += "<body>";
    body += "  <div class=\"notification\" id=\"notification\">" + message + "</div>";
    body += "  <script>";
    body += "    document.getElementById('notification').style.display = 'block';";
    body += "    setTimeout(function() {";
    body += "      document.getElementById('notification').style.display = 'none';";
    body += "      window.location.href = '" + directory + "';";
    body += "    }, 1500);";
    body += "  </script>";
    body += "</body>";
    body += "</html>";

    res->setBody(body);
    return res;
}

Response* LoginHandler::callback(Request* req) 
{
    try {
        string id = req->getBodyParam("id");
        string password = req->getBodyParam("password");

        system->login(id, password);
        Response* res = new Response();
    
        if (system->get_entered_person().user == STUDENT) 
            res = Response::redirect("/student");
        if (system->get_entered_person().user == PROFESSOR)
            res = Response::redirect("/professor");
        if (system->get_entered_person().user == MANAGER)
            res = Response::redirect("/manager");

        return res;
    }
    
    catch (Request_Exception ex) {
        return show_message(WRONG_REQUEST_MESSAGE, "/");
    }
    catch (NotFound_Exception ex) {
        return show_message(NOT_FOUND_MESSAGE, "/");
    }
    catch (Permission_Exception ex) {
        return show_message(ILLEGAL_ACCESS_MESSAGE, "/");
    }
}

Response* ProfileHandler::callback(Request* req) 
{
    string profile_name = req->getBodyParam("file_name");
    string file = req->getBodyParam("file");
    utils::writeToFile(file, profile_name);
    if (profile_name.empty())
        profile_name = INVALID_VALUE;
    system->find_current_user()->set_profile_path(profile_name);

    Response* res = new Response();
    
        if (system->get_entered_person().user == STUDENT) 
            res = Response::redirect("/student");
        if (system->get_entered_person().user == PROFESSOR)
            res = Response::redirect("/professor");
        if (system->get_entered_person().user == MANAGER)
            res = Response::redirect("/manager");

    return res;
}

Response* ShowProfileHandler::callback(Request* req) 
{
    Response* res = new Response();
    res->setHeader("Content-Type", "image/html");
    res->setBody(utils::readFile(system->find_current_user()->get_profile_path()));
    return res;
}

Response* PageProfileHandler::callback(Request* req) 
{
    Response* res = new Response();
    res->setHeader("Content-Type", "image/html");
    res->setBody(utils::readFile(system->find_wanted_user()->get_profile_path()));
    return res;
}

Response* StudentPageHandler::callback(Request* req) 
{
    string user_name = system->get_entered_person().name;
    string user_id = system->get_entered_person().id;
    string major_name = system->get_entered_person().major;

    Response* res = new Response();

    res->setHeader("Content-Type", "text/html");
    
    string body;

    set_the_head_of_users_pages(body);

    body += "<body>";
    body += "  <div class=\"container\">";
    body += "    <div class=\"profile\">";
    body += "      <h1>Welcome, " + user_name + "</h1>";
    body += "      <img src=\"profile_photo1.png\" alt=\"Profile\">";
    body += "      <h4>ID: " + user_id + "</h4>";
    body += "      <h4>Major: " + major_name + "</h4>";
    body += "    </div>";
    body += "    <div class=\"actions\">";
    body += "      <a href=\"/get_profile\">Change Profile Photo</a>";
    body += "      <a href=\"/send_post\">Send a Post</a>";
    body += "      <a href=\"/show_page\">Show Personal Page</a>";
    body += "      <a href=\"/show_offered_courses\">Show Offered Courses</a>";
    body += "      <a href=\"/register_for_course\">Register for a Course</a>";
    body += "      <a href=\"/show_own_courses\">Show Own Courses</a>";
    body += "      <a href=\"/delete_course\">Delete a Course</a>";
    body += "      <a href=\"/logout\">Log out</a>";
    body += "    </div>";
    body += "  </div>";
    body += "</body>";

    body += "</html>";
    res->setBody(body);
    
    return res;
}

Response* ProfessorPageHandler::callback(Request* req) 
{
    string user_name = system->get_entered_person().name;
    string user_id = system->get_entered_person().id;
    string major_name = system->get_entered_person().major;

    Response* res = new Response();
    res->setHeader("Content-Type", "text/html");

    res->setHeader("Content-Type", "text/html");

    string body;
    
    set_the_head_of_users_pages(body);

    body += "<body>";
    body += "  <div class=\"container\">";
    body += "    <div class=\"profile\">";
    body += "      <h1>Welcome, " + user_name + "</h1>";
    body += "      <img src=\"profile_photo1.png\" alt=\"Profile\">";
    body += "      <h4>ID: " + user_id + "</h4>";
    body += "      <h4>Major: " + major_name + "</h4>";
    body += "    </div>";
    body += "    <div class=\"actions\">";
    body += "      <a href=\"/get_profile\">Change Profile Photo</a>";
    body += "      <a href=\"/send_post\">Send a Post</a>";
    body += "      <a href=\"/show_page\">Show Personal Page</a>";
    body += "      <a href=\"/show_offered_courses\">Show Offered Courses</a>";
    body += "      <a href=\"/logout\">Log out</a>";
    body += "    </div>";
    body += "  </div>";
    body += "</body>";

    body += "</html>";
    res->setBody(body);
    return res;
}

Response* ManagerPageHandler::callback(Request* req) 
{
    string user_name = system->get_entered_person().name;

    Response* res = new Response();
    res->setHeader("Content-Type", "text/html");

    string body;

    set_the_head_of_users_pages(body);

    body += "<body>";
    body += "  <div class=\"container\">";
    body += "    <div class=\"profile\">";
    body += "      <h1>Welcome, " + user_name + "</h1>";
    body += "      <img src=\"profile_photo1.png\" alt=\"Profile\">";
    body += "    </div>";
    body += "    <div class=\"actions\">";
    body += "      <a href=\"/get_profile\">change profile photo</a>";
    body += "      <a href=\"/send_post\">send a post</a>";
    body += "      <a href=\"/add_course\">add a course</a>";
    body += "      <a href=\"/logout\">Log out</a>";
    body += "    </div>";
    body += "  </div>";
    body += "</body>";

    body += "</html>";
    res->setBody(body);
    return res;
}

Response* PostHandler::callback(Request* req) 
{
    try {
        string title = req->getBodyParam("title");
        string message = req->getBodyParam("message");

        system->posting(title, message);
    
        if (system->get_entered_person().user == STUDENT) 
            return show_message(CONFIRMATION_MESSAGE, "/student");
        else if (system->get_entered_person().user == PROFESSOR)
            return show_message(CONFIRMATION_MESSAGE, "/professor");
        else
            return show_message(CONFIRMATION_MESSAGE, "/manager");

    }
    
    catch (Request_Exception ex) {
        return show_message(WRONG_REQUEST_MESSAGE, "/send_post");
    }
}

Response* LogoutHandler::callback(Request* req) 
{
    Response* res = Response::redirect("/");
    return res;
}

Response* PersonalPageHandler::callback(Request* req) 
{
    try {
        string user_id = req->getBodyParam("user_id");

        system->set_wanted_user(user_id);
        User* user = system->find_wanted_user();

        string name = user->get_name();
        string profile_path = user->get_profile_path();
        vector<Post*> posts = user->get_posts();
        string page_title;
        string semester;
        string position;

        if (system->who_are_you(user_id) == "student") {
            page_title = "STUDENT PAGE";
            semester = to_string(dynamic_cast<Student*>(user)->get_semester());
            position = "INVALID_VALUE";
        } else if (system->who_are_you(user_id) == "professor") {
            page_title = "PROFESSOR PAGE";
            position = dynamic_cast<Professor*>(user)->get_position();
            semester = "INVALID_VALUE";
        } else if (system->who_are_you(user_id) == "manager") {
            page_title = "UT_ACCOUNT PAGE";
            semester = "INVALID_VALUE";
            position = "INVALID_VALUE";
        }

        Response* res = new Response();
        res->setHeader("Content-Type", "text/html");

        string body;

        set_the_head_of_personal_pages(body, page_title);        

        body += "<body>";
        body += "  <div class=\"container\">";
        body += "    <h1>" + page_title + "</h1>";

        body += "    <div class=\"profile\">";
        body += "      <img src=\"profile_photo2.png\" alt=\"Profile\">";
        body += "    </div>";

        body += "    <div class=\"details\">";
        body += "      <h4>Name: " + name + "</h4>";
        if (semester != "INVALID_VALUE") body += "      <h4>Semester: " + semester + "</h4>";
        if (position != "INVALID_VALUE") body += "      <h4>Position: " + position + "</h4>";
        body += "    </div>";

        for (Post* post : posts) {
            string title = post->title;
            string message = post->message;

            body += "    <div class=\"post\">";
            body += "      <span class=\"post-title\">" + title + "</span>";
            body += "      <span class=\"post-message\">" + message + "</span>";
            body += "    </div>";
        }

        body += "  </div>";
        body += "</body>";

        body += "</html>";
        res->setBody(body);

        return res;

    } catch (Request_Exception& ex) {
        return show_message(WRONG_REQUEST_MESSAGE, "/show_personal_page");
    } catch (NotFound_Exception& ex) {
        return show_message(NOT_FOUND_MESSAGE, "/show_personal_page");;
    }
}

Response* AddCourseHandler::callback(Request* req) 
{
    try {
        string course_id = req->getBodyParam("course_id");
        string professor_id = req->getBodyParam("professor_id");
        string capacity = req->getBodyParam("capacity");
        string time = req->getBodyParam("time");
        string exam_date = req->getBodyParam("exam_date");
        string class_number = req->getBodyParam("class_number");

        system->course_offering(course_id, professor_id, time, exam_date, capacity, class_number);

        return show_message(CONFIRMATION_MESSAGE, "/manager");
    }
    
    catch (Request_Exception ex) {
        return show_message(WRONG_REQUEST_MESSAGE, "/add_course");
    }
    catch (NotFound_Exception ex) {
        return show_message(NOT_FOUND_MESSAGE, "/add_course");
    }
    catch (Permission_Exception ex) {
        return show_message(ILLEGAL_ACCESS_MESSAGE, "/add_course");
    }
}

Response* ShowCoursesHandler::callback(Request* req) 
{
    vector<Course*> offered_courses = system->get_offered_courses();

    Response* res = new Response();
    res->setHeader("Content-Type", "text/html");

    string body;

    set_the_show_courses_pages(body, offered_courses);

    res->setBody(body);

    return res;
}

Response* RegisterHandler::callback(Request* req)
{
    try {
        string course_id = req->getBodyParam("course_id");

        system->register_for_lesson(course_id);

        return show_message(CONFIRMATION_MESSAGE, "/student");
    }
    catch (Request_Exception ex) {
        return show_message(WRONG_REQUEST_MESSAGE, "/register_for_course");
    }
    catch (NotFound_Exception ex) {
        return show_message(NOT_FOUND_MESSAGE, "/register_for_course");
    }
    catch (Permission_Exception ex) {
        return show_message(ILLEGAL_ACCESS_MESSAGE, "/register_for_course");
    }
}

Response* ShowOwnCoursesHandler::callback(Request* req)
{
    vector<Course*> my_courses = system->find_current_user()->get_courses();

    Response* res = new Response();
    res->setHeader("Content-Type", "text/html");

    string body;

    set_the_show_courses_pages(body, my_courses);

    res->setBody(body);

   
    return res;
}

Response* DeleteCourseHandler::callback(Request* req)
{
    try {
        string course_id = req->getBodyParam("course_id");

        system->delete_course(course_id);

        return show_message(CONFIRMATION_MESSAGE, "/student");
    }
    catch (Request_Exception ex) {
        return show_message(WRONG_REQUEST_MESSAGE, "/register_for_course");
    }
    catch (NotFound_Exception ex) {
        return show_message(NOT_FOUND_MESSAGE, "/register_for_course");
    }
}