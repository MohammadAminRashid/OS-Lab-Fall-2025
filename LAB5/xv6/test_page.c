#include "types.h"
#include "stat.h"
#include "user.h"

int main(void)
{
    for (int i = 0; i < 4; i++)
    {
        write_page(i, i*100);
    }

    printf(1, "\nReading: %d\n", read_page(0));
    printf(1, "Reading: %d\n", read_page(1));
    printf(1, "Reading: %d\n", read_page(2));
    printf(1, "Reading: %d\n", read_page(3));
    printf(1, "Reading: %d\n", read_page(4));
    printf(1, "Reading: %d\n", read_page(5));
    printf(1, "Reading: %d\n", read_page(0));
    printf(1, "Reading: %d\n", read_page(1));
    printf(1, "Reading: %d\n", read_page(2));



    for (int i = 0; i < 4; i++)
    {
        write_page(i, i * 100 + 2);
    }

    printf(1, "\nReading: %d\n", read_page(0));
    printf(1, "Reading: %d\n", read_page(1));
    printf(1, "Reading: %d\n", read_page(3));
    printf(1, "Reading: %d\n", read_page(2));
    printf(1, "Reading: %d\n", read_page(4));
    printf(1, "Reading: %d\n", read_page(5));

    write_page(4, 400);
    write_page(5, 500);
    write_page(6, 10000);

    for (int i = 0; i <= 6; i++)
    {
        int val = read_page(i);
        printf(1, "Read VPN %d -> Value: %d\n", i, val);
    }


    for (int i = 0; i < 4; i++)
    {
        write_page(i, i * 100 + 3);
    }
    printf(1,"FINISH\n\n");
    exit();
}