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

#define KEY_LEFT 0xE4
#define KEY_RIGHT 0xE5
#define TAB_KEY '\t'
#define INPUT_BUF 128


const char *cmds[] = {
  "README", "find_sum", "cat", "echo", "forktest", "grep", "init",
  "kill", "ln", "ls", "mkdir", "rm", "sh", "stressfs", "usertests",
  "wc", "zombie", "console", "cd"
};
#define CMDS_COUNT (sizeof(cmds)/sizeof(cmds[0]))
int tab_count = 0;


static void consputc(int);

static int panicked = 0;

static struct
{
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

  if (sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do
  {
    buf[i++] = digits[x % base];
  } while ((x /= base) != 0);

  if (sign)
    buf[i++] = '-';

  while (--i >= 0)
    consputc(buf[i]);
}
// PAGEBREAK: 50


struct char_time
{
  char c;
  uint time;
};

char copy_buf[INPUT_BUF];
struct char_time times_copy_buf[INPUT_BUF];
struct char_time times_buf[INPUT_BUF];

char ctrl_c[INPUT_BUF];
int is_copy = 0;
uint inedx_copy1 = 0;
uint inedx_copy2 = 0;

struct
{
  char buf[INPUT_BUF];
  uint r;
  uint w;
  uint e;
  uint end_pos;
  uint time;
  uint s1; /// alo
  uint s2;
  uint mode;
  char color;
} input = {
    .time = 1,
    .mode = 0,
    .color = 'B'};

// Print to the console. only understands %d, %x, %p, %s.
void cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if (locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint *)(void *)(&fmt + 1);
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
  {
    if (c != '%')
    {
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if (c == 0)
      break;
    switch (c)
    {
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if ((s = (char *)*argp++) == 0)
        s = "(null)";
      for (; *s; s++)
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

  if (locking)
    release(&cons.lock);
}

void panic(char *s)
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
  for (i = 0; i < 10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for (;;)
    ;
}

// PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort *)P2V(0xb8000); // CGA memory

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT + 1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT + 1);

  if (c == '\n')
  {
    pos += 80 - pos % 80;
  }
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
  else if (c == BACKSPACE)
  {
    if (pos > 0)
    {
      //  crt[pos] = ' ' | 0x0700;
      --pos;
    }
  }
  else if (input.color == 'W')
  {

    crt[pos++] = (c & 0xff) | 0xF000;
  }
  else
  {

    crt[pos++] = (c & 0xff) | 0x0700; // black on white
  }

  if (pos < 0 || pos > 25 * 80)
    panic("pos under/overflow");

  if ((pos / 80) >= 24)
  { // Scroll up.
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
    pos -= 80;
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT + 1, pos >> 8);
  outb(CRTPORT, 15);
  outb(CRTPORT + 1, pos);
  if (input.mode != 2)
    crt[pos] = ' ' | 0x0700;
}

void consputc(int c)
{
  if (panicked)
  {
    cli();
    for (;;)
      ;
  }

  if (c == BACKSPACE)
  {
    uartputc('\b');
    uartputc(' ');
    uartputc('\b');
    cgaputc(c);
  }
  else if (c == KEY_LEFT)
  {
    uartputc('\b');
    cgaputc(c);
  }
  else if (c == KEY_RIGHT)
  {

    uartputc('\033');
    uartputc('[');
    uartputc('C');
    cgaputc(c);
  }
  else
  {
    uartputc(c);
    cgaputc(c);
  }
}

#define C(x) ((x) - '@') // Control-x

void printbuf()
{
  for (uint i = input.e + 1; i < input.end_pos; i++)
  {

    consputc(input.buf[i % INPUT_BUF]);
  }
}

void set_cursor(int pos)
{
  outb(CRTPORT, 14);
  outb(CRTPORT + 1, pos >> 8);
  outb(CRTPORT, 15);
  outb(CRTPORT + 1, pos);
}

void move_cursor(int delta)
{
  int pos;

  outb(CRTPORT, 14);
  pos = inb(CRTPORT + 1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT + 1);

  pos += delta;

  if (pos < 0)
    pos = 0;
  if (pos >= 25 * 80)
    pos = 25 * 80 - 1;
  outb(CRTPORT, 14);
  outb(CRTPORT + 1, pos >> 8);
  outb(CRTPORT, 15);
  outb(CRTPORT + 1, pos);
}

void move_chars_left()
{
  for (uint i = input.e; i < input.end_pos - 1; i++)
  {

    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
    consputc(input.buf[i % INPUT_BUF]);
  }

  // uartputc(' ');
  for (uint i = input.e; i < input.end_pos - 1; i++)
  {
    move_cursor(-1);
    // uartputc('\b');
  }

  return;
}

void move_chars_right()
{

  for (uint i = input.e; i <= input.end_pos; i++)
  {

    input.buf[(i) % INPUT_BUF] = copy_buf[(i - 1) % INPUT_BUF];
    consputc(input.buf[(i) % INPUT_BUF]);
  }

  for (uint i = input.e; i <= input.end_pos; i++)
  {

    move_cursor(-1);
    uartputc('\b');
  }

  return;
}

void move_to_first_current()
{

  int flag = 0;
  int j = input.e;

  while (j > input.w)
  {
    if (input.buf[j % INPUT_BUF] == ' ')
    {
      move_cursor(1);
      input.e += 1;

      break;
    }

    move_cursor(-1);
    input.e--;

    j--;
  }

  return;
}
void move_to_first_previous()
{
  int flag = 0;
  int found = 0;
  int step = 0;
  int j = input.e;

  while (j > input.w)
  {
    if (flag == 2 && input.buf[j % INPUT_BUF] == ' ')
    {
      move_cursor(1);
      input.e++;

      found = 1;
      break;
    }
    if (flag == 1 && input.buf[j % INPUT_BUF] != ' ')
    {
      flag = 2;
    }

    if (input.buf[j % INPUT_BUF] == ' ' && flag == 0)
    {
      flag = 1;
    }
    move_cursor(-1);
    input.e--;
    j--;
    step++;
  }

  return;
}

void print_select(uint s1, uint s2)
{

  uint min, max;
  if (s1 < s2)
  {
    min = s1;
    max = s2;
  }
  else
  {
    min = s2;
    max = s1;
  }
  int delta = (int)(min - input.e);
  move_cursor(delta);

  for (uint i = min; i <= max; i++)
  {

    consputc(input.buf[i % INPUT_BUF]);
  }


  if (s1 > s2)
  {
    for (uint i = min; i <= max; i++)
    {

      move_cursor(-1);
    }
  }
  else
  {
    move_cursor(-1);
  }
}

void delete_selected()
{
  input.mode = 0;
  if (input.s1 <= input.s2)
  {
    move_cursor(1);
    input.e++;
  }
  else
  {

    uint temp;
    temp = input.s1;
    input.s1 = input.s2;
    input.s2 = temp;
    move_cursor(1 + (int)(input.s2 - input.s1));
    for (int i = 0; i <= (int)(input.s2 - input.s1); i++)
    {

      input.e++;
    }
  }

  for (int i = 0; i <= (int)(input.s2 - input.s1); i++)
  {
    if (input.e < input.end_pos)
    {

      input.e--;

      consputc(BACKSPACE);

      move_chars_left();  //NOTE
      input.end_pos--;
    }
    else
    {
      input.e--;
      input.end_pos--;

      consputc(BACKSPACE);
    }
  }

  return;
}

void move_timed_chars_right(uint start_index)
{
  for (uint i = INPUT_BUF - 2; i >= start_index; i--)
    times_buf[(i + 1) % INPUT_BUF] = times_buf[(i) % INPUT_BUF];
}

uint find_max_char_time_index()
{
  uint max_index;
  uint max_time = 0;
  for (uint i = 0; i < INPUT_BUF; i++)
  {
    if (times_buf[i].time >= max_time)
    {
      max_index = i;
      max_time = times_buf[i].time;
    }
  }
  return max_index;
}

void move_timed_chars_left(uint start_index, uint input_buf_start_index)
{
  for (uint i = start_index; i < INPUT_BUF - 1; i++)
    times_buf[(i) % INPUT_BUF] = times_buf[(i + 1) % INPUT_BUF];

  for (uint i = input_buf_start_index; i < input.end_pos - 1; i++)
  {
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
    consputc(input.buf[i % INPUT_BUF]);
  }
  for (uint i = input_buf_start_index; i < input.end_pos - 1; i++)
  {
    move_cursor(-1);
  }
}

void clear_char_time_array()
{
  for (int i = 0; i < INPUT_BUF; i++)
  {
    times_buf[i].time = 0;
    times_buf[i].c = '\0';
  }
}

int has_prefix(const char *s, const char *p) {
  while (*p) {
    if (*s != *p) return 0;
    s++; p++;
  }
  return 1;
}

int collect_matches(const char *prefix, int *out_idx, int maxn) {
  int n = 0;
  for (int i = 0; i < (int)CMDS_COUNT; i++) {
    if (has_prefix(cmds[i], prefix)) {
      if (out_idx && n < maxn) out_idx[n] = i;
      n++;
    }
  }
  return n;
}

static void consputs(const char *s) {
  while (*s) consputc(*s++);
}

void consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;
  acquire(&cons.lock);
  if (input.e > input.end_pos)
  {
    input.end_pos = input.e;
  }


  while ((c = getc()) >= 0)
  {
    if (c == '\n')
      tab_count = 0;

    switch (c)
    {



  case '\r':
  case '\n':
  c = '\n';
  consputc('\n');
  input.buf[input.end_pos++ % INPUT_BUF] = c;
  input.w = input.end_pos;
  input.e = input.end_pos;
  wakeup(&input.r);
  clear_char_time_array();
  input.time = 0;
  tab_count = 0;
  break;
    case TAB_KEY: {

      if (input.e != input.end_pos) {
        break;
      }

      char user_input[INPUT_BUF];
      int len = 0;

      int pos = input.e - 1;
      if (pos < (int)input.w) {
        tab_count = 0;
        break;
      }

      while (pos >= (int)input.w) {
        char ch = input.buf[pos % INPUT_BUF];
        if (ch == ' ' || ch == '\n') 
          break;
        pos--;
      }
      int start = pos + 1;


      for (int i = start; i < (int)input.e && len < INPUT_BUF-1; i++) {
        user_input[len++] = input.buf[i % INPUT_BUF];
      }
      user_input[len] = 0;

      if (len == 0) {
        tab_count = 0;
        break;
      }

      tab_count++;

      int cmd_indexes[64];
      int m = collect_matches(user_input, cmd_indexes, 64);

      if (m == 0) {
        tab_count = 0;
      }

      else if (m == 1) {
        if (tab_count == 1) {
          const char *full = cmds[cmd_indexes[0]];
          const char *suffix = full + len; 

          while (*suffix) {
            if (input.end_pos - input.r >= INPUT_BUF) 
              break;
            input.buf[input.end_pos % INPUT_BUF] = *suffix;
            input.end_pos++;
            input.e++;
            consputc(*suffix);
            suffix++;
          }
        }
        tab_count = 0;

      } else {
        if (tab_count == 1) {
        }
        else {
          consputc('\n');
          for (int k = 0; k < m; k++) {
            consputs(cmds[cmd_indexes[k]]);
            consputc(' ');
          }
          consputc('\n');
          tab_count = 0;
            
          input.buf[input.end_pos++ % INPUT_BUF] = '\n';
          input.w = input.end_pos;
          input.e = input.end_pos;
          input.r = input.w-1;
          wakeup(&input.r);
        }
      }

      break;
    }
    case KEY_LEFT:

      if (input.mode == 2)
      {
        print_select(input.s1, input.s2);
        input.mode = 0;
        break;
      }
      if (input.e > input.w)
      {
        consputc(KEY_LEFT);
        input.e--;
      }

      break;

    case KEY_RIGHT:
      if (input.mode == 2)
      {
        print_select(input.s1, input.s2);
        input.mode = 0;
        break;
      }
      if (input.e < input.end_pos)
      {
        consputc(KEY_RIGHT);
        input.e++;
      }

      break;
    case C('P'): // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;

    case C('U'): // Kill line.
      if (input.mode == 2)
      {
        print_select(input.s1, input.s2);
        input.mode = 0;
        break;
      }

      for (uint i = input.e; i < input.end_pos; i++)
      {
        move_cursor(1);
      }

      while (input.end_pos != input.w &&
             input.buf[(input.end_pos - 1) % INPUT_BUF] != '\n')
      {

        // input.e--;
        input.end_pos--;

        consputc(BACKSPACE);
      }
      input.e = input.end_pos;

      break;

    case C('H'):
    case '\x7f': // Backspace
      if (input.mode == 2)
      {

        delete_selected();

        break;
      }
      if (input.e != input.w)
      {
        if (input.e < input.end_pos)
        {

          input.e--;

          consputc(BACKSPACE);
          uint cursor_index = input.e - input.w -1 ;
          move_timed_chars_left(cursor_index, input.e);
          input.end_pos--;
        }
        else
        {
          input.e--;
          uint cursor_index = input.e - input.w - 1 ;
          move_timed_chars_left(cursor_index, input.e);
          input.end_pos--;

          consputc(BACKSPACE);
        }
      }
      break;
    case C('D'):
      if (input.mode == 2)
      {
        print_select(input.s1, input.s2);
        input.mode = 0;
        break;
      }

      int flag = 0;
      int found = 0;
      int step = 0;
      int j = input.e;
      while (j <= input.end_pos)
      {
        if (flag == 1 && input.buf[j % INPUT_BUF] != ' ')
        {

          found = 1;
          break;
        }

        if (input.buf[j % INPUT_BUF] == ' ')
        {
          flag = 1;
        }
        j++;
        step++;
      }
      if (found)
      {
        for (int i = 0; i < step; i++)
        {
          move_cursor(1);
          input.e++;
        }
      }

      break;
    case C('A'):
      if (input.mode == 2)
      {
        print_select(input.s1, input.s2);
        input.mode = 0;
        break;
      }

      if (input.e != input.w)
      {

        int j = input.e;
        if (input.buf[j % INPUT_BUF] == ' ' || input.buf[(j - 1) % INPUT_BUF] == ' ')
        {
          move_to_first_previous();
        }
        else
        {

          move_to_first_current();
        }
      }
      break;

    case C('Z'):

      if (input.mode == 2)
      {
        print_select(input.s1, input.s2);
        input.mode = 0;
        break;
      }
      uint removing_char_index = find_max_char_time_index();
      uint interval = input.end_pos - input.w;
      uint cursor_index = input.e - input.w - 1;
      uint absolute_char_index = input.w + removing_char_index;

      if (input.end_pos == input.w)
      {
        clear_char_time_array();
        input.time = 0;
        break;
      }
      else if (cursor_index > removing_char_index)
      {
        for (uint i = cursor_index; i > removing_char_index; i--)
          move_cursor(-1);

        consputc(BACKSPACE);
        move_timed_chars_left(removing_char_index, absolute_char_index);
         
        for (uint i = cursor_index; i > removing_char_index; i--)
          move_cursor(1);

        input.e--;
      }
      else if (cursor_index < removing_char_index && removing_char_index < interval)
      {

        for (uint i = cursor_index; i < removing_char_index; i++)
          move_cursor(1);

        consputc(BACKSPACE);
        move_timed_chars_left(removing_char_index, absolute_char_index);
         
        for (uint i = cursor_index; i < removing_char_index - 1; i++)
          move_cursor(-1);
      }
      else
      {
        consputc(BACKSPACE);
        move_timed_chars_left(removing_char_index, absolute_char_index);
         
        input.e--;
      }
      input.end_pos--;
      break;

    case C('S'):
      if (input.mode == 0)
      {
        input.s1 = input.e;
        input.mode = 1;
      }
      else if (input.mode == 1)
      {
        input.mode = 2;
        input.s2 = input.e;
        input.color = 'W';
        print_select(input.s1, input.s2);
        input.color = 'B';
      }
      else if (input.mode == 2)
      {
        print_select(input.s1, input.s2);
        input.mode = 0;
      }

      break;

    case C('C'):
      if (input.mode == 2)
      {
        is_copy = 1;
        for (int i = 0; i < INPUT_BUF; i++)
        {

          ctrl_c[i] = input.buf[i];
        }
        if (input.s1 <= input.s2)
        {

          inedx_copy1 = input.s1 % INPUT_BUF;
          inedx_copy2 = input.s2 % INPUT_BUF;
        }
        else
        {

          inedx_copy1 = input.s2 % INPUT_BUF;
          inedx_copy2 = input.s1 % INPUT_BUF;
        }
      }

      break;
    case C('V'):

      if (is_copy == 1)
      {
        if (input.mode == 2)
        {
          delete_selected();
        }

        for (uint i = inedx_copy1; i <= inedx_copy2; i++)
        {
          c = ctrl_c[i];
          if ((input.e < input.end_pos) && c != '\n')
          {

            for (int i = 0; i < INPUT_BUF; i++)
            {

              copy_buf[i] = input.buf[i];
            }
            input.buf[input.e++ % INPUT_BUF] = c;
            consputc(c);

            move_chars_right();

            input.end_pos++;
            continue;
          }

          input.buf[input.e++ % INPUT_BUF] = c;
          if (input.e == input.end_pos + 1)
          {
            input.end_pos++;
            consputc(c);
          }
        }
      }

      break;

    default:
      if (c != 0 && input.e - input.r < INPUT_BUF)
      {

        if (input.mode == 2)
        {
          delete_selected();
        }
        c = (c == '\r') ? '\n' : c;

        if ((input.e < input.end_pos) && c != '\n')
        {

          for (int i = 0; i < INPUT_BUF; i++)
          {

            copy_buf[i] = input.buf[i];
          }
          input.buf[input.e++ % INPUT_BUF] = c;
          consputc(c);
          move_chars_right();

          // right shift needs for times_buf befor inserting new object
          uint new_char_time_position_index = input.e - input.w - 1;
          uint last_char_time_position_index = (input.end_pos - 1) - input.w;
          move_timed_chars_right(new_char_time_position_index);
          struct char_time new_char;
          new_char.c = c;
          new_char.time = input.time++;
          times_buf[new_char_time_position_index++] = new_char;

          input.end_pos++;
          break;
        }

        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
        {
          input.buf[input.end_pos++ % INPUT_BUF] = c; 
          input.w = input.end_pos;
          input.e = input.end_pos;
          wakeup(&input.r);

          if (c == '\n')
          {
            clear_char_time_array();
            input.time = 0;
          }

          break;
        }
        input.buf[input.e++ % INPUT_BUF] = c;
        if (input.e == input.end_pos + 1)
        {
          input.end_pos++;
          consputc(c);

          uint last_char_time_position_index = input.e - input.w - 1;
          struct char_time new_char;
          new_char.c = c;
          new_char.time = input.time++;
          times_buf[last_char_time_position_index] = new_char;
        }
      }
      break;
    }
  }
  release(&cons.lock);
  if (doprocdump)
  {
    procdump(); // now call procdump() wo. cons.lock held
  }
}

int consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while (n > 0)
  {
    while (input.r == input.w)
    {
      if (myproc()->killed)
      {
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if (c == C('D'))
    { // EOF
      if (n < target)
      {
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if (c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for (i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}
