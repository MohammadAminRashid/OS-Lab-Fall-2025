
#include "types.h"
#include "stat.h"
#include "user.h"

void busy_print(int id) {
  volatile unsigned long i = 0;

  while (1) {
 
    for (unsigned long k = 0; k < 1000000UL; k++)
      i++;
  }
}

int main(void) {
  for (int i = 1; i <= 4; i++) {
    if (fork() == 0) {
      busy_print(i);
      exit();
    }
  }

  for (;;)
    asm volatile("");

  exit();
}
