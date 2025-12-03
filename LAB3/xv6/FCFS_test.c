#include "types.h"
#include "stat.h"
#include "user.h"

void busy(char *name, int loops) {
  printf(1, "%s: busy start\n", name);
  volatile int x = 0;
  for (int i = 0; i < loops; i++)
    x += i;
  printf(1, "%s: busy end\n", name);
}

int main(void) {
  int pidA, pidB;
  pidA = fork();
  if(pidA < 0){
    exit();
  }

  if(pidA == 0){
    printf(1, "A: created (going to sleep)\n");
    sleep(120); 
    printf(1, "A: woke\n");
    busy("A", 80000000);   
    printf(1, "A: done\n");
    exit();
  }
  sleep(30);
  pidB = fork();
  if(pidB < 0){
    exit();
  }

  if(pidB == 0){
    printf(1, "B: created\n");
    busy("B", 200000000);  
    printf(1, "B: done\n");
    exit();
  }

  wait();
  wait();
  exit();
}