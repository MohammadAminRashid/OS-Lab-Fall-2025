CXX := g++
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra -Wpedantic
THREADFLAGS := -pthread

OBJDIR := build
SRV_SRCS := server.cpp register.cpp login.cpp add_flight.cpp list_flights.cpp reservation.cpp
CLI_SRCS := client.cpp

SRV_OBJS := $(SRV_SRCS:%.cpp=$(OBJDIR)/%.o)
CLI_OBJS := $(CLI_SRCS:%.cpp=$(OBJDIR)/%.o)

all: server client

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/%.o: %.cpp | $(OBJDIR)
	$(CXX) $(CXXFLAGS) $(THREADFLAGS) -MMD -MP -c $< -o $@

server: $(SRV_OBJS)
	$(CXX) $(CXXFLAGS) $(THREADFLAGS) $(SRV_OBJS) -o $@

client: $(CLI_OBJS)
	$(CXX) $(CXXFLAGS) $(THREADFLAGS) $(CLI_OBJS) -o $@

clean:
	rm -rf $(OBJDIR) server client

-include $(SRV_OBJS:.o=.d) $(CLI_OBJS:.o=.d)