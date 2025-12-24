#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "plock.h"

struct plock global_plock;

void plock_init(struct plock *pl)
{
  initlock(&pl->self_lock, "self_lock");
  pl->locked = 0;
  pl->owner = 0;
  pl->head = 0;
}

void plock_acquire(struct plock *pl, int priority)
{
  struct proc *requesting_proc = myproc();

  acquire(&pl->self_lock);

  if(pl->locked == 0){
    pl->locked = 1;
    pl->owner = requesting_proc;
    release(&pl->self_lock);
    return;
  }

  struct plock_node *new_node = (struct plock_node*)kalloc();
  if(new_node == 0)
    panic("Error in memory allocation for plock acquire!");

  new_node->process = requesting_proc;
  new_node->priority = priority;
  new_node->next = pl->head;
  pl->head = new_node;

  while(pl->owner != requesting_proc){
    sleep(requesting_proc, &pl->self_lock);
  }

  release(&pl->self_lock);
}


void plock_release(struct plock *pl)
{
  acquire(&pl->self_lock);

  if (pl->owner != myproc())
    panic("A process other than the owner has released the lock!");

  if(pl->head == 0){
    pl->locked = 0;
    pl->owner = 0;
    release(&pl->self_lock);
    return;
  }

  struct plock_node *best = pl->head;
  struct plock_node *current = pl->head;

  while(current != 0){
    if(current->priority > best->priority){
      best = current;
    }
    current = current->next;
  }

  if(best == pl->head){
    pl->head = best->next;
  } 
  else {
    struct plock_node *prev_best = pl->head;
    while(prev_best->next != best){
      prev_best = prev_best->next;
    }
    prev_best->next = best->next;
  }

  pl->locked = 1;
  pl->owner = best->process;    

  wakeup(best->process); 
  kfree((char*)best); 

  release(&pl->self_lock);
}


