// Long-term locks for processes
struct sleeplock {
  uint locked;       // Is the lock held?
  struct spinlock lk; // spinlock protecting this sleep lock
  
  // For debugging:
  char *name;        // Name of lock.
  int pid;           // Process holding lock
};

struct rwlock {
  struct spinlock lk;
  int read_count;    
  int writing;      
  char *name;
};

extern struct sleeplock test_lock;
extern int test_lock_inited;

extern struct rwlock global_rw;
extern int rw_inited;

void check_and_init_rw(void);
void check_and_init_test_lock(void);

