#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

extern int measurement_start_ticks;
extern int finished_process_count;
extern int measurement_active;

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_simple_arithmetic_syscall(void)
{
  int a, b, result;
  struct proc *curproc = myproc();

  a = curproc->tf->ebx;
  b = curproc->tf->ecx;

  result = (a - b) * (a + b);

  cprintf("Calc:  (%d - %d) * (%d + %d) = %d\n", a, b, a, b, result);

  return result;
}

int sys_show_process_family(void)
{

int pid;
if(argint(0,&pid) < 0 ){


  return -2;
}

return  show_process_family( pid);
}

extern int set_priority_helper(int pid, int priority);

int sys_set_priority_syscall(void)
{
  int pid;
  int priority;

  if(argint(0, &pid) < 0)
    return -1;
  if(argint(1, &priority) < 0)
    return -1;

  if(priority < 0 || priority > 2) {
    cprintf("Error: Priority must be between 0 (High) and 2 (Low).\n");
    return -1;
  }
    
  return set_priority_helper(pid, priority);
}

int sys_start_measure(void) {
  measurement_active = 1;
  finished_process_count = 0;
  measurement_start_ticks = ticks; 
  cprintf("Measurement Started at tick %d\n", measurement_start_ticks);
  return 0;
}

int sys_end_measure(void) {
  if (!measurement_active) {
    cprintf("Error: Measurement was not started.\n");
    return -1;
  }
  
  int current_ticks = ticks;
  int duration = current_ticks - measurement_start_ticks;
  
  if (duration == 0) duration = 1; 


  int throughput_integer = finished_process_count / duration;
  int throughput_fraction = ((finished_process_count * 100) / duration) % 100;

  cprintf("\n--- Measurement Results ---\n");
  cprintf("Total Time (ticks): %d\n", duration);
  cprintf("Finished Processes: %d\n", finished_process_count);
  cprintf("Throughput: %d.%d processes/tick\n", throughput_integer, throughput_fraction);
  
  measurement_active = 0;
  return 0;
}

int sys_print_info(void) {
  struct proc *p = myproc(); 
  int lifetime = ticks - p->create_time;
  
  cprintf("\n--- Process Info ---\n");
  cprintf("Name: %s\n", p->name);
  cprintf("PID: %d\n", p->pid);
  cprintf("Lifetime: %d ticks\n", lifetime);
  
  return 0;
}