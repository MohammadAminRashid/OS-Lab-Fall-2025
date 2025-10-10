// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"



#include <stdio.h>



#define KEY_LEFT   0xE4  
#define KEY_RIGHT  0xE5  



static void consputc(int);

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50




#define INPUT_BUF 128
struct {
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
  uint end_pos;
} input;




// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n'){
    pos += 80 - pos%80;}
    else if (c == KEY_RIGHT)
  {
    pos++;
    outb(CRTPORT + 1, pos);
    return;
  }
  else if (c == KEY_LEFT)
  {
    --pos;
    outb(CRTPORT + 1, pos);
  
    return;
  }
  else if(c == BACKSPACE){
    if(pos > 0) {
    //  crt[pos] = ' ' | 0x0700;
     --pos;
    }
  } else
   
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }


  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
     cgaputc(c);
  } 
  else if (c==KEY_LEFT){
       uartputc('\b');
        cgaputc(c);
       
      

  }
 else if(c==KEY_RIGHT){


   uartputc('\033'); 
  uartputc('[');
  uartputc('C');
   cgaputc(c);

 }
  else{
  uartputc(c);
  cgaputc(c);
  }
}



#define C(x)  ((x)-'@')  // Control-x



void printbuf() {
   for(uint i=input.e+1 ; i<input.end_pos ; i++ ){

    consputc(input.buf[i%INPUT_BUF]);
 
   }
      
}
void
set_cursor(int pos)
{
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
}
void move_cursor(int delta)
{
  int pos;


  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);


  pos += delta;

  
  if(pos < 0) pos = 0;
  if(pos >= 25*80) pos = 25*80 - 1;
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos >> 8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
}
void move_chars_left(){
for (uint i=input.e ; i<input.end_pos-1 ; i++){

  input.buf[i % INPUT_BUF]=input.buf[(i+1)%INPUT_BUF];
  consputc(input.buf[i % INPUT_BUF]);
  
  
}
uartputc(' ');
for (uint i=input.e ; i<input.end_pos-1 ; i++){
  move_cursor(-1);
  uartputc('\b');

}


 return;
}

int middle=0;
int x;
void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;
  acquire(&cons.lock);
  if(input.e > input.end_pos){
    input.end_pos=input.e;
  }
  
  while((c = getc()) >= 0){
  
    // if(input.cursor!=input.e){
    //   middle=1;

    // }else{
    //   middle=0;
    // }
    switch(c){
      case KEY_LEFT:
        if(input.e> input.w){
          consputc(KEY_LEFT);
          input.e--;
        }

                 
      break;

      case KEY_RIGHT:
         if(input.e <input.end_pos){
          consputc(KEY_RIGHT);
          input.e++;
         }
          
        
      break;
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){

            
        input.e--;
        input.end_pos--;
       
        consputc(BACKSPACE);
        
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        if(middle){
          x++;
        }
        if(input.e != input.end_pos){
          
        input.e--;
        
        consputc(BACKSPACE);
      
        move_chars_left();
        input.end_pos--;
        
        
        }
        else{
          input.e--;
          input.end_pos--;
           
           consputc(BACKSPACE);

        }
      }
      break;
        case C('A'): 
        //  printint(input.buf[input.e % INPUT_BUF],10,0);
        consputc(input.buf[input.e % INPUT_BUF]);

      // if(input.e != input.w){
      //   int flag=0;
      //   int found=0;
      //   int step=0;
      //   while(input.cursor <input.end_pos ){
      //        if(flag==1 && input.buf[input.cursor % INPUT_BUF]!=' '){

      //            found=1;
      //         break;
      //        }

      //        if(input.buf[input.cursor % INPUT_BUF]==' '){
      //         flag=1;
      //        }
      //        input.cursor++;
      //        step++;
            
      //   }
      //   if(found){
      //       int pos;
      //       outb(CRTPORT, 14);
      //       pos = inb(CRTPORT+1) << 8;
      //       outb(CRTPORT, 15);
      //       pos |= inb(CRTPORT+1);
      //       pos = pos + step;
      //       set_cursor(pos);
      //       input.e=input.cursor;

      //   }
      //   else{
      //          input.cursor=input.e;
      //   }
         
      // }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        if(input.e==input.end_pos+1){
          input.end_pos++;
        }
      
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){  //line complete
          input.w = input.e;
          x=0;
          input.end_pos=input.e;
          wakeup(&input.r);
        }
      }
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock); 
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}



