#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h" 

int
main(int argc, char *argv[])
{
  if(argc < 2){
    printf(1, "\n");
    printf(1, "Usage: find_sum <string>\n");
    exit();
  }

  int sum = 0;
  int num = 0;
  int in_number = 0;
  char *p;
  int i;

  for(i = 1; i < argc; i++){
    p = argv[i];
    while(*p){
      if(*p >= '0' && *p <= '9'){
        num = num * 10 + (*p - '0');
        in_number = 1;
      } else {
        if(in_number){
          sum += num;
          num = 0;
          in_number = 0;
        }
      }
      p++;
    }

    if(in_number){
      sum += num;
      num = 0;
      in_number = 0;
    }
  }

  unlink("result.txt");
  int fd = open("result.txt", O_CREATE | O_WRONLY);
  if(fd < 0){
    printf(1, "\n");
    printf(1, "find_sum: cannot open result.txt\n");
    exit();
  }

  char buf[32];
  int len = 0;
  int temp = sum;

  buf[len++] = '\n';

  if(temp == 0){
    buf[len++] = '0';
  } else {
    char rev[32];
    int j = 0;

    while(temp > 0){
      rev[j++] = (temp % 10) + '0';
      temp /= 10;
    }

    while(j > 0)
      buf[len++] = rev[--j];
  }

  buf[len++] = '\n';


  write(fd, buf, len);
  close(fd);
  printf(1, "\n");
  exit();
}