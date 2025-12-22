#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h" 

int main(int argc, char *argv[])
{
  if(argc < 2){
    printf(1, "\n");
    printf(1, "Usage: find_sum <string>\n");
    exit();
  }

  int sum = 0;
  int num = 0;
  int in_number = 0;
  char *current_char;
  int i;

  for(i = 1; i < argc; i++){
    current_char = argv[i];
    while(*current_char){
      if(*current_char >= '0' && *current_char <= '9'){
        num = num * 10 + (*current_char - '0');
        in_number = 1;
      } else {
        if(in_number){
          sum += num;
          num = 0;
          in_number = 0;
        }
      }
      current_char++;
    }

    if(in_number){
      sum += num;
      num = 0;
      in_number = 0;
    }
  }

  char buf[32];
  int len = 0;
  
  buf[len++] = '\n';
  
  if(sum == 0){
    buf[len++] = '0';
  } else {
    char buf_rev[32];
    int j = 0;

    while(sum > 0){
      buf_rev[j++] = (sum % 10) + '0';
      sum /= 10;
    }
    
    while(j > 0)
    buf[len++] = buf_rev[--j];
  }
  
  buf[len++] = '\n';
  
  unlink("result.txt");
  int fd = open("result.txt", O_CREATE | O_WRONLY);
  if(fd < 0){
    printf(1, "\n");
    printf(1, "cannot open result.txt\n");
    exit();
  }

  write(fd, buf, len);
  close(fd);
  printf(1, "\n");
  exit();
}