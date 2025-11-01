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
    char *src = argv[1];
    int ret = make_duplicate(src);
    
    if (ret == -1)
    {
        printf(1,"No file with this name!" );
    }
    else if (ret == 0)
    {
        printf(1,"Completed duplicate!" );
    }

    else
    {
        printf(1,"Error");
    }

    printf(1, "\n");
    exit();
}