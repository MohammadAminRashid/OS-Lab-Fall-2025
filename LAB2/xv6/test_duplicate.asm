
_test_duplicate:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

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
  10:	83 ec 14             	sub    $0x14,%esp
  13:	8b 19                	mov    (%ecx),%ebx
  15:	8b 71 04             	mov    0x4(%ecx),%esi
    printf(1, "\n");
  18:	68 48 07 00 00       	push   $0x748
  1d:	6a 01                	push   $0x1
  1f:	e8 1c 04 00 00       	call   440 <printf>
    if (argc < 2)
  24:	83 c4 10             	add    $0x10,%esp
  27:	83 fb 01             	cmp    $0x1,%ebx
  2a:	7e 28                	jle    54 <main+0x54>
    {
        printf(1, "\n");
        exit();
    }
    char *src = argv[1];
    int ret = make_duplicate(src);
  2c:	83 ec 0c             	sub    $0xc,%esp
  2f:	ff 76 04             	pushl  0x4(%esi)
  32:	e8 3c 03 00 00       	call   373 <make_duplicate>
    
    if (ret == -1)
  37:	83 c4 10             	add    $0x10,%esp
  3a:	83 f8 ff             	cmp    $0xffffffff,%eax
  3d:	74 3c                	je     7b <main+0x7b>
    {
        printf(1,"No file with this name!" );
    }
    else if (ret == 0)
  3f:	85 c0                	test   %eax,%eax
  41:	75 25                	jne    68 <main+0x68>
    {
        printf(1,"Completed duplicate!" );
  43:	52                   	push   %edx
  44:	52                   	push   %edx
  45:	68 62 07 00 00       	push   $0x762
  4a:	6a 01                	push   $0x1
  4c:	e8 ef 03 00 00       	call   440 <printf>
  51:	83 c4 10             	add    $0x10,%esp
        printf(1, "\n");
  54:	83 ec 08             	sub    $0x8,%esp
  57:	68 48 07 00 00       	push   $0x748
  5c:	6a 01                	push   $0x1
  5e:	e8 dd 03 00 00       	call   440 <printf>
        exit();
  63:	e8 6b 02 00 00       	call   2d3 <exit>
    }

    else
    {
        printf(1,"Error");
  68:	50                   	push   %eax
  69:	50                   	push   %eax
  6a:	68 77 07 00 00       	push   $0x777
  6f:	6a 01                	push   $0x1
  71:	e8 ca 03 00 00       	call   440 <printf>
  76:	83 c4 10             	add    $0x10,%esp
  79:	eb d9                	jmp    54 <main+0x54>
        printf(1,"No file with this name!" );
  7b:	51                   	push   %ecx
  7c:	51                   	push   %ecx
  7d:	68 4a 07 00 00       	push   $0x74a
  82:	6a 01                	push   $0x1
  84:	e8 b7 03 00 00       	call   440 <printf>
  89:	83 c4 10             	add    $0x10,%esp
  8c:	eb c6                	jmp    54 <main+0x54>
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

0000038b <simple_arithmetic_syscall>:

.globl simple_arithmetic_syscall
simple_arithmetic_syscall:
  movl 4(%esp), %ebx  
 38b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  movl 8(%esp), %ecx  
 38f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  movl $SYS_simple_arithmetic_syscall, %eax # 
 393:	b8 16 00 00 00       	mov    $0x16,%eax
  int $T_SYSCALL    
 398:	cd 40                	int    $0x40
  ret                
 39a:	c3                   	ret    
 39b:	66 90                	xchg   %ax,%ax
 39d:	66 90                	xchg   %ax,%ax
 39f:	90                   	nop

000003a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
 3a6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3a8:	89 d1                	mov    %edx,%ecx
{
 3aa:	83 ec 3c             	sub    $0x3c,%esp
 3ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 3b0:	85 d2                	test   %edx,%edx
 3b2:	0f 89 80 00 00 00    	jns    438 <printint+0x98>
 3b8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3bc:	74 7a                	je     438 <printint+0x98>
    x = -xx;
 3be:	f7 d9                	neg    %ecx
    neg = 1;
 3c0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 3c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3c8:	31 f6                	xor    %esi,%esi
 3ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3d0:	89 c8                	mov    %ecx,%eax
 3d2:	31 d2                	xor    %edx,%edx
 3d4:	89 f7                	mov    %esi,%edi
 3d6:	f7 f3                	div    %ebx
 3d8:	8d 76 01             	lea    0x1(%esi),%esi
 3db:	0f b6 92 dc 07 00 00 	movzbl 0x7dc(%edx),%edx
 3e2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3e6:	89 ca                	mov    %ecx,%edx
 3e8:	89 c1                	mov    %eax,%ecx
 3ea:	39 da                	cmp    %ebx,%edx
 3ec:	73 e2                	jae    3d0 <printint+0x30>
  if(neg)
 3ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3f1:	85 c0                	test   %eax,%eax
 3f3:	74 07                	je     3fc <printint+0x5c>
    buf[i++] = '-';
 3f5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 3fa:	89 f7                	mov    %esi,%edi
 3fc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3ff:	8b 75 c0             	mov    -0x40(%ebp),%esi
 402:	01 df                	add    %ebx,%edi
 404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 408:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 40b:	83 ec 04             	sub    $0x4,%esp
 40e:	88 45 d7             	mov    %al,-0x29(%ebp)
 411:	8d 45 d7             	lea    -0x29(%ebp),%eax
 414:	6a 01                	push   $0x1
 416:	50                   	push   %eax
 417:	56                   	push   %esi
 418:	e8 d6 fe ff ff       	call   2f3 <write>
  while(--i >= 0)
 41d:	89 f8                	mov    %edi,%eax
 41f:	83 c4 10             	add    $0x10,%esp
 422:	83 ef 01             	sub    $0x1,%edi
 425:	39 c3                	cmp    %eax,%ebx
 427:	75 df                	jne    408 <printint+0x68>
}
 429:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42c:	5b                   	pop    %ebx
 42d:	5e                   	pop    %esi
 42e:	5f                   	pop    %edi
 42f:	5d                   	pop    %ebp
 430:	c3                   	ret    
 431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 438:	31 c0                	xor    %eax,%eax
 43a:	eb 89                	jmp    3c5 <printint+0x25>
 43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000440 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 449:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 44c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 44f:	0f b6 1e             	movzbl (%esi),%ebx
 452:	83 c6 01             	add    $0x1,%esi
 455:	84 db                	test   %bl,%bl
 457:	74 67                	je     4c0 <printf+0x80>
 459:	8d 4d 10             	lea    0x10(%ebp),%ecx
 45c:	31 d2                	xor    %edx,%edx
 45e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 461:	eb 34                	jmp    497 <printf+0x57>
 463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 467:	90                   	nop
 468:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 46b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 470:	83 f8 25             	cmp    $0x25,%eax
 473:	74 18                	je     48d <printf+0x4d>
  write(fd, &c, 1);
 475:	83 ec 04             	sub    $0x4,%esp
 478:	8d 45 e7             	lea    -0x19(%ebp),%eax
 47b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 47e:	6a 01                	push   $0x1
 480:	50                   	push   %eax
 481:	57                   	push   %edi
 482:	e8 6c fe ff ff       	call   2f3 <write>
 487:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 48a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 48d:	0f b6 1e             	movzbl (%esi),%ebx
 490:	83 c6 01             	add    $0x1,%esi
 493:	84 db                	test   %bl,%bl
 495:	74 29                	je     4c0 <printf+0x80>
    c = fmt[i] & 0xff;
 497:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 49a:	85 d2                	test   %edx,%edx
 49c:	74 ca                	je     468 <printf+0x28>
      }
    } else if(state == '%'){
 49e:	83 fa 25             	cmp    $0x25,%edx
 4a1:	75 ea                	jne    48d <printf+0x4d>
      if(c == 'd'){
 4a3:	83 f8 25             	cmp    $0x25,%eax
 4a6:	0f 84 04 01 00 00    	je     5b0 <printf+0x170>
 4ac:	83 e8 63             	sub    $0x63,%eax
 4af:	83 f8 15             	cmp    $0x15,%eax
 4b2:	77 1c                	ja     4d0 <printf+0x90>
 4b4:	ff 24 85 84 07 00 00 	jmp    *0x784(,%eax,4)
 4bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4bf:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c3:	5b                   	pop    %ebx
 4c4:	5e                   	pop    %esi
 4c5:	5f                   	pop    %edi
 4c6:	5d                   	pop    %ebp
 4c7:	c3                   	ret    
 4c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop
  write(fd, &c, 1);
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4d6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4da:	6a 01                	push   $0x1
 4dc:	52                   	push   %edx
 4dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4e0:	57                   	push   %edi
 4e1:	e8 0d fe ff ff       	call   2f3 <write>
 4e6:	83 c4 0c             	add    $0xc,%esp
 4e9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4ec:	6a 01                	push   $0x1
 4ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4f1:	52                   	push   %edx
 4f2:	57                   	push   %edi
 4f3:	e8 fb fd ff ff       	call   2f3 <write>
        putc(fd, c);
 4f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4fb:	31 d2                	xor    %edx,%edx
 4fd:	eb 8e                	jmp    48d <printf+0x4d>
 4ff:	90                   	nop
        printint(fd, *ap, 16, 0);
 500:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 503:	83 ec 0c             	sub    $0xc,%esp
 506:	b9 10 00 00 00       	mov    $0x10,%ecx
 50b:	8b 13                	mov    (%ebx),%edx
 50d:	6a 00                	push   $0x0
 50f:	89 f8                	mov    %edi,%eax
        ap++;
 511:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 514:	e8 87 fe ff ff       	call   3a0 <printint>
        ap++;
 519:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 51c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51f:	31 d2                	xor    %edx,%edx
 521:	e9 67 ff ff ff       	jmp    48d <printf+0x4d>
        s = (char*)*ap;
 526:	8b 45 d0             	mov    -0x30(%ebp),%eax
 529:	8b 18                	mov    (%eax),%ebx
        ap++;
 52b:	83 c0 04             	add    $0x4,%eax
 52e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 531:	85 db                	test   %ebx,%ebx
 533:	0f 84 87 00 00 00    	je     5c0 <printf+0x180>
        while(*s != 0){
 539:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 53c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 53e:	84 c0                	test   %al,%al
 540:	0f 84 47 ff ff ff    	je     48d <printf+0x4d>
 546:	8d 55 e7             	lea    -0x19(%ebp),%edx
 549:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 54c:	89 de                	mov    %ebx,%esi
 54e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 550:	83 ec 04             	sub    $0x4,%esp
 553:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 556:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 559:	6a 01                	push   $0x1
 55b:	53                   	push   %ebx
 55c:	57                   	push   %edi
 55d:	e8 91 fd ff ff       	call   2f3 <write>
        while(*s != 0){
 562:	0f b6 06             	movzbl (%esi),%eax
 565:	83 c4 10             	add    $0x10,%esp
 568:	84 c0                	test   %al,%al
 56a:	75 e4                	jne    550 <printf+0x110>
      state = 0;
 56c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 56f:	31 d2                	xor    %edx,%edx
 571:	e9 17 ff ff ff       	jmp    48d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 576:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 579:	83 ec 0c             	sub    $0xc,%esp
 57c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 581:	8b 13                	mov    (%ebx),%edx
 583:	6a 01                	push   $0x1
 585:	eb 88                	jmp    50f <printf+0xcf>
        putc(fd, *ap);
 587:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 58a:	83 ec 04             	sub    $0x4,%esp
 58d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 590:	8b 03                	mov    (%ebx),%eax
        ap++;
 592:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 595:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 598:	6a 01                	push   $0x1
 59a:	52                   	push   %edx
 59b:	57                   	push   %edi
 59c:	e8 52 fd ff ff       	call   2f3 <write>
        ap++;
 5a1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5a4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a7:	31 d2                	xor    %edx,%edx
 5a9:	e9 df fe ff ff       	jmp    48d <printf+0x4d>
 5ae:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
 5b3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5b6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5b9:	6a 01                	push   $0x1
 5bb:	e9 31 ff ff ff       	jmp    4f1 <printf+0xb1>
 5c0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5c5:	bb 7d 07 00 00       	mov    $0x77d,%ebx
 5ca:	e9 77 ff ff ff       	jmp    546 <printf+0x106>
 5cf:	90                   	nop

000005d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 80 0a 00 00       	mov    0xa80,%eax
{
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ea:	39 c8                	cmp    %ecx,%eax
 5ec:	73 32                	jae    620 <free+0x50>
 5ee:	39 d1                	cmp    %edx,%ecx
 5f0:	72 04                	jb     5f6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f2:	39 d0                	cmp    %edx,%eax
 5f4:	72 32                	jb     628 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5fc:	39 fa                	cmp    %edi,%edx
 5fe:	74 30                	je     630 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 600:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 603:	8b 50 04             	mov    0x4(%eax),%edx
 606:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 609:	39 f1                	cmp    %esi,%ecx
 60b:	74 3a                	je     647 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 60d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 60f:	5b                   	pop    %ebx
  freep = p;
 610:	a3 80 0a 00 00       	mov    %eax,0xa80
}
 615:	5e                   	pop    %esi
 616:	5f                   	pop    %edi
 617:	5d                   	pop    %ebp
 618:	c3                   	ret    
 619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	39 d0                	cmp    %edx,%eax
 622:	72 04                	jb     628 <free+0x58>
 624:	39 d1                	cmp    %edx,%ecx
 626:	72 ce                	jb     5f6 <free+0x26>
{
 628:	89 d0                	mov    %edx,%eax
 62a:	eb bc                	jmp    5e8 <free+0x18>
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 630:	03 72 04             	add    0x4(%edx),%esi
 633:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 636:	8b 10                	mov    (%eax),%edx
 638:	8b 12                	mov    (%edx),%edx
 63a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 63d:	8b 50 04             	mov    0x4(%eax),%edx
 640:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 643:	39 f1                	cmp    %esi,%ecx
 645:	75 c6                	jne    60d <free+0x3d>
    p->s.size += bp->s.size;
 647:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 64a:	a3 80 0a 00 00       	mov    %eax,0xa80
    p->s.size += bp->s.size;
 64f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 652:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 655:	89 08                	mov    %ecx,(%eax)
}
 657:	5b                   	pop    %ebx
 658:	5e                   	pop    %esi
 659:	5f                   	pop    %edi
 65a:	5d                   	pop    %ebp
 65b:	c3                   	ret    
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000660 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 669:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 66c:	8b 15 80 0a 00 00    	mov    0xa80,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 672:	8d 78 07             	lea    0x7(%eax),%edi
 675:	c1 ef 03             	shr    $0x3,%edi
 678:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 67b:	85 d2                	test   %edx,%edx
 67d:	0f 84 8d 00 00 00    	je     710 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 683:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 685:	8b 48 04             	mov    0x4(%eax),%ecx
 688:	39 f9                	cmp    %edi,%ecx
 68a:	73 64                	jae    6f0 <malloc+0x90>
  if(nu < 4096)
 68c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 691:	39 df                	cmp    %ebx,%edi
 693:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 696:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 69d:	eb 0a                	jmp    6a9 <malloc+0x49>
 69f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6a2:	8b 48 04             	mov    0x4(%eax),%ecx
 6a5:	39 f9                	cmp    %edi,%ecx
 6a7:	73 47                	jae    6f0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6a9:	89 c2                	mov    %eax,%edx
 6ab:	3b 05 80 0a 00 00    	cmp    0xa80,%eax
 6b1:	75 ed                	jne    6a0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 6b3:	83 ec 0c             	sub    $0xc,%esp
 6b6:	56                   	push   %esi
 6b7:	e8 9f fc ff ff       	call   35b <sbrk>
  if(p == (char*)-1)
 6bc:	83 c4 10             	add    $0x10,%esp
 6bf:	83 f8 ff             	cmp    $0xffffffff,%eax
 6c2:	74 1c                	je     6e0 <malloc+0x80>
  hp->s.size = nu;
 6c4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6c7:	83 ec 0c             	sub    $0xc,%esp
 6ca:	83 c0 08             	add    $0x8,%eax
 6cd:	50                   	push   %eax
 6ce:	e8 fd fe ff ff       	call   5d0 <free>
  return freep;
 6d3:	8b 15 80 0a 00 00    	mov    0xa80,%edx
      if((p = morecore(nunits)) == 0)
 6d9:	83 c4 10             	add    $0x10,%esp
 6dc:	85 d2                	test   %edx,%edx
 6de:	75 c0                	jne    6a0 <malloc+0x40>
        return 0;
  }
}
 6e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6e3:	31 c0                	xor    %eax,%eax
}
 6e5:	5b                   	pop    %ebx
 6e6:	5e                   	pop    %esi
 6e7:	5f                   	pop    %edi
 6e8:	5d                   	pop    %ebp
 6e9:	c3                   	ret    
 6ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6f0:	39 cf                	cmp    %ecx,%edi
 6f2:	74 4c                	je     740 <malloc+0xe0>
        p->s.size -= nunits;
 6f4:	29 f9                	sub    %edi,%ecx
 6f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6fc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6ff:	89 15 80 0a 00 00    	mov    %edx,0xa80
}
 705:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 708:	83 c0 08             	add    $0x8,%eax
}
 70b:	5b                   	pop    %ebx
 70c:	5e                   	pop    %esi
 70d:	5f                   	pop    %edi
 70e:	5d                   	pop    %ebp
 70f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 710:	c7 05 80 0a 00 00 84 	movl   $0xa84,0xa80
 717:	0a 00 00 
    base.s.size = 0;
 71a:	b8 84 0a 00 00       	mov    $0xa84,%eax
    base.s.ptr = freep = prevp = &base;
 71f:	c7 05 84 0a 00 00 84 	movl   $0xa84,0xa84
 726:	0a 00 00 
    base.s.size = 0;
 729:	c7 05 88 0a 00 00 00 	movl   $0x0,0xa88
 730:	00 00 00 
    if(p->s.size >= nunits){
 733:	e9 54 ff ff ff       	jmp    68c <malloc+0x2c>
 738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 740:	8b 08                	mov    (%eax),%ecx
 742:	89 0a                	mov    %ecx,(%edx)
 744:	eb b9                	jmp    6ff <malloc+0x9f>
