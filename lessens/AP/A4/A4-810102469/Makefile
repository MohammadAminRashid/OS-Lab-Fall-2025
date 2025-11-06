CXX = g++ -g -std=c++20

FILES = main.o general_functions.o cars.o stages.o workers.o 
EXE = CarWashManager

all: $(EXE)


$(EXE): $(FILES)
	$(CXX) $^ -o $@


cars.o: cars.cpp cars.hpp
	$(CXX) -c $< -o $@	
workers.o: workers.cpp workers.hpp
	$(CXX) -c $< -o $@
stages.o: stages.cpp stages.hpp
	$(CXX) -c $< -o $@
general_functions.o: general_functions.cpp general_functions.hpp
	$(CXX) -c $< -o $@	
main.o: main.cpp general_functions.hpp
	$(CXX) -c $< -o $@			

.PHONY: all clean

clean:
	rm -f $(FILES) $(EXE)