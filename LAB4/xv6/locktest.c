#include "types.h"
#include "stat.h"
#include "user.h"

#define NCPU 8 

void
print_scores(char *label, uint *scores) {
  printf(1, "%s (Spins per Acquisition):\n", label);
  int i;
  for(i = 0; i < NCPU; i++) {
    int val = (int)scores[i];
    printf(1, "CPU %d Cost: %d spins/lock\n", i, val);
  }
}

int
main(int argc, char *argv[])
{
  uint scores[NCPU];
  
  printf(1, "\nStarting Lock Contention Test...\n");

  if(getlockstat(scores) < 0) {
    printf(1, "ERROR: System call failed!\n");
    exit();
}
  print_scores("Initial Stats", scores);

  int n_children = 4;
  int i;
  for(i = 0; i < n_children; i++) {
    int pid = fork();
    if(pid == 0) {
      int j;
      for(j = 0; j < 1000; j++)
        sleep(1); 
      exit(); 
    }
  }

  for(i = 0; i < n_children; i++)
    wait(); 

  getlockstat(scores);
  print_scores("Final Stats", scores);

  exit();
}