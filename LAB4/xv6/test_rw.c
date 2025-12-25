#include "types.h"
#include "stat.h"
#include "user.h"

int main()
{
    printf(1, "\n");

    if (fork()==0)
    {
        printf(1, "witer 1 try to get lock\n");
        rw_acquire_write();
        printf(1, "writer 1 entered!\n");
        sleep(40);
        printf(1, "writer 1 leaved\n");
        rw_release_write();
        exit();
    }

    if (fork()==0)
    {
        sleep(5);  
        printf(1, "witer 2 try to get lock\n");
        rw_acquire_write();  
        printf(1, "writer 2 entered!\n");
        sleep(40);
        printf(1, "writer 2 leaved\n");
        rw_release_write();
        exit();
    }

    for (int i =1; i<4; i++)
    {   
        if (fork()==0)
        {
            sleep(80+i*3);  
            printf(1, "reader %d try to get lock\n",i);
            rw_acquire_read();
            printf(1, "reader %d entered!\n",i);
            sleep(40);
            printf(1, "reader %d: Leaved\n",i);
            rw_release_read();
            exit();
        }
    }

    if (fork()==0)
    {
        sleep(100);  
        printf(1, "witer 3 try to get lock\n");
        rw_acquire_write();
        printf(1, "writer 3 entered!\n");
        sleep(40);
        printf(1, "writer 3 leaved\n");
        rw_release_write();
        exit();
    }

    for (int i=0; i<6; i++)
    {
        wait();
    }

    printf(1, "FINISH\n");
    exit();
}
