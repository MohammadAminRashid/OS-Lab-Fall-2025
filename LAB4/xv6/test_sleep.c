
int main() {
    printf (1, "\n");
    int pid=fork();
    if (pid==0) {
        sleep(10); 
        printf("Child trying to release parent's lock...\n");
        test_lock_release(); 
        exit();
    }
    test_lock_acquire(); 
    wait();
    // test_lock_release(); 
    exit();
}