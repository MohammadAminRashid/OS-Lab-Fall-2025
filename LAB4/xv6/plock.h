#include "spinlock.h"

struct plock_node {
    struct proc *process;
    int priority;
    struct plock_node *next;
};

struct plock {
    struct spinlock self_lock;
    int locked;
    struct plock_node *head;
    struct proc *owner;       
};

extern struct plock global_plock;

void plock_init(struct plock *pl);
void plock_acquire(struct plock *pl, int priority);
void plock_release(struct plock *pl);
