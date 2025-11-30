#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  int a, b;

  if (argc != 3) {
    printf(2, "Usage: test_simple a b\n");
    exit();
  }
  
  a = atoi(argv[1]);
  b = atoi(argv[2]);

  int result = simple_arithmetic_syscall(a, b);
    
  exit();
}
