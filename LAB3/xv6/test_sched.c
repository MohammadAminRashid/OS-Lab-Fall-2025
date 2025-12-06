#include "types.h"
#include "stat.h"
#include "user.h"

void heavy_computation() {
    volatile double x = 0;
    for (double z = 0; z < 4000000.0; z += 1.0) {
         x = x + 3.14 * 89.64; 
    }
}

int main(int argc, char *argv[]) {
    printf(1, "Starting scheduler test\n");

    start_measure();
    int N_CHILDREN = 6;

    for (int i = 0; i < N_CHILDREN; i++) {
        int pid = fork();
        
        if (pid < 0) {
            printf(1, "Fork failed\n");
            exit();
        }

        if (pid == 0) {
            heavy_computation();
            print_info(); 
            exit();
        }
    }

    for (int i = 0; i < N_CHILDREN; i++) {
        wait();
    }
    print_info(); 
    end_measure();
    exit();
}