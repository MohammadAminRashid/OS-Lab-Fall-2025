#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

#define MAX_PAGES 4

int algo_type = 0;
int global_page_time = 0;

struct PageEntry
{
  int vpn;
  char *paddr;
  int pid;
  int valid;

  int creation_time;
  int last_access;
  int access_count;
  int reference_bit;
};

struct
{
  struct spinlock lock;
  struct PageEntry pages[MAX_PAGES];

  int hit_count;
  int miss_count;
} page_table;

int sys_fork(void)
{
  return fork();
}

int sys_exit(void)
{
  exit();
  return 0; // not reached
}

int sys_wait(void)
{
  return wait();
}

int sys_kill(void)
{
  int pid;

  if (argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int sys_getpid(void)
{
  return myproc()->pid;
}

int sys_sbrk(void)
{
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

int sys_sleep(void)
{
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}




//////////////////Rashid

int get_victim_index()
{
  int victim = 0;

  if (algo_type == 0)
  {
    int min_time = 0x7FFFFFFF;
    for (int i = 0; i < MAX_PAGES; i++)
    {
      if (page_table.pages[i].creation_time < min_time)
      {
        min_time = page_table.pages[i].creation_time;
        victim = i;
      }
    }
  }
  // LRU
  else if (algo_type == 1)
  {
    int min_access = 0x7FFFFFFF;
    for (int i = 0; i < MAX_PAGES; i++)
    {
      if (page_table.pages[i].last_access < min_access)
      {
        min_access = page_table.pages[i].last_access;
        victim = i;
      }
    }
  }
  // LFU
  else if (algo_type == 2)
  {
    int min_count = 0x7FFFFFFF;

    for (int i = 0; i < MAX_PAGES; i++)
    {
      // cprintf("%d",page_table.pages[i].access_count);
      if (page_table.pages[i].access_count < min_count)
      {
        min_count = page_table.pages[i].access_count;
        victim = i;
      }
    }
    // cprintf("%d",victim);
  }

  else if (algo_type == 3)
  {
    // Do that
  }

  return victim;
}

int sys_write_page(void)
{
  int vpn, data, found;
  global_page_time += 1;
  if (argint(0, &vpn) < 0 || argint(1, &data) < 0)
  {
    return -1;
  }

  struct proc *curproc = myproc();
  found = -1;
  int current_pid = curproc->pid;

  acquire(&page_table.lock);
  for (int i = 0; i < MAX_PAGES; i++)
  {
    if (page_table.pages[i].vpn == vpn)
    {
      if (page_table.pages[i].valid == 1 && page_table.pages[i].pid == current_pid)
      {
        found = 1;
        page_table.hit_count++;
        page_table.pages[i].last_access = global_page_time;
        page_table.pages[i].access_count++;
        page_table.pages[i].reference_bit = 1;

        *(int *)(page_table.pages[i].paddr) = data;

        break;
      }
    }
  }

  if (found == -1)
  {
    page_table.miss_count++;
    int target_index;
    target_index = -1;

    for (int i = 0; i < MAX_PAGES; i++)
    {
      if (page_table.pages[i].valid == 0)
      {
        target_index = i;
        break;
      }
    }

    if (target_index == -1)
    {
      target_index = get_victim_index();
    }

    if (page_table.pages[target_index].paddr == 0)
    {
      page_table.pages[target_index].paddr = kalloc();
    }

    page_table.pages[target_index].vpn = vpn;
    page_table.pages[target_index].pid = current_pid;
    page_table.pages[target_index].valid = 1;
    page_table.pages[target_index].creation_time = global_page_time;
    page_table.pages[target_index].last_access = global_page_time;
    page_table.pages[target_index].access_count = 1;
    page_table.pages[target_index].reference_bit = 1;
    *(int *)(page_table.pages[target_index].paddr) = data;
  }

  release(&page_table.lock);
  return 0;
}

int sys_read_page(void)
{
  int vpn, data;
  data = -1;
  if (argint(0, &vpn) < 0)
  {
    return -1;
  }

  struct proc *curproc = myproc();
  int current_pid = curproc->pid;
  int found = 0;
  acquire(&page_table.lock);
  global_page_time += 1;

  for (int i = 0; i < MAX_PAGES; i++)
  {
    if (page_table.pages[i].vpn == vpn)
    {
      if (page_table.pages[i].valid == 1 && page_table.pages[i].pid == current_pid)
      {

        data = *(int *)(page_table.pages[i].paddr);
        page_table.hit_count++;
        page_table.pages[i].last_access = global_page_time;
        page_table.pages[i].access_count++;
        page_table.pages[i].reference_bit = 1;

        found = 1;

        break;
      }
    }
  }
  if (found == 0)
  {

    page_table.miss_count++;
  }
  release(&page_table.lock);
  return data;
}

void invalidate_pages_for_pid(int pid)
{
  acquire(&page_table.lock);

  for (int i = 0; i < MAX_PAGES; i++)
  {
    if (page_table.pages[i].valid && page_table.pages[i].pid == pid)
    {
      page_table.pages[i].valid = 0;
    }
  }
  release(&page_table.lock);
}