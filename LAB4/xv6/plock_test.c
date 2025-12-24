#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    int priorities[] = {10, 20, 30, 40, 50};
    int proc_count = 5;
    int pid;

    printf (1, "\n");

    for (int i = 0; i < proc_count; i++) {
        pid = fork();
        if (pid < 0) 
            exit();

        if (pid == 0) {
            int priority = priorities[i];
            if (i == 0) {
                sleep(5); 
            } 
            else {
                sleep(i * 20); 
            }
            printf(1, "REQUEST from PID %d with priority %d\n", getpid(), priority);
            
            plock_acquire(priority);
            printf(1, "ACQUIRED by PID %d with priority %d\n", getpid(), priority);
            
            if (i == 0) {
                sleep(160); 
            } 
            else {
                sleep(10);
            }

            printf(1, "RELEASING by PID %d with priority %d\n", getpid(), priority);
            plock_release();
    
            exit();
        }
    }

    for (int i = 0; i < proc_count; i++) {
        wait();
    }
    exit();
}