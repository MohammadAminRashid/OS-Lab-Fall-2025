
_grep_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"

#define BUFSZ 512

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	81 ec 14 02 00 00    	sub    $0x214,%esp
  16:	8b 19                	mov    (%ecx),%ebx
  18:	8b 71 04             	mov    0x4(%ecx),%esi

    printf(1, "\n");
  1b:	68 6a 07 00 00       	push   $0x76a
  20:	6a 01                	push   $0x1
  22:	e8 29 04 00 00       	call   450 <printf>

    if (argc != 3) {
  27:	83 c4 10             	add    $0x10,%esp
  2a:	83 fb 03             	cmp    $0x3,%ebx
  2d:	74 13                	je     42 <main+0x42>
        printf(1, "\n");
  2f:	51                   	push   %ecx
  30:	51                   	push   %ecx
  31:	68 6a 07 00 00       	push   $0x76a
  36:	6a 01                	push   $0x1
  38:	e8 13 04 00 00       	call   450 <printf>
        exit();
  3d:	e8 91 02 00 00       	call   2d3 <exit>
    }

    char buf[BUFSZ];
    int n = grep_syscall(argv[1], argv[2], buf, BUFSZ);
  42:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  48:	68 00 02 00 00       	push   $0x200
  4d:	53                   	push   %ebx
  4e:	ff 76 08             	pushl  0x8(%esi)
  51:	ff 76 04             	pushl  0x4(%esi)
  54:	e8 2a 03 00 00       	call   383 <grep_syscall>

    if (n < 0) {
  59:	83 c4 10             	add    $0x10,%esp
  5c:	85 c0                	test   %eax,%eax
  5e:	78 13                	js     73 <main+0x73>
        printf(1, "not found or error\n");
        exit();
    }

    printf(1, "%s\n", buf);
  60:	50                   	push   %eax
  61:	53                   	push   %ebx
  62:	68 6c 07 00 00       	push   $0x76c
  67:	6a 01                	push   $0x1
  69:	e8 e2 03 00 00       	call   450 <printf>

    exit();
  6e:	e8 60 02 00 00       	call   2d3 <exit>
        printf(1, "not found or error\n");
  73:	52                   	push   %edx
  74:	52                   	push   %edx
  75:	68 58 07 00 00       	push   $0x758
  7a:	6a 01                	push   $0x1
  7c:	e8 cf 03 00 00       	call   450 <printf>
        exit();
  81:	e8 4d 02 00 00       	call   2d3 <exit>
  86:	66 90                	xchg   %ax,%ax
  88:	66 90                	xchg   %ax,%ax
  8a:	66 90                	xchg   %ax,%ax
  8c:	66 90                	xchg   %ax,%ax
  8e:	66 90                	xchg   %ax,%ax

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  90:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  91:	31 c0                	xor    %eax,%eax
{
  93:	89 e5                	mov    %esp,%ebp
  95:	53                   	push   %ebx
  96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  a7:	83 c0 01             	add    $0x1,%eax
  aa:	84 d2                	test   %dl,%dl
  ac:	75 f2                	jne    a0 <strcpy+0x10>
    ;
  return os;
}
  ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b1:	89 c8                	mov    %ecx,%eax
  b3:	c9                   	leave  
  b4:	c3                   	ret    
  b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	53                   	push   %ebx
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
  c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ca:	0f b6 02             	movzbl (%edx),%eax
  cd:	84 c0                	test   %al,%al
  cf:	75 17                	jne    e8 <strcmp+0x28>
  d1:	eb 3a                	jmp    10d <strcmp+0x4d>
  d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  d7:	90                   	nop
  d8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  dc:	83 c2 01             	add    $0x1,%edx
  df:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  e2:	84 c0                	test   %al,%al
  e4:	74 1a                	je     100 <strcmp+0x40>
  e6:	89 d9                	mov    %ebx,%ecx
  e8:	0f b6 19             	movzbl (%ecx),%ebx
  eb:	38 c3                	cmp    %al,%bl
  ed:	74 e9                	je     d8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  ef:	29 d8                	sub    %ebx,%eax
}
  f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  f4:	c9                   	leave  
  f5:	c3                   	ret    
  f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 100:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 104:	31 c0                	xor    %eax,%eax
 106:	29 d8                	sub    %ebx,%eax
}
 108:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 10b:	c9                   	leave  
 10c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 10d:	0f b6 19             	movzbl (%ecx),%ebx
 110:	31 c0                	xor    %eax,%eax
 112:	eb db                	jmp    ef <strcmp+0x2f>
 114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 11f:	90                   	nop

00000120 <strlen>:

uint
strlen(const char *s)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 126:	80 3a 00             	cmpb   $0x0,(%edx)
 129:	74 15                	je     140 <strlen+0x20>
 12b:	31 c0                	xor    %eax,%eax
 12d:	8d 76 00             	lea    0x0(%esi),%esi
 130:	83 c0 01             	add    $0x1,%eax
 133:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 137:	89 c1                	mov    %eax,%ecx
 139:	75 f5                	jne    130 <strlen+0x10>
    ;
  return n;
}
 13b:	89 c8                	mov    %ecx,%eax
 13d:	5d                   	pop    %ebp
 13e:	c3                   	ret    
 13f:	90                   	nop
  for(n = 0; s[n]; n++)
 140:	31 c9                	xor    %ecx,%ecx
}
 142:	5d                   	pop    %ebp
 143:	89 c8                	mov    %ecx,%eax
 145:	c3                   	ret    
 146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14d:	8d 76 00             	lea    0x0(%esi),%esi

00000150 <memset>:

void*
memset(void *dst, int c, uint n)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 157:	8b 4d 10             	mov    0x10(%ebp),%ecx
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	89 d7                	mov    %edx,%edi
 15f:	fc                   	cld    
 160:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 162:	8b 7d fc             	mov    -0x4(%ebp),%edi
 165:	89 d0                	mov    %edx,%eax
 167:	c9                   	leave  
 168:	c3                   	ret    
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000170 <strchr>:

char*
strchr(const char *s, char c)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 17a:	0f b6 10             	movzbl (%eax),%edx
 17d:	84 d2                	test   %dl,%dl
 17f:	75 12                	jne    193 <strchr+0x23>
 181:	eb 1d                	jmp    1a0 <strchr+0x30>
 183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 187:	90                   	nop
 188:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 18c:	83 c0 01             	add    $0x1,%eax
 18f:	84 d2                	test   %dl,%dl
 191:	74 0d                	je     1a0 <strchr+0x30>
    if(*s == c)
 193:	38 d1                	cmp    %dl,%cl
 195:	75 f1                	jne    188 <strchr+0x18>
      return (char*)s;
  return 0;
}
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1a0:	31 c0                	xor    %eax,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    
 1a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1af:	90                   	nop

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1b5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 1b8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1b9:	31 db                	xor    %ebx,%ebx
{
 1bb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1be:	eb 27                	jmp    1e7 <gets+0x37>
    cc = read(0, &c, 1);
 1c0:	83 ec 04             	sub    $0x4,%esp
 1c3:	6a 01                	push   $0x1
 1c5:	56                   	push   %esi
 1c6:	6a 00                	push   $0x0
 1c8:	e8 1e 01 00 00       	call   2eb <read>
    if(cc < 1)
 1cd:	83 c4 10             	add    $0x10,%esp
 1d0:	85 c0                	test   %eax,%eax
 1d2:	7e 1d                	jle    1f1 <gets+0x41>
      break;
    buf[i++] = c;
 1d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1d8:	8b 55 08             	mov    0x8(%ebp),%edx
 1db:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1df:	3c 0a                	cmp    $0xa,%al
 1e1:	74 10                	je     1f3 <gets+0x43>
 1e3:	3c 0d                	cmp    $0xd,%al
 1e5:	74 0c                	je     1f3 <gets+0x43>
  for(i=0; i+1 < max; ){
 1e7:	89 df                	mov    %ebx,%edi
 1e9:	83 c3 01             	add    $0x1,%ebx
 1ec:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ef:	7c cf                	jl     1c0 <gets+0x10>
 1f1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1fd:	5b                   	pop    %ebx
 1fe:	5e                   	pop    %esi
 1ff:	5f                   	pop    %edi
 200:	5d                   	pop    %ebp
 201:	c3                   	ret    
 202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000210 <stat>:

int
stat(const char *n, struct stat *st)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	56                   	push   %esi
 214:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 215:	83 ec 08             	sub    $0x8,%esp
 218:	6a 00                	push   $0x0
 21a:	ff 75 08             	pushl  0x8(%ebp)
 21d:	e8 f1 00 00 00       	call   313 <open>
  if(fd < 0)
 222:	83 c4 10             	add    $0x10,%esp
 225:	85 c0                	test   %eax,%eax
 227:	78 27                	js     250 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	ff 75 0c             	pushl  0xc(%ebp)
 22f:	89 c3                	mov    %eax,%ebx
 231:	50                   	push   %eax
 232:	e8 f4 00 00 00       	call   32b <fstat>
  close(fd);
 237:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 23a:	89 c6                	mov    %eax,%esi
  close(fd);
 23c:	e8 ba 00 00 00       	call   2fb <close>
  return r;
 241:	83 c4 10             	add    $0x10,%esp
}
 244:	8d 65 f8             	lea    -0x8(%ebp),%esp
 247:	89 f0                	mov    %esi,%eax
 249:	5b                   	pop    %ebx
 24a:	5e                   	pop    %esi
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret    
 24d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 250:	be ff ff ff ff       	mov    $0xffffffff,%esi
 255:	eb ed                	jmp    244 <stat+0x34>
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax

00000260 <atoi>:

int
atoi(const char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	53                   	push   %ebx
 264:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 267:	0f be 02             	movsbl (%edx),%eax
 26a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 26d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 270:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 275:	77 1e                	ja     295 <atoi+0x35>
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 280:	83 c2 01             	add    $0x1,%edx
 283:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 286:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 28a:	0f be 02             	movsbl (%edx),%eax
 28d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 290:	80 fb 09             	cmp    $0x9,%bl
 293:	76 eb                	jbe    280 <atoi+0x20>
  return n;
}
 295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 298:	89 c8                	mov    %ecx,%eax
 29a:	c9                   	leave  
 29b:	c3                   	ret    
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	8b 45 10             	mov    0x10(%ebp),%eax
 2a7:	8b 55 08             	mov    0x8(%ebp),%edx
 2aa:	56                   	push   %esi
 2ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	85 c0                	test   %eax,%eax
 2b0:	7e 13                	jle    2c5 <memmove+0x25>
 2b2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2b4:	89 d7                	mov    %edx,%edi
 2b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2c1:	39 f8                	cmp    %edi,%eax
 2c3:	75 fb                	jne    2c0 <memmove+0x20>
  return vdst;
}
 2c5:	5e                   	pop    %esi
 2c6:	89 d0                	mov    %edx,%eax
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    

000002cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cb:	b8 01 00 00 00       	mov    $0x1,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <exit>:
SYSCALL(exit)
 2d3:	b8 02 00 00 00       	mov    $0x2,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <wait>:
SYSCALL(wait)
 2db:	b8 03 00 00 00       	mov    $0x3,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <pipe>:
SYSCALL(pipe)
 2e3:	b8 04 00 00 00       	mov    $0x4,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <read>:
SYSCALL(read)
 2eb:	b8 05 00 00 00       	mov    $0x5,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <write>:
SYSCALL(write)
 2f3:	b8 10 00 00 00       	mov    $0x10,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <close>:
SYSCALL(close)
 2fb:	b8 15 00 00 00       	mov    $0x15,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <kill>:
SYSCALL(kill)
 303:	b8 06 00 00 00       	mov    $0x6,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <exec>:
SYSCALL(exec)
 30b:	b8 07 00 00 00       	mov    $0x7,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <open>:
SYSCALL(open)
 313:	b8 0f 00 00 00       	mov    $0xf,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mknod>:
SYSCALL(mknod)
 31b:	b8 11 00 00 00       	mov    $0x11,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <unlink>:
SYSCALL(unlink)
 323:	b8 12 00 00 00       	mov    $0x12,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <fstat>:
SYSCALL(fstat)
 32b:	b8 08 00 00 00       	mov    $0x8,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <link>:
SYSCALL(link)
 333:	b8 13 00 00 00       	mov    $0x13,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mkdir>:
SYSCALL(mkdir)
 33b:	b8 14 00 00 00       	mov    $0x14,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <chdir>:
SYSCALL(chdir)
 343:	b8 09 00 00 00       	mov    $0x9,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <dup>:
SYSCALL(dup)
 34b:	b8 0a 00 00 00       	mov    $0xa,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <getpid>:
SYSCALL(getpid)
 353:	b8 0b 00 00 00       	mov    $0xb,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sbrk>:
SYSCALL(sbrk)
 35b:	b8 0c 00 00 00       	mov    $0xc,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <sleep>:
SYSCALL(sleep)
 363:	b8 0d 00 00 00       	mov    $0xd,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <uptime>:
SYSCALL(uptime)
 36b:	b8 0e 00 00 00       	mov    $0xe,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <make_duplicate>:
SYSCALL(make_duplicate)
 373:	b8 17 00 00 00       	mov    $0x17,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <show_process_family>:
SYSCALL(show_process_family)
 37b:	b8 18 00 00 00       	mov    $0x18,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <grep_syscall>:
SYSCALL(grep_syscall)
 383:	b8 19 00 00 00       	mov    $0x19,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 38b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <simple_arithmetic_syscall>:

.globl simple_arithmetic_syscall
simple_arithmetic_syscall:
  movl 4(%esp), %ebx  
 393:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  movl 8(%esp), %ecx  
 397:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  movl $SYS_simple_arithmetic_syscall, %eax 
 39b:	b8 16 00 00 00       	mov    $0x16,%eax
  int $T_SYSCALL    
 3a0:	cd 40                	int    $0x40
  ret                
 3a2:	c3                   	ret    
 3a3:	66 90                	xchg   %ax,%ax
 3a5:	66 90                	xchg   %ax,%ax
 3a7:	66 90                	xchg   %ax,%ax
 3a9:	66 90                	xchg   %ax,%ax
 3ab:	66 90                	xchg   %ax,%ax
 3ad:	66 90                	xchg   %ax,%ax
 3af:	90                   	nop

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3b8:	89 d1                	mov    %edx,%ecx
{
 3ba:	83 ec 3c             	sub    $0x3c,%esp
 3bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 3c0:	85 d2                	test   %edx,%edx
 3c2:	0f 89 80 00 00 00    	jns    448 <printint+0x98>
 3c8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3cc:	74 7a                	je     448 <printint+0x98>
    x = -xx;
 3ce:	f7 d9                	neg    %ecx
    neg = 1;
 3d0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 3d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3d8:	31 f6                	xor    %esi,%esi
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3e0:	89 c8                	mov    %ecx,%eax
 3e2:	31 d2                	xor    %edx,%edx
 3e4:	89 f7                	mov    %esi,%edi
 3e6:	f7 f3                	div    %ebx
 3e8:	8d 76 01             	lea    0x1(%esi),%esi
 3eb:	0f b6 92 d0 07 00 00 	movzbl 0x7d0(%edx),%edx
 3f2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3f6:	89 ca                	mov    %ecx,%edx
 3f8:	89 c1                	mov    %eax,%ecx
 3fa:	39 da                	cmp    %ebx,%edx
 3fc:	73 e2                	jae    3e0 <printint+0x30>
  if(neg)
 3fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 401:	85 c0                	test   %eax,%eax
 403:	74 07                	je     40c <printint+0x5c>
    buf[i++] = '-';
 405:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 40a:	89 f7                	mov    %esi,%edi
 40c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 40f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 412:	01 df                	add    %ebx,%edi
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 418:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 41b:	83 ec 04             	sub    $0x4,%esp
 41e:	88 45 d7             	mov    %al,-0x29(%ebp)
 421:	8d 45 d7             	lea    -0x29(%ebp),%eax
 424:	6a 01                	push   $0x1
 426:	50                   	push   %eax
 427:	56                   	push   %esi
 428:	e8 c6 fe ff ff       	call   2f3 <write>
  while(--i >= 0)
 42d:	89 f8                	mov    %edi,%eax
 42f:	83 c4 10             	add    $0x10,%esp
 432:	83 ef 01             	sub    $0x1,%edi
 435:	39 c3                	cmp    %eax,%ebx
 437:	75 df                	jne    418 <printint+0x68>
}
 439:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43c:	5b                   	pop    %ebx
 43d:	5e                   	pop    %esi
 43e:	5f                   	pop    %edi
 43f:	5d                   	pop    %ebp
 440:	c3                   	ret    
 441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 448:	31 c0                	xor    %eax,%eax
 44a:	eb 89                	jmp    3d5 <printint+0x25>
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 459:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 45c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 45f:	0f b6 1e             	movzbl (%esi),%ebx
 462:	83 c6 01             	add    $0x1,%esi
 465:	84 db                	test   %bl,%bl
 467:	74 67                	je     4d0 <printf+0x80>
 469:	8d 4d 10             	lea    0x10(%ebp),%ecx
 46c:	31 d2                	xor    %edx,%edx
 46e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 471:	eb 34                	jmp    4a7 <printf+0x57>
 473:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 477:	90                   	nop
 478:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 47b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 480:	83 f8 25             	cmp    $0x25,%eax
 483:	74 18                	je     49d <printf+0x4d>
  write(fd, &c, 1);
 485:	83 ec 04             	sub    $0x4,%esp
 488:	8d 45 e7             	lea    -0x19(%ebp),%eax
 48b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 48e:	6a 01                	push   $0x1
 490:	50                   	push   %eax
 491:	57                   	push   %edi
 492:	e8 5c fe ff ff       	call   2f3 <write>
 497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 49a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 49d:	0f b6 1e             	movzbl (%esi),%ebx
 4a0:	83 c6 01             	add    $0x1,%esi
 4a3:	84 db                	test   %bl,%bl
 4a5:	74 29                	je     4d0 <printf+0x80>
    c = fmt[i] & 0xff;
 4a7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4aa:	85 d2                	test   %edx,%edx
 4ac:	74 ca                	je     478 <printf+0x28>
      }
    } else if(state == '%'){
 4ae:	83 fa 25             	cmp    $0x25,%edx
 4b1:	75 ea                	jne    49d <printf+0x4d>
      if(c == 'd'){
 4b3:	83 f8 25             	cmp    $0x25,%eax
 4b6:	0f 84 04 01 00 00    	je     5c0 <printf+0x170>
 4bc:	83 e8 63             	sub    $0x63,%eax
 4bf:	83 f8 15             	cmp    $0x15,%eax
 4c2:	77 1c                	ja     4e0 <printf+0x90>
 4c4:	ff 24 85 78 07 00 00 	jmp    *0x778(,%eax,4)
 4cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d3:	5b                   	pop    %ebx
 4d4:	5e                   	pop    %esi
 4d5:	5f                   	pop    %edi
 4d6:	5d                   	pop    %ebp
 4d7:	c3                   	ret    
 4d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop
  write(fd, &c, 1);
 4e0:	83 ec 04             	sub    $0x4,%esp
 4e3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4e6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4ea:	6a 01                	push   $0x1
 4ec:	52                   	push   %edx
 4ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4f0:	57                   	push   %edi
 4f1:	e8 fd fd ff ff       	call   2f3 <write>
 4f6:	83 c4 0c             	add    $0xc,%esp
 4f9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4fc:	6a 01                	push   $0x1
 4fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 501:	52                   	push   %edx
 502:	57                   	push   %edi
 503:	e8 eb fd ff ff       	call   2f3 <write>
        putc(fd, c);
 508:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50b:	31 d2                	xor    %edx,%edx
 50d:	eb 8e                	jmp    49d <printf+0x4d>
 50f:	90                   	nop
        printint(fd, *ap, 16, 0);
 510:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 513:	83 ec 0c             	sub    $0xc,%esp
 516:	b9 10 00 00 00       	mov    $0x10,%ecx
 51b:	8b 13                	mov    (%ebx),%edx
 51d:	6a 00                	push   $0x0
 51f:	89 f8                	mov    %edi,%eax
        ap++;
 521:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 524:	e8 87 fe ff ff       	call   3b0 <printint>
        ap++;
 529:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 52c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 52f:	31 d2                	xor    %edx,%edx
 531:	e9 67 ff ff ff       	jmp    49d <printf+0x4d>
        s = (char*)*ap;
 536:	8b 45 d0             	mov    -0x30(%ebp),%eax
 539:	8b 18                	mov    (%eax),%ebx
        ap++;
 53b:	83 c0 04             	add    $0x4,%eax
 53e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 541:	85 db                	test   %ebx,%ebx
 543:	0f 84 87 00 00 00    	je     5d0 <printf+0x180>
        while(*s != 0){
 549:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 54c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 54e:	84 c0                	test   %al,%al
 550:	0f 84 47 ff ff ff    	je     49d <printf+0x4d>
 556:	8d 55 e7             	lea    -0x19(%ebp),%edx
 559:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 55c:	89 de                	mov    %ebx,%esi
 55e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 560:	83 ec 04             	sub    $0x4,%esp
 563:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 566:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 569:	6a 01                	push   $0x1
 56b:	53                   	push   %ebx
 56c:	57                   	push   %edi
 56d:	e8 81 fd ff ff       	call   2f3 <write>
        while(*s != 0){
 572:	0f b6 06             	movzbl (%esi),%eax
 575:	83 c4 10             	add    $0x10,%esp
 578:	84 c0                	test   %al,%al
 57a:	75 e4                	jne    560 <printf+0x110>
      state = 0;
 57c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 57f:	31 d2                	xor    %edx,%edx
 581:	e9 17 ff ff ff       	jmp    49d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 586:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 589:	83 ec 0c             	sub    $0xc,%esp
 58c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 591:	8b 13                	mov    (%ebx),%edx
 593:	6a 01                	push   $0x1
 595:	eb 88                	jmp    51f <printf+0xcf>
        putc(fd, *ap);
 597:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 59a:	83 ec 04             	sub    $0x4,%esp
 59d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 5a0:	8b 03                	mov    (%ebx),%eax
        ap++;
 5a2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 5a5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5a8:	6a 01                	push   $0x1
 5aa:	52                   	push   %edx
 5ab:	57                   	push   %edi
 5ac:	e8 42 fd ff ff       	call   2f3 <write>
        ap++;
 5b1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5b4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b7:	31 d2                	xor    %edx,%edx
 5b9:	e9 df fe ff ff       	jmp    49d <printf+0x4d>
 5be:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5c9:	6a 01                	push   $0x1
 5cb:	e9 31 ff ff ff       	jmp    501 <printf+0xb1>
 5d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5d5:	bb 70 07 00 00       	mov    $0x770,%ebx
 5da:	e9 77 ff ff ff       	jmp    556 <printf+0x106>
 5df:	90                   	nop

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	a1 74 0a 00 00       	mov    0xa74,%eax
{
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fa:	39 c8                	cmp    %ecx,%eax
 5fc:	73 32                	jae    630 <free+0x50>
 5fe:	39 d1                	cmp    %edx,%ecx
 600:	72 04                	jb     606 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 602:	39 d0                	cmp    %edx,%eax
 604:	72 32                	jb     638 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 606:	8b 73 fc             	mov    -0x4(%ebx),%esi
 609:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60c:	39 fa                	cmp    %edi,%edx
 60e:	74 30                	je     640 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 610:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 613:	8b 50 04             	mov    0x4(%eax),%edx
 616:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 619:	39 f1                	cmp    %esi,%ecx
 61b:	74 3a                	je     657 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 61d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 61f:	5b                   	pop    %ebx
  freep = p;
 620:	a3 74 0a 00 00       	mov    %eax,0xa74
}
 625:	5e                   	pop    %esi
 626:	5f                   	pop    %edi
 627:	5d                   	pop    %ebp
 628:	c3                   	ret    
 629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	39 d0                	cmp    %edx,%eax
 632:	72 04                	jb     638 <free+0x58>
 634:	39 d1                	cmp    %edx,%ecx
 636:	72 ce                	jb     606 <free+0x26>
{
 638:	89 d0                	mov    %edx,%eax
 63a:	eb bc                	jmp    5f8 <free+0x18>
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 640:	03 72 04             	add    0x4(%edx),%esi
 643:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 646:	8b 10                	mov    (%eax),%edx
 648:	8b 12                	mov    (%edx),%edx
 64a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 653:	39 f1                	cmp    %esi,%ecx
 655:	75 c6                	jne    61d <free+0x3d>
    p->s.size += bp->s.size;
 657:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 65a:	a3 74 0a 00 00       	mov    %eax,0xa74
    p->s.size += bp->s.size;
 65f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 662:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 665:	89 08                	mov    %ecx,(%eax)
}
 667:	5b                   	pop    %ebx
 668:	5e                   	pop    %esi
 669:	5f                   	pop    %edi
 66a:	5d                   	pop    %ebp
 66b:	c3                   	ret    
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 679:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 67c:	8b 15 74 0a 00 00    	mov    0xa74,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 682:	8d 78 07             	lea    0x7(%eax),%edi
 685:	c1 ef 03             	shr    $0x3,%edi
 688:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 68b:	85 d2                	test   %edx,%edx
 68d:	0f 84 8d 00 00 00    	je     720 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 693:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 695:	8b 48 04             	mov    0x4(%eax),%ecx
 698:	39 f9                	cmp    %edi,%ecx
 69a:	73 64                	jae    700 <malloc+0x90>
  if(nu < 4096)
 69c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6a1:	39 df                	cmp    %ebx,%edi
 6a3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6a6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6ad:	eb 0a                	jmp    6b9 <malloc+0x49>
 6af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6b2:	8b 48 04             	mov    0x4(%eax),%ecx
 6b5:	39 f9                	cmp    %edi,%ecx
 6b7:	73 47                	jae    700 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6b9:	89 c2                	mov    %eax,%edx
 6bb:	3b 05 74 0a 00 00    	cmp    0xa74,%eax
 6c1:	75 ed                	jne    6b0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 6c3:	83 ec 0c             	sub    $0xc,%esp
 6c6:	56                   	push   %esi
 6c7:	e8 8f fc ff ff       	call   35b <sbrk>
  if(p == (char*)-1)
 6cc:	83 c4 10             	add    $0x10,%esp
 6cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 6d2:	74 1c                	je     6f0 <malloc+0x80>
  hp->s.size = nu;
 6d4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6d7:	83 ec 0c             	sub    $0xc,%esp
 6da:	83 c0 08             	add    $0x8,%eax
 6dd:	50                   	push   %eax
 6de:	e8 fd fe ff ff       	call   5e0 <free>
  return freep;
 6e3:	8b 15 74 0a 00 00    	mov    0xa74,%edx
      if((p = morecore(nunits)) == 0)
 6e9:	83 c4 10             	add    $0x10,%esp
 6ec:	85 d2                	test   %edx,%edx
 6ee:	75 c0                	jne    6b0 <malloc+0x40>
        return 0;
  }
}
 6f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6f3:	31 c0                	xor    %eax,%eax
}
 6f5:	5b                   	pop    %ebx
 6f6:	5e                   	pop    %esi
 6f7:	5f                   	pop    %edi
 6f8:	5d                   	pop    %ebp
 6f9:	c3                   	ret    
 6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 700:	39 cf                	cmp    %ecx,%edi
 702:	74 4c                	je     750 <malloc+0xe0>
        p->s.size -= nunits;
 704:	29 f9                	sub    %edi,%ecx
 706:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 709:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 70c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 70f:	89 15 74 0a 00 00    	mov    %edx,0xa74
}
 715:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 718:	83 c0 08             	add    $0x8,%eax
}
 71b:	5b                   	pop    %ebx
 71c:	5e                   	pop    %esi
 71d:	5f                   	pop    %edi
 71e:	5d                   	pop    %ebp
 71f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 720:	c7 05 74 0a 00 00 78 	movl   $0xa78,0xa74
 727:	0a 00 00 
    base.s.size = 0;
 72a:	b8 78 0a 00 00       	mov    $0xa78,%eax
    base.s.ptr = freep = prevp = &base;
 72f:	c7 05 78 0a 00 00 78 	movl   $0xa78,0xa78
 736:	0a 00 00 
    base.s.size = 0;
 739:	c7 05 7c 0a 00 00 00 	movl   $0x0,0xa7c
 740:	00 00 00 
    if(p->s.size >= nunits){
 743:	e9 54 ff ff ff       	jmp    69c <malloc+0x2c>
 748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 750:	8b 08                	mov    (%eax),%ecx
 752:	89 0a                	mov    %ecx,(%edx)
 754:	eb b9                	jmp    70f <malloc+0x9f>
