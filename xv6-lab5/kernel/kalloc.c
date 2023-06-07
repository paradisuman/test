// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

struct mem_ref
{
  int cnt;
};
struct spinlock cowlock;

struct mem_ref mem_ref[PHYSTOP/PGSIZE];


//int
void add_ref(uint64 pa)
{
//  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
 //   return -1;
  acquire(&cowlock);
  ++mem_ref[(uint64)pa/PGSIZE].cnt;
  release(&cowlock);
//  return 1;
}

uint64 
cow_copy(pagetable_t pagetable, uint64 va)
{
  if(va > MAXVA)
    return 0;

  va = PGROUNDDOWN(va);
  pte_t* pte = walk(pagetable, va, 0);

  if(pte == 0)
    return 0;
  // printf("judge here 0\n");
  if(((*pte) & (PTE_V)) == 0)
    return 0;
  // printf("judge here 1\n");
  int ans = (*pte) & (PTE_COW);
  
  if(ans == 0)
    return 0;

  
  uint64 pa = PTE2PA(*pte);
  //printf("cow_copy: 15 %p pid=%d\n", pa);

  if(get_mem_ref(pa) == 1)
  {
    *pte = (*pte) & (~PTE_COW);
    *pte = (*pte) | (PTE_W);
    return pa;
  }
  else
  {
    char *mem = kalloc();
    if(mem == 0){
      return 0;
    }

    memmove(mem, (char *)pa, PGSIZE);
    *pte = (*pte) & (~PTE_V);
    uint64 flag = PTE_FLAGS(*pte);
    flag = flag | PTE_W;
    flag = flag & (~PTE_COW);


    if(mappages(pagetable, va, PGSIZE, (uint64)mem, flag) != 0)
    {
      kfree(mem);
      return 0;
    }
    kfree((char*)PGROUNDDOWN(pa));

    return (uint64)mem;

  }
}

void
kinit()
{

  //for(int i = 0; i < PHYSTOP/PGSIZE; ++i)
  //  initlock(&(mem_ref[i].lock), "kmem_ref");
  initlock(&cowlock, "cow_lock");
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}


void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
  {
    mem_ref[(uint64)p/PGSIZE].cnt = 1;
    kfree(p);
  }
}
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");
  
  uint64 pi = (uint64)pa/PGSIZE;
  acquire(&cowlock);
  --mem_ref[pi].cnt;
  if(mem_ref[pi].cnt > 0)
  {
    release(&cowlock);
    return;
    
  }
  release(&cowlock);
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
  {
    //printf("usertrap(): 15 %p pid=%d\n", r);
    uint64 pi = (uint64)r/PGSIZE;
    acquire(&cowlock);
    mem_ref[pi].cnt = 1;
    release(&cowlock);
    kmem.freelist = r->next;
  }
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
