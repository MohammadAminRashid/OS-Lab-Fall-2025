#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
       
    if (argc < 2)
    {
        printf(1, "\n");
        exit();
    }
    int pid = atoi(argv[1]);
    int ret = show_process_family(pid);
    
    if (ret == -1)
    {
        printf(1,"Not found process" );
    }


  
    exit();
}