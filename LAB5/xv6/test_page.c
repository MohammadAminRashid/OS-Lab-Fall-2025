#include "types.h"
#include "stat.h"
#include "user.h"

#define PAGES 4
#define PAGE_SZ 4096

int main()
{
    int i;

    for (i = 0; i < PAGES; i++)
    {
        int va = i * PAGE_SZ;
        printf(1, "WRITE PAGE %d (va=%x) => value=%d\n", i, va, i * 10 + 1);
        write_page(va, i * 10 + 1);
    }
    read_page(2 * PAGE_SZ);
    read_page(2 * PAGE_SZ);
    read_page(2 * PAGE_SZ);
    read_page(2 * PAGE_SZ);
    read_page(2 * PAGE_SZ);
    read_page(0 * PAGE_SZ);
    read_page(1 * PAGE_SZ);
    write_page(4 * PAGE_SZ, 4 * 10 + 1);
    // write_page(5 * PAGE_SZ, 4 * 10 + 1);
    for (i = 0; i < PAGES + 1; i++)
    {
        int va = i * PAGE_SZ;
        int val = read_page(va);
        printf(1, "READ PAGE %d (va=%x) => got=%d\n", i, va, val);
        printf("\n %d", i);
    }

    exit();
}
