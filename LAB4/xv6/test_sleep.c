
int main() {
    printf (1, "\n");
    int pid=fork();
    if (pid==0) {
        sleep(10); 
        printf(1,"Child is trying to release lock of parent !!\n");
        test_lock_release(); 
        exit();
    }
    test_lock_acquire(); 
    wait();
    // test_lock_release(); 
    exit();
}