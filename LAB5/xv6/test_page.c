#include "types.h"
#include "stat.h"
#include "user.h"

#define PAGES 4
#define PAGE_SZ 4096

int align_up(int x, int a)
{
  int r = x % a;
  if(r == 0)
    return x;

  return x + (a - r);
}

int main()
{
    printf(1, "\n");

    int i;

    char *raw = sbrk(7 * PAGE_SZ);
    if(raw == (char*)-1){
        printf(1, "sbrk failed\n");
        exit();
    }
    int base = align_up(raw, PAGE_SZ);

    for (i = 0; i < PAGES; i++)
    {
        int va = (base + i * PAGE_SZ);
        write_page(va, i * 10);
    }

    for (i = 0; i < PAGES; i++)
    {
        int va = (base + i * PAGE_SZ);
        int value = read_page(va);
        printf(1, "Read from page %d (vpn=%x) => value=%d\n", i, va / PAGE_SZ, value);
    }

    read_page((base + 3 * PAGE_SZ));
    read_page((base + 3 * PAGE_SZ));
    read_page((base + 3 * PAGE_SZ));
    read_page((base + 1 * PAGE_SZ));
    read_page((base + 1 * PAGE_SZ));
    read_page((base + 2 * PAGE_SZ));
    read_page((base + 0 * PAGE_SZ));
    read_page((base + 0 * PAGE_SZ));

    write_page((base + 4 * PAGE_SZ), 4 * 10);
    write_page((base + 5 * PAGE_SZ), 5 * 10);
    
    exit();
}