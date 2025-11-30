#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
    int n = 3;
    if (argc == 2)
    {
        n = atoi(argv[1]);
    }
    int pids[3];
    for (int i = 0; i <n ; i++)
    {
        int pid = fork();
        if (pid == 0)
        {
            sleep(200);
            exit();
        }
        else
        {
            pids[i] = pid;
        }
    }
    int ret = show_process_family(pids[0]);
    for (int i = 0; i < n; i++)
    {
        wait();
    }
    exit();
}
