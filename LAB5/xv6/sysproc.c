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

int algo_type = 1;
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

extern pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc);

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
        // cprintf("%d",i);
      }
    }
  }
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
  else if (algo_type == 2)
  {
    int min_count = 0x7FFFFFFF;
    for (int i = 0; i < MAX_PAGES; i++)
    {
      // cprintf("%d", page_table.pages[i].access_count);
      if (page_table.pages[i].access_count < min_count)
      {
        min_count = page_table.pages[i].access_count;
        victim = i;
        
      }
    }
  }
  cprintf("%d",victim);
  return victim;
}
void write_back_victim(int idx)
{
  struct PageEntry *vic = &page_table.pages[idx];
  // struct proc *p = myproc();

  // if (vic->valid && vic->paddr != 0)
  // {
  //   pte_t *pte = walkpgdir(p->pgdir, (void *)(vic->vpn * PGSIZE), 0);
  //   if (pte && (*pte & PTE_P))
  //   {
  //     memmove(P2V(PTE_ADDR(*pte)), vic->paddr, PGSIZE);
  //   }
  // }
  vic->valid = 0;
}

int find_page_entry(int vpn, int pid)
{
  for (int i = 0; i < MAX_PAGES; i++)
    if (page_table.pages[i].valid && page_table.pages[i].vpn == vpn && page_table.pages[i].pid == pid)
    {
      return i;
    }

  return -1;
}

int find_free_frame()
{
  for (int i = 0; i < MAX_PAGES; i++)
    if (!page_table.pages[i].valid)
    {
      return i;
    }
  return -1;
}

void load_page_into_frame(int idx, int vpn, int pid, char *phys_addr)
{
  // struct proc *p = myproc();
  // pte_t *pte = walkpgdir(p->pgdir, (void *)(vpn * PGSIZE), 0);

  // if (pte && (*pte & PTE_P))
  // {
  //   memmove(phys_addr, P2V(PTE_ADDR(*pte)), PGSIZE);
  // }
  // else
  // {
  //   memset(phys_addr, 0, PGSIZE);
  // }

  page_table.pages[idx].vpn = vpn;
  page_table.pages[idx].pid = pid;
  page_table.pages[idx].valid = 1;

  page_table.pages[idx].creation_time = global_page_time;
  page_table.pages[idx].last_access = global_page_time;
  page_table.pages[idx].access_count = 1;
  page_table.pages[idx].reference_bit = 1;
}

void update_access_metadata(int idx)
{
  page_table.pages[idx].last_access = global_page_time;
  page_table.pages[idx].access_count++;
  page_table.pages[idx].reference_bit = 1;
}

int get_target_frame()
{
  int free_idx = find_free_frame();
  if (free_idx != -1)
  {
    return free_idx;
  }

  return get_victim_index();
}

int sys_write_page(void)
{
  int va, data;
  global_page_time++;

  if (argint(0, &va) < 0 || argint(1, &data) < 0)
  {
    return -1;
  }

  int vpn = (PGROUNDDOWN(va) / PGSIZE);
  int offset = va % PGSIZE;
  int pid = myproc()->pid;

  // cprintf("\nvpn %d",vpn);

  acquire(&page_table.lock);

  int idx = find_page_entry(vpn, pid);

  if (idx != -1)
  {
    page_table.hit_count++;
    update_access_metadata(idx);
    *(int *)(page_table.pages[idx].paddr + offset) = data;
  }
  else
  {
    page_table.miss_count++;

    int target = get_target_frame();

    if (page_table.pages[target].valid)
    {
      write_back_victim(target);
    }

    if (page_table.pages[target].paddr == 0)
    {
      page_table.pages[target].paddr = kalloc();
    }

    load_page_into_frame(target, vpn, pid, page_table.pages[target].paddr);

    *(int *)(page_table.pages[target].paddr + offset) = data;
  }

  release(&page_table.lock);
  return 0;
}
int sys_read_page(void)
{
  int va;
  global_page_time++;

  if (argint(0, &va) < 0)
  {
    return -1;
  }

  int vpn = (PGROUNDDOWN(va) / PGSIZE);
  int offset = va % PGSIZE;
  int pid = myproc()->pid;
  int data = -1;

  acquire(&page_table.lock);

  int idx = find_page_entry(vpn, pid);

  // cprintf("\n%d\n", idx);

  if (idx != -1)
  {
    page_table.hit_count++;
    update_access_metadata(idx);
    data = *(int *)(page_table.pages[idx].paddr + offset);
  }
  else
  {
    page_table.miss_count++;

    // // int target = get_target_frame();
    // // if (page_table.pages[target].valid)
    // // {
    // //   write_back_victim(target);
    // // }

    // // if (page_table.pages[target].paddr == 0)
    // // {
    // //   page_table.pages[target].paddr = kalloc();
    // // }

    // load_page_into_frame(target, vpn, pid, page_table.pages[target].paddr);

    // // data = *(int *)(page_table.pages[target].paddr + offset);
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