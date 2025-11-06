CXX = g++ -g -std=c++20

FILES = main.o general_functions.o users.o system.o 
EXE = utms.out

all: $(EXE)


$(EXE): $(FILES)
	$(CXX) $^ -o $@


users.o: users.cpp users.hpp
	$(CXX) -c $< -o $@	
system.o: system.cpp system.hpp
	$(CXX) -c $< -o $@
general_functions.o: general_functions.cpp general_functions.hpp
	$(CXX) -c $< -o $@	
main.o: main.cpp general_functions.hpp
	$(CXX) -c $< -o $@			

.PHONY: all clean

clean:
	rm -f $(FILES) $(EXE)