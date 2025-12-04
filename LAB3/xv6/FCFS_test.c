#include "types.h"
#include "stat.h"
#include "user.h"

void busy(char *name, int loops)
{
  printf(1, "%s: busy start\n", name);
  volatile int x = 0;
  for (int i = 0; i < loops; i++)
    x += i;
  printf(1, "%s: busy end\n", name);
}

int main(void) {
  int pidA, pidB, pidC;

  printf(1, "fcfstest: start\n");

  pidA = fork();
  if(pidA < 0){
    exit();
  }

  if(pidA == 0){
    printf(1, "A: start (sleeping)\n");
    sleep(40);                 
    printf(1, "A: woke up\n");
    busy("A", 40000000);     
    printf(1, "A: done\n");
    exit();
  }

  sleep(5);                  

  pidB = fork();
  if(pidB < 0){
    exit();
  }

  if(pidB == 0){
    printf(1, "B: start (sleeping)\n");
    sleep(20);             
    printf(1, "B: woke up\n");
    busy("B", 50000000);     
    printf(1, "B: done\n");
    exit();
  }

  sleep(5);                 

  pidC = fork();
  if(pidC < 0){
    exit();
  }

  if(pidC == 0){
    printf(1, "C: start (no sleep)\n");
    busy("C", 60000000);   
    printf(1, "C: done\n");
    exit();
  }

  wait();
  wait();
  wait();

  printf(1, "fcfstest: done\n");
  exit();
}