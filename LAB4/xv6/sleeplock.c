// Sleeping locks

#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"

struct sleeplock test_lock;
int test_lock_inited = 0;

struct rwlock global_rw;
int rw_inited = 0;


void initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
}

void acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked)
  {
    sleep(lk, &lk->lk);
  }
  lk->locked=1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
}

void releasesleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  if (lk->pid != myproc()->pid)
  {
    panic("Panic in releasesleep !!: This process isn't the owner of this lock!");
  }
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
}

int holdingsleep(struct sleeplock *lk)
{
  int r;

  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
  release(&lk->lk);
  return r;
}



void rwlock_init(struct rwlock *rw, char *name)
{
  initlock(&rw->lk, "rwlock");
  rw->read_count = 0;
  rw->writing = 0;
  rw->name = name;
}

void rwlock_acquire_read(struct rwlock *rw)
{
  acquire(&rw->lk);
  while (rw->writing)
  {
    sleep(rw, &rw->lk);
  }
  rw->read_count+=1;
  release(&rw->lk);
}

void rwlock_release_read(struct rwlock *rw)
{
  acquire(&rw->lk);
  rw->read_count-=1;
  int readers=rw->read_count;
  if (readers==0)
  {
    wakeup(rw); 
  }
  release(&rw->lk);
}
void rwlock_acquire_write(struct rwlock *rw)
{
  acquire(&rw->lk);
  while ((rw->writing==1) || (rw->read_count>0))
  { 
    sleep(rw, &rw->lk);
  }
  rw->writing=1;
  release(&rw->lk);
}
void rwlock_release_write(struct rwlock *rw)
{
  acquire(&rw->lk);
  rw->writing=0;
  wakeup(rw); 
  release(&rw->lk);
}


void check_and_init_rw()
{
  if (rw_inited==0)
  {
    rwlock_init(&global_rw, "test_rw");
    rw_inited = 1;
  }
}

void check_and_init_test_lock()
{
  if (test_lock_inited == 0)
  {
    initsleeplock(&test_lock,"test_lock");
    test_lock_inited = 1;
  }
}