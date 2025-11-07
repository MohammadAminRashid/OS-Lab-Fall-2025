#include "types.h"
#include "stat.h"
#include "user.h"

void heavy_loop(char *process_type)
{
  long long i;
  long int count = 1;
  printf(1, "Process %s: STARTED\n", process_type);

  for (i = 0; i < 1000000000; i++) 
    count += 1;

  printf(1, "Process %s: FINISHED\n", process_type);
}

int main(int argc, char *argv[])
{
  int pid_low, pid_high;

  printf(1, "Parent: priority test started\n");

  pid_low = fork();
  if (pid_low == 0) {
    heavy_loop("LowPriority");
    exit();
  }

  pid_high = fork();
  if (pid_high == 0) {
    heavy_loop("HighPriority");
    exit();
  }

  if (pid_low > 0 && pid_high > 0) {
    set_priority_syscall(pid_low, 2);     
    set_priority_syscall(pid_high, 0);
    wait();
    wait();
    printf(1, "Parent: both children finished. test completed.\n");
  }

  exit();
}
