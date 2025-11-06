#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <cmath>
#include <algorithm>
#include <cctype>
#include <sstream>
#include "system.hpp"

using namespace std;

int main(int argc, char *argv[])
{
    System system(argv[1], argv[2], argv[3], argv[4]);
    system.run();
    return 0;
}