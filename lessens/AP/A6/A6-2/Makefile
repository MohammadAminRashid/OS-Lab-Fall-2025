CXX = g++ -g -std=c++20

FILES = main.o generals.o course.o users.o system.o 
EXE = utms.out

all: $(EXE)


$(EXE): $(FILES)
	$(CXX) $^ -o $@


users.o: users.cpp users.hpp
	$(CXX) -c $< -o $@
course.o: course.cpp course.hpp
	$(CXX) -c $< -o $@	
system.o: system.cpp system.hpp
	$(CXX) -c $< -o $@
generals.o: generals.cpp generals.hpp
	$(CXX) -c $< -o $@	
main.o: main.cpp generals.hpp
	$(CXX) -c $< -o $@			

.PHONY: all clean

clean:
	rm -f $(FILES) $(EXE)