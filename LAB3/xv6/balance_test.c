#include "types.h"
#include "stat.h"
#include "user.h"

#define NCHILD 4

void busy(int id) {
  volatile int x = 0;
  printf(1, "child %d: start\n", id);
  for(int i = 0; i < 20000000; i++) 
    x += i;
  printf(1, "child %d: done\n", id);
}

int main(void) {
  int i, pid;
  printf(1, "balancetest: start\n");

  for(i = 0; i < NCHILD; i++){
    pid = fork();
    if(pid < 0){
      exit();
    }

    if(pid == 0){
      busy(i);
      exit();
    }
  }

  sleep(10);

  for(i = 0; i < NCHILD; i++)
    wait();

  printf(1, "balancetest: done\n");
  exit();
}

