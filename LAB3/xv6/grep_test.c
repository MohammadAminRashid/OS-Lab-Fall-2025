#include "types.h"
#include "stat.h"
#include "user.h"

#define BUFSZ 512

int main(int argc, char *argv[])
{

    printf(1, "\n");

    if (argc != 3) {
        printf(1, "\n");
        exit();
    }

    char buf[BUFSZ];
    int n = grep_syscall(argv[1], argv[2], buf, BUFSZ);

    if (n < 0) {
        printf(1, "not found or error\n");
        exit();
    }

    printf(1, "%s\n", buf);

    exit();
}