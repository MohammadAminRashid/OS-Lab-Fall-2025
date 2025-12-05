#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    printf(1, "Starting scheduler test...\n");

    start_measure();

    int pid = fork();
    if (pid < 0) {
        printf(1, "Fork failed\n");
        exit();
    }

    if (pid == 0) {
        print_info();
        
        double x = 0;
        for (double z = 0; z < 100000.0; z += 0.1) {
             x = x + 3.14 * 89.64; 
        }
        
        exit();
    } else {
        wait(); 
        print_info(); 
        
    }
    
    end_measure();
    exit();
}