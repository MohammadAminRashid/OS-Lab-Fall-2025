
_find_sum:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fcntl.h" 

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 58             	sub    $0x58,%esp
  14:	8b 11                	mov    (%ecx),%edx
  16:	8b 49 04             	mov    0x4(%ecx),%ecx
  if(argc < 2){
  19:	83 fa 01             	cmp    $0x1,%edx
  1c:	0f 8e 5c 01 00 00    	jle    17e <main+0x17e>
  22:	8d 3c 91             	lea    (%ecx,%edx,4),%edi
  25:	8d 41 04             	lea    0x4(%ecx),%eax
    printf(1, "Usage: find_sum <string>\n");
    exit();
  }

  int sum = 0;
  int num = 0;
  28:	31 db                	xor    %ebx,%ebx
  2a:	89 7d a0             	mov    %edi,-0x60(%ebp)
  int sum = 0;
  2d:	89 c1                	mov    %eax,%ecx
  2f:	31 ff                	xor    %edi,%edi
  31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int in_number = 0;
  char *current_char;
  int i;

  for(i = 1; i < argc; i++){
    current_char = argv[i];
  38:	8b 11                	mov    (%ecx),%edx
    while(*current_char){
  3a:	0f be 02             	movsbl (%edx),%eax
  3d:	84 c0                	test   %al,%al
  3f:	74 4e                	je     8f <main+0x8f>
  41:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
  44:	31 f6                	xor    %esi,%esi
  46:	eb 1f                	jmp    67 <main+0x67>
  48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  4f:	90                   	nop
      if(*current_char >= '0' && *current_char <= '9'){
        num = num * 10 + (*current_char - '0');
  50:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
        in_number = 1;
  53:	be 01 00 00 00       	mov    $0x1,%esi
        num = num * 10 + (*current_char - '0');
  58:	8d 5c 48 d0          	lea    -0x30(%eax,%ecx,2),%ebx
    while(*current_char){
  5c:	0f be 42 01          	movsbl 0x1(%edx),%eax
          sum += num;
          num = 0;
          in_number = 0;
        }
      }
      current_char++;
  60:	83 c2 01             	add    $0x1,%edx
    while(*current_char){
  63:	84 c0                	test   %al,%al
  65:	74 1d                	je     84 <main+0x84>
      if(*current_char >= '0' && *current_char <= '9'){
  67:	8d 48 d0             	lea    -0x30(%eax),%ecx
  6a:	80 f9 09             	cmp    $0x9,%cl
  6d:	76 e1                	jbe    50 <main+0x50>
        if(in_number){
  6f:	85 f6                	test   %esi,%esi
  71:	74 e9                	je     5c <main+0x5c>
    while(*current_char){
  73:	0f be 42 01          	movsbl 0x1(%edx),%eax
          sum += num;
  77:	01 df                	add    %ebx,%edi
      current_char++;
  79:	83 c2 01             	add    $0x1,%edx
          in_number = 0;
  7c:	31 f6                	xor    %esi,%esi
          num = 0;
  7e:	31 db                	xor    %ebx,%ebx
    while(*current_char){
  80:	84 c0                	test   %al,%al
  82:	75 e3                	jne    67 <main+0x67>
    }

    if(in_number){
  84:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
  87:	85 f6                	test   %esi,%esi
  89:	74 04                	je     8f <main+0x8f>
      sum += num;
  8b:	01 df                	add    %ebx,%edi
      num = 0;
  8d:	31 db                	xor    %ebx,%ebx
  for(i = 1; i < argc; i++){
  8f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  92:	83 c1 04             	add    $0x4,%ecx
  95:	39 c1                	cmp    %eax,%ecx
  97:	75 9f                	jne    38 <main+0x38>
  }

  char buf[32];
  int len = 0;
  
  buf[len++] = '\n';
  99:	c6 45 a8 0a          	movb   $0xa,-0x58(%ebp)
  
  if(sum == 0){
  9d:	85 ff                	test   %edi,%edi
  9f:	75 63                	jne    104 <main+0x104>
    buf[len++] = '0';
  a1:	c6 45 a9 30          	movb   $0x30,-0x57(%ebp)
  a5:	bb 02 00 00 00       	mov    $0x2,%ebx
    buf[len++] = buf_rev[--j];
  }
  
  buf[len++] = '\n';
  
  unlink("result.txt");
  aa:	83 ec 0c             	sub    $0xc,%esp
  buf[len++] = '\n';
  ad:	c6 44 1d a8 0a       	movb   $0xa,-0x58(%ebp,%ebx,1)
  unlink("result.txt");
  b2:	68 72 08 00 00       	push   $0x872
  b7:	e8 77 03 00 00       	call   433 <unlink>
  int fd = open("result.txt", O_CREATE | O_WRONLY);
  bc:	58                   	pop    %eax
  bd:	5a                   	pop    %edx
  be:	68 01 02 00 00       	push   $0x201
  c3:	68 72 08 00 00       	push   $0x872
  c8:	e8 56 03 00 00       	call   423 <open>
  if(fd < 0){
  cd:	83 c4 10             	add    $0x10,%esp
  int fd = open("result.txt", O_CREATE | O_WRONLY);
  d0:	89 c6                	mov    %eax,%esi
  if(fd < 0){
  d2:	85 c0                	test   %eax,%eax
  d4:	0f 88 83 00 00 00    	js     15d <main+0x15d>
  buf[len++] = '\n';
  da:	83 c3 01             	add    $0x1,%ebx
    printf(1, "\n");
    printf(1, "cannot open result.txt\n");
    exit();
  }

  write(fd, buf, len);
  dd:	50                   	push   %eax
  de:	8d 45 a8             	lea    -0x58(%ebp),%eax
  e1:	53                   	push   %ebx
  e2:	50                   	push   %eax
  e3:	56                   	push   %esi
  e4:	e8 1a 03 00 00       	call   403 <write>
  close(fd);
  e9:	89 34 24             	mov    %esi,(%esp)
  ec:	e8 1a 03 00 00       	call   40b <close>
  printf(1, "\n");
  f1:	5a                   	pop    %edx
  f2:	59                   	pop    %ecx
  f3:	68 70 08 00 00       	push   $0x870
  f8:	6a 01                	push   $0x1
  fa:	e8 51 04 00 00       	call   550 <printf>
  exit();
  ff:	e8 df 02 00 00       	call   3e3 <exit>
  buf[len++] = '\n';
 104:	bb 01 00 00 00       	mov    $0x1,%ebx
    while(sum > 0){
 109:	7e 9f                	jle    aa <main+0xaa>
    int j = 0;
 10b:	31 c9                	xor    %ecx,%ecx
 10d:	8d 76 00             	lea    0x0(%esi),%esi
      buf_rev[j++] = (sum % 10) + '0';
 110:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
 115:	89 cb                	mov    %ecx,%ebx
 117:	8d 49 01             	lea    0x1(%ecx),%ecx
 11a:	f7 e7                	mul    %edi
 11c:	89 f8                	mov    %edi,%eax
 11e:	c1 ea 03             	shr    $0x3,%edx
 121:	8d 34 92             	lea    (%edx,%edx,4),%esi
 124:	01 f6                	add    %esi,%esi
 126:	29 f0                	sub    %esi,%eax
 128:	83 c0 30             	add    $0x30,%eax
 12b:	88 44 0d c7          	mov    %al,-0x39(%ebp,%ecx,1)
      sum /= 10;
 12f:	89 f8                	mov    %edi,%eax
 131:	89 d7                	mov    %edx,%edi
    while(sum > 0){
 133:	83 f8 09             	cmp    $0x9,%eax
 136:	7f d8                	jg     110 <main+0x110>
    while(j > 0)
 138:	8d 45 c8             	lea    -0x38(%ebp),%eax
 13b:	8d 4d a9             	lea    -0x57(%ebp),%ecx
 13e:	01 d8                	add    %ebx,%eax
    buf[len++] = buf_rev[--j];
 140:	0f b6 10             	movzbl (%eax),%edx
    while(j > 0)
 143:	8d 7d c8             	lea    -0x38(%ebp),%edi
 146:	83 c1 01             	add    $0x1,%ecx
    buf[len++] = buf_rev[--j];
 149:	88 51 ff             	mov    %dl,-0x1(%ecx)
    while(j > 0)
 14c:	89 c2                	mov    %eax,%edx
 14e:	83 e8 01             	sub    $0x1,%eax
 151:	39 fa                	cmp    %edi,%edx
 153:	75 eb                	jne    140 <main+0x140>
 155:	83 c3 02             	add    $0x2,%ebx
 158:	e9 4d ff ff ff       	jmp    aa <main+0xaa>
    printf(1, "\n");
 15d:	53                   	push   %ebx
 15e:	53                   	push   %ebx
 15f:	68 70 08 00 00       	push   $0x870
 164:	6a 01                	push   $0x1
 166:	e8 e5 03 00 00       	call   550 <printf>
    printf(1, "cannot open result.txt\n");
 16b:	5e                   	pop    %esi
 16c:	5f                   	pop    %edi
 16d:	68 7d 08 00 00       	push   $0x87d
 172:	6a 01                	push   $0x1
 174:	e8 d7 03 00 00       	call   550 <printf>
    exit();
 179:	e8 65 02 00 00       	call   3e3 <exit>
    printf(1, "\n");
 17e:	51                   	push   %ecx
 17f:	51                   	push   %ecx
 180:	68 70 08 00 00       	push   $0x870
 185:	6a 01                	push   $0x1
 187:	e8 c4 03 00 00       	call   550 <printf>
    printf(1, "Usage: find_sum <string>\n");
 18c:	5b                   	pop    %ebx
 18d:	5e                   	pop    %esi
 18e:	68 58 08 00 00       	push   $0x858
 193:	6a 01                	push   $0x1
 195:	e8 b6 03 00 00       	call   550 <printf>
    exit();
 19a:	e8 44 02 00 00       	call   3e3 <exit>
 19f:	90                   	nop

000001a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a1:	31 c0                	xor    %eax,%eax
{
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	53                   	push   %ebx
 1a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1b7:	83 c0 01             	add    $0x1,%eax
 1ba:	84 d2                	test   %dl,%dl
 1bc:	75 f2                	jne    1b0 <strcpy+0x10>
    ;
  return os;
}
 1be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c1:	89 c8                	mov    %ecx,%eax
 1c3:	c9                   	leave  
 1c4:	c3                   	ret    
 1c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	53                   	push   %ebx
 1d4:	8b 55 08             	mov    0x8(%ebp),%edx
 1d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1da:	0f b6 02             	movzbl (%edx),%eax
 1dd:	84 c0                	test   %al,%al
 1df:	75 17                	jne    1f8 <strcmp+0x28>
 1e1:	eb 3a                	jmp    21d <strcmp+0x4d>
 1e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e7:	90                   	nop
 1e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1ec:	83 c2 01             	add    $0x1,%edx
 1ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1f2:	84 c0                	test   %al,%al
 1f4:	74 1a                	je     210 <strcmp+0x40>
 1f6:	89 d9                	mov    %ebx,%ecx
 1f8:	0f b6 19             	movzbl (%ecx),%ebx
 1fb:	38 c3                	cmp    %al,%bl
 1fd:	74 e9                	je     1e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1ff:	29 d8                	sub    %ebx,%eax
}
 201:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 204:	c9                   	leave  
 205:	c3                   	ret    
 206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 210:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 214:	31 c0                	xor    %eax,%eax
 216:	29 d8                	sub    %ebx,%eax
}
 218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 21b:	c9                   	leave  
 21c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 21d:	0f b6 19             	movzbl (%ecx),%ebx
 220:	31 c0                	xor    %eax,%eax
 222:	eb db                	jmp    1ff <strcmp+0x2f>
 224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 22f:	90                   	nop

00000230 <strlen>:

uint
strlen(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 236:	80 3a 00             	cmpb   $0x0,(%edx)
 239:	74 15                	je     250 <strlen+0x20>
 23b:	31 c0                	xor    %eax,%eax
 23d:	8d 76 00             	lea    0x0(%esi),%esi
 240:	83 c0 01             	add    $0x1,%eax
 243:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 247:	89 c1                	mov    %eax,%ecx
 249:	75 f5                	jne    240 <strlen+0x10>
    ;
  return n;
}
 24b:	89 c8                	mov    %ecx,%eax
 24d:	5d                   	pop    %ebp
 24e:	c3                   	ret    
 24f:	90                   	nop
  for(n = 0; s[n]; n++)
 250:	31 c9                	xor    %ecx,%ecx
}
 252:	5d                   	pop    %ebp
 253:	89 c8                	mov    %ecx,%eax
 255:	c3                   	ret    
 256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25d:	8d 76 00             	lea    0x0(%esi),%esi

00000260 <memset>:

void*
memset(void *dst, int c, uint n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 267:	8b 4d 10             	mov    0x10(%ebp),%ecx
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	89 d7                	mov    %edx,%edi
 26f:	fc                   	cld    
 270:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 272:	8b 7d fc             	mov    -0x4(%ebp),%edi
 275:	89 d0                	mov    %edx,%eax
 277:	c9                   	leave  
 278:	c3                   	ret    
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <strchr>:

char*
strchr(const char *s, char c)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 28a:	0f b6 10             	movzbl (%eax),%edx
 28d:	84 d2                	test   %dl,%dl
 28f:	75 12                	jne    2a3 <strchr+0x23>
 291:	eb 1d                	jmp    2b0 <strchr+0x30>
 293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 297:	90                   	nop
 298:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 29c:	83 c0 01             	add    $0x1,%eax
 29f:	84 d2                	test   %dl,%dl
 2a1:	74 0d                	je     2b0 <strchr+0x30>
    if(*s == c)
 2a3:	38 d1                	cmp    %dl,%cl
 2a5:	75 f1                	jne    298 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2a7:	5d                   	pop    %ebp
 2a8:	c3                   	ret    
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2b0:	31 c0                	xor    %eax,%eax
}
 2b2:	5d                   	pop    %ebp
 2b3:	c3                   	ret    
 2b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2bf:	90                   	nop

000002c0 <gets>:

char*
gets(char *buf, int max)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2c5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 2c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2c9:	31 db                	xor    %ebx,%ebx
{
 2cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2ce:	eb 27                	jmp    2f7 <gets+0x37>
    cc = read(0, &c, 1);
 2d0:	83 ec 04             	sub    $0x4,%esp
 2d3:	6a 01                	push   $0x1
 2d5:	56                   	push   %esi
 2d6:	6a 00                	push   $0x0
 2d8:	e8 1e 01 00 00       	call   3fb <read>
    if(cc < 1)
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	85 c0                	test   %eax,%eax
 2e2:	7e 1d                	jle    301 <gets+0x41>
      break;
    buf[i++] = c;
 2e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2e8:	8b 55 08             	mov    0x8(%ebp),%edx
 2eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2ef:	3c 0a                	cmp    $0xa,%al
 2f1:	74 10                	je     303 <gets+0x43>
 2f3:	3c 0d                	cmp    $0xd,%al
 2f5:	74 0c                	je     303 <gets+0x43>
  for(i=0; i+1 < max; ){
 2f7:	89 df                	mov    %ebx,%edi
 2f9:	83 c3 01             	add    $0x1,%ebx
 2fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ff:	7c cf                	jl     2d0 <gets+0x10>
 301:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 30a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 30d:	5b                   	pop    %ebx
 30e:	5e                   	pop    %esi
 30f:	5f                   	pop    %edi
 310:	5d                   	pop    %ebp
 311:	c3                   	ret    
 312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000320 <stat>:

int
stat(const char *n, struct stat *st)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 325:	83 ec 08             	sub    $0x8,%esp
 328:	6a 00                	push   $0x0
 32a:	ff 75 08             	pushl  0x8(%ebp)
 32d:	e8 f1 00 00 00       	call   423 <open>
  if(fd < 0)
 332:	83 c4 10             	add    $0x10,%esp
 335:	85 c0                	test   %eax,%eax
 337:	78 27                	js     360 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 339:	83 ec 08             	sub    $0x8,%esp
 33c:	ff 75 0c             	pushl  0xc(%ebp)
 33f:	89 c3                	mov    %eax,%ebx
 341:	50                   	push   %eax
 342:	e8 f4 00 00 00       	call   43b <fstat>
  close(fd);
 347:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 34a:	89 c6                	mov    %eax,%esi
  close(fd);
 34c:	e8 ba 00 00 00       	call   40b <close>
  return r;
 351:	83 c4 10             	add    $0x10,%esp
}
 354:	8d 65 f8             	lea    -0x8(%ebp),%esp
 357:	89 f0                	mov    %esi,%eax
 359:	5b                   	pop    %ebx
 35a:	5e                   	pop    %esi
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    
 35d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 360:	be ff ff ff ff       	mov    $0xffffffff,%esi
 365:	eb ed                	jmp    354 <stat+0x34>
 367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36e:	66 90                	xchg   %ax,%ax

00000370 <atoi>:

int
atoi(const char *s)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 377:	0f be 02             	movsbl (%edx),%eax
 37a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 37d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 380:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 385:	77 1e                	ja     3a5 <atoi+0x35>
 387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 390:	83 c2 01             	add    $0x1,%edx
 393:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 396:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 39a:	0f be 02             	movsbl (%edx),%eax
 39d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3a0:	80 fb 09             	cmp    $0x9,%bl
 3a3:	76 eb                	jbe    390 <atoi+0x20>
  return n;
}
 3a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3a8:	89 c8                	mov    %ecx,%eax
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	8b 45 10             	mov    0x10(%ebp),%eax
 3b7:	8b 55 08             	mov    0x8(%ebp),%edx
 3ba:	56                   	push   %esi
 3bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3be:	85 c0                	test   %eax,%eax
 3c0:	7e 13                	jle    3d5 <memmove+0x25>
 3c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3c4:	89 d7                	mov    %edx,%edi
 3c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 3d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3d1:	39 f8                	cmp    %edi,%eax
 3d3:	75 fb                	jne    3d0 <memmove+0x20>
  return vdst;
}
 3d5:	5e                   	pop    %esi
 3d6:	89 d0                	mov    %edx,%eax
 3d8:	5f                   	pop    %edi
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    

000003db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3db:	b8 01 00 00 00       	mov    $0x1,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <exit>:
SYSCALL(exit)
 3e3:	b8 02 00 00 00       	mov    $0x2,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <wait>:
SYSCALL(wait)
 3eb:	b8 03 00 00 00       	mov    $0x3,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <pipe>:
SYSCALL(pipe)
 3f3:	b8 04 00 00 00       	mov    $0x4,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <read>:
SYSCALL(read)
 3fb:	b8 05 00 00 00       	mov    $0x5,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <write>:
SYSCALL(write)
 403:	b8 10 00 00 00       	mov    $0x10,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <close>:
SYSCALL(close)
 40b:	b8 15 00 00 00       	mov    $0x15,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <kill>:
SYSCALL(kill)
 413:	b8 06 00 00 00       	mov    $0x6,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <exec>:
SYSCALL(exec)
 41b:	b8 07 00 00 00       	mov    $0x7,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <open>:
SYSCALL(open)
 423:	b8 0f 00 00 00       	mov    $0xf,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <mknod>:
SYSCALL(mknod)
 42b:	b8 11 00 00 00       	mov    $0x11,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <unlink>:
SYSCALL(unlink)
 433:	b8 12 00 00 00       	mov    $0x12,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <fstat>:
SYSCALL(fstat)
 43b:	b8 08 00 00 00       	mov    $0x8,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <link>:
SYSCALL(link)
 443:	b8 13 00 00 00       	mov    $0x13,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <mkdir>:
SYSCALL(mkdir)
 44b:	b8 14 00 00 00       	mov    $0x14,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <chdir>:
SYSCALL(chdir)
 453:	b8 09 00 00 00       	mov    $0x9,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <dup>:
SYSCALL(dup)
 45b:	b8 0a 00 00 00       	mov    $0xa,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <getpid>:
SYSCALL(getpid)
 463:	b8 0b 00 00 00       	mov    $0xb,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <sbrk>:
SYSCALL(sbrk)
 46b:	b8 0c 00 00 00       	mov    $0xc,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <sleep>:
SYSCALL(sleep)
 473:	b8 0d 00 00 00       	mov    $0xd,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <uptime>:
SYSCALL(uptime)
 47b:	b8 0e 00 00 00       	mov    $0xe,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <make_duplicate>:
SYSCALL(make_duplicate)
 483:	b8 17 00 00 00       	mov    $0x17,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <show_process_family>:
SYSCALL(show_process_family)
 48b:	b8 18 00 00 00       	mov    $0x18,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <grep_syscall>:
SYSCALL(grep_syscall)
 493:	b8 19 00 00 00       	mov    $0x19,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <simple_arithmetic_syscall>:

.globl simple_arithmetic_syscall
simple_arithmetic_syscall:
  movl 4(%esp), %ebx  
 49b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  movl 8(%esp), %ecx  
 49f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  movl $SYS_simple_arithmetic_syscall, %eax # 
 4a3:	b8 16 00 00 00       	mov    $0x16,%eax
  int $T_SYSCALL    
 4a8:	cd 40                	int    $0x40
  ret                
 4aa:	c3                   	ret    
 4ab:	66 90                	xchg   %ax,%ax
 4ad:	66 90                	xchg   %ax,%ax
 4af:	90                   	nop

000004b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4b8:	89 d1                	mov    %edx,%ecx
{
 4ba:	83 ec 3c             	sub    $0x3c,%esp
 4bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 4c0:	85 d2                	test   %edx,%edx
 4c2:	0f 89 80 00 00 00    	jns    548 <printint+0x98>
 4c8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4cc:	74 7a                	je     548 <printint+0x98>
    x = -xx;
 4ce:	f7 d9                	neg    %ecx
    neg = 1;
 4d0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 4d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 4d8:	31 f6                	xor    %esi,%esi
 4da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4e0:	89 c8                	mov    %ecx,%eax
 4e2:	31 d2                	xor    %edx,%edx
 4e4:	89 f7                	mov    %esi,%edi
 4e6:	f7 f3                	div    %ebx
 4e8:	8d 76 01             	lea    0x1(%esi),%esi
 4eb:	0f b6 92 f4 08 00 00 	movzbl 0x8f4(%edx),%edx
 4f2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 4f6:	89 ca                	mov    %ecx,%edx
 4f8:	89 c1                	mov    %eax,%ecx
 4fa:	39 da                	cmp    %ebx,%edx
 4fc:	73 e2                	jae    4e0 <printint+0x30>
  if(neg)
 4fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 501:	85 c0                	test   %eax,%eax
 503:	74 07                	je     50c <printint+0x5c>
    buf[i++] = '-';
 505:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 50a:	89 f7                	mov    %esi,%edi
 50c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 50f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 512:	01 df                	add    %ebx,%edi
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 518:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 51b:	83 ec 04             	sub    $0x4,%esp
 51e:	88 45 d7             	mov    %al,-0x29(%ebp)
 521:	8d 45 d7             	lea    -0x29(%ebp),%eax
 524:	6a 01                	push   $0x1
 526:	50                   	push   %eax
 527:	56                   	push   %esi
 528:	e8 d6 fe ff ff       	call   403 <write>
  while(--i >= 0)
 52d:	89 f8                	mov    %edi,%eax
 52f:	83 c4 10             	add    $0x10,%esp
 532:	83 ef 01             	sub    $0x1,%edi
 535:	39 c3                	cmp    %eax,%ebx
 537:	75 df                	jne    518 <printint+0x68>
}
 539:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53c:	5b                   	pop    %ebx
 53d:	5e                   	pop    %esi
 53e:	5f                   	pop    %edi
 53f:	5d                   	pop    %ebp
 540:	c3                   	ret    
 541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 548:	31 c0                	xor    %eax,%eax
 54a:	eb 89                	jmp    4d5 <printint+0x25>
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000550 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 559:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 55c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 55f:	0f b6 1e             	movzbl (%esi),%ebx
 562:	83 c6 01             	add    $0x1,%esi
 565:	84 db                	test   %bl,%bl
 567:	74 67                	je     5d0 <printf+0x80>
 569:	8d 4d 10             	lea    0x10(%ebp),%ecx
 56c:	31 d2                	xor    %edx,%edx
 56e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 571:	eb 34                	jmp    5a7 <printf+0x57>
 573:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 577:	90                   	nop
 578:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 57b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 580:	83 f8 25             	cmp    $0x25,%eax
 583:	74 18                	je     59d <printf+0x4d>
  write(fd, &c, 1);
 585:	83 ec 04             	sub    $0x4,%esp
 588:	8d 45 e7             	lea    -0x19(%ebp),%eax
 58b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 58e:	6a 01                	push   $0x1
 590:	50                   	push   %eax
 591:	57                   	push   %edi
 592:	e8 6c fe ff ff       	call   403 <write>
 597:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 59a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 59d:	0f b6 1e             	movzbl (%esi),%ebx
 5a0:	83 c6 01             	add    $0x1,%esi
 5a3:	84 db                	test   %bl,%bl
 5a5:	74 29                	je     5d0 <printf+0x80>
    c = fmt[i] & 0xff;
 5a7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5aa:	85 d2                	test   %edx,%edx
 5ac:	74 ca                	je     578 <printf+0x28>
      }
    } else if(state == '%'){
 5ae:	83 fa 25             	cmp    $0x25,%edx
 5b1:	75 ea                	jne    59d <printf+0x4d>
      if(c == 'd'){
 5b3:	83 f8 25             	cmp    $0x25,%eax
 5b6:	0f 84 04 01 00 00    	je     6c0 <printf+0x170>
 5bc:	83 e8 63             	sub    $0x63,%eax
 5bf:	83 f8 15             	cmp    $0x15,%eax
 5c2:	77 1c                	ja     5e0 <printf+0x90>
 5c4:	ff 24 85 9c 08 00 00 	jmp    *0x89c(,%eax,4)
 5cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5cf:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d3:	5b                   	pop    %ebx
 5d4:	5e                   	pop    %esi
 5d5:	5f                   	pop    %edi
 5d6:	5d                   	pop    %ebp
 5d7:	c3                   	ret    
 5d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop
  write(fd, &c, 1);
 5e0:	83 ec 04             	sub    $0x4,%esp
 5e3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5e6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5ea:	6a 01                	push   $0x1
 5ec:	52                   	push   %edx
 5ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5f0:	57                   	push   %edi
 5f1:	e8 0d fe ff ff       	call   403 <write>
 5f6:	83 c4 0c             	add    $0xc,%esp
 5f9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5fc:	6a 01                	push   $0x1
 5fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 601:	52                   	push   %edx
 602:	57                   	push   %edi
 603:	e8 fb fd ff ff       	call   403 <write>
        putc(fd, c);
 608:	83 c4 10             	add    $0x10,%esp
      state = 0;
 60b:	31 d2                	xor    %edx,%edx
 60d:	eb 8e                	jmp    59d <printf+0x4d>
 60f:	90                   	nop
        printint(fd, *ap, 16, 0);
 610:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 613:	83 ec 0c             	sub    $0xc,%esp
 616:	b9 10 00 00 00       	mov    $0x10,%ecx
 61b:	8b 13                	mov    (%ebx),%edx
 61d:	6a 00                	push   $0x0
 61f:	89 f8                	mov    %edi,%eax
        ap++;
 621:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 624:	e8 87 fe ff ff       	call   4b0 <printint>
        ap++;
 629:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 62c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 62f:	31 d2                	xor    %edx,%edx
 631:	e9 67 ff ff ff       	jmp    59d <printf+0x4d>
        s = (char*)*ap;
 636:	8b 45 d0             	mov    -0x30(%ebp),%eax
 639:	8b 18                	mov    (%eax),%ebx
        ap++;
 63b:	83 c0 04             	add    $0x4,%eax
 63e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 641:	85 db                	test   %ebx,%ebx
 643:	0f 84 87 00 00 00    	je     6d0 <printf+0x180>
        while(*s != 0){
 649:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 64c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 64e:	84 c0                	test   %al,%al
 650:	0f 84 47 ff ff ff    	je     59d <printf+0x4d>
 656:	8d 55 e7             	lea    -0x19(%ebp),%edx
 659:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 65c:	89 de                	mov    %ebx,%esi
 65e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 660:	83 ec 04             	sub    $0x4,%esp
 663:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 666:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 669:	6a 01                	push   $0x1
 66b:	53                   	push   %ebx
 66c:	57                   	push   %edi
 66d:	e8 91 fd ff ff       	call   403 <write>
        while(*s != 0){
 672:	0f b6 06             	movzbl (%esi),%eax
 675:	83 c4 10             	add    $0x10,%esp
 678:	84 c0                	test   %al,%al
 67a:	75 e4                	jne    660 <printf+0x110>
      state = 0;
 67c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 67f:	31 d2                	xor    %edx,%edx
 681:	e9 17 ff ff ff       	jmp    59d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 686:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 689:	83 ec 0c             	sub    $0xc,%esp
 68c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 691:	8b 13                	mov    (%ebx),%edx
 693:	6a 01                	push   $0x1
 695:	eb 88                	jmp    61f <printf+0xcf>
        putc(fd, *ap);
 697:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 69a:	83 ec 04             	sub    $0x4,%esp
 69d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 6a0:	8b 03                	mov    (%ebx),%eax
        ap++;
 6a2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 6a5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6a8:	6a 01                	push   $0x1
 6aa:	52                   	push   %edx
 6ab:	57                   	push   %edi
 6ac:	e8 52 fd ff ff       	call   403 <write>
        ap++;
 6b1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6b4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6b7:	31 d2                	xor    %edx,%edx
 6b9:	e9 df fe ff ff       	jmp    59d <printf+0x4d>
 6be:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 6c0:	83 ec 04             	sub    $0x4,%esp
 6c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6c9:	6a 01                	push   $0x1
 6cb:	e9 31 ff ff ff       	jmp    601 <printf+0xb1>
 6d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 6d5:	bb 95 08 00 00       	mov    $0x895,%ebx
 6da:	e9 77 ff ff ff       	jmp    656 <printf+0x106>
 6df:	90                   	nop

000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	a1 9c 0b 00 00       	mov    0xb9c,%eax
{
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	57                   	push   %edi
 6e9:	56                   	push   %esi
 6ea:	53                   	push   %ebx
 6eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	39 c8                	cmp    %ecx,%eax
 6fc:	73 32                	jae    730 <free+0x50>
 6fe:	39 d1                	cmp    %edx,%ecx
 700:	72 04                	jb     706 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 702:	39 d0                	cmp    %edx,%eax
 704:	72 32                	jb     738 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 706:	8b 73 fc             	mov    -0x4(%ebx),%esi
 709:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 70c:	39 fa                	cmp    %edi,%edx
 70e:	74 30                	je     740 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 713:	8b 50 04             	mov    0x4(%eax),%edx
 716:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 719:	39 f1                	cmp    %esi,%ecx
 71b:	74 3a                	je     757 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 71d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 71f:	5b                   	pop    %ebx
  freep = p;
 720:	a3 9c 0b 00 00       	mov    %eax,0xb9c
}
 725:	5e                   	pop    %esi
 726:	5f                   	pop    %edi
 727:	5d                   	pop    %ebp
 728:	c3                   	ret    
 729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	39 d0                	cmp    %edx,%eax
 732:	72 04                	jb     738 <free+0x58>
 734:	39 d1                	cmp    %edx,%ecx
 736:	72 ce                	jb     706 <free+0x26>
{
 738:	89 d0                	mov    %edx,%eax
 73a:	eb bc                	jmp    6f8 <free+0x18>
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 740:	03 72 04             	add    0x4(%edx),%esi
 743:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 746:	8b 10                	mov    (%eax),%edx
 748:	8b 12                	mov    (%edx),%edx
 74a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 74d:	8b 50 04             	mov    0x4(%eax),%edx
 750:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 753:	39 f1                	cmp    %esi,%ecx
 755:	75 c6                	jne    71d <free+0x3d>
    p->s.size += bp->s.size;
 757:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 75a:	a3 9c 0b 00 00       	mov    %eax,0xb9c
    p->s.size += bp->s.size;
 75f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 762:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 765:	89 08                	mov    %ecx,(%eax)
}
 767:	5b                   	pop    %ebx
 768:	5e                   	pop    %esi
 769:	5f                   	pop    %edi
 76a:	5d                   	pop    %ebp
 76b:	c3                   	ret    
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000770 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 779:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 77c:	8b 15 9c 0b 00 00    	mov    0xb9c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	8d 78 07             	lea    0x7(%eax),%edi
 785:	c1 ef 03             	shr    $0x3,%edi
 788:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 78b:	85 d2                	test   %edx,%edx
 78d:	0f 84 8d 00 00 00    	je     820 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 793:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 795:	8b 48 04             	mov    0x4(%eax),%ecx
 798:	39 f9                	cmp    %edi,%ecx
 79a:	73 64                	jae    800 <malloc+0x90>
  if(nu < 4096)
 79c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7a1:	39 df                	cmp    %ebx,%edi
 7a3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7a6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7ad:	eb 0a                	jmp    7b9 <malloc+0x49>
 7af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7b2:	8b 48 04             	mov    0x4(%eax),%ecx
 7b5:	39 f9                	cmp    %edi,%ecx
 7b7:	73 47                	jae    800 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b9:	89 c2                	mov    %eax,%edx
 7bb:	3b 05 9c 0b 00 00    	cmp    0xb9c,%eax
 7c1:	75 ed                	jne    7b0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 7c3:	83 ec 0c             	sub    $0xc,%esp
 7c6:	56                   	push   %esi
 7c7:	e8 9f fc ff ff       	call   46b <sbrk>
  if(p == (char*)-1)
 7cc:	83 c4 10             	add    $0x10,%esp
 7cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 7d2:	74 1c                	je     7f0 <malloc+0x80>
  hp->s.size = nu;
 7d4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7d7:	83 ec 0c             	sub    $0xc,%esp
 7da:	83 c0 08             	add    $0x8,%eax
 7dd:	50                   	push   %eax
 7de:	e8 fd fe ff ff       	call   6e0 <free>
  return freep;
 7e3:	8b 15 9c 0b 00 00    	mov    0xb9c,%edx
      if((p = morecore(nunits)) == 0)
 7e9:	83 c4 10             	add    $0x10,%esp
 7ec:	85 d2                	test   %edx,%edx
 7ee:	75 c0                	jne    7b0 <malloc+0x40>
        return 0;
  }
}
 7f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7f3:	31 c0                	xor    %eax,%eax
}
 7f5:	5b                   	pop    %ebx
 7f6:	5e                   	pop    %esi
 7f7:	5f                   	pop    %edi
 7f8:	5d                   	pop    %ebp
 7f9:	c3                   	ret    
 7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 800:	39 cf                	cmp    %ecx,%edi
 802:	74 4c                	je     850 <malloc+0xe0>
        p->s.size -= nunits;
 804:	29 f9                	sub    %edi,%ecx
 806:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 809:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 80c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 80f:	89 15 9c 0b 00 00    	mov    %edx,0xb9c
}
 815:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 818:	83 c0 08             	add    $0x8,%eax
}
 81b:	5b                   	pop    %ebx
 81c:	5e                   	pop    %esi
 81d:	5f                   	pop    %edi
 81e:	5d                   	pop    %ebp
 81f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 820:	c7 05 9c 0b 00 00 a0 	movl   $0xba0,0xb9c
 827:	0b 00 00 
    base.s.size = 0;
 82a:	b8 a0 0b 00 00       	mov    $0xba0,%eax
    base.s.ptr = freep = prevp = &base;
 82f:	c7 05 a0 0b 00 00 a0 	movl   $0xba0,0xba0
 836:	0b 00 00 
    base.s.size = 0;
 839:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 840:	00 00 00 
    if(p->s.size >= nunits){
 843:	e9 54 ff ff ff       	jmp    79c <malloc+0x2c>
 848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 84f:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 850:	8b 08                	mov    (%eax),%ecx
 852:	89 0a                	mov    %ecx,(%edx)
 854:	eb b9                	jmp    80f <malloc+0x9f>
