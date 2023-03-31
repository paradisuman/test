#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "date.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
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

uint64
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


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.
  uint64 v_addr;
  int check_nums;
  uint64 user_addr;
  uint64 mask = 0;
  struct proc *my_proc = myproc();
 
  
  if(argaddr(0, &v_addr) < 0)
    return -1;
  if(argint(1, &check_nums) < 0)
    return -1;
  if(argaddr(2, &user_addr) < 0)
    return -1;
  //mask is 64bit
  if(check_nums > 64)
    return -1;
    
    
  v_addr = PGROUNDDOWN(v_addr);
  for(int i = 0; i < check_nums; i++)
  {
    pte_t *pte;
    pte = walk(my_proc->pagetable, v_addr, 1);
    if((*pte & PTE_V) == 0)
    {
      panic("not valid va!");
    }
    if((*pte)>>6 & 1){
      mask = mask | (1<<i);
      *pte = (*pte) ^ (1<<6);
    }
    v_addr += PGSIZE;
  }
  
  if(copyout(my_proc->pagetable, user_addr, (char *)&mask, sizeof(mask)) < 0)
      return -1;
  return 0;
}
#endif

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
