#include <iostream>
#include <string>
#include "../server/server.hpp"
#include "handlers.hpp"

using namespace std;

void mapServerPaths(Server& server, System* &system) 
{
    server.setNotFoundErrPage("static/404.html");
    server.get("/", new ShowPage("static/login.html"));
    server.post("/", new LoginHandler(system));
    server.get("/get_profile", new ShowPage("static/get_profile.html"));
    server.post("/get_profile", new ProfileHandler(system));
    server.get("/profile_photo1.png", new ShowProfileHandler(system));
    server.get("/profile_photo2.png", new PageProfileHandler(system));
    server.get("/logout", new LogoutHandler(system));
    server.get("/student", new StudentPageHandler(system));
    server.get("/professor", new ProfessorPageHandler(system));
    server.get("/manager", new ManagerPageHandler(system));
    server.get("/send_post", new ShowPage("static/post.html"));
    server.post("/send_post", new PostHandler(system));
    server.get("/show_page", new ShowPage("static/show_page.html"));
    server.post("/show_page", new PersonalPageHandler(system));
    server.get("/add_course", new ShowPage("static/add_course.html"));
    server.post("/add_course", new AddCourseHandler(system));
    server.get("/show_offered_courses", new ShowCoursesHandler(system));
    server.get("/register_for_course", new ShowPage("static/course_register.html"));
    server.post("/register_for_course", new RegisterHandler(system));
    server.get("/show_own_courses", new ShowOwnCoursesHandler(system));
    server.get("/delete_course", new ShowPage("static/delete_course.html"));
    server.post("/delete_course", new DeleteCourseHandler(system));
}

int main(int argc, char* argv[]) {
    System* system = new System(argv[1], argv[2], argv[3], argv[4]);
    Server server(5000);
    mapServerPaths(server, system);
    server.run();
    return 0;
}
