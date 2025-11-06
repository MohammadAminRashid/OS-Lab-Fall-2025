#ifndef HANDLERS_HPP_INCLUDE
#define HANDLERS_HPP_INCLUDE

#include <map>
#include <string>
#include "system.hpp"

#include "../server/server.hpp"

class LoginHandler : public RequestHandler {
public:
    LoginHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class ProfileHandler : public RequestHandler {
public:
    ProfileHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class ShowProfileHandler : public RequestHandler {
public:
    ShowProfileHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class StudentPageHandler : public RequestHandler {
public:
    StudentPageHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class ProfessorPageHandler : public RequestHandler {
public:
    ProfessorPageHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class ManagerPageHandler : public RequestHandler {
public:
    ManagerPageHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class PostHandler : public RequestHandler {
public:
    PostHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class LogoutHandler : public RequestHandler {
public:
    LogoutHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class PersonalPageHandler : public RequestHandler {
public:
    PersonalPageHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class PageProfileHandler : public RequestHandler {
public:
    PageProfileHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class AddCourseHandler : public RequestHandler {
public:
    AddCourseHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class ShowCoursesHandler : public RequestHandler {
public:
    ShowCoursesHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class RegisterHandler : public RequestHandler {
public:
    RegisterHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class ShowOwnCoursesHandler : public RequestHandler {
public:
    ShowOwnCoursesHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};

class DeleteCourseHandler : public RequestHandler {
public:
    DeleteCourseHandler(System* sys) { system = sys; }
    Response* callback(Request*) override;
private:
    System* system;
};


#endif
