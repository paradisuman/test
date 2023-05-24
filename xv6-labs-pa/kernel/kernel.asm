
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	88013103          	ld	sp,-1920(sp) # 80008880 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	68c050ef          	jal	ra,800056a2 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	02e080e7          	jalr	46(ra) # 80006088 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	0ce080e7          	jalr	206(ra) # 8000613c <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	ac6080e7          	jalr	-1338(ra) # 80005b50 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	f02080e7          	jalr	-254(ra) # 80005ff8 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	f5a080e7          	jalr	-166(ra) # 80006088 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	ff6080e7          	jalr	-10(ra) # 8000613c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	fcc080e7          	jalr	-52(ra) # 8000613c <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	af0080e7          	jalr	-1296(ra) # 80000e18 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00009717          	auipc	a4,0x9
    80000334:	cd070713          	addi	a4,a4,-816 # 80009000 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	ad4080e7          	jalr	-1324(ra) # 80000e18 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	844080e7          	jalr	-1980(ra) # 80005b9a <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	73c080e7          	jalr	1852(ra) # 80001aa2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	d12080e7          	jalr	-750(ra) # 80005080 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fe8080e7          	jalr	-24(ra) # 8000135e <scheduler>
    consoleinit();
    8000037e:	00005097          	auipc	ra,0x5
    80000382:	6e2080e7          	jalr	1762(ra) # 80005a60 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	9f4080e7          	jalr	-1548(ra) # 80005d7a <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	804080e7          	jalr	-2044(ra) # 80005b9a <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00005097          	auipc	ra,0x5
    800003aa:	7f4080e7          	jalr	2036(ra) # 80005b9a <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00005097          	auipc	ra,0x5
    800003ba:	7e4080e7          	jalr	2020(ra) # 80005b9a <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	322080e7          	jalr	802(ra) # 800006e8 <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	992080e7          	jalr	-1646(ra) # 80000d68 <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	69c080e7          	jalr	1692(ra) # 80001a7a <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	6bc080e7          	jalr	1724(ra) # 80001aa2 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	c7c080e7          	jalr	-900(ra) # 8000506a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	c8a080e7          	jalr	-886(ra) # 80005080 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	e4e080e7          	jalr	-434(ra) # 8000224c <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	4dc080e7          	jalr	1244(ra) # 800028e2 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	48e080e7          	jalr	1166(ra) # 8000389c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	d8a080e7          	jalr	-630(ra) # 800051a0 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	cfe080e7          	jalr	-770(ra) # 8000111c <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043c:	00009797          	auipc	a5,0x9
    80000440:	bcc7b783          	ld	a5,-1076(a5) # 80009008 <kernel_pagetable>
    80000444:	83b1                	srli	a5,a5,0xc
    80000446:	577d                	li	a4,-1
    80000448:	177e                	slli	a4,a4,0x3f
    8000044a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000450:	12000073          	sfence.vma
  sfence_vma();
}
    80000454:	6422                	ld	s0,8(sp)
    80000456:	0141                	addi	sp,sp,16
    80000458:	8082                	ret

000000008000045a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045a:	7139                	addi	sp,sp,-64
    8000045c:	fc06                	sd	ra,56(sp)
    8000045e:	f822                	sd	s0,48(sp)
    80000460:	f426                	sd	s1,40(sp)
    80000462:	f04a                	sd	s2,32(sp)
    80000464:	ec4e                	sd	s3,24(sp)
    80000466:	e852                	sd	s4,16(sp)
    80000468:	e456                	sd	s5,8(sp)
    8000046a:	e05a                	sd	s6,0(sp)
    8000046c:	0080                	addi	s0,sp,64
    8000046e:	84aa                	mv	s1,a0
    80000470:	89ae                	mv	s3,a1
    80000472:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00005097          	auipc	ra,0x5
    8000048c:	6c8080e7          	jalr	1736(ra) # 80005b50 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000490:	060a8663          	beqz	s5,800004fc <walk+0xa2>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000049c:	84aa                	mv	s1,a0
    8000049e:	c529                	beqz	a0,800004e8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a0:	6605                	lui	a2,0x1
    800004a2:	4581                	li	a1,0
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	cd6080e7          	jalr	-810(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ac:	00c4d793          	srli	a5,s1,0xc
    800004b0:	07aa                	slli	a5,a5,0xa
    800004b2:	0017e793          	ori	a5,a5,1
    800004b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004cc:	00093483          	ld	s1,0(s2)
    800004d0:	0014f793          	andi	a5,s1,1
    800004d4:	dfd5                	beqz	a5,80000490 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d6:	80a9                	srli	s1,s1,0xa
    800004d8:	04b2                	slli	s1,s1,0xc
    800004da:	b7c5                	j	800004ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004dc:	00c9d513          	srli	a0,s3,0xc
    800004e0:	1ff57513          	andi	a0,a0,511
    800004e4:	050e                	slli	a0,a0,0x3
    800004e6:	9526                	add	a0,a0,s1
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	74a2                	ld	s1,40(sp)
    800004ee:	7902                	ld	s2,32(sp)
    800004f0:	69e2                	ld	s3,24(sp)
    800004f2:	6a42                	ld	s4,16(sp)
    800004f4:	6aa2                	ld	s5,8(sp)
    800004f6:	6b02                	ld	s6,0(sp)
    800004f8:	6121                	addi	sp,sp,64
    800004fa:	8082                	ret
        return 0;
    800004fc:	4501                	li	a0,0
    800004fe:	b7ed                	j	800004e8 <walk+0x8e>

0000000080000500 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050a:	8082                	ret
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000514:	4601                	li	a2,0
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	f44080e7          	jalr	-188(ra) # 8000045a <walk>
  if(pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052a:	00e68663          	beq	a3,a4,80000536 <walkaddr+0x36>
}
    8000052e:	60a2                	ld	ra,8(sp)
    80000530:	6402                	ld	s0,0(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  pa = PTE2PA(*pte);
    80000536:	83a9                	srli	a5,a5,0xa
    80000538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053c:	bfcd                	j	8000052e <walkaddr+0x2e>
    return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7fd                	j	8000052e <walkaddr+0x2e>

0000000080000542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000542:	715d                	addi	sp,sp,-80
    80000544:	e486                	sd	ra,72(sp)
    80000546:	e0a2                	sd	s0,64(sp)
    80000548:	fc26                	sd	s1,56(sp)
    8000054a:	f84a                	sd	s2,48(sp)
    8000054c:	f44e                	sd	s3,40(sp)
    8000054e:	f052                	sd	s4,32(sp)
    80000550:	ec56                	sd	s5,24(sp)
    80000552:	e85a                	sd	s6,16(sp)
    80000554:	e45e                	sd	s7,8(sp)
    80000556:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000558:	c639                	beqz	a2,800005a6 <mappages+0x64>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055e:	777d                	lui	a4,0xfffff
    80000560:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000564:	fff58993          	addi	s3,a1,-1
    80000568:	99b2                	add	s3,s3,a2
    8000056a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000056e:	893e                	mv	s2,a5
    80000570:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	5a2080e7          	jalr	1442(ra) # 80005b50 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	592080e7          	jalr	1426(ra) # 80005b50 <panic>
      return -1;
    800005c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c8:	60a6                	ld	ra,72(sp)
    800005ca:	6406                	ld	s0,64(sp)
    800005cc:	74e2                	ld	s1,56(sp)
    800005ce:	7942                	ld	s2,48(sp)
    800005d0:	79a2                	ld	s3,40(sp)
    800005d2:	7a02                	ld	s4,32(sp)
    800005d4:	6ae2                	ld	s5,24(sp)
    800005d6:	6b42                	ld	s6,16(sp)
    800005d8:	6ba2                	ld	s7,8(sp)
    800005da:	6161                	addi	sp,sp,80
    800005dc:	8082                	ret
  return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7e5                	j	800005c8 <mappages+0x86>

00000000800005e2 <kvmmap>:
{
    800005e2:	1141                	addi	sp,sp,-16
    800005e4:	e406                	sd	ra,8(sp)
    800005e6:	e022                	sd	s0,0(sp)
    800005e8:	0800                	addi	s0,sp,16
    800005ea:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ec:	86b2                	mv	a3,a2
    800005ee:	863e                	mv	a2,a5
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f52080e7          	jalr	-174(ra) # 80000542 <mappages>
    800005f8:	e509                	bnez	a0,80000602 <kvmmap+0x20>
}
    800005fa:	60a2                	ld	ra,8(sp)
    800005fc:	6402                	ld	s0,0(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret
    panic("kvmmap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a7650513          	addi	a0,a0,-1418 # 80008078 <etext+0x78>
    8000060a:	00005097          	auipc	ra,0x5
    8000060e:	546080e7          	jalr	1350(ra) # 80005b50 <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	afc080e7          	jalr	-1284(ra) # 8000011a <kalloc>
    80000626:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000628:	6605                	lui	a2,0x1
    8000062a:	4581                	li	a1,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	b4e080e7          	jalr	-1202(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	6685                	lui	a3,0x1
    80000638:	10000637          	lui	a2,0x10000
    8000063c:	100005b7          	lui	a1,0x10000
    80000640:	8526                	mv	a0,s1
    80000642:	00000097          	auipc	ra,0x0
    80000646:	fa0080e7          	jalr	-96(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10001637          	lui	a2,0x10001
    80000652:	100015b7          	lui	a1,0x10001
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f8a080e7          	jalr	-118(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	004006b7          	lui	a3,0x400
    80000666:	0c000637          	lui	a2,0xc000
    8000066a:	0c0005b7          	lui	a1,0xc000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f72080e7          	jalr	-142(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000678:	00008917          	auipc	s2,0x8
    8000067c:	98890913          	addi	s2,s2,-1656 # 80008000 <etext>
    80000680:	4729                	li	a4,10
    80000682:	80008697          	auipc	a3,0x80008
    80000686:	97e68693          	addi	a3,a3,-1666 # 8000 <_entry-0x7fff8000>
    8000068a:	4605                	li	a2,1
    8000068c:	067e                	slli	a2,a2,0x1f
    8000068e:	85b2                	mv	a1,a2
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f50080e7          	jalr	-176(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	46c5                	li	a3,17
    8000069e:	06ee                	slli	a3,a3,0x1b
    800006a0:	412686b3          	sub	a3,a3,s2
    800006a4:	864a                	mv	a2,s2
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f38080e7          	jalr	-200(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b2:	4729                	li	a4,10
    800006b4:	6685                	lui	a3,0x1
    800006b6:	00007617          	auipc	a2,0x7
    800006ba:	94a60613          	addi	a2,a2,-1718 # 80007000 <_trampoline>
    800006be:	040005b7          	lui	a1,0x4000
    800006c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c4:	05b2                	slli	a1,a1,0xc
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f1a080e7          	jalr	-230(ra) # 800005e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	600080e7          	jalr	1536(ra) # 80000cd2 <proc_mapstacks>
}
    800006da:	8526                	mv	a0,s1
    800006dc:	60e2                	ld	ra,24(sp)
    800006de:	6442                	ld	s0,16(sp)
    800006e0:	64a2                	ld	s1,8(sp)
    800006e2:	6902                	ld	s2,0(sp)
    800006e4:	6105                	addi	sp,sp,32
    800006e6:	8082                	ret

00000000800006e8 <kvminit>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f22080e7          	jalr	-222(ra) # 80000612 <kvmmake>
    800006f8:	00009797          	auipc	a5,0x9
    800006fc:	90a7b823          	sd	a0,-1776(a5) # 80009008 <kernel_pagetable>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret

0000000080000708 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000708:	715d                	addi	sp,sp,-80
    8000070a:	e486                	sd	ra,72(sp)
    8000070c:	e0a2                	sd	s0,64(sp)
    8000070e:	fc26                	sd	s1,56(sp)
    80000710:	f84a                	sd	s2,48(sp)
    80000712:	f44e                	sd	s3,40(sp)
    80000714:	f052                	sd	s4,32(sp)
    80000716:	ec56                	sd	s5,24(sp)
    80000718:	e85a                	sd	s6,16(sp)
    8000071a:	e45e                	sd	s7,8(sp)
    8000071c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071e:	03459793          	slli	a5,a1,0x34
    80000722:	e795                	bnez	a5,8000074e <uvmunmap+0x46>
    80000724:	8a2a                	mv	s4,a0
    80000726:	892e                	mv	s2,a1
    80000728:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000732:	6b05                	lui	s6,0x1
    80000734:	0735e263          	bltu	a1,s3,80000798 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000738:	60a6                	ld	ra,72(sp)
    8000073a:	6406                	ld	s0,64(sp)
    8000073c:	74e2                	ld	s1,56(sp)
    8000073e:	7942                	ld	s2,48(sp)
    80000740:	79a2                	ld	s3,40(sp)
    80000742:	7a02                	ld	s4,32(sp)
    80000744:	6ae2                	ld	s5,24(sp)
    80000746:	6b42                	ld	s6,16(sp)
    80000748:	6ba2                	ld	s7,8(sp)
    8000074a:	6161                	addi	sp,sp,80
    8000074c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074e:	00008517          	auipc	a0,0x8
    80000752:	93250513          	addi	a0,a0,-1742 # 80008080 <etext+0x80>
    80000756:	00005097          	auipc	ra,0x5
    8000075a:	3fa080e7          	jalr	1018(ra) # 80005b50 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	3ea080e7          	jalr	1002(ra) # 80005b50 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	3da080e7          	jalr	986(ra) # 80005b50 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	3ca080e7          	jalr	970(ra) # 80005b50 <panic>
    *pte = 0;
    8000078e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000792:	995a                	add	s2,s2,s6
    80000794:	fb3972e3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000798:	4601                	li	a2,0
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8552                	mv	a0,s4
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	cbc080e7          	jalr	-836(ra) # 8000045a <walk>
    800007a6:	84aa                	mv	s1,a0
    800007a8:	d95d                	beqz	a0,8000075e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007aa:	6108                	ld	a0,0(a0)
    800007ac:	00157793          	andi	a5,a0,1
    800007b0:	dfdd                	beqz	a5,8000076e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b2:	3ff57793          	andi	a5,a0,1023
    800007b6:	fd7784e3          	beq	a5,s7,8000077e <uvmunmap+0x76>
    if(do_free){
    800007ba:	fc0a8ae3          	beqz	s5,8000078e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007be:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c0:	0532                	slli	a0,a0,0xc
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	85a080e7          	jalr	-1958(ra) # 8000001c <kfree>
    800007ca:	b7d1                	j	8000078e <uvmunmap+0x86>

00000000800007cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007cc:	1101                	addi	sp,sp,-32
    800007ce:	ec06                	sd	ra,24(sp)
    800007d0:	e822                	sd	s0,16(sp)
    800007d2:	e426                	sd	s1,8(sp)
    800007d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	944080e7          	jalr	-1724(ra) # 8000011a <kalloc>
    800007de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e0:	c519                	beqz	a0,800007ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e2:	6605                	lui	a2,0x1
    800007e4:	4581                	li	a1,0
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	994080e7          	jalr	-1644(ra) # 8000017a <memset>
  return pagetable;
}
    800007ee:	8526                	mv	a0,s1
    800007f0:	60e2                	ld	ra,24(sp)
    800007f2:	6442                	ld	s0,16(sp)
    800007f4:	64a2                	ld	s1,8(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fa:	7179                	addi	sp,sp,-48
    800007fc:	f406                	sd	ra,40(sp)
    800007fe:	f022                	sd	s0,32(sp)
    80000800:	ec26                	sd	s1,24(sp)
    80000802:	e84a                	sd	s2,16(sp)
    80000804:	e44e                	sd	s3,8(sp)
    80000806:	e052                	sd	s4,0(sp)
    80000808:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080a:	6785                	lui	a5,0x1
    8000080c:	04f67863          	bgeu	a2,a5,8000085c <uvminit+0x62>
    80000810:	8a2a                	mv	s4,a0
    80000812:	89ae                	mv	s3,a1
    80000814:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	904080e7          	jalr	-1788(ra) # 8000011a <kalloc>
    8000081e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000820:	6605                	lui	a2,0x1
    80000822:	4581                	li	a1,0
    80000824:	00000097          	auipc	ra,0x0
    80000828:	956080e7          	jalr	-1706(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082c:	4779                	li	a4,30
    8000082e:	86ca                	mv	a3,s2
    80000830:	6605                	lui	a2,0x1
    80000832:	4581                	li	a1,0
    80000834:	8552                	mv	a0,s4
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	d0c080e7          	jalr	-756(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    8000083e:	8626                	mv	a2,s1
    80000840:	85ce                	mv	a1,s3
    80000842:	854a                	mv	a0,s2
    80000844:	00000097          	auipc	ra,0x0
    80000848:	992080e7          	jalr	-1646(ra) # 800001d6 <memmove>
}
    8000084c:	70a2                	ld	ra,40(sp)
    8000084e:	7402                	ld	s0,32(sp)
    80000850:	64e2                	ld	s1,24(sp)
    80000852:	6942                	ld	s2,16(sp)
    80000854:	69a2                	ld	s3,8(sp)
    80000856:	6a02                	ld	s4,0(sp)
    80000858:	6145                	addi	sp,sp,48
    8000085a:	8082                	ret
    panic("inituvm: more than a page");
    8000085c:	00008517          	auipc	a0,0x8
    80000860:	87c50513          	addi	a0,a0,-1924 # 800080d8 <etext+0xd8>
    80000864:	00005097          	auipc	ra,0x5
    80000868:	2ec080e7          	jalr	748(ra) # 80005b50 <panic>

000000008000086c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086c:	1101                	addi	sp,sp,-32
    8000086e:	ec06                	sd	ra,24(sp)
    80000870:	e822                	sd	s0,16(sp)
    80000872:	e426                	sd	s1,8(sp)
    80000874:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000876:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000878:	00b67d63          	bgeu	a2,a1,80000892 <uvmdealloc+0x26>
    8000087c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087e:	6785                	lui	a5,0x1
    80000880:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000882:	00f60733          	add	a4,a2,a5
    80000886:	76fd                	lui	a3,0xfffff
    80000888:	8f75                	and	a4,a4,a3
    8000088a:	97ae                	add	a5,a5,a1
    8000088c:	8ff5                	and	a5,a5,a3
    8000088e:	00f76863          	bltu	a4,a5,8000089e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000892:	8526                	mv	a0,s1
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089e:	8f99                	sub	a5,a5,a4
    800008a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a2:	4685                	li	a3,1
    800008a4:	0007861b          	sext.w	a2,a5
    800008a8:	85ba                	mv	a1,a4
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	e5e080e7          	jalr	-418(ra) # 80000708 <uvmunmap>
    800008b2:	b7c5                	j	80000892 <uvmdealloc+0x26>

00000000800008b4 <uvmalloc>:
  if(newsz < oldsz)
    800008b4:	0ab66163          	bltu	a2,a1,80000956 <uvmalloc+0xa2>
{
    800008b8:	7139                	addi	sp,sp,-64
    800008ba:	fc06                	sd	ra,56(sp)
    800008bc:	f822                	sd	s0,48(sp)
    800008be:	f426                	sd	s1,40(sp)
    800008c0:	f04a                	sd	s2,32(sp)
    800008c2:	ec4e                	sd	s3,24(sp)
    800008c4:	e852                	sd	s4,16(sp)
    800008c6:	e456                	sd	s5,8(sp)
    800008c8:	0080                	addi	s0,sp,64
    800008ca:	8aaa                	mv	s5,a0
    800008cc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d2:	95be                	add	a1,a1,a5
    800008d4:	77fd                	lui	a5,0xfffff
    800008d6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008da:	08c9f063          	bgeu	s3,a2,8000095a <uvmalloc+0xa6>
    800008de:	894e                	mv	s2,s3
    mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	83a080e7          	jalr	-1990(ra) # 8000011a <kalloc>
    800008e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ea:	c51d                	beqz	a0,80000918 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ec:	6605                	lui	a2,0x1
    800008ee:	4581                	li	a1,0
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	88a080e7          	jalr	-1910(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f8:	4779                	li	a4,30
    800008fa:	86a6                	mv	a3,s1
    800008fc:	6605                	lui	a2,0x1
    800008fe:	85ca                	mv	a1,s2
    80000900:	8556                	mv	a0,s5
    80000902:	00000097          	auipc	ra,0x0
    80000906:	c40080e7          	jalr	-960(ra) # 80000542 <mappages>
    8000090a:	e905                	bnez	a0,8000093a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090c:	6785                	lui	a5,0x1
    8000090e:	993e                	add	s2,s2,a5
    80000910:	fd4968e3          	bltu	s2,s4,800008e0 <uvmalloc+0x2c>
  return newsz;
    80000914:	8552                	mv	a0,s4
    80000916:	a809                	j	80000928 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000918:	864e                	mv	a2,s3
    8000091a:	85ca                	mv	a1,s2
    8000091c:	8556                	mv	a0,s5
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	f4e080e7          	jalr	-178(ra) # 8000086c <uvmdealloc>
      return 0;
    80000926:	4501                	li	a0,0
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6121                	addi	sp,sp,64
    80000938:	8082                	ret
      kfree(mem);
    8000093a:	8526                	mv	a0,s1
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	6e0080e7          	jalr	1760(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f22080e7          	jalr	-222(ra) # 8000086c <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
    80000954:	bfd1                	j	80000928 <uvmalloc+0x74>
    return oldsz;
    80000956:	852e                	mv	a0,a1
}
    80000958:	8082                	ret
  return newsz;
    8000095a:	8532                	mv	a0,a2
    8000095c:	b7f1                	j	80000928 <uvmalloc+0x74>

000000008000095e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095e:	7179                	addi	sp,sp,-48
    80000960:	f406                	sd	ra,40(sp)
    80000962:	f022                	sd	s0,32(sp)
    80000964:	ec26                	sd	s1,24(sp)
    80000966:	e84a                	sd	s2,16(sp)
    80000968:	e44e                	sd	s3,8(sp)
    8000096a:	e052                	sd	s4,0(sp)
    8000096c:	1800                	addi	s0,sp,48
    8000096e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000970:	84aa                	mv	s1,a0
    80000972:	6905                	lui	s2,0x1
    80000974:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000976:	4985                	li	s3,1
    80000978:	a829                	j	80000992 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097c:	00c79513          	slli	a0,a5,0xc
    80000980:	00000097          	auipc	ra,0x0
    80000984:	fde080e7          	jalr	-34(ra) # 8000095e <freewalk>
      pagetable[i] = 0;
    80000988:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098c:	04a1                	addi	s1,s1,8
    8000098e:	03248163          	beq	s1,s2,800009b0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000992:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000994:	00f7f713          	andi	a4,a5,15
    80000998:	ff3701e3          	beq	a4,s3,8000097a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099c:	8b85                	andi	a5,a5,1
    8000099e:	d7fd                	beqz	a5,8000098c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009a0:	00007517          	auipc	a0,0x7
    800009a4:	75850513          	addi	a0,a0,1880 # 800080f8 <etext+0xf8>
    800009a8:	00005097          	auipc	ra,0x5
    800009ac:	1a8080e7          	jalr	424(ra) # 80005b50 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b0:	8552                	mv	a0,s4
    800009b2:	fffff097          	auipc	ra,0xfffff
    800009b6:	66a080e7          	jalr	1642(ra) # 8000001c <kfree>
}
    800009ba:	70a2                	ld	ra,40(sp)
    800009bc:	7402                	ld	s0,32(sp)
    800009be:	64e2                	ld	s1,24(sp)
    800009c0:	6942                	ld	s2,16(sp)
    800009c2:	69a2                	ld	s3,8(sp)
    800009c4:	6a02                	ld	s4,0(sp)
    800009c6:	6145                	addi	sp,sp,48
    800009c8:	8082                	ret

00000000800009ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
    800009d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d6:	e999                	bnez	a1,800009ec <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d8:	8526                	mv	a0,s1
    800009da:	00000097          	auipc	ra,0x0
    800009de:	f84080e7          	jalr	-124(ra) # 8000095e <freewalk>
}
    800009e2:	60e2                	ld	ra,24(sp)
    800009e4:	6442                	ld	s0,16(sp)
    800009e6:	64a2                	ld	s1,8(sp)
    800009e8:	6105                	addi	sp,sp,32
    800009ea:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ec:	6785                	lui	a5,0x1
    800009ee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f0:	95be                	add	a1,a1,a5
    800009f2:	4685                	li	a3,1
    800009f4:	00c5d613          	srli	a2,a1,0xc
    800009f8:	4581                	li	a1,0
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	d0e080e7          	jalr	-754(ra) # 80000708 <uvmunmap>
    80000a02:	bfd9                	j	800009d8 <uvmfree+0xe>

0000000080000a04 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a04:	c679                	beqz	a2,80000ad2 <uvmcopy+0xce>
{
    80000a06:	715d                	addi	sp,sp,-80
    80000a08:	e486                	sd	ra,72(sp)
    80000a0a:	e0a2                	sd	s0,64(sp)
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	f052                	sd	s4,32(sp)
    80000a14:	ec56                	sd	s5,24(sp)
    80000a16:	e85a                	sd	s6,16(sp)
    80000a18:	e45e                	sd	s7,8(sp)
    80000a1a:	0880                	addi	s0,sp,80
    80000a1c:	8b2a                	mv	s6,a0
    80000a1e:	8aae                	mv	s5,a1
    80000a20:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a22:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a24:	4601                	li	a2,0
    80000a26:	85ce                	mv	a1,s3
    80000a28:	855a                	mv	a0,s6
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	a30080e7          	jalr	-1488(ra) # 8000045a <walk>
    80000a32:	c531                	beqz	a0,80000a7e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a34:	6118                	ld	a4,0(a0)
    80000a36:	00177793          	andi	a5,a4,1
    80000a3a:	cbb1                	beqz	a5,80000a8e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3c:	00a75593          	srli	a1,a4,0xa
    80000a40:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a44:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a48:	fffff097          	auipc	ra,0xfffff
    80000a4c:	6d2080e7          	jalr	1746(ra) # 8000011a <kalloc>
    80000a50:	892a                	mv	s2,a0
    80000a52:	c939                	beqz	a0,80000aa8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	85de                	mv	a1,s7
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	77e080e7          	jalr	1918(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a60:	8726                	mv	a4,s1
    80000a62:	86ca                	mv	a3,s2
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85ce                	mv	a1,s3
    80000a68:	8556                	mv	a0,s5
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	ad8080e7          	jalr	-1320(ra) # 80000542 <mappages>
    80000a72:	e515                	bnez	a0,80000a9e <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a74:	6785                	lui	a5,0x1
    80000a76:	99be                	add	s3,s3,a5
    80000a78:	fb49e6e3          	bltu	s3,s4,80000a24 <uvmcopy+0x20>
    80000a7c:	a081                	j	80000abc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	68a50513          	addi	a0,a0,1674 # 80008108 <etext+0x108>
    80000a86:	00005097          	auipc	ra,0x5
    80000a8a:	0ca080e7          	jalr	202(ra) # 80005b50 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	0ba080e7          	jalr	186(ra) # 80005b50 <panic>
      kfree(mem);
    80000a9e:	854a                	mv	a0,s2
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	57c080e7          	jalr	1404(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa8:	4685                	li	a3,1
    80000aaa:	00c9d613          	srli	a2,s3,0xc
    80000aae:	4581                	li	a1,0
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	c56080e7          	jalr	-938(ra) # 80000708 <uvmunmap>
  return -1;
    80000aba:	557d                	li	a0,-1
}
    80000abc:	60a6                	ld	ra,72(sp)
    80000abe:	6406                	ld	s0,64(sp)
    80000ac0:	74e2                	ld	s1,56(sp)
    80000ac2:	7942                	ld	s2,48(sp)
    80000ac4:	79a2                	ld	s3,40(sp)
    80000ac6:	7a02                	ld	s4,32(sp)
    80000ac8:	6ae2                	ld	s5,24(sp)
    80000aca:	6b42                	ld	s6,16(sp)
    80000acc:	6ba2                	ld	s7,8(sp)
    80000ace:	6161                	addi	sp,sp,80
    80000ad0:	8082                	ret
  return 0;
    80000ad2:	4501                	li	a0,0
}
    80000ad4:	8082                	ret

0000000080000ad6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad6:	1141                	addi	sp,sp,-16
    80000ad8:	e406                	sd	ra,8(sp)
    80000ada:	e022                	sd	s0,0(sp)
    80000adc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ade:	4601                	li	a2,0
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	97a080e7          	jalr	-1670(ra) # 8000045a <walk>
  if(pte == 0)
    80000ae8:	c901                	beqz	a0,80000af8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aea:	611c                	ld	a5,0(a0)
    80000aec:	9bbd                	andi	a5,a5,-17
    80000aee:	e11c                	sd	a5,0(a0)
}
    80000af0:	60a2                	ld	ra,8(sp)
    80000af2:	6402                	ld	s0,0(sp)
    80000af4:	0141                	addi	sp,sp,16
    80000af6:	8082                	ret
    panic("uvmclear");
    80000af8:	00007517          	auipc	a0,0x7
    80000afc:	65050513          	addi	a0,a0,1616 # 80008148 <etext+0x148>
    80000b00:	00005097          	auipc	ra,0x5
    80000b04:	050080e7          	jalr	80(ra) # 80005b50 <panic>

0000000080000b08 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b08:	c6bd                	beqz	a3,80000b76 <copyout+0x6e>
{
    80000b0a:	715d                	addi	sp,sp,-80
    80000b0c:	e486                	sd	ra,72(sp)
    80000b0e:	e0a2                	sd	s0,64(sp)
    80000b10:	fc26                	sd	s1,56(sp)
    80000b12:	f84a                	sd	s2,48(sp)
    80000b14:	f44e                	sd	s3,40(sp)
    80000b16:	f052                	sd	s4,32(sp)
    80000b18:	ec56                	sd	s5,24(sp)
    80000b1a:	e85a                	sd	s6,16(sp)
    80000b1c:	e45e                	sd	s7,8(sp)
    80000b1e:	e062                	sd	s8,0(sp)
    80000b20:	0880                	addi	s0,sp,80
    80000b22:	8b2a                	mv	s6,a0
    80000b24:	8c2e                	mv	s8,a1
    80000b26:	8a32                	mv	s4,a2
    80000b28:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2c:	6a85                	lui	s5,0x1
    80000b2e:	a015                	j	80000b52 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b30:	9562                	add	a0,a0,s8
    80000b32:	0004861b          	sext.w	a2,s1
    80000b36:	85d2                	mv	a1,s4
    80000b38:	41250533          	sub	a0,a0,s2
    80000b3c:	fffff097          	auipc	ra,0xfffff
    80000b40:	69a080e7          	jalr	1690(ra) # 800001d6 <memmove>

    len -= n;
    80000b44:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b48:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b4e:	02098263          	beqz	s3,80000b72 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b52:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b56:	85ca                	mv	a1,s2
    80000b58:	855a                	mv	a0,s6
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	9a6080e7          	jalr	-1626(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b62:	cd01                	beqz	a0,80000b7a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b64:	418904b3          	sub	s1,s2,s8
    80000b68:	94d6                	add	s1,s1,s5
    80000b6a:	fc99f3e3          	bgeu	s3,s1,80000b30 <copyout+0x28>
    80000b6e:	84ce                	mv	s1,s3
    80000b70:	b7c1                	j	80000b30 <copyout+0x28>
  }
  return 0;
    80000b72:	4501                	li	a0,0
    80000b74:	a021                	j	80000b7c <copyout+0x74>
    80000b76:	4501                	li	a0,0
}
    80000b78:	8082                	ret
      return -1;
    80000b7a:	557d                	li	a0,-1
}
    80000b7c:	60a6                	ld	ra,72(sp)
    80000b7e:	6406                	ld	s0,64(sp)
    80000b80:	74e2                	ld	s1,56(sp)
    80000b82:	7942                	ld	s2,48(sp)
    80000b84:	79a2                	ld	s3,40(sp)
    80000b86:	7a02                	ld	s4,32(sp)
    80000b88:	6ae2                	ld	s5,24(sp)
    80000b8a:	6b42                	ld	s6,16(sp)
    80000b8c:	6ba2                	ld	s7,8(sp)
    80000b8e:	6c02                	ld	s8,0(sp)
    80000b90:	6161                	addi	sp,sp,80
    80000b92:	8082                	ret

0000000080000b94 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b94:	caa5                	beqz	a3,80000c04 <copyin+0x70>
{
    80000b96:	715d                	addi	sp,sp,-80
    80000b98:	e486                	sd	ra,72(sp)
    80000b9a:	e0a2                	sd	s0,64(sp)
    80000b9c:	fc26                	sd	s1,56(sp)
    80000b9e:	f84a                	sd	s2,48(sp)
    80000ba0:	f44e                	sd	s3,40(sp)
    80000ba2:	f052                	sd	s4,32(sp)
    80000ba4:	ec56                	sd	s5,24(sp)
    80000ba6:	e85a                	sd	s6,16(sp)
    80000ba8:	e45e                	sd	s7,8(sp)
    80000baa:	e062                	sd	s8,0(sp)
    80000bac:	0880                	addi	s0,sp,80
    80000bae:	8b2a                	mv	s6,a0
    80000bb0:	8a2e                	mv	s4,a1
    80000bb2:	8c32                	mv	s8,a2
    80000bb4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb8:	6a85                	lui	s5,0x1
    80000bba:	a01d                	j	80000be0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbc:	018505b3          	add	a1,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412585b3          	sub	a1,a1,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60c080e7          	jalr	1548(ra) # 800001d6 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	918080e7          	jalr	-1768(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    80000bf8:	fc99f2e3          	bgeu	s3,s1,80000bbc <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	bf7d                	j	80000bbc <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x76>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c2dd                	beqz	a3,80000cc8 <copyinstr+0xa6>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a02d                	j	80000c70 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6161                	addi	sp,sp,80
    80000c68:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6e:	c8a9                	beqz	s1,80000cc0 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c70:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c74:	85ca                	mv	a1,s2
    80000c76:	8552                	mv	a0,s4
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	888080e7          	jalr	-1912(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c80:	c131                	beqz	a0,80000cc4 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c82:	417906b3          	sub	a3,s2,s7
    80000c86:	96ce                	add	a3,a3,s3
    80000c88:	00d4f363          	bgeu	s1,a3,80000c8e <copyinstr+0x6c>
    80000c8c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8e:	955e                	add	a0,a0,s7
    80000c90:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c94:	daf9                	beqz	a3,80000c6a <copyinstr+0x48>
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	fff48593          	addi	a1,s1,-1
    80000ca0:	95da                	add	a1,a1,s6
    while(n > 0){
    80000ca2:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000ca4:	00f60733          	add	a4,a2,a5
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cac:	df51                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cae:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb2:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cb6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb8:	fed796e3          	bne	a5,a3,80000ca4 <copyinstr+0x82>
      dst++;
    80000cbc:	8b3e                	mv	s6,a5
    80000cbe:	b775                	j	80000c6a <copyinstr+0x48>
    80000cc0:	4781                	li	a5,0
    80000cc2:	b771                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc4:	557d                	li	a0,-1
    80000cc6:	b779                	j	80000c54 <copyinstr+0x32>
  int got_null = 0;
    80000cc8:	4781                	li	a5,0
  if(got_null){
    80000cca:	37fd                	addiw	a5,a5,-1
    80000ccc:	0007851b          	sext.w	a0,a5
}
    80000cd0:	8082                	ret

0000000080000cd2 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd2:	7139                	addi	sp,sp,-64
    80000cd4:	fc06                	sd	ra,56(sp)
    80000cd6:	f822                	sd	s0,48(sp)
    80000cd8:	f426                	sd	s1,40(sp)
    80000cda:	f04a                	sd	s2,32(sp)
    80000cdc:	ec4e                	sd	s3,24(sp)
    80000cde:	e852                	sd	s4,16(sp)
    80000ce0:	e456                	sd	s5,8(sp)
    80000ce2:	e05a                	sd	s6,0(sp)
    80000ce4:	0080                	addi	s0,sp,64
    80000ce6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	00008497          	auipc	s1,0x8
    80000cec:	79848493          	addi	s1,s1,1944 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf0:	8b26                	mv	s6,s1
    80000cf2:	00007a97          	auipc	s5,0x7
    80000cf6:	30ea8a93          	addi	s5,s5,782 # 80008000 <etext>
    80000cfa:	04000937          	lui	s2,0x4000
    80000cfe:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d00:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	0000ea17          	auipc	s4,0xe
    80000d06:	37ea0a13          	addi	s4,s4,894 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d0a:	fffff097          	auipc	ra,0xfffff
    80000d0e:	410080e7          	jalr	1040(ra) # 8000011a <kalloc>
    80000d12:	862a                	mv	a2,a0
    if(pa == 0)
    80000d14:	c131                	beqz	a0,80000d58 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d16:	416485b3          	sub	a1,s1,s6
    80000d1a:	8591                	srai	a1,a1,0x4
    80000d1c:	000ab783          	ld	a5,0(s5)
    80000d20:	02f585b3          	mul	a1,a1,a5
    80000d24:	2585                	addiw	a1,a1,1
    80000d26:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2a:	4719                	li	a4,6
    80000d2c:	6685                	lui	a3,0x1
    80000d2e:	40b905b3          	sub	a1,s2,a1
    80000d32:	854e                	mv	a0,s3
    80000d34:	00000097          	auipc	ra,0x0
    80000d38:	8ae080e7          	jalr	-1874(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3c:	17048493          	addi	s1,s1,368
    80000d40:	fd4495e3          	bne	s1,s4,80000d0a <proc_mapstacks+0x38>
  }
}
    80000d44:	70e2                	ld	ra,56(sp)
    80000d46:	7442                	ld	s0,48(sp)
    80000d48:	74a2                	ld	s1,40(sp)
    80000d4a:	7902                	ld	s2,32(sp)
    80000d4c:	69e2                	ld	s3,24(sp)
    80000d4e:	6a42                	ld	s4,16(sp)
    80000d50:	6aa2                	ld	s5,8(sp)
    80000d52:	6b02                	ld	s6,0(sp)
    80000d54:	6121                	addi	sp,sp,64
    80000d56:	8082                	ret
      panic("kalloc");
    80000d58:	00007517          	auipc	a0,0x7
    80000d5c:	40050513          	addi	a0,a0,1024 # 80008158 <etext+0x158>
    80000d60:	00005097          	auipc	ra,0x5
    80000d64:	df0080e7          	jalr	-528(ra) # 80005b50 <panic>

0000000080000d68 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d68:	7139                	addi	sp,sp,-64
    80000d6a:	fc06                	sd	ra,56(sp)
    80000d6c:	f822                	sd	s0,48(sp)
    80000d6e:	f426                	sd	s1,40(sp)
    80000d70:	f04a                	sd	s2,32(sp)
    80000d72:	ec4e                	sd	s3,24(sp)
    80000d74:	e852                	sd	s4,16(sp)
    80000d76:	e456                	sd	s5,8(sp)
    80000d78:	e05a                	sd	s6,0(sp)
    80000d7a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7c:	00007597          	auipc	a1,0x7
    80000d80:	3e458593          	addi	a1,a1,996 # 80008160 <etext+0x160>
    80000d84:	00008517          	auipc	a0,0x8
    80000d88:	2cc50513          	addi	a0,a0,716 # 80009050 <pid_lock>
    80000d8c:	00005097          	auipc	ra,0x5
    80000d90:	26c080e7          	jalr	620(ra) # 80005ff8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d94:	00007597          	auipc	a1,0x7
    80000d98:	3d458593          	addi	a1,a1,980 # 80008168 <etext+0x168>
    80000d9c:	00008517          	auipc	a0,0x8
    80000da0:	2cc50513          	addi	a0,a0,716 # 80009068 <wait_lock>
    80000da4:	00005097          	auipc	ra,0x5
    80000da8:	254080e7          	jalr	596(ra) # 80005ff8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dac:	00008497          	auipc	s1,0x8
    80000db0:	6d448493          	addi	s1,s1,1748 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db4:	00007b17          	auipc	s6,0x7
    80000db8:	3c4b0b13          	addi	s6,s6,964 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dbc:	8aa6                	mv	s5,s1
    80000dbe:	00007a17          	auipc	s4,0x7
    80000dc2:	242a0a13          	addi	s4,s4,578 # 80008000 <etext>
    80000dc6:	04000937          	lui	s2,0x4000
    80000dca:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dcc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dce:	0000e997          	auipc	s3,0xe
    80000dd2:	2b298993          	addi	s3,s3,690 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000dd6:	85da                	mv	a1,s6
    80000dd8:	8526                	mv	a0,s1
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	21e080e7          	jalr	542(ra) # 80005ff8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de2:	415487b3          	sub	a5,s1,s5
    80000de6:	8791                	srai	a5,a5,0x4
    80000de8:	000a3703          	ld	a4,0(s4)
    80000dec:	02e787b3          	mul	a5,a5,a4
    80000df0:	2785                	addiw	a5,a5,1
    80000df2:	00d7979b          	slliw	a5,a5,0xd
    80000df6:	40f907b3          	sub	a5,s2,a5
    80000dfa:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	17048493          	addi	s1,s1,368
    80000e00:	fd349be3          	bne	s1,s3,80000dd6 <procinit+0x6e>
  }
}
    80000e04:	70e2                	ld	ra,56(sp)
    80000e06:	7442                	ld	s0,48(sp)
    80000e08:	74a2                	ld	s1,40(sp)
    80000e0a:	7902                	ld	s2,32(sp)
    80000e0c:	69e2                	ld	s3,24(sp)
    80000e0e:	6a42                	ld	s4,16(sp)
    80000e10:	6aa2                	ld	s5,8(sp)
    80000e12:	6b02                	ld	s6,0(sp)
    80000e14:	6121                	addi	sp,sp,64
    80000e16:	8082                	ret

0000000080000e18 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e422                	sd	s0,8(sp)
    80000e1c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e20:	2501                	sext.w	a0,a0
    80000e22:	6422                	ld	s0,8(sp)
    80000e24:	0141                	addi	sp,sp,16
    80000e26:	8082                	ret

0000000080000e28 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
    80000e2e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e30:	2781                	sext.w	a5,a5
    80000e32:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e34:	00008517          	auipc	a0,0x8
    80000e38:	24c50513          	addi	a0,a0,588 # 80009080 <cpus>
    80000e3c:	953e                	add	a0,a0,a5
    80000e3e:	6422                	ld	s0,8(sp)
    80000e40:	0141                	addi	sp,sp,16
    80000e42:	8082                	ret

0000000080000e44 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e44:	1101                	addi	sp,sp,-32
    80000e46:	ec06                	sd	ra,24(sp)
    80000e48:	e822                	sd	s0,16(sp)
    80000e4a:	e426                	sd	s1,8(sp)
    80000e4c:	1000                	addi	s0,sp,32
  push_off();
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	1ee080e7          	jalr	494(ra) # 8000603c <push_off>
    80000e56:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e58:	2781                	sext.w	a5,a5
    80000e5a:	079e                	slli	a5,a5,0x7
    80000e5c:	00008717          	auipc	a4,0x8
    80000e60:	1f470713          	addi	a4,a4,500 # 80009050 <pid_lock>
    80000e64:	97ba                	add	a5,a5,a4
    80000e66:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e68:	00005097          	auipc	ra,0x5
    80000e6c:	274080e7          	jalr	628(ra) # 800060dc <pop_off>
  return p;
}
    80000e70:	8526                	mv	a0,s1
    80000e72:	60e2                	ld	ra,24(sp)
    80000e74:	6442                	ld	s0,16(sp)
    80000e76:	64a2                	ld	s1,8(sp)
    80000e78:	6105                	addi	sp,sp,32
    80000e7a:	8082                	ret

0000000080000e7c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e406                	sd	ra,8(sp)
    80000e80:	e022                	sd	s0,0(sp)
    80000e82:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e84:	00000097          	auipc	ra,0x0
    80000e88:	fc0080e7          	jalr	-64(ra) # 80000e44 <myproc>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	2b0080e7          	jalr	688(ra) # 8000613c <release>

  if (first) {
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	99c7a783          	lw	a5,-1636(a5) # 80008830 <first.1>
    80000e9c:	eb89                	bnez	a5,80000eae <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	c1c080e7          	jalr	-996(ra) # 80001aba <usertrapret>
}
    80000ea6:	60a2                	ld	ra,8(sp)
    80000ea8:	6402                	ld	s0,0(sp)
    80000eaa:	0141                	addi	sp,sp,16
    80000eac:	8082                	ret
    first = 0;
    80000eae:	00008797          	auipc	a5,0x8
    80000eb2:	9807a123          	sw	zero,-1662(a5) # 80008830 <first.1>
    fsinit(ROOTDEV);
    80000eb6:	4505                	li	a0,1
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	9aa080e7          	jalr	-1622(ra) # 80002862 <fsinit>
    80000ec0:	bff9                	j	80000e9e <forkret+0x22>

0000000080000ec2 <allocpid>:
allocpid() {
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	e426                	sd	s1,8(sp)
    80000eca:	e04a                	sd	s2,0(sp)
    80000ecc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ece:	00008917          	auipc	s2,0x8
    80000ed2:	18290913          	addi	s2,s2,386 # 80009050 <pid_lock>
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	1b0080e7          	jalr	432(ra) # 80006088 <acquire>
  pid = nextpid;
    80000ee0:	00008797          	auipc	a5,0x8
    80000ee4:	95478793          	addi	a5,a5,-1708 # 80008834 <nextpid>
    80000ee8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eea:	0014871b          	addiw	a4,s1,1
    80000eee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef0:	854a                	mv	a0,s2
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	24a080e7          	jalr	586(ra) # 8000613c <release>
}
    80000efa:	8526                	mv	a0,s1
    80000efc:	60e2                	ld	ra,24(sp)
    80000efe:	6442                	ld	s0,16(sp)
    80000f00:	64a2                	ld	s1,8(sp)
    80000f02:	6902                	ld	s2,0(sp)
    80000f04:	6105                	addi	sp,sp,32
    80000f06:	8082                	ret

0000000080000f08 <proc_pagetable>:
{
    80000f08:	1101                	addi	sp,sp,-32
    80000f0a:	ec06                	sd	ra,24(sp)
    80000f0c:	e822                	sd	s0,16(sp)
    80000f0e:	e426                	sd	s1,8(sp)
    80000f10:	e04a                	sd	s2,0(sp)
    80000f12:	1000                	addi	s0,sp,32
    80000f14:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	8b6080e7          	jalr	-1866(ra) # 800007cc <uvmcreate>
    80000f1e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f20:	c121                	beqz	a0,80000f60 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f22:	4729                	li	a4,10
    80000f24:	00006697          	auipc	a3,0x6
    80000f28:	0dc68693          	addi	a3,a3,220 # 80007000 <_trampoline>
    80000f2c:	6605                	lui	a2,0x1
    80000f2e:	040005b7          	lui	a1,0x4000
    80000f32:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f34:	05b2                	slli	a1,a1,0xc
    80000f36:	fffff097          	auipc	ra,0xfffff
    80000f3a:	60c080e7          	jalr	1548(ra) # 80000542 <mappages>
    80000f3e:	02054863          	bltz	a0,80000f6e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f42:	4719                	li	a4,6
    80000f44:	05893683          	ld	a3,88(s2)
    80000f48:	6605                	lui	a2,0x1
    80000f4a:	020005b7          	lui	a1,0x2000
    80000f4e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f50:	05b6                	slli	a1,a1,0xd
    80000f52:	8526                	mv	a0,s1
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	5ee080e7          	jalr	1518(ra) # 80000542 <mappages>
    80000f5c:	02054163          	bltz	a0,80000f7e <proc_pagetable+0x76>
}
    80000f60:	8526                	mv	a0,s1
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6902                	ld	s2,0(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6e:	4581                	li	a1,0
    80000f70:	8526                	mv	a0,s1
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	a58080e7          	jalr	-1448(ra) # 800009ca <uvmfree>
    return 0;
    80000f7a:	4481                	li	s1,0
    80000f7c:	b7d5                	j	80000f60 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7e:	4681                	li	a3,0
    80000f80:	4605                	li	a2,1
    80000f82:	040005b7          	lui	a1,0x4000
    80000f86:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f88:	05b2                	slli	a1,a1,0xc
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	77c080e7          	jalr	1916(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f94:	4581                	li	a1,0
    80000f96:	8526                	mv	a0,s1
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	a32080e7          	jalr	-1486(ra) # 800009ca <uvmfree>
    return 0;
    80000fa0:	4481                	li	s1,0
    80000fa2:	bf7d                	j	80000f60 <proc_pagetable+0x58>

0000000080000fa4 <proc_freepagetable>:
{
    80000fa4:	1101                	addi	sp,sp,-32
    80000fa6:	ec06                	sd	ra,24(sp)
    80000fa8:	e822                	sd	s0,16(sp)
    80000faa:	e426                	sd	s1,8(sp)
    80000fac:	e04a                	sd	s2,0(sp)
    80000fae:	1000                	addi	s0,sp,32
    80000fb0:	84aa                	mv	s1,a0
    80000fb2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb4:	4681                	li	a3,0
    80000fb6:	4605                	li	a2,1
    80000fb8:	040005b7          	lui	a1,0x4000
    80000fbc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fbe:	05b2                	slli	a1,a1,0xc
    80000fc0:	fffff097          	auipc	ra,0xfffff
    80000fc4:	748080e7          	jalr	1864(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	732080e7          	jalr	1842(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fde:	85ca                	mv	a1,s2
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	9e8080e7          	jalr	-1560(ra) # 800009ca <uvmfree>
}
    80000fea:	60e2                	ld	ra,24(sp)
    80000fec:	6442                	ld	s0,16(sp)
    80000fee:	64a2                	ld	s1,8(sp)
    80000ff0:	6902                	ld	s2,0(sp)
    80000ff2:	6105                	addi	sp,sp,32
    80000ff4:	8082                	ret

0000000080000ff6 <freeproc>:
{
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	1000                	addi	s0,sp,32
    80001000:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001002:	6d28                	ld	a0,88(a0)
    80001004:	c509                	beqz	a0,8000100e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	016080e7          	jalr	22(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001012:	68a8                	ld	a0,80(s1)
    80001014:	c511                	beqz	a0,80001020 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001016:	64ac                	ld	a1,72(s1)
    80001018:	00000097          	auipc	ra,0x0
    8000101c:	f8c080e7          	jalr	-116(ra) # 80000fa4 <proc_freepagetable>
  p->pagetable = 0;
    80001020:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001024:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001028:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001030:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001034:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001038:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001040:	0004ac23          	sw	zero,24(s1)
}
    80001044:	60e2                	ld	ra,24(sp)
    80001046:	6442                	ld	s0,16(sp)
    80001048:	64a2                	ld	s1,8(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret

000000008000104e <allocproc>:
{
    8000104e:	1101                	addi	sp,sp,-32
    80001050:	ec06                	sd	ra,24(sp)
    80001052:	e822                	sd	s0,16(sp)
    80001054:	e426                	sd	s1,8(sp)
    80001056:	e04a                	sd	s2,0(sp)
    80001058:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105a:	00008497          	auipc	s1,0x8
    8000105e:	42648493          	addi	s1,s1,1062 # 80009480 <proc>
    80001062:	0000e917          	auipc	s2,0xe
    80001066:	01e90913          	addi	s2,s2,30 # 8000f080 <tickslock>
    acquire(&p->lock);
    8000106a:	8526                	mv	a0,s1
    8000106c:	00005097          	auipc	ra,0x5
    80001070:	01c080e7          	jalr	28(ra) # 80006088 <acquire>
    if(p->state == UNUSED) {
    80001074:	4c9c                	lw	a5,24(s1)
    80001076:	cf81                	beqz	a5,8000108e <allocproc+0x40>
      release(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	0c2080e7          	jalr	194(ra) # 8000613c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001082:	17048493          	addi	s1,s1,368
    80001086:	ff2492e3          	bne	s1,s2,8000106a <allocproc+0x1c>
  return 0;
    8000108a:	4481                	li	s1,0
    8000108c:	a889                	j	800010de <allocproc+0x90>
  p->pid = allocpid();
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	e34080e7          	jalr	-460(ra) # 80000ec2 <allocpid>
    80001096:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001098:	4785                	li	a5,1
    8000109a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	07e080e7          	jalr	126(ra) # 8000011a <kalloc>
    800010a4:	892a                	mv	s2,a0
    800010a6:	eca8                	sd	a0,88(s1)
    800010a8:	c131                	beqz	a0,800010ec <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010aa:	8526                	mv	a0,s1
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	e5c080e7          	jalr	-420(ra) # 80000f08 <proc_pagetable>
    800010b4:	892a                	mv	s2,a0
    800010b6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010b8:	c531                	beqz	a0,80001104 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ba:	07000613          	li	a2,112
    800010be:	4581                	li	a1,0
    800010c0:	06048513          	addi	a0,s1,96
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	0b6080e7          	jalr	182(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010cc:	00000797          	auipc	a5,0x0
    800010d0:	db078793          	addi	a5,a5,-592 # 80000e7c <forkret>
    800010d4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010d6:	60bc                	ld	a5,64(s1)
    800010d8:	6705                	lui	a4,0x1
    800010da:	97ba                	add	a5,a5,a4
    800010dc:	f4bc                	sd	a5,104(s1)
}
    800010de:	8526                	mv	a0,s1
    800010e0:	60e2                	ld	ra,24(sp)
    800010e2:	6442                	ld	s0,16(sp)
    800010e4:	64a2                	ld	s1,8(sp)
    800010e6:	6902                	ld	s2,0(sp)
    800010e8:	6105                	addi	sp,sp,32
    800010ea:	8082                	ret
    freeproc(p);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	f08080e7          	jalr	-248(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    800010f6:	8526                	mv	a0,s1
    800010f8:	00005097          	auipc	ra,0x5
    800010fc:	044080e7          	jalr	68(ra) # 8000613c <release>
    return 0;
    80001100:	84ca                	mv	s1,s2
    80001102:	bff1                	j	800010de <allocproc+0x90>
    freeproc(p);
    80001104:	8526                	mv	a0,s1
    80001106:	00000097          	auipc	ra,0x0
    8000110a:	ef0080e7          	jalr	-272(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    8000110e:	8526                	mv	a0,s1
    80001110:	00005097          	auipc	ra,0x5
    80001114:	02c080e7          	jalr	44(ra) # 8000613c <release>
    return 0;
    80001118:	84ca                	mv	s1,s2
    8000111a:	b7d1                	j	800010de <allocproc+0x90>

000000008000111c <userinit>:
{
    8000111c:	1101                	addi	sp,sp,-32
    8000111e:	ec06                	sd	ra,24(sp)
    80001120:	e822                	sd	s0,16(sp)
    80001122:	e426                	sd	s1,8(sp)
    80001124:	1000                	addi	s0,sp,32
  p = allocproc();
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f28080e7          	jalr	-216(ra) # 8000104e <allocproc>
    8000112e:	84aa                	mv	s1,a0
  initproc = p;
    80001130:	00008797          	auipc	a5,0x8
    80001134:	eea7b023          	sd	a0,-288(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001138:	03400613          	li	a2,52
    8000113c:	00007597          	auipc	a1,0x7
    80001140:	70458593          	addi	a1,a1,1796 # 80008840 <initcode>
    80001144:	6928                	ld	a0,80(a0)
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	6b4080e7          	jalr	1716(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    8000114e:	6785                	lui	a5,0x1
    80001150:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001152:	6cb8                	ld	a4,88(s1)
    80001154:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001158:	6cb8                	ld	a4,88(s1)
    8000115a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000115c:	4641                	li	a2,16
    8000115e:	00007597          	auipc	a1,0x7
    80001162:	02258593          	addi	a1,a1,34 # 80008180 <etext+0x180>
    80001166:	15848513          	addi	a0,s1,344
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	15a080e7          	jalr	346(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001172:	00007517          	auipc	a0,0x7
    80001176:	01e50513          	addi	a0,a0,30 # 80008190 <etext+0x190>
    8000117a:	00002097          	auipc	ra,0x2
    8000117e:	11e080e7          	jalr	286(ra) # 80003298 <namei>
    80001182:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001186:	478d                	li	a5,3
    80001188:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00005097          	auipc	ra,0x5
    80001190:	fb0080e7          	jalr	-80(ra) # 8000613c <release>
}
    80001194:	60e2                	ld	ra,24(sp)
    80001196:	6442                	ld	s0,16(sp)
    80001198:	64a2                	ld	s1,8(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <growproc>:
{
    8000119e:	1101                	addi	sp,sp,-32
    800011a0:	ec06                	sd	ra,24(sp)
    800011a2:	e822                	sd	s0,16(sp)
    800011a4:	e426                	sd	s1,8(sp)
    800011a6:	e04a                	sd	s2,0(sp)
    800011a8:	1000                	addi	s0,sp,32
    800011aa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011ac:	00000097          	auipc	ra,0x0
    800011b0:	c98080e7          	jalr	-872(ra) # 80000e44 <myproc>
    800011b4:	892a                	mv	s2,a0
  sz = p->sz;
    800011b6:	652c                	ld	a1,72(a0)
    800011b8:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011bc:	00904f63          	bgtz	s1,800011da <growproc+0x3c>
  } else if(n < 0){
    800011c0:	0204cd63          	bltz	s1,800011fa <growproc+0x5c>
  p->sz = sz;
    800011c4:	1782                	slli	a5,a5,0x20
    800011c6:	9381                	srli	a5,a5,0x20
    800011c8:	04f93423          	sd	a5,72(s2)
  return 0;
    800011cc:	4501                	li	a0,0
}
    800011ce:	60e2                	ld	ra,24(sp)
    800011d0:	6442                	ld	s0,16(sp)
    800011d2:	64a2                	ld	s1,8(sp)
    800011d4:	6902                	ld	s2,0(sp)
    800011d6:	6105                	addi	sp,sp,32
    800011d8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011da:	00f4863b          	addw	a2,s1,a5
    800011de:	1602                	slli	a2,a2,0x20
    800011e0:	9201                	srli	a2,a2,0x20
    800011e2:	1582                	slli	a1,a1,0x20
    800011e4:	9181                	srli	a1,a1,0x20
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	6cc080e7          	jalr	1740(ra) # 800008b4 <uvmalloc>
    800011f0:	0005079b          	sext.w	a5,a0
    800011f4:	fbe1                	bnez	a5,800011c4 <growproc+0x26>
      return -1;
    800011f6:	557d                	li	a0,-1
    800011f8:	bfd9                	j	800011ce <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fa:	00f4863b          	addw	a2,s1,a5
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	664080e7          	jalr	1636(ra) # 8000086c <uvmdealloc>
    80001210:	0005079b          	sext.w	a5,a0
    80001214:	bf45                	j	800011c4 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7139                	addi	sp,sp,-64
    80001218:	fc06                	sd	ra,56(sp)
    8000121a:	f822                	sd	s0,48(sp)
    8000121c:	f426                	sd	s1,40(sp)
    8000121e:	f04a                	sd	s2,32(sp)
    80001220:	ec4e                	sd	s3,24(sp)
    80001222:	e852                	sd	s4,16(sp)
    80001224:	e456                	sd	s5,8(sp)
    80001226:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	c1c080e7          	jalr	-996(ra) # 80000e44 <myproc>
    80001230:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001232:	00000097          	auipc	ra,0x0
    80001236:	e1c080e7          	jalr	-484(ra) # 8000104e <allocproc>
    8000123a:	12050063          	beqz	a0,8000135a <fork+0x144>
    8000123e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001240:	048ab603          	ld	a2,72(s5)
    80001244:	692c                	ld	a1,80(a0)
    80001246:	050ab503          	ld	a0,80(s5)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	7ba080e7          	jalr	1978(ra) # 80000a04 <uvmcopy>
    80001252:	04054863          	bltz	a0,800012a2 <fork+0x8c>
  np->sz = p->sz;
    80001256:	048ab783          	ld	a5,72(s5)
    8000125a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000125e:	058ab683          	ld	a3,88(s5)
    80001262:	87b6                	mv	a5,a3
    80001264:	0589b703          	ld	a4,88(s3)
    80001268:	12068693          	addi	a3,a3,288
    8000126c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001270:	6788                	ld	a0,8(a5)
    80001272:	6b8c                	ld	a1,16(a5)
    80001274:	6f90                	ld	a2,24(a5)
    80001276:	01073023          	sd	a6,0(a4)
    8000127a:	e708                	sd	a0,8(a4)
    8000127c:	eb0c                	sd	a1,16(a4)
    8000127e:	ef10                	sd	a2,24(a4)
    80001280:	02078793          	addi	a5,a5,32
    80001284:	02070713          	addi	a4,a4,32
    80001288:	fed792e3          	bne	a5,a3,8000126c <fork+0x56>
  np->trapframe->a0 = 0;
    8000128c:	0589b783          	ld	a5,88(s3)
    80001290:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001294:	0d0a8493          	addi	s1,s5,208
    80001298:	0d098913          	addi	s2,s3,208
    8000129c:	150a8a13          	addi	s4,s5,336
    800012a0:	a00d                	j	800012c2 <fork+0xac>
    freeproc(np);
    800012a2:	854e                	mv	a0,s3
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	d52080e7          	jalr	-686(ra) # 80000ff6 <freeproc>
    release(&np->lock);
    800012ac:	854e                	mv	a0,s3
    800012ae:	00005097          	auipc	ra,0x5
    800012b2:	e8e080e7          	jalr	-370(ra) # 8000613c <release>
    return -1;
    800012b6:	597d                	li	s2,-1
    800012b8:	a079                	j	80001346 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800012ba:	04a1                	addi	s1,s1,8
    800012bc:	0921                	addi	s2,s2,8
    800012be:	01448b63          	beq	s1,s4,800012d4 <fork+0xbe>
    if(p->ofile[i])
    800012c2:	6088                	ld	a0,0(s1)
    800012c4:	d97d                	beqz	a0,800012ba <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c6:	00002097          	auipc	ra,0x2
    800012ca:	668080e7          	jalr	1640(ra) # 8000392e <filedup>
    800012ce:	00a93023          	sd	a0,0(s2)
    800012d2:	b7e5                	j	800012ba <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012d4:	150ab503          	ld	a0,336(s5)
    800012d8:	00001097          	auipc	ra,0x1
    800012dc:	7c6080e7          	jalr	1990(ra) # 80002a9e <idup>
    800012e0:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012e4:	4641                	li	a2,16
    800012e6:	158a8593          	addi	a1,s5,344
    800012ea:	15898513          	addi	a0,s3,344
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	fd6080e7          	jalr	-42(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800012f6:	0309a903          	lw	s2,48(s3)
  np->trace_mask = p->trace_mask;
    800012fa:	168aa783          	lw	a5,360(s5)
    800012fe:	16f9a423          	sw	a5,360(s3)
  release(&np->lock);
    80001302:	854e                	mv	a0,s3
    80001304:	00005097          	auipc	ra,0x5
    80001308:	e38080e7          	jalr	-456(ra) # 8000613c <release>
  acquire(&wait_lock);
    8000130c:	00008497          	auipc	s1,0x8
    80001310:	d5c48493          	addi	s1,s1,-676 # 80009068 <wait_lock>
    80001314:	8526                	mv	a0,s1
    80001316:	00005097          	auipc	ra,0x5
    8000131a:	d72080e7          	jalr	-654(ra) # 80006088 <acquire>
  np->parent = p;
    8000131e:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001322:	8526                	mv	a0,s1
    80001324:	00005097          	auipc	ra,0x5
    80001328:	e18080e7          	jalr	-488(ra) # 8000613c <release>
  acquire(&np->lock);
    8000132c:	854e                	mv	a0,s3
    8000132e:	00005097          	auipc	ra,0x5
    80001332:	d5a080e7          	jalr	-678(ra) # 80006088 <acquire>
  np->state = RUNNABLE;
    80001336:	478d                	li	a5,3
    80001338:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000133c:	854e                	mv	a0,s3
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	dfe080e7          	jalr	-514(ra) # 8000613c <release>
}
    80001346:	854a                	mv	a0,s2
    80001348:	70e2                	ld	ra,56(sp)
    8000134a:	7442                	ld	s0,48(sp)
    8000134c:	74a2                	ld	s1,40(sp)
    8000134e:	7902                	ld	s2,32(sp)
    80001350:	69e2                	ld	s3,24(sp)
    80001352:	6a42                	ld	s4,16(sp)
    80001354:	6aa2                	ld	s5,8(sp)
    80001356:	6121                	addi	sp,sp,64
    80001358:	8082                	ret
    return -1;
    8000135a:	597d                	li	s2,-1
    8000135c:	b7ed                	j	80001346 <fork+0x130>

000000008000135e <scheduler>:
{
    8000135e:	7139                	addi	sp,sp,-64
    80001360:	fc06                	sd	ra,56(sp)
    80001362:	f822                	sd	s0,48(sp)
    80001364:	f426                	sd	s1,40(sp)
    80001366:	f04a                	sd	s2,32(sp)
    80001368:	ec4e                	sd	s3,24(sp)
    8000136a:	e852                	sd	s4,16(sp)
    8000136c:	e456                	sd	s5,8(sp)
    8000136e:	e05a                	sd	s6,0(sp)
    80001370:	0080                	addi	s0,sp,64
    80001372:	8792                	mv	a5,tp
  int id = r_tp();
    80001374:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001376:	00779a93          	slli	s5,a5,0x7
    8000137a:	00008717          	auipc	a4,0x8
    8000137e:	cd670713          	addi	a4,a4,-810 # 80009050 <pid_lock>
    80001382:	9756                	add	a4,a4,s5
    80001384:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001388:	00008717          	auipc	a4,0x8
    8000138c:	d0070713          	addi	a4,a4,-768 # 80009088 <cpus+0x8>
    80001390:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001392:	498d                	li	s3,3
        p->state = RUNNING;
    80001394:	4b11                	li	s6,4
        c->proc = p;
    80001396:	079e                	slli	a5,a5,0x7
    80001398:	00008a17          	auipc	s4,0x8
    8000139c:	cb8a0a13          	addi	s4,s4,-840 # 80009050 <pid_lock>
    800013a0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013a2:	0000e917          	auipc	s2,0xe
    800013a6:	cde90913          	addi	s2,s2,-802 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013ae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013b2:	10079073          	csrw	sstatus,a5
    800013b6:	00008497          	auipc	s1,0x8
    800013ba:	0ca48493          	addi	s1,s1,202 # 80009480 <proc>
    800013be:	a811                	j	800013d2 <scheduler+0x74>
      release(&p->lock);
    800013c0:	8526                	mv	a0,s1
    800013c2:	00005097          	auipc	ra,0x5
    800013c6:	d7a080e7          	jalr	-646(ra) # 8000613c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ca:	17048493          	addi	s1,s1,368
    800013ce:	fd248ee3          	beq	s1,s2,800013aa <scheduler+0x4c>
      acquire(&p->lock);
    800013d2:	8526                	mv	a0,s1
    800013d4:	00005097          	auipc	ra,0x5
    800013d8:	cb4080e7          	jalr	-844(ra) # 80006088 <acquire>
      if(p->state == RUNNABLE) {
    800013dc:	4c9c                	lw	a5,24(s1)
    800013de:	ff3791e3          	bne	a5,s3,800013c0 <scheduler+0x62>
        p->state = RUNNING;
    800013e2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013e6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013ea:	06048593          	addi	a1,s1,96
    800013ee:	8556                	mv	a0,s5
    800013f0:	00000097          	auipc	ra,0x0
    800013f4:	620080e7          	jalr	1568(ra) # 80001a10 <swtch>
        c->proc = 0;
    800013f8:	020a3823          	sd	zero,48(s4)
    800013fc:	b7d1                	j	800013c0 <scheduler+0x62>

00000000800013fe <sched>:
{
    800013fe:	7179                	addi	sp,sp,-48
    80001400:	f406                	sd	ra,40(sp)
    80001402:	f022                	sd	s0,32(sp)
    80001404:	ec26                	sd	s1,24(sp)
    80001406:	e84a                	sd	s2,16(sp)
    80001408:	e44e                	sd	s3,8(sp)
    8000140a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	a38080e7          	jalr	-1480(ra) # 80000e44 <myproc>
    80001414:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001416:	00005097          	auipc	ra,0x5
    8000141a:	bf8080e7          	jalr	-1032(ra) # 8000600e <holding>
    8000141e:	c93d                	beqz	a0,80001494 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001420:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001422:	2781                	sext.w	a5,a5
    80001424:	079e                	slli	a5,a5,0x7
    80001426:	00008717          	auipc	a4,0x8
    8000142a:	c2a70713          	addi	a4,a4,-982 # 80009050 <pid_lock>
    8000142e:	97ba                	add	a5,a5,a4
    80001430:	0a87a703          	lw	a4,168(a5)
    80001434:	4785                	li	a5,1
    80001436:	06f71763          	bne	a4,a5,800014a4 <sched+0xa6>
  if(p->state == RUNNING)
    8000143a:	4c98                	lw	a4,24(s1)
    8000143c:	4791                	li	a5,4
    8000143e:	06f70b63          	beq	a4,a5,800014b4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001442:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001446:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001448:	efb5                	bnez	a5,800014c4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000144c:	00008917          	auipc	s2,0x8
    80001450:	c0490913          	addi	s2,s2,-1020 # 80009050 <pid_lock>
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	97ca                	add	a5,a5,s2
    8000145a:	0ac7a983          	lw	s3,172(a5)
    8000145e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001460:	2781                	sext.w	a5,a5
    80001462:	079e                	slli	a5,a5,0x7
    80001464:	00008597          	auipc	a1,0x8
    80001468:	c2458593          	addi	a1,a1,-988 # 80009088 <cpus+0x8>
    8000146c:	95be                	add	a1,a1,a5
    8000146e:	06048513          	addi	a0,s1,96
    80001472:	00000097          	auipc	ra,0x0
    80001476:	59e080e7          	jalr	1438(ra) # 80001a10 <swtch>
    8000147a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000147c:	2781                	sext.w	a5,a5
    8000147e:	079e                	slli	a5,a5,0x7
    80001480:	993e                	add	s2,s2,a5
    80001482:	0b392623          	sw	s3,172(s2)
}
    80001486:	70a2                	ld	ra,40(sp)
    80001488:	7402                	ld	s0,32(sp)
    8000148a:	64e2                	ld	s1,24(sp)
    8000148c:	6942                	ld	s2,16(sp)
    8000148e:	69a2                	ld	s3,8(sp)
    80001490:	6145                	addi	sp,sp,48
    80001492:	8082                	ret
    panic("sched p->lock");
    80001494:	00007517          	auipc	a0,0x7
    80001498:	d0450513          	addi	a0,a0,-764 # 80008198 <etext+0x198>
    8000149c:	00004097          	auipc	ra,0x4
    800014a0:	6b4080e7          	jalr	1716(ra) # 80005b50 <panic>
    panic("sched locks");
    800014a4:	00007517          	auipc	a0,0x7
    800014a8:	d0450513          	addi	a0,a0,-764 # 800081a8 <etext+0x1a8>
    800014ac:	00004097          	auipc	ra,0x4
    800014b0:	6a4080e7          	jalr	1700(ra) # 80005b50 <panic>
    panic("sched running");
    800014b4:	00007517          	auipc	a0,0x7
    800014b8:	d0450513          	addi	a0,a0,-764 # 800081b8 <etext+0x1b8>
    800014bc:	00004097          	auipc	ra,0x4
    800014c0:	694080e7          	jalr	1684(ra) # 80005b50 <panic>
    panic("sched interruptible");
    800014c4:	00007517          	auipc	a0,0x7
    800014c8:	d0450513          	addi	a0,a0,-764 # 800081c8 <etext+0x1c8>
    800014cc:	00004097          	auipc	ra,0x4
    800014d0:	684080e7          	jalr	1668(ra) # 80005b50 <panic>

00000000800014d4 <yield>:
{
    800014d4:	1101                	addi	sp,sp,-32
    800014d6:	ec06                	sd	ra,24(sp)
    800014d8:	e822                	sd	s0,16(sp)
    800014da:	e426                	sd	s1,8(sp)
    800014dc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	966080e7          	jalr	-1690(ra) # 80000e44 <myproc>
    800014e6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	ba0080e7          	jalr	-1120(ra) # 80006088 <acquire>
  p->state = RUNNABLE;
    800014f0:	478d                	li	a5,3
    800014f2:	cc9c                	sw	a5,24(s1)
  sched();
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	f0a080e7          	jalr	-246(ra) # 800013fe <sched>
  release(&p->lock);
    800014fc:	8526                	mv	a0,s1
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	c3e080e7          	jalr	-962(ra) # 8000613c <release>
}
    80001506:	60e2                	ld	ra,24(sp)
    80001508:	6442                	ld	s0,16(sp)
    8000150a:	64a2                	ld	s1,8(sp)
    8000150c:	6105                	addi	sp,sp,32
    8000150e:	8082                	ret

0000000080001510 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001510:	7179                	addi	sp,sp,-48
    80001512:	f406                	sd	ra,40(sp)
    80001514:	f022                	sd	s0,32(sp)
    80001516:	ec26                	sd	s1,24(sp)
    80001518:	e84a                	sd	s2,16(sp)
    8000151a:	e44e                	sd	s3,8(sp)
    8000151c:	1800                	addi	s0,sp,48
    8000151e:	89aa                	mv	s3,a0
    80001520:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001522:	00000097          	auipc	ra,0x0
    80001526:	922080e7          	jalr	-1758(ra) # 80000e44 <myproc>
    8000152a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	b5c080e7          	jalr	-1188(ra) # 80006088 <acquire>
  release(lk);
    80001534:	854a                	mv	a0,s2
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	c06080e7          	jalr	-1018(ra) # 8000613c <release>

  // Go to sleep.
  p->chan = chan;
    8000153e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001542:	4789                	li	a5,2
    80001544:	cc9c                	sw	a5,24(s1)

  sched();
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	eb8080e7          	jalr	-328(ra) # 800013fe <sched>

  // Tidy up.
  p->chan = 0;
    8000154e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001552:	8526                	mv	a0,s1
    80001554:	00005097          	auipc	ra,0x5
    80001558:	be8080e7          	jalr	-1048(ra) # 8000613c <release>
  acquire(lk);
    8000155c:	854a                	mv	a0,s2
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	b2a080e7          	jalr	-1238(ra) # 80006088 <acquire>
}
    80001566:	70a2                	ld	ra,40(sp)
    80001568:	7402                	ld	s0,32(sp)
    8000156a:	64e2                	ld	s1,24(sp)
    8000156c:	6942                	ld	s2,16(sp)
    8000156e:	69a2                	ld	s3,8(sp)
    80001570:	6145                	addi	sp,sp,48
    80001572:	8082                	ret

0000000080001574 <wait>:
{
    80001574:	715d                	addi	sp,sp,-80
    80001576:	e486                	sd	ra,72(sp)
    80001578:	e0a2                	sd	s0,64(sp)
    8000157a:	fc26                	sd	s1,56(sp)
    8000157c:	f84a                	sd	s2,48(sp)
    8000157e:	f44e                	sd	s3,40(sp)
    80001580:	f052                	sd	s4,32(sp)
    80001582:	ec56                	sd	s5,24(sp)
    80001584:	e85a                	sd	s6,16(sp)
    80001586:	e45e                	sd	s7,8(sp)
    80001588:	e062                	sd	s8,0(sp)
    8000158a:	0880                	addi	s0,sp,80
    8000158c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	8b6080e7          	jalr	-1866(ra) # 80000e44 <myproc>
    80001596:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001598:	00008517          	auipc	a0,0x8
    8000159c:	ad050513          	addi	a0,a0,-1328 # 80009068 <wait_lock>
    800015a0:	00005097          	auipc	ra,0x5
    800015a4:	ae8080e7          	jalr	-1304(ra) # 80006088 <acquire>
    havekids = 0;
    800015a8:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015aa:	4a15                	li	s4,5
        havekids = 1;
    800015ac:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015ae:	0000e997          	auipc	s3,0xe
    800015b2:	ad298993          	addi	s3,s3,-1326 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015b6:	00008c17          	auipc	s8,0x8
    800015ba:	ab2c0c13          	addi	s8,s8,-1358 # 80009068 <wait_lock>
    havekids = 0;
    800015be:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015c0:	00008497          	auipc	s1,0x8
    800015c4:	ec048493          	addi	s1,s1,-320 # 80009480 <proc>
    800015c8:	a0bd                	j	80001636 <wait+0xc2>
          pid = np->pid;
    800015ca:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015ce:	000b0e63          	beqz	s6,800015ea <wait+0x76>
    800015d2:	4691                	li	a3,4
    800015d4:	02c48613          	addi	a2,s1,44
    800015d8:	85da                	mv	a1,s6
    800015da:	05093503          	ld	a0,80(s2)
    800015de:	fffff097          	auipc	ra,0xfffff
    800015e2:	52a080e7          	jalr	1322(ra) # 80000b08 <copyout>
    800015e6:	02054563          	bltz	a0,80001610 <wait+0x9c>
          freeproc(np);
    800015ea:	8526                	mv	a0,s1
    800015ec:	00000097          	auipc	ra,0x0
    800015f0:	a0a080e7          	jalr	-1526(ra) # 80000ff6 <freeproc>
          release(&np->lock);
    800015f4:	8526                	mv	a0,s1
    800015f6:	00005097          	auipc	ra,0x5
    800015fa:	b46080e7          	jalr	-1210(ra) # 8000613c <release>
          release(&wait_lock);
    800015fe:	00008517          	auipc	a0,0x8
    80001602:	a6a50513          	addi	a0,a0,-1430 # 80009068 <wait_lock>
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	b36080e7          	jalr	-1226(ra) # 8000613c <release>
          return pid;
    8000160e:	a09d                	j	80001674 <wait+0x100>
            release(&np->lock);
    80001610:	8526                	mv	a0,s1
    80001612:	00005097          	auipc	ra,0x5
    80001616:	b2a080e7          	jalr	-1238(ra) # 8000613c <release>
            release(&wait_lock);
    8000161a:	00008517          	auipc	a0,0x8
    8000161e:	a4e50513          	addi	a0,a0,-1458 # 80009068 <wait_lock>
    80001622:	00005097          	auipc	ra,0x5
    80001626:	b1a080e7          	jalr	-1254(ra) # 8000613c <release>
            return -1;
    8000162a:	59fd                	li	s3,-1
    8000162c:	a0a1                	j	80001674 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000162e:	17048493          	addi	s1,s1,368
    80001632:	03348463          	beq	s1,s3,8000165a <wait+0xe6>
      if(np->parent == p){
    80001636:	7c9c                	ld	a5,56(s1)
    80001638:	ff279be3          	bne	a5,s2,8000162e <wait+0xba>
        acquire(&np->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	a4a080e7          	jalr	-1462(ra) # 80006088 <acquire>
        if(np->state == ZOMBIE){
    80001646:	4c9c                	lw	a5,24(s1)
    80001648:	f94781e3          	beq	a5,s4,800015ca <wait+0x56>
        release(&np->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	aee080e7          	jalr	-1298(ra) # 8000613c <release>
        havekids = 1;
    80001656:	8756                	mv	a4,s5
    80001658:	bfd9                	j	8000162e <wait+0xba>
    if(!havekids || p->killed){
    8000165a:	c701                	beqz	a4,80001662 <wait+0xee>
    8000165c:	02892783          	lw	a5,40(s2)
    80001660:	c79d                	beqz	a5,8000168e <wait+0x11a>
      release(&wait_lock);
    80001662:	00008517          	auipc	a0,0x8
    80001666:	a0650513          	addi	a0,a0,-1530 # 80009068 <wait_lock>
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	ad2080e7          	jalr	-1326(ra) # 8000613c <release>
      return -1;
    80001672:	59fd                	li	s3,-1
}
    80001674:	854e                	mv	a0,s3
    80001676:	60a6                	ld	ra,72(sp)
    80001678:	6406                	ld	s0,64(sp)
    8000167a:	74e2                	ld	s1,56(sp)
    8000167c:	7942                	ld	s2,48(sp)
    8000167e:	79a2                	ld	s3,40(sp)
    80001680:	7a02                	ld	s4,32(sp)
    80001682:	6ae2                	ld	s5,24(sp)
    80001684:	6b42                	ld	s6,16(sp)
    80001686:	6ba2                	ld	s7,8(sp)
    80001688:	6c02                	ld	s8,0(sp)
    8000168a:	6161                	addi	sp,sp,80
    8000168c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000168e:	85e2                	mv	a1,s8
    80001690:	854a                	mv	a0,s2
    80001692:	00000097          	auipc	ra,0x0
    80001696:	e7e080e7          	jalr	-386(ra) # 80001510 <sleep>
    havekids = 0;
    8000169a:	b715                	j	800015be <wait+0x4a>

000000008000169c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000169c:	7139                	addi	sp,sp,-64
    8000169e:	fc06                	sd	ra,56(sp)
    800016a0:	f822                	sd	s0,48(sp)
    800016a2:	f426                	sd	s1,40(sp)
    800016a4:	f04a                	sd	s2,32(sp)
    800016a6:	ec4e                	sd	s3,24(sp)
    800016a8:	e852                	sd	s4,16(sp)
    800016aa:	e456                	sd	s5,8(sp)
    800016ac:	0080                	addi	s0,sp,64
    800016ae:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016b0:	00008497          	auipc	s1,0x8
    800016b4:	dd048493          	addi	s1,s1,-560 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016b8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ba:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016bc:	0000e917          	auipc	s2,0xe
    800016c0:	9c490913          	addi	s2,s2,-1596 # 8000f080 <tickslock>
    800016c4:	a811                	j	800016d8 <wakeup+0x3c>
      }
      release(&p->lock);
    800016c6:	8526                	mv	a0,s1
    800016c8:	00005097          	auipc	ra,0x5
    800016cc:	a74080e7          	jalr	-1420(ra) # 8000613c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d0:	17048493          	addi	s1,s1,368
    800016d4:	03248663          	beq	s1,s2,80001700 <wakeup+0x64>
    if(p != myproc()){
    800016d8:	fffff097          	auipc	ra,0xfffff
    800016dc:	76c080e7          	jalr	1900(ra) # 80000e44 <myproc>
    800016e0:	fea488e3          	beq	s1,a0,800016d0 <wakeup+0x34>
      acquire(&p->lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	9a2080e7          	jalr	-1630(ra) # 80006088 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016ee:	4c9c                	lw	a5,24(s1)
    800016f0:	fd379be3          	bne	a5,s3,800016c6 <wakeup+0x2a>
    800016f4:	709c                	ld	a5,32(s1)
    800016f6:	fd4798e3          	bne	a5,s4,800016c6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016fa:	0154ac23          	sw	s5,24(s1)
    800016fe:	b7e1                	j	800016c6 <wakeup+0x2a>
    }
  }
}
    80001700:	70e2                	ld	ra,56(sp)
    80001702:	7442                	ld	s0,48(sp)
    80001704:	74a2                	ld	s1,40(sp)
    80001706:	7902                	ld	s2,32(sp)
    80001708:	69e2                	ld	s3,24(sp)
    8000170a:	6a42                	ld	s4,16(sp)
    8000170c:	6aa2                	ld	s5,8(sp)
    8000170e:	6121                	addi	sp,sp,64
    80001710:	8082                	ret

0000000080001712 <reparent>:
{
    80001712:	7179                	addi	sp,sp,-48
    80001714:	f406                	sd	ra,40(sp)
    80001716:	f022                	sd	s0,32(sp)
    80001718:	ec26                	sd	s1,24(sp)
    8000171a:	e84a                	sd	s2,16(sp)
    8000171c:	e44e                	sd	s3,8(sp)
    8000171e:	e052                	sd	s4,0(sp)
    80001720:	1800                	addi	s0,sp,48
    80001722:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001724:	00008497          	auipc	s1,0x8
    80001728:	d5c48493          	addi	s1,s1,-676 # 80009480 <proc>
      pp->parent = initproc;
    8000172c:	00008a17          	auipc	s4,0x8
    80001730:	8e4a0a13          	addi	s4,s4,-1820 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001734:	0000e997          	auipc	s3,0xe
    80001738:	94c98993          	addi	s3,s3,-1716 # 8000f080 <tickslock>
    8000173c:	a029                	j	80001746 <reparent+0x34>
    8000173e:	17048493          	addi	s1,s1,368
    80001742:	01348d63          	beq	s1,s3,8000175c <reparent+0x4a>
    if(pp->parent == p){
    80001746:	7c9c                	ld	a5,56(s1)
    80001748:	ff279be3          	bne	a5,s2,8000173e <reparent+0x2c>
      pp->parent = initproc;
    8000174c:	000a3503          	ld	a0,0(s4)
    80001750:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001752:	00000097          	auipc	ra,0x0
    80001756:	f4a080e7          	jalr	-182(ra) # 8000169c <wakeup>
    8000175a:	b7d5                	j	8000173e <reparent+0x2c>
}
    8000175c:	70a2                	ld	ra,40(sp)
    8000175e:	7402                	ld	s0,32(sp)
    80001760:	64e2                	ld	s1,24(sp)
    80001762:	6942                	ld	s2,16(sp)
    80001764:	69a2                	ld	s3,8(sp)
    80001766:	6a02                	ld	s4,0(sp)
    80001768:	6145                	addi	sp,sp,48
    8000176a:	8082                	ret

000000008000176c <exit>:
{
    8000176c:	7179                	addi	sp,sp,-48
    8000176e:	f406                	sd	ra,40(sp)
    80001770:	f022                	sd	s0,32(sp)
    80001772:	ec26                	sd	s1,24(sp)
    80001774:	e84a                	sd	s2,16(sp)
    80001776:	e44e                	sd	s3,8(sp)
    80001778:	e052                	sd	s4,0(sp)
    8000177a:	1800                	addi	s0,sp,48
    8000177c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000177e:	fffff097          	auipc	ra,0xfffff
    80001782:	6c6080e7          	jalr	1734(ra) # 80000e44 <myproc>
    80001786:	89aa                	mv	s3,a0
  if(p == initproc)
    80001788:	00008797          	auipc	a5,0x8
    8000178c:	8887b783          	ld	a5,-1912(a5) # 80009010 <initproc>
    80001790:	0d050493          	addi	s1,a0,208
    80001794:	15050913          	addi	s2,a0,336
    80001798:	02a79363          	bne	a5,a0,800017be <exit+0x52>
    panic("init exiting");
    8000179c:	00007517          	auipc	a0,0x7
    800017a0:	a4450513          	addi	a0,a0,-1468 # 800081e0 <etext+0x1e0>
    800017a4:	00004097          	auipc	ra,0x4
    800017a8:	3ac080e7          	jalr	940(ra) # 80005b50 <panic>
      fileclose(f);
    800017ac:	00002097          	auipc	ra,0x2
    800017b0:	1d4080e7          	jalr	468(ra) # 80003980 <fileclose>
      p->ofile[fd] = 0;
    800017b4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017b8:	04a1                	addi	s1,s1,8
    800017ba:	01248563          	beq	s1,s2,800017c4 <exit+0x58>
    if(p->ofile[fd]){
    800017be:	6088                	ld	a0,0(s1)
    800017c0:	f575                	bnez	a0,800017ac <exit+0x40>
    800017c2:	bfdd                	j	800017b8 <exit+0x4c>
  begin_op();
    800017c4:	00002097          	auipc	ra,0x2
    800017c8:	cf4080e7          	jalr	-780(ra) # 800034b8 <begin_op>
  iput(p->cwd);
    800017cc:	1509b503          	ld	a0,336(s3)
    800017d0:	00001097          	auipc	ra,0x1
    800017d4:	4c6080e7          	jalr	1222(ra) # 80002c96 <iput>
  end_op();
    800017d8:	00002097          	auipc	ra,0x2
    800017dc:	d5e080e7          	jalr	-674(ra) # 80003536 <end_op>
  p->cwd = 0;
    800017e0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017e4:	00008497          	auipc	s1,0x8
    800017e8:	88448493          	addi	s1,s1,-1916 # 80009068 <wait_lock>
    800017ec:	8526                	mv	a0,s1
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	89a080e7          	jalr	-1894(ra) # 80006088 <acquire>
  reparent(p);
    800017f6:	854e                	mv	a0,s3
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	f1a080e7          	jalr	-230(ra) # 80001712 <reparent>
  wakeup(p->parent);
    80001800:	0389b503          	ld	a0,56(s3)
    80001804:	00000097          	auipc	ra,0x0
    80001808:	e98080e7          	jalr	-360(ra) # 8000169c <wakeup>
  acquire(&p->lock);
    8000180c:	854e                	mv	a0,s3
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	87a080e7          	jalr	-1926(ra) # 80006088 <acquire>
  p->xstate = status;
    80001816:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000181a:	4795                	li	a5,5
    8000181c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001820:	8526                	mv	a0,s1
    80001822:	00005097          	auipc	ra,0x5
    80001826:	91a080e7          	jalr	-1766(ra) # 8000613c <release>
  sched();
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	bd4080e7          	jalr	-1068(ra) # 800013fe <sched>
  panic("zombie exit");
    80001832:	00007517          	auipc	a0,0x7
    80001836:	9be50513          	addi	a0,a0,-1602 # 800081f0 <etext+0x1f0>
    8000183a:	00004097          	auipc	ra,0x4
    8000183e:	316080e7          	jalr	790(ra) # 80005b50 <panic>

0000000080001842 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001842:	7179                	addi	sp,sp,-48
    80001844:	f406                	sd	ra,40(sp)
    80001846:	f022                	sd	s0,32(sp)
    80001848:	ec26                	sd	s1,24(sp)
    8000184a:	e84a                	sd	s2,16(sp)
    8000184c:	e44e                	sd	s3,8(sp)
    8000184e:	1800                	addi	s0,sp,48
    80001850:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001852:	00008497          	auipc	s1,0x8
    80001856:	c2e48493          	addi	s1,s1,-978 # 80009480 <proc>
    8000185a:	0000e997          	auipc	s3,0xe
    8000185e:	82698993          	addi	s3,s3,-2010 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	824080e7          	jalr	-2012(ra) # 80006088 <acquire>
    if(p->pid == pid){
    8000186c:	589c                	lw	a5,48(s1)
    8000186e:	01278d63          	beq	a5,s2,80001888 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	8c8080e7          	jalr	-1848(ra) # 8000613c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000187c:	17048493          	addi	s1,s1,368
    80001880:	ff3491e3          	bne	s1,s3,80001862 <kill+0x20>
  }
  return -1;
    80001884:	557d                	li	a0,-1
    80001886:	a829                	j	800018a0 <kill+0x5e>
      p->killed = 1;
    80001888:	4785                	li	a5,1
    8000188a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000188c:	4c98                	lw	a4,24(s1)
    8000188e:	4789                	li	a5,2
    80001890:	00f70f63          	beq	a4,a5,800018ae <kill+0x6c>
      release(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	8a6080e7          	jalr	-1882(ra) # 8000613c <release>
      return 0;
    8000189e:	4501                	li	a0,0
}
    800018a0:	70a2                	ld	ra,40(sp)
    800018a2:	7402                	ld	s0,32(sp)
    800018a4:	64e2                	ld	s1,24(sp)
    800018a6:	6942                	ld	s2,16(sp)
    800018a8:	69a2                	ld	s3,8(sp)
    800018aa:	6145                	addi	sp,sp,48
    800018ac:	8082                	ret
        p->state = RUNNABLE;
    800018ae:	478d                	li	a5,3
    800018b0:	cc9c                	sw	a5,24(s1)
    800018b2:	b7cd                	j	80001894 <kill+0x52>

00000000800018b4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018b4:	7179                	addi	sp,sp,-48
    800018b6:	f406                	sd	ra,40(sp)
    800018b8:	f022                	sd	s0,32(sp)
    800018ba:	ec26                	sd	s1,24(sp)
    800018bc:	e84a                	sd	s2,16(sp)
    800018be:	e44e                	sd	s3,8(sp)
    800018c0:	e052                	sd	s4,0(sp)
    800018c2:	1800                	addi	s0,sp,48
    800018c4:	84aa                	mv	s1,a0
    800018c6:	892e                	mv	s2,a1
    800018c8:	89b2                	mv	s3,a2
    800018ca:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018cc:	fffff097          	auipc	ra,0xfffff
    800018d0:	578080e7          	jalr	1400(ra) # 80000e44 <myproc>
  if(user_dst){
    800018d4:	c08d                	beqz	s1,800018f6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018d6:	86d2                	mv	a3,s4
    800018d8:	864e                	mv	a2,s3
    800018da:	85ca                	mv	a1,s2
    800018dc:	6928                	ld	a0,80(a0)
    800018de:	fffff097          	auipc	ra,0xfffff
    800018e2:	22a080e7          	jalr	554(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018e6:	70a2                	ld	ra,40(sp)
    800018e8:	7402                	ld	s0,32(sp)
    800018ea:	64e2                	ld	s1,24(sp)
    800018ec:	6942                	ld	s2,16(sp)
    800018ee:	69a2                	ld	s3,8(sp)
    800018f0:	6a02                	ld	s4,0(sp)
    800018f2:	6145                	addi	sp,sp,48
    800018f4:	8082                	ret
    memmove((char *)dst, src, len);
    800018f6:	000a061b          	sext.w	a2,s4
    800018fa:	85ce                	mv	a1,s3
    800018fc:	854a                	mv	a0,s2
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	8d8080e7          	jalr	-1832(ra) # 800001d6 <memmove>
    return 0;
    80001906:	8526                	mv	a0,s1
    80001908:	bff9                	j	800018e6 <either_copyout+0x32>

000000008000190a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000190a:	7179                	addi	sp,sp,-48
    8000190c:	f406                	sd	ra,40(sp)
    8000190e:	f022                	sd	s0,32(sp)
    80001910:	ec26                	sd	s1,24(sp)
    80001912:	e84a                	sd	s2,16(sp)
    80001914:	e44e                	sd	s3,8(sp)
    80001916:	e052                	sd	s4,0(sp)
    80001918:	1800                	addi	s0,sp,48
    8000191a:	892a                	mv	s2,a0
    8000191c:	84ae                	mv	s1,a1
    8000191e:	89b2                	mv	s3,a2
    80001920:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001922:	fffff097          	auipc	ra,0xfffff
    80001926:	522080e7          	jalr	1314(ra) # 80000e44 <myproc>
  if(user_src){
    8000192a:	c08d                	beqz	s1,8000194c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000192c:	86d2                	mv	a3,s4
    8000192e:	864e                	mv	a2,s3
    80001930:	85ca                	mv	a1,s2
    80001932:	6928                	ld	a0,80(a0)
    80001934:	fffff097          	auipc	ra,0xfffff
    80001938:	260080e7          	jalr	608(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000193c:	70a2                	ld	ra,40(sp)
    8000193e:	7402                	ld	s0,32(sp)
    80001940:	64e2                	ld	s1,24(sp)
    80001942:	6942                	ld	s2,16(sp)
    80001944:	69a2                	ld	s3,8(sp)
    80001946:	6a02                	ld	s4,0(sp)
    80001948:	6145                	addi	sp,sp,48
    8000194a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000194c:	000a061b          	sext.w	a2,s4
    80001950:	85ce                	mv	a1,s3
    80001952:	854a                	mv	a0,s2
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	882080e7          	jalr	-1918(ra) # 800001d6 <memmove>
    return 0;
    8000195c:	8526                	mv	a0,s1
    8000195e:	bff9                	j	8000193c <either_copyin+0x32>

0000000080001960 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001960:	715d                	addi	sp,sp,-80
    80001962:	e486                	sd	ra,72(sp)
    80001964:	e0a2                	sd	s0,64(sp)
    80001966:	fc26                	sd	s1,56(sp)
    80001968:	f84a                	sd	s2,48(sp)
    8000196a:	f44e                	sd	s3,40(sp)
    8000196c:	f052                	sd	s4,32(sp)
    8000196e:	ec56                	sd	s5,24(sp)
    80001970:	e85a                	sd	s6,16(sp)
    80001972:	e45e                	sd	s7,8(sp)
    80001974:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001976:	00006517          	auipc	a0,0x6
    8000197a:	6d250513          	addi	a0,a0,1746 # 80008048 <etext+0x48>
    8000197e:	00004097          	auipc	ra,0x4
    80001982:	21c080e7          	jalr	540(ra) # 80005b9a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001986:	00008497          	auipc	s1,0x8
    8000198a:	c5248493          	addi	s1,s1,-942 # 800095d8 <proc+0x158>
    8000198e:	0000e917          	auipc	s2,0xe
    80001992:	84a90913          	addi	s2,s2,-1974 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001996:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001998:	00007997          	auipc	s3,0x7
    8000199c:	86898993          	addi	s3,s3,-1944 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019a0:	00007a97          	auipc	s5,0x7
    800019a4:	868a8a93          	addi	s5,s5,-1944 # 80008208 <etext+0x208>
    printf("\n");
    800019a8:	00006a17          	auipc	s4,0x6
    800019ac:	6a0a0a13          	addi	s4,s4,1696 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019b0:	00007b97          	auipc	s7,0x7
    800019b4:	890b8b93          	addi	s7,s7,-1904 # 80008240 <states.0>
    800019b8:	a00d                	j	800019da <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ba:	ed86a583          	lw	a1,-296(a3)
    800019be:	8556                	mv	a0,s5
    800019c0:	00004097          	auipc	ra,0x4
    800019c4:	1da080e7          	jalr	474(ra) # 80005b9a <printf>
    printf("\n");
    800019c8:	8552                	mv	a0,s4
    800019ca:	00004097          	auipc	ra,0x4
    800019ce:	1d0080e7          	jalr	464(ra) # 80005b9a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d2:	17048493          	addi	s1,s1,368
    800019d6:	03248263          	beq	s1,s2,800019fa <procdump+0x9a>
    if(p->state == UNUSED)
    800019da:	86a6                	mv	a3,s1
    800019dc:	ec04a783          	lw	a5,-320(s1)
    800019e0:	dbed                	beqz	a5,800019d2 <procdump+0x72>
      state = "???";
    800019e2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e4:	fcfb6be3          	bltu	s6,a5,800019ba <procdump+0x5a>
    800019e8:	02079713          	slli	a4,a5,0x20
    800019ec:	01d75793          	srli	a5,a4,0x1d
    800019f0:	97de                	add	a5,a5,s7
    800019f2:	6390                	ld	a2,0(a5)
    800019f4:	f279                	bnez	a2,800019ba <procdump+0x5a>
      state = "???";
    800019f6:	864e                	mv	a2,s3
    800019f8:	b7c9                	j	800019ba <procdump+0x5a>
  }
}
    800019fa:	60a6                	ld	ra,72(sp)
    800019fc:	6406                	ld	s0,64(sp)
    800019fe:	74e2                	ld	s1,56(sp)
    80001a00:	7942                	ld	s2,48(sp)
    80001a02:	79a2                	ld	s3,40(sp)
    80001a04:	7a02                	ld	s4,32(sp)
    80001a06:	6ae2                	ld	s5,24(sp)
    80001a08:	6b42                	ld	s6,16(sp)
    80001a0a:	6ba2                	ld	s7,8(sp)
    80001a0c:	6161                	addi	sp,sp,80
    80001a0e:	8082                	ret

0000000080001a10 <swtch>:
    80001a10:	00153023          	sd	ra,0(a0)
    80001a14:	00253423          	sd	sp,8(a0)
    80001a18:	e900                	sd	s0,16(a0)
    80001a1a:	ed04                	sd	s1,24(a0)
    80001a1c:	03253023          	sd	s2,32(a0)
    80001a20:	03353423          	sd	s3,40(a0)
    80001a24:	03453823          	sd	s4,48(a0)
    80001a28:	03553c23          	sd	s5,56(a0)
    80001a2c:	05653023          	sd	s6,64(a0)
    80001a30:	05753423          	sd	s7,72(a0)
    80001a34:	05853823          	sd	s8,80(a0)
    80001a38:	05953c23          	sd	s9,88(a0)
    80001a3c:	07a53023          	sd	s10,96(a0)
    80001a40:	07b53423          	sd	s11,104(a0)
    80001a44:	0005b083          	ld	ra,0(a1)
    80001a48:	0085b103          	ld	sp,8(a1)
    80001a4c:	6980                	ld	s0,16(a1)
    80001a4e:	6d84                	ld	s1,24(a1)
    80001a50:	0205b903          	ld	s2,32(a1)
    80001a54:	0285b983          	ld	s3,40(a1)
    80001a58:	0305ba03          	ld	s4,48(a1)
    80001a5c:	0385ba83          	ld	s5,56(a1)
    80001a60:	0405bb03          	ld	s6,64(a1)
    80001a64:	0485bb83          	ld	s7,72(a1)
    80001a68:	0505bc03          	ld	s8,80(a1)
    80001a6c:	0585bc83          	ld	s9,88(a1)
    80001a70:	0605bd03          	ld	s10,96(a1)
    80001a74:	0685bd83          	ld	s11,104(a1)
    80001a78:	8082                	ret

0000000080001a7a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a7a:	1141                	addi	sp,sp,-16
    80001a7c:	e406                	sd	ra,8(sp)
    80001a7e:	e022                	sd	s0,0(sp)
    80001a80:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a82:	00006597          	auipc	a1,0x6
    80001a86:	7ee58593          	addi	a1,a1,2030 # 80008270 <states.0+0x30>
    80001a8a:	0000d517          	auipc	a0,0xd
    80001a8e:	5f650513          	addi	a0,a0,1526 # 8000f080 <tickslock>
    80001a92:	00004097          	auipc	ra,0x4
    80001a96:	566080e7          	jalr	1382(ra) # 80005ff8 <initlock>
}
    80001a9a:	60a2                	ld	ra,8(sp)
    80001a9c:	6402                	ld	s0,0(sp)
    80001a9e:	0141                	addi	sp,sp,16
    80001aa0:	8082                	ret

0000000080001aa2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aa2:	1141                	addi	sp,sp,-16
    80001aa4:	e422                	sd	s0,8(sp)
    80001aa6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa8:	00003797          	auipc	a5,0x3
    80001aac:	50878793          	addi	a5,a5,1288 # 80004fb0 <kernelvec>
    80001ab0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ab4:	6422                	ld	s0,8(sp)
    80001ab6:	0141                	addi	sp,sp,16
    80001ab8:	8082                	ret

0000000080001aba <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aba:	1141                	addi	sp,sp,-16
    80001abc:	e406                	sd	ra,8(sp)
    80001abe:	e022                	sd	s0,0(sp)
    80001ac0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ac2:	fffff097          	auipc	ra,0xfffff
    80001ac6:	382080e7          	jalr	898(ra) # 80000e44 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ace:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ad4:	00005697          	auipc	a3,0x5
    80001ad8:	52c68693          	addi	a3,a3,1324 # 80007000 <_trampoline>
    80001adc:	00005717          	auipc	a4,0x5
    80001ae0:	52470713          	addi	a4,a4,1316 # 80007000 <_trampoline>
    80001ae4:	8f15                	sub	a4,a4,a3
    80001ae6:	040007b7          	lui	a5,0x4000
    80001aea:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001aec:	07b2                	slli	a5,a5,0xc
    80001aee:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af0:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001af4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001af6:	18002673          	csrr	a2,satp
    80001afa:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001afc:	6d30                	ld	a2,88(a0)
    80001afe:	6138                	ld	a4,64(a0)
    80001b00:	6585                	lui	a1,0x1
    80001b02:	972e                	add	a4,a4,a1
    80001b04:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b06:	6d38                	ld	a4,88(a0)
    80001b08:	00000617          	auipc	a2,0x0
    80001b0c:	13860613          	addi	a2,a2,312 # 80001c40 <usertrap>
    80001b10:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b12:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b14:	8612                	mv	a2,tp
    80001b16:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b18:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b1c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b20:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b24:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b28:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b2a:	6f18                	ld	a4,24(a4)
    80001b2c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b30:	692c                	ld	a1,80(a0)
    80001b32:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b34:	00005717          	auipc	a4,0x5
    80001b38:	55c70713          	addi	a4,a4,1372 # 80007090 <userret>
    80001b3c:	8f15                	sub	a4,a4,a3
    80001b3e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b40:	577d                	li	a4,-1
    80001b42:	177e                	slli	a4,a4,0x3f
    80001b44:	8dd9                	or	a1,a1,a4
    80001b46:	02000537          	lui	a0,0x2000
    80001b4a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b4c:	0536                	slli	a0,a0,0xd
    80001b4e:	9782                	jalr	a5
}
    80001b50:	60a2                	ld	ra,8(sp)
    80001b52:	6402                	ld	s0,0(sp)
    80001b54:	0141                	addi	sp,sp,16
    80001b56:	8082                	ret

0000000080001b58 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b58:	1101                	addi	sp,sp,-32
    80001b5a:	ec06                	sd	ra,24(sp)
    80001b5c:	e822                	sd	s0,16(sp)
    80001b5e:	e426                	sd	s1,8(sp)
    80001b60:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b62:	0000d497          	auipc	s1,0xd
    80001b66:	51e48493          	addi	s1,s1,1310 # 8000f080 <tickslock>
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	00004097          	auipc	ra,0x4
    80001b70:	51c080e7          	jalr	1308(ra) # 80006088 <acquire>
  ticks++;
    80001b74:	00007517          	auipc	a0,0x7
    80001b78:	4a450513          	addi	a0,a0,1188 # 80009018 <ticks>
    80001b7c:	411c                	lw	a5,0(a0)
    80001b7e:	2785                	addiw	a5,a5,1
    80001b80:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b82:	00000097          	auipc	ra,0x0
    80001b86:	b1a080e7          	jalr	-1254(ra) # 8000169c <wakeup>
  release(&tickslock);
    80001b8a:	8526                	mv	a0,s1
    80001b8c:	00004097          	auipc	ra,0x4
    80001b90:	5b0080e7          	jalr	1456(ra) # 8000613c <release>
}
    80001b94:	60e2                	ld	ra,24(sp)
    80001b96:	6442                	ld	s0,16(sp)
    80001b98:	64a2                	ld	s1,8(sp)
    80001b9a:	6105                	addi	sp,sp,32
    80001b9c:	8082                	ret

0000000080001b9e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bac:	00074d63          	bltz	a4,80001bc6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bb0:	57fd                	li	a5,-1
    80001bb2:	17fe                	slli	a5,a5,0x3f
    80001bb4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bb6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bb8:	06f70363          	beq	a4,a5,80001c1e <devintr+0x80>
  }
}
    80001bbc:	60e2                	ld	ra,24(sp)
    80001bbe:	6442                	ld	s0,16(sp)
    80001bc0:	64a2                	ld	s1,8(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret
     (scause & 0xff) == 9){
    80001bc6:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001bca:	46a5                	li	a3,9
    80001bcc:	fed792e3          	bne	a5,a3,80001bb0 <devintr+0x12>
    int irq = plic_claim();
    80001bd0:	00003097          	auipc	ra,0x3
    80001bd4:	4e8080e7          	jalr	1256(ra) # 800050b8 <plic_claim>
    80001bd8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bda:	47a9                	li	a5,10
    80001bdc:	02f50763          	beq	a0,a5,80001c0a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001be0:	4785                	li	a5,1
    80001be2:	02f50963          	beq	a0,a5,80001c14 <devintr+0x76>
    return 1;
    80001be6:	4505                	li	a0,1
    } else if(irq){
    80001be8:	d8f1                	beqz	s1,80001bbc <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bea:	85a6                	mv	a1,s1
    80001bec:	00006517          	auipc	a0,0x6
    80001bf0:	68c50513          	addi	a0,a0,1676 # 80008278 <states.0+0x38>
    80001bf4:	00004097          	auipc	ra,0x4
    80001bf8:	fa6080e7          	jalr	-90(ra) # 80005b9a <printf>
      plic_complete(irq);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	00003097          	auipc	ra,0x3
    80001c02:	4de080e7          	jalr	1246(ra) # 800050dc <plic_complete>
    return 1;
    80001c06:	4505                	li	a0,1
    80001c08:	bf55                	j	80001bbc <devintr+0x1e>
      uartintr();
    80001c0a:	00004097          	auipc	ra,0x4
    80001c0e:	39e080e7          	jalr	926(ra) # 80005fa8 <uartintr>
    80001c12:	b7ed                	j	80001bfc <devintr+0x5e>
      virtio_disk_intr();
    80001c14:	00004097          	auipc	ra,0x4
    80001c18:	954080e7          	jalr	-1708(ra) # 80005568 <virtio_disk_intr>
    80001c1c:	b7c5                	j	80001bfc <devintr+0x5e>
    if(cpuid() == 0){
    80001c1e:	fffff097          	auipc	ra,0xfffff
    80001c22:	1fa080e7          	jalr	506(ra) # 80000e18 <cpuid>
    80001c26:	c901                	beqz	a0,80001c36 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c28:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c2c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c2e:	14479073          	csrw	sip,a5
    return 2;
    80001c32:	4509                	li	a0,2
    80001c34:	b761                	j	80001bbc <devintr+0x1e>
      clockintr();
    80001c36:	00000097          	auipc	ra,0x0
    80001c3a:	f22080e7          	jalr	-222(ra) # 80001b58 <clockintr>
    80001c3e:	b7ed                	j	80001c28 <devintr+0x8a>

0000000080001c40 <usertrap>:
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	e04a                	sd	s2,0(sp)
    80001c4a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c4c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c50:	1007f793          	andi	a5,a5,256
    80001c54:	e3ad                	bnez	a5,80001cb6 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c56:	00003797          	auipc	a5,0x3
    80001c5a:	35a78793          	addi	a5,a5,858 # 80004fb0 <kernelvec>
    80001c5e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	1e2080e7          	jalr	482(ra) # 80000e44 <myproc>
    80001c6a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c6c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c6e:	14102773          	csrr	a4,sepc
    80001c72:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c74:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c78:	47a1                	li	a5,8
    80001c7a:	04f71c63          	bne	a4,a5,80001cd2 <usertrap+0x92>
    if(p->killed)
    80001c7e:	551c                	lw	a5,40(a0)
    80001c80:	e3b9                	bnez	a5,80001cc6 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c82:	6cb8                	ld	a4,88(s1)
    80001c84:	6f1c                	ld	a5,24(a4)
    80001c86:	0791                	addi	a5,a5,4
    80001c88:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c8e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c92:	10079073          	csrw	sstatus,a5
    syscall();
    80001c96:	00000097          	auipc	ra,0x0
    80001c9a:	2e0080e7          	jalr	736(ra) # 80001f76 <syscall>
  if(p->killed)
    80001c9e:	549c                	lw	a5,40(s1)
    80001ca0:	ebc1                	bnez	a5,80001d30 <usertrap+0xf0>
  usertrapret();
    80001ca2:	00000097          	auipc	ra,0x0
    80001ca6:	e18080e7          	jalr	-488(ra) # 80001aba <usertrapret>
}
    80001caa:	60e2                	ld	ra,24(sp)
    80001cac:	6442                	ld	s0,16(sp)
    80001cae:	64a2                	ld	s1,8(sp)
    80001cb0:	6902                	ld	s2,0(sp)
    80001cb2:	6105                	addi	sp,sp,32
    80001cb4:	8082                	ret
    panic("usertrap: not from user mode");
    80001cb6:	00006517          	auipc	a0,0x6
    80001cba:	5e250513          	addi	a0,a0,1506 # 80008298 <states.0+0x58>
    80001cbe:	00004097          	auipc	ra,0x4
    80001cc2:	e92080e7          	jalr	-366(ra) # 80005b50 <panic>
      exit(-1);
    80001cc6:	557d                	li	a0,-1
    80001cc8:	00000097          	auipc	ra,0x0
    80001ccc:	aa4080e7          	jalr	-1372(ra) # 8000176c <exit>
    80001cd0:	bf4d                	j	80001c82 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	ecc080e7          	jalr	-308(ra) # 80001b9e <devintr>
    80001cda:	892a                	mv	s2,a0
    80001cdc:	c501                	beqz	a0,80001ce4 <usertrap+0xa4>
  if(p->killed)
    80001cde:	549c                	lw	a5,40(s1)
    80001ce0:	c3a1                	beqz	a5,80001d20 <usertrap+0xe0>
    80001ce2:	a815                	j	80001d16 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ce4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ce8:	5890                	lw	a2,48(s1)
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	5ce50513          	addi	a0,a0,1486 # 800082b8 <states.0+0x78>
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	ea8080e7          	jalr	-344(ra) # 80005b9a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cfa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cfe:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d02:	00006517          	auipc	a0,0x6
    80001d06:	5e650513          	addi	a0,a0,1510 # 800082e8 <states.0+0xa8>
    80001d0a:	00004097          	auipc	ra,0x4
    80001d0e:	e90080e7          	jalr	-368(ra) # 80005b9a <printf>
    p->killed = 1;
    80001d12:	4785                	li	a5,1
    80001d14:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d16:	557d                	li	a0,-1
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	a54080e7          	jalr	-1452(ra) # 8000176c <exit>
  if(which_dev == 2)
    80001d20:	4789                	li	a5,2
    80001d22:	f8f910e3          	bne	s2,a5,80001ca2 <usertrap+0x62>
    yield();
    80001d26:	fffff097          	auipc	ra,0xfffff
    80001d2a:	7ae080e7          	jalr	1966(ra) # 800014d4 <yield>
    80001d2e:	bf95                	j	80001ca2 <usertrap+0x62>
  int which_dev = 0;
    80001d30:	4901                	li	s2,0
    80001d32:	b7d5                	j	80001d16 <usertrap+0xd6>

0000000080001d34 <kerneltrap>:
{
    80001d34:	7179                	addi	sp,sp,-48
    80001d36:	f406                	sd	ra,40(sp)
    80001d38:	f022                	sd	s0,32(sp)
    80001d3a:	ec26                	sd	s1,24(sp)
    80001d3c:	e84a                	sd	s2,16(sp)
    80001d3e:	e44e                	sd	s3,8(sp)
    80001d40:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d42:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d46:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d4a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d4e:	1004f793          	andi	a5,s1,256
    80001d52:	cb85                	beqz	a5,80001d82 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d54:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d58:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d5a:	ef85                	bnez	a5,80001d92 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	e42080e7          	jalr	-446(ra) # 80001b9e <devintr>
    80001d64:	cd1d                	beqz	a0,80001da2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d66:	4789                	li	a5,2
    80001d68:	06f50a63          	beq	a0,a5,80001ddc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d6c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d70:	10049073          	csrw	sstatus,s1
}
    80001d74:	70a2                	ld	ra,40(sp)
    80001d76:	7402                	ld	s0,32(sp)
    80001d78:	64e2                	ld	s1,24(sp)
    80001d7a:	6942                	ld	s2,16(sp)
    80001d7c:	69a2                	ld	s3,8(sp)
    80001d7e:	6145                	addi	sp,sp,48
    80001d80:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d82:	00006517          	auipc	a0,0x6
    80001d86:	58650513          	addi	a0,a0,1414 # 80008308 <states.0+0xc8>
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	dc6080e7          	jalr	-570(ra) # 80005b50 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d92:	00006517          	auipc	a0,0x6
    80001d96:	59e50513          	addi	a0,a0,1438 # 80008330 <states.0+0xf0>
    80001d9a:	00004097          	auipc	ra,0x4
    80001d9e:	db6080e7          	jalr	-586(ra) # 80005b50 <panic>
    printf("scause %p\n", scause);
    80001da2:	85ce                	mv	a1,s3
    80001da4:	00006517          	auipc	a0,0x6
    80001da8:	5ac50513          	addi	a0,a0,1452 # 80008350 <states.0+0x110>
    80001dac:	00004097          	auipc	ra,0x4
    80001db0:	dee080e7          	jalr	-530(ra) # 80005b9a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001db8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dbc:	00006517          	auipc	a0,0x6
    80001dc0:	5a450513          	addi	a0,a0,1444 # 80008360 <states.0+0x120>
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	dd6080e7          	jalr	-554(ra) # 80005b9a <printf>
    panic("kerneltrap");
    80001dcc:	00006517          	auipc	a0,0x6
    80001dd0:	5ac50513          	addi	a0,a0,1452 # 80008378 <states.0+0x138>
    80001dd4:	00004097          	auipc	ra,0x4
    80001dd8:	d7c080e7          	jalr	-644(ra) # 80005b50 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	068080e7          	jalr	104(ra) # 80000e44 <myproc>
    80001de4:	d541                	beqz	a0,80001d6c <kerneltrap+0x38>
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	05e080e7          	jalr	94(ra) # 80000e44 <myproc>
    80001dee:	4d18                	lw	a4,24(a0)
    80001df0:	4791                	li	a5,4
    80001df2:	f6f71de3          	bne	a4,a5,80001d6c <kerneltrap+0x38>
    yield();
    80001df6:	fffff097          	auipc	ra,0xfffff
    80001dfa:	6de080e7          	jalr	1758(ra) # 800014d4 <yield>
    80001dfe:	b7bd                	j	80001d6c <kerneltrap+0x38>

0000000080001e00 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e00:	1101                	addi	sp,sp,-32
    80001e02:	ec06                	sd	ra,24(sp)
    80001e04:	e822                	sd	s0,16(sp)
    80001e06:	e426                	sd	s1,8(sp)
    80001e08:	1000                	addi	s0,sp,32
    80001e0a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	038080e7          	jalr	56(ra) # 80000e44 <myproc>
  switch (n) {
    80001e14:	4795                	li	a5,5
    80001e16:	0497e163          	bltu	a5,s1,80001e58 <argraw+0x58>
    80001e1a:	048a                	slli	s1,s1,0x2
    80001e1c:	00006717          	auipc	a4,0x6
    80001e20:	5ac70713          	addi	a4,a4,1452 # 800083c8 <states.0+0x188>
    80001e24:	94ba                	add	s1,s1,a4
    80001e26:	409c                	lw	a5,0(s1)
    80001e28:	97ba                	add	a5,a5,a4
    80001e2a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e2c:	6d3c                	ld	a5,88(a0)
    80001e2e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e30:	60e2                	ld	ra,24(sp)
    80001e32:	6442                	ld	s0,16(sp)
    80001e34:	64a2                	ld	s1,8(sp)
    80001e36:	6105                	addi	sp,sp,32
    80001e38:	8082                	ret
    return p->trapframe->a1;
    80001e3a:	6d3c                	ld	a5,88(a0)
    80001e3c:	7fa8                	ld	a0,120(a5)
    80001e3e:	bfcd                	j	80001e30 <argraw+0x30>
    return p->trapframe->a2;
    80001e40:	6d3c                	ld	a5,88(a0)
    80001e42:	63c8                	ld	a0,128(a5)
    80001e44:	b7f5                	j	80001e30 <argraw+0x30>
    return p->trapframe->a3;
    80001e46:	6d3c                	ld	a5,88(a0)
    80001e48:	67c8                	ld	a0,136(a5)
    80001e4a:	b7dd                	j	80001e30 <argraw+0x30>
    return p->trapframe->a4;
    80001e4c:	6d3c                	ld	a5,88(a0)
    80001e4e:	6bc8                	ld	a0,144(a5)
    80001e50:	b7c5                	j	80001e30 <argraw+0x30>
    return p->trapframe->a5;
    80001e52:	6d3c                	ld	a5,88(a0)
    80001e54:	6fc8                	ld	a0,152(a5)
    80001e56:	bfe9                	j	80001e30 <argraw+0x30>
  panic("argraw");
    80001e58:	00006517          	auipc	a0,0x6
    80001e5c:	53050513          	addi	a0,a0,1328 # 80008388 <states.0+0x148>
    80001e60:	00004097          	auipc	ra,0x4
    80001e64:	cf0080e7          	jalr	-784(ra) # 80005b50 <panic>

0000000080001e68 <fetchaddr>:
{
    80001e68:	1101                	addi	sp,sp,-32
    80001e6a:	ec06                	sd	ra,24(sp)
    80001e6c:	e822                	sd	s0,16(sp)
    80001e6e:	e426                	sd	s1,8(sp)
    80001e70:	e04a                	sd	s2,0(sp)
    80001e72:	1000                	addi	s0,sp,32
    80001e74:	84aa                	mv	s1,a0
    80001e76:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	fcc080e7          	jalr	-52(ra) # 80000e44 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e80:	653c                	ld	a5,72(a0)
    80001e82:	02f4f863          	bgeu	s1,a5,80001eb2 <fetchaddr+0x4a>
    80001e86:	00848713          	addi	a4,s1,8
    80001e8a:	02e7e663          	bltu	a5,a4,80001eb6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e8e:	46a1                	li	a3,8
    80001e90:	8626                	mv	a2,s1
    80001e92:	85ca                	mv	a1,s2
    80001e94:	6928                	ld	a0,80(a0)
    80001e96:	fffff097          	auipc	ra,0xfffff
    80001e9a:	cfe080e7          	jalr	-770(ra) # 80000b94 <copyin>
    80001e9e:	00a03533          	snez	a0,a0
    80001ea2:	40a00533          	neg	a0,a0
}
    80001ea6:	60e2                	ld	ra,24(sp)
    80001ea8:	6442                	ld	s0,16(sp)
    80001eaa:	64a2                	ld	s1,8(sp)
    80001eac:	6902                	ld	s2,0(sp)
    80001eae:	6105                	addi	sp,sp,32
    80001eb0:	8082                	ret
    return -1;
    80001eb2:	557d                	li	a0,-1
    80001eb4:	bfcd                	j	80001ea6 <fetchaddr+0x3e>
    80001eb6:	557d                	li	a0,-1
    80001eb8:	b7fd                	j	80001ea6 <fetchaddr+0x3e>

0000000080001eba <fetchstr>:
{
    80001eba:	7179                	addi	sp,sp,-48
    80001ebc:	f406                	sd	ra,40(sp)
    80001ebe:	f022                	sd	s0,32(sp)
    80001ec0:	ec26                	sd	s1,24(sp)
    80001ec2:	e84a                	sd	s2,16(sp)
    80001ec4:	e44e                	sd	s3,8(sp)
    80001ec6:	1800                	addi	s0,sp,48
    80001ec8:	892a                	mv	s2,a0
    80001eca:	84ae                	mv	s1,a1
    80001ecc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	f76080e7          	jalr	-138(ra) # 80000e44 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ed6:	86ce                	mv	a3,s3
    80001ed8:	864a                	mv	a2,s2
    80001eda:	85a6                	mv	a1,s1
    80001edc:	6928                	ld	a0,80(a0)
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	d44080e7          	jalr	-700(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ee6:	00054763          	bltz	a0,80001ef4 <fetchstr+0x3a>
  return strlen(buf);
    80001eea:	8526                	mv	a0,s1
    80001eec:	ffffe097          	auipc	ra,0xffffe
    80001ef0:	40a080e7          	jalr	1034(ra) # 800002f6 <strlen>
}
    80001ef4:	70a2                	ld	ra,40(sp)
    80001ef6:	7402                	ld	s0,32(sp)
    80001ef8:	64e2                	ld	s1,24(sp)
    80001efa:	6942                	ld	s2,16(sp)
    80001efc:	69a2                	ld	s3,8(sp)
    80001efe:	6145                	addi	sp,sp,48
    80001f00:	8082                	ret

0000000080001f02 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f02:	1101                	addi	sp,sp,-32
    80001f04:	ec06                	sd	ra,24(sp)
    80001f06:	e822                	sd	s0,16(sp)
    80001f08:	e426                	sd	s1,8(sp)
    80001f0a:	1000                	addi	s0,sp,32
    80001f0c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f0e:	00000097          	auipc	ra,0x0
    80001f12:	ef2080e7          	jalr	-270(ra) # 80001e00 <argraw>
    80001f16:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f18:	4501                	li	a0,0
    80001f1a:	60e2                	ld	ra,24(sp)
    80001f1c:	6442                	ld	s0,16(sp)
    80001f1e:	64a2                	ld	s1,8(sp)
    80001f20:	6105                	addi	sp,sp,32
    80001f22:	8082                	ret

0000000080001f24 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f24:	1101                	addi	sp,sp,-32
    80001f26:	ec06                	sd	ra,24(sp)
    80001f28:	e822                	sd	s0,16(sp)
    80001f2a:	e426                	sd	s1,8(sp)
    80001f2c:	1000                	addi	s0,sp,32
    80001f2e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f30:	00000097          	auipc	ra,0x0
    80001f34:	ed0080e7          	jalr	-304(ra) # 80001e00 <argraw>
    80001f38:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f3a:	4501                	li	a0,0
    80001f3c:	60e2                	ld	ra,24(sp)
    80001f3e:	6442                	ld	s0,16(sp)
    80001f40:	64a2                	ld	s1,8(sp)
    80001f42:	6105                	addi	sp,sp,32
    80001f44:	8082                	ret

0000000080001f46 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f46:	1101                	addi	sp,sp,-32
    80001f48:	ec06                	sd	ra,24(sp)
    80001f4a:	e822                	sd	s0,16(sp)
    80001f4c:	e426                	sd	s1,8(sp)
    80001f4e:	e04a                	sd	s2,0(sp)
    80001f50:	1000                	addi	s0,sp,32
    80001f52:	84ae                	mv	s1,a1
    80001f54:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f56:	00000097          	auipc	ra,0x0
    80001f5a:	eaa080e7          	jalr	-342(ra) # 80001e00 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f5e:	864a                	mv	a2,s2
    80001f60:	85a6                	mv	a1,s1
    80001f62:	00000097          	auipc	ra,0x0
    80001f66:	f58080e7          	jalr	-168(ra) # 80001eba <fetchstr>
}
    80001f6a:	60e2                	ld	ra,24(sp)
    80001f6c:	6442                	ld	s0,16(sp)
    80001f6e:	64a2                	ld	s1,8(sp)
    80001f70:	6902                	ld	s2,0(sp)
    80001f72:	6105                	addi	sp,sp,32
    80001f74:	8082                	ret

0000000080001f76 <syscall>:
[SYS_trace]   sys_trace,
};

void
syscall(void)
{
    80001f76:	7179                	addi	sp,sp,-48
    80001f78:	f406                	sd	ra,40(sp)
    80001f7a:	f022                	sd	s0,32(sp)
    80001f7c:	ec26                	sd	s1,24(sp)
    80001f7e:	e84a                	sd	s2,16(sp)
    80001f80:	e44e                	sd	s3,8(sp)
    80001f82:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001f84:	fffff097          	auipc	ra,0xfffff
    80001f88:	ec0080e7          	jalr	-320(ra) # 80000e44 <myproc>
    80001f8c:	84aa                	mv	s1,a0

  //get syscall num from a7 and then put its funtion into a0
  num = p->trapframe->a7;
    80001f8e:	05853983          	ld	s3,88(a0)
    80001f92:	0a89b783          	ld	a5,168(s3)
    80001f96:	0007891b          	sext.w	s2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f9a:	37fd                	addiw	a5,a5,-1
    80001f9c:	4755                	li	a4,21
    80001f9e:	04f76163          	bltu	a4,a5,80001fe0 <syscall+0x6a>
    80001fa2:	00391713          	slli	a4,s2,0x3
    80001fa6:	00006797          	auipc	a5,0x6
    80001faa:	43a78793          	addi	a5,a5,1082 # 800083e0 <syscalls>
    80001fae:	97ba                	add	a5,a5,a4
    80001fb0:	639c                	ld	a5,0(a5)
    80001fb2:	c79d                	beqz	a5,80001fe0 <syscall+0x6a>
    p->trapframe->a0 = syscalls[num]();
    80001fb4:	9782                	jalr	a5
    80001fb6:	06a9b823          	sd	a0,112(s3)
    
    if((1<<num) & p->trace_mask)
    80001fba:	1684a683          	lw	a3,360(s1)
    80001fbe:	4126d6bb          	sraw	a3,a3,s2
    80001fc2:	8a85                	andi	a3,a3,1
    80001fc4:	ce8d                	beqz	a3,80001ffe <syscall+0x88>
      printf("%d:syscall %s -> %d\n", p->pid, p->name, p->pid);
    80001fc6:	588c                	lw	a1,48(s1)
    80001fc8:	86ae                	mv	a3,a1
    80001fca:	15848613          	addi	a2,s1,344
    80001fce:	00006517          	auipc	a0,0x6
    80001fd2:	3c250513          	addi	a0,a0,962 # 80008390 <states.0+0x150>
    80001fd6:	00004097          	auipc	ra,0x4
    80001fda:	bc4080e7          	jalr	-1084(ra) # 80005b9a <printf>
    80001fde:	a005                	j	80001ffe <syscall+0x88>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fe0:	86ca                	mv	a3,s2
    80001fe2:	15848613          	addi	a2,s1,344
    80001fe6:	588c                	lw	a1,48(s1)
    80001fe8:	00006517          	auipc	a0,0x6
    80001fec:	3c050513          	addi	a0,a0,960 # 800083a8 <states.0+0x168>
    80001ff0:	00004097          	auipc	ra,0x4
    80001ff4:	baa080e7          	jalr	-1110(ra) # 80005b9a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001ff8:	6cbc                	ld	a5,88(s1)
    80001ffa:	577d                	li	a4,-1
    80001ffc:	fbb8                	sd	a4,112(a5)
  }
}
    80001ffe:	70a2                	ld	ra,40(sp)
    80002000:	7402                	ld	s0,32(sp)
    80002002:	64e2                	ld	s1,24(sp)
    80002004:	6942                	ld	s2,16(sp)
    80002006:	69a2                	ld	s3,8(sp)
    80002008:	6145                	addi	sp,sp,48
    8000200a:	8082                	ret

000000008000200c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000200c:	1101                	addi	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002014:	fec40593          	addi	a1,s0,-20
    80002018:	4501                	li	a0,0
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	ee8080e7          	jalr	-280(ra) # 80001f02 <argint>
    return -1;
    80002022:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002024:	00054963          	bltz	a0,80002036 <sys_exit+0x2a>
  exit(n);
    80002028:	fec42503          	lw	a0,-20(s0)
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	740080e7          	jalr	1856(ra) # 8000176c <exit>
  return 0;  // not reached
    80002034:	4781                	li	a5,0
}
    80002036:	853e                	mv	a0,a5
    80002038:	60e2                	ld	ra,24(sp)
    8000203a:	6442                	ld	s0,16(sp)
    8000203c:	6105                	addi	sp,sp,32
    8000203e:	8082                	ret

0000000080002040 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002040:	1141                	addi	sp,sp,-16
    80002042:	e406                	sd	ra,8(sp)
    80002044:	e022                	sd	s0,0(sp)
    80002046:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	dfc080e7          	jalr	-516(ra) # 80000e44 <myproc>
}
    80002050:	5908                	lw	a0,48(a0)
    80002052:	60a2                	ld	ra,8(sp)
    80002054:	6402                	ld	s0,0(sp)
    80002056:	0141                	addi	sp,sp,16
    80002058:	8082                	ret

000000008000205a <sys_fork>:

uint64
sys_fork(void)
{
    8000205a:	1141                	addi	sp,sp,-16
    8000205c:	e406                	sd	ra,8(sp)
    8000205e:	e022                	sd	s0,0(sp)
    80002060:	0800                	addi	s0,sp,16
  return fork();
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	1b4080e7          	jalr	436(ra) # 80001216 <fork>
}
    8000206a:	60a2                	ld	ra,8(sp)
    8000206c:	6402                	ld	s0,0(sp)
    8000206e:	0141                	addi	sp,sp,16
    80002070:	8082                	ret

0000000080002072 <sys_wait>:

uint64
sys_wait(void)
{
    80002072:	1101                	addi	sp,sp,-32
    80002074:	ec06                	sd	ra,24(sp)
    80002076:	e822                	sd	s0,16(sp)
    80002078:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000207a:	fe840593          	addi	a1,s0,-24
    8000207e:	4501                	li	a0,0
    80002080:	00000097          	auipc	ra,0x0
    80002084:	ea4080e7          	jalr	-348(ra) # 80001f24 <argaddr>
    80002088:	87aa                	mv	a5,a0
    return -1;
    8000208a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000208c:	0007c863          	bltz	a5,8000209c <sys_wait+0x2a>
  return wait(p);
    80002090:	fe843503          	ld	a0,-24(s0)
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	4e0080e7          	jalr	1248(ra) # 80001574 <wait>
}
    8000209c:	60e2                	ld	ra,24(sp)
    8000209e:	6442                	ld	s0,16(sp)
    800020a0:	6105                	addi	sp,sp,32
    800020a2:	8082                	ret

00000000800020a4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020a4:	7179                	addi	sp,sp,-48
    800020a6:	f406                	sd	ra,40(sp)
    800020a8:	f022                	sd	s0,32(sp)
    800020aa:	ec26                	sd	s1,24(sp)
    800020ac:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020ae:	fdc40593          	addi	a1,s0,-36
    800020b2:	4501                	li	a0,0
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	e4e080e7          	jalr	-434(ra) # 80001f02 <argint>
    800020bc:	87aa                	mv	a5,a0
    return -1;
    800020be:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020c0:	0207c063          	bltz	a5,800020e0 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800020c4:	fffff097          	auipc	ra,0xfffff
    800020c8:	d80080e7          	jalr	-640(ra) # 80000e44 <myproc>
    800020cc:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800020ce:	fdc42503          	lw	a0,-36(s0)
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	0cc080e7          	jalr	204(ra) # 8000119e <growproc>
    800020da:	00054863          	bltz	a0,800020ea <sys_sbrk+0x46>
    return -1;
  return addr;
    800020de:	8526                	mv	a0,s1
}
    800020e0:	70a2                	ld	ra,40(sp)
    800020e2:	7402                	ld	s0,32(sp)
    800020e4:	64e2                	ld	s1,24(sp)
    800020e6:	6145                	addi	sp,sp,48
    800020e8:	8082                	ret
    return -1;
    800020ea:	557d                	li	a0,-1
    800020ec:	bfd5                	j	800020e0 <sys_sbrk+0x3c>

00000000800020ee <sys_sleep>:

uint64
sys_sleep(void)
{
    800020ee:	7139                	addi	sp,sp,-64
    800020f0:	fc06                	sd	ra,56(sp)
    800020f2:	f822                	sd	s0,48(sp)
    800020f4:	f426                	sd	s1,40(sp)
    800020f6:	f04a                	sd	s2,32(sp)
    800020f8:	ec4e                	sd	s3,24(sp)
    800020fa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800020fc:	fcc40593          	addi	a1,s0,-52
    80002100:	4501                	li	a0,0
    80002102:	00000097          	auipc	ra,0x0
    80002106:	e00080e7          	jalr	-512(ra) # 80001f02 <argint>
    return -1;
    8000210a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000210c:	06054563          	bltz	a0,80002176 <sys_sleep+0x88>
  acquire(&tickslock);
    80002110:	0000d517          	auipc	a0,0xd
    80002114:	f7050513          	addi	a0,a0,-144 # 8000f080 <tickslock>
    80002118:	00004097          	auipc	ra,0x4
    8000211c:	f70080e7          	jalr	-144(ra) # 80006088 <acquire>
  ticks0 = ticks;
    80002120:	00007917          	auipc	s2,0x7
    80002124:	ef892903          	lw	s2,-264(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002128:	fcc42783          	lw	a5,-52(s0)
    8000212c:	cf85                	beqz	a5,80002164 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000212e:	0000d997          	auipc	s3,0xd
    80002132:	f5298993          	addi	s3,s3,-174 # 8000f080 <tickslock>
    80002136:	00007497          	auipc	s1,0x7
    8000213a:	ee248493          	addi	s1,s1,-286 # 80009018 <ticks>
    if(myproc()->killed){
    8000213e:	fffff097          	auipc	ra,0xfffff
    80002142:	d06080e7          	jalr	-762(ra) # 80000e44 <myproc>
    80002146:	551c                	lw	a5,40(a0)
    80002148:	ef9d                	bnez	a5,80002186 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000214a:	85ce                	mv	a1,s3
    8000214c:	8526                	mv	a0,s1
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	3c2080e7          	jalr	962(ra) # 80001510 <sleep>
  while(ticks - ticks0 < n){
    80002156:	409c                	lw	a5,0(s1)
    80002158:	412787bb          	subw	a5,a5,s2
    8000215c:	fcc42703          	lw	a4,-52(s0)
    80002160:	fce7efe3          	bltu	a5,a4,8000213e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002164:	0000d517          	auipc	a0,0xd
    80002168:	f1c50513          	addi	a0,a0,-228 # 8000f080 <tickslock>
    8000216c:	00004097          	auipc	ra,0x4
    80002170:	fd0080e7          	jalr	-48(ra) # 8000613c <release>
  return 0;
    80002174:	4781                	li	a5,0
}
    80002176:	853e                	mv	a0,a5
    80002178:	70e2                	ld	ra,56(sp)
    8000217a:	7442                	ld	s0,48(sp)
    8000217c:	74a2                	ld	s1,40(sp)
    8000217e:	7902                	ld	s2,32(sp)
    80002180:	69e2                	ld	s3,24(sp)
    80002182:	6121                	addi	sp,sp,64
    80002184:	8082                	ret
      release(&tickslock);
    80002186:	0000d517          	auipc	a0,0xd
    8000218a:	efa50513          	addi	a0,a0,-262 # 8000f080 <tickslock>
    8000218e:	00004097          	auipc	ra,0x4
    80002192:	fae080e7          	jalr	-82(ra) # 8000613c <release>
      return -1;
    80002196:	57fd                	li	a5,-1
    80002198:	bff9                	j	80002176 <sys_sleep+0x88>

000000008000219a <sys_kill>:

uint64
sys_kill(void)
{
    8000219a:	1101                	addi	sp,sp,-32
    8000219c:	ec06                	sd	ra,24(sp)
    8000219e:	e822                	sd	s0,16(sp)
    800021a0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021a2:	fec40593          	addi	a1,s0,-20
    800021a6:	4501                	li	a0,0
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	d5a080e7          	jalr	-678(ra) # 80001f02 <argint>
    800021b0:	87aa                	mv	a5,a0
    return -1;
    800021b2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021b4:	0007c863          	bltz	a5,800021c4 <sys_kill+0x2a>
  return kill(pid);
    800021b8:	fec42503          	lw	a0,-20(s0)
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	686080e7          	jalr	1670(ra) # 80001842 <kill>
}
    800021c4:	60e2                	ld	ra,24(sp)
    800021c6:	6442                	ld	s0,16(sp)
    800021c8:	6105                	addi	sp,sp,32
    800021ca:	8082                	ret

00000000800021cc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021cc:	1101                	addi	sp,sp,-32
    800021ce:	ec06                	sd	ra,24(sp)
    800021d0:	e822                	sd	s0,16(sp)
    800021d2:	e426                	sd	s1,8(sp)
    800021d4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021d6:	0000d517          	auipc	a0,0xd
    800021da:	eaa50513          	addi	a0,a0,-342 # 8000f080 <tickslock>
    800021de:	00004097          	auipc	ra,0x4
    800021e2:	eaa080e7          	jalr	-342(ra) # 80006088 <acquire>
  xticks = ticks;
    800021e6:	00007497          	auipc	s1,0x7
    800021ea:	e324a483          	lw	s1,-462(s1) # 80009018 <ticks>
  release(&tickslock);
    800021ee:	0000d517          	auipc	a0,0xd
    800021f2:	e9250513          	addi	a0,a0,-366 # 8000f080 <tickslock>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	f46080e7          	jalr	-186(ra) # 8000613c <release>
  return xticks;
}
    800021fe:	02049513          	slli	a0,s1,0x20
    80002202:	9101                	srli	a0,a0,0x20
    80002204:	60e2                	ld	ra,24(sp)
    80002206:	6442                	ld	s0,16(sp)
    80002208:	64a2                	ld	s1,8(sp)
    8000220a:	6105                	addi	sp,sp,32
    8000220c:	8082                	ret

000000008000220e <sys_trace>:

uint64
sys_trace(void)
{
    8000220e:	1101                	addi	sp,sp,-32
    80002210:	ec06                	sd	ra,24(sp)
    80002212:	e822                	sd	s0,16(sp)
    80002214:	1000                	addi	s0,sp,32
  uint mask;

  if(argint(0, (int*)&mask) < 0)
    80002216:	fec40593          	addi	a1,s0,-20
    8000221a:	4501                	li	a0,0
    8000221c:	00000097          	auipc	ra,0x0
    80002220:	ce6080e7          	jalr	-794(ra) # 80001f02 <argint>
    return -1;
    80002224:	57fd                	li	a5,-1
  if(argint(0, (int*)&mask) < 0)
    80002226:	00054e63          	bltz	a0,80002242 <sys_trace+0x34>
    
  struct proc *_proc = myproc();
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	c1a080e7          	jalr	-998(ra) # 80000e44 <myproc>
  _proc->trace_mask |= mask;
    80002232:	16852783          	lw	a5,360(a0)
    80002236:	fec42703          	lw	a4,-20(s0)
    8000223a:	8fd9                	or	a5,a5,a4
    8000223c:	16f52423          	sw	a5,360(a0)
  
  return 0;
    80002240:	4781                	li	a5,0
}
    80002242:	853e                	mv	a0,a5
    80002244:	60e2                	ld	ra,24(sp)
    80002246:	6442                	ld	s0,16(sp)
    80002248:	6105                	addi	sp,sp,32
    8000224a:	8082                	ret

000000008000224c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000224c:	7179                	addi	sp,sp,-48
    8000224e:	f406                	sd	ra,40(sp)
    80002250:	f022                	sd	s0,32(sp)
    80002252:	ec26                	sd	s1,24(sp)
    80002254:	e84a                	sd	s2,16(sp)
    80002256:	e44e                	sd	s3,8(sp)
    80002258:	e052                	sd	s4,0(sp)
    8000225a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000225c:	00006597          	auipc	a1,0x6
    80002260:	23c58593          	addi	a1,a1,572 # 80008498 <syscalls+0xb8>
    80002264:	0000d517          	auipc	a0,0xd
    80002268:	e3450513          	addi	a0,a0,-460 # 8000f098 <bcache>
    8000226c:	00004097          	auipc	ra,0x4
    80002270:	d8c080e7          	jalr	-628(ra) # 80005ff8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002274:	00015797          	auipc	a5,0x15
    80002278:	e2478793          	addi	a5,a5,-476 # 80017098 <bcache+0x8000>
    8000227c:	00015717          	auipc	a4,0x15
    80002280:	08470713          	addi	a4,a4,132 # 80017300 <bcache+0x8268>
    80002284:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002288:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000228c:	0000d497          	auipc	s1,0xd
    80002290:	e2448493          	addi	s1,s1,-476 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002294:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002296:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002298:	00006a17          	auipc	s4,0x6
    8000229c:	208a0a13          	addi	s4,s4,520 # 800084a0 <syscalls+0xc0>
    b->next = bcache.head.next;
    800022a0:	2b893783          	ld	a5,696(s2)
    800022a4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022a6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022aa:	85d2                	mv	a1,s4
    800022ac:	01048513          	addi	a0,s1,16
    800022b0:	00001097          	auipc	ra,0x1
    800022b4:	4c2080e7          	jalr	1218(ra) # 80003772 <initsleeplock>
    bcache.head.next->prev = b;
    800022b8:	2b893783          	ld	a5,696(s2)
    800022bc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022be:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022c2:	45848493          	addi	s1,s1,1112
    800022c6:	fd349de3          	bne	s1,s3,800022a0 <binit+0x54>
  }
}
    800022ca:	70a2                	ld	ra,40(sp)
    800022cc:	7402                	ld	s0,32(sp)
    800022ce:	64e2                	ld	s1,24(sp)
    800022d0:	6942                	ld	s2,16(sp)
    800022d2:	69a2                	ld	s3,8(sp)
    800022d4:	6a02                	ld	s4,0(sp)
    800022d6:	6145                	addi	sp,sp,48
    800022d8:	8082                	ret

00000000800022da <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022da:	7179                	addi	sp,sp,-48
    800022dc:	f406                	sd	ra,40(sp)
    800022de:	f022                	sd	s0,32(sp)
    800022e0:	ec26                	sd	s1,24(sp)
    800022e2:	e84a                	sd	s2,16(sp)
    800022e4:	e44e                	sd	s3,8(sp)
    800022e6:	1800                	addi	s0,sp,48
    800022e8:	892a                	mv	s2,a0
    800022ea:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022ec:	0000d517          	auipc	a0,0xd
    800022f0:	dac50513          	addi	a0,a0,-596 # 8000f098 <bcache>
    800022f4:	00004097          	auipc	ra,0x4
    800022f8:	d94080e7          	jalr	-620(ra) # 80006088 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022fc:	00015497          	auipc	s1,0x15
    80002300:	0544b483          	ld	s1,84(s1) # 80017350 <bcache+0x82b8>
    80002304:	00015797          	auipc	a5,0x15
    80002308:	ffc78793          	addi	a5,a5,-4 # 80017300 <bcache+0x8268>
    8000230c:	02f48f63          	beq	s1,a5,8000234a <bread+0x70>
    80002310:	873e                	mv	a4,a5
    80002312:	a021                	j	8000231a <bread+0x40>
    80002314:	68a4                	ld	s1,80(s1)
    80002316:	02e48a63          	beq	s1,a4,8000234a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000231a:	449c                	lw	a5,8(s1)
    8000231c:	ff279ce3          	bne	a5,s2,80002314 <bread+0x3a>
    80002320:	44dc                	lw	a5,12(s1)
    80002322:	ff3799e3          	bne	a5,s3,80002314 <bread+0x3a>
      b->refcnt++;
    80002326:	40bc                	lw	a5,64(s1)
    80002328:	2785                	addiw	a5,a5,1
    8000232a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000232c:	0000d517          	auipc	a0,0xd
    80002330:	d6c50513          	addi	a0,a0,-660 # 8000f098 <bcache>
    80002334:	00004097          	auipc	ra,0x4
    80002338:	e08080e7          	jalr	-504(ra) # 8000613c <release>
      acquiresleep(&b->lock);
    8000233c:	01048513          	addi	a0,s1,16
    80002340:	00001097          	auipc	ra,0x1
    80002344:	46c080e7          	jalr	1132(ra) # 800037ac <acquiresleep>
      return b;
    80002348:	a8b9                	j	800023a6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000234a:	00015497          	auipc	s1,0x15
    8000234e:	ffe4b483          	ld	s1,-2(s1) # 80017348 <bcache+0x82b0>
    80002352:	00015797          	auipc	a5,0x15
    80002356:	fae78793          	addi	a5,a5,-82 # 80017300 <bcache+0x8268>
    8000235a:	00f48863          	beq	s1,a5,8000236a <bread+0x90>
    8000235e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002360:	40bc                	lw	a5,64(s1)
    80002362:	cf81                	beqz	a5,8000237a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002364:	64a4                	ld	s1,72(s1)
    80002366:	fee49de3          	bne	s1,a4,80002360 <bread+0x86>
  panic("bget: no buffers");
    8000236a:	00006517          	auipc	a0,0x6
    8000236e:	13e50513          	addi	a0,a0,318 # 800084a8 <syscalls+0xc8>
    80002372:	00003097          	auipc	ra,0x3
    80002376:	7de080e7          	jalr	2014(ra) # 80005b50 <panic>
      b->dev = dev;
    8000237a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000237e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002382:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002386:	4785                	li	a5,1
    80002388:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000238a:	0000d517          	auipc	a0,0xd
    8000238e:	d0e50513          	addi	a0,a0,-754 # 8000f098 <bcache>
    80002392:	00004097          	auipc	ra,0x4
    80002396:	daa080e7          	jalr	-598(ra) # 8000613c <release>
      acquiresleep(&b->lock);
    8000239a:	01048513          	addi	a0,s1,16
    8000239e:	00001097          	auipc	ra,0x1
    800023a2:	40e080e7          	jalr	1038(ra) # 800037ac <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023a6:	409c                	lw	a5,0(s1)
    800023a8:	cb89                	beqz	a5,800023ba <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023aa:	8526                	mv	a0,s1
    800023ac:	70a2                	ld	ra,40(sp)
    800023ae:	7402                	ld	s0,32(sp)
    800023b0:	64e2                	ld	s1,24(sp)
    800023b2:	6942                	ld	s2,16(sp)
    800023b4:	69a2                	ld	s3,8(sp)
    800023b6:	6145                	addi	sp,sp,48
    800023b8:	8082                	ret
    virtio_disk_rw(b, 0);
    800023ba:	4581                	li	a1,0
    800023bc:	8526                	mv	a0,s1
    800023be:	00003097          	auipc	ra,0x3
    800023c2:	f24080e7          	jalr	-220(ra) # 800052e2 <virtio_disk_rw>
    b->valid = 1;
    800023c6:	4785                	li	a5,1
    800023c8:	c09c                	sw	a5,0(s1)
  return b;
    800023ca:	b7c5                	j	800023aa <bread+0xd0>

00000000800023cc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023cc:	1101                	addi	sp,sp,-32
    800023ce:	ec06                	sd	ra,24(sp)
    800023d0:	e822                	sd	s0,16(sp)
    800023d2:	e426                	sd	s1,8(sp)
    800023d4:	1000                	addi	s0,sp,32
    800023d6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023d8:	0541                	addi	a0,a0,16
    800023da:	00001097          	auipc	ra,0x1
    800023de:	46c080e7          	jalr	1132(ra) # 80003846 <holdingsleep>
    800023e2:	cd01                	beqz	a0,800023fa <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023e4:	4585                	li	a1,1
    800023e6:	8526                	mv	a0,s1
    800023e8:	00003097          	auipc	ra,0x3
    800023ec:	efa080e7          	jalr	-262(ra) # 800052e2 <virtio_disk_rw>
}
    800023f0:	60e2                	ld	ra,24(sp)
    800023f2:	6442                	ld	s0,16(sp)
    800023f4:	64a2                	ld	s1,8(sp)
    800023f6:	6105                	addi	sp,sp,32
    800023f8:	8082                	ret
    panic("bwrite");
    800023fa:	00006517          	auipc	a0,0x6
    800023fe:	0c650513          	addi	a0,a0,198 # 800084c0 <syscalls+0xe0>
    80002402:	00003097          	auipc	ra,0x3
    80002406:	74e080e7          	jalr	1870(ra) # 80005b50 <panic>

000000008000240a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000240a:	1101                	addi	sp,sp,-32
    8000240c:	ec06                	sd	ra,24(sp)
    8000240e:	e822                	sd	s0,16(sp)
    80002410:	e426                	sd	s1,8(sp)
    80002412:	e04a                	sd	s2,0(sp)
    80002414:	1000                	addi	s0,sp,32
    80002416:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002418:	01050913          	addi	s2,a0,16
    8000241c:	854a                	mv	a0,s2
    8000241e:	00001097          	auipc	ra,0x1
    80002422:	428080e7          	jalr	1064(ra) # 80003846 <holdingsleep>
    80002426:	c92d                	beqz	a0,80002498 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002428:	854a                	mv	a0,s2
    8000242a:	00001097          	auipc	ra,0x1
    8000242e:	3d8080e7          	jalr	984(ra) # 80003802 <releasesleep>

  acquire(&bcache.lock);
    80002432:	0000d517          	auipc	a0,0xd
    80002436:	c6650513          	addi	a0,a0,-922 # 8000f098 <bcache>
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	c4e080e7          	jalr	-946(ra) # 80006088 <acquire>
  b->refcnt--;
    80002442:	40bc                	lw	a5,64(s1)
    80002444:	37fd                	addiw	a5,a5,-1
    80002446:	0007871b          	sext.w	a4,a5
    8000244a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000244c:	eb05                	bnez	a4,8000247c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000244e:	68bc                	ld	a5,80(s1)
    80002450:	64b8                	ld	a4,72(s1)
    80002452:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002454:	64bc                	ld	a5,72(s1)
    80002456:	68b8                	ld	a4,80(s1)
    80002458:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000245a:	00015797          	auipc	a5,0x15
    8000245e:	c3e78793          	addi	a5,a5,-962 # 80017098 <bcache+0x8000>
    80002462:	2b87b703          	ld	a4,696(a5)
    80002466:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002468:	00015717          	auipc	a4,0x15
    8000246c:	e9870713          	addi	a4,a4,-360 # 80017300 <bcache+0x8268>
    80002470:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002472:	2b87b703          	ld	a4,696(a5)
    80002476:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002478:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000247c:	0000d517          	auipc	a0,0xd
    80002480:	c1c50513          	addi	a0,a0,-996 # 8000f098 <bcache>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	cb8080e7          	jalr	-840(ra) # 8000613c <release>
}
    8000248c:	60e2                	ld	ra,24(sp)
    8000248e:	6442                	ld	s0,16(sp)
    80002490:	64a2                	ld	s1,8(sp)
    80002492:	6902                	ld	s2,0(sp)
    80002494:	6105                	addi	sp,sp,32
    80002496:	8082                	ret
    panic("brelse");
    80002498:	00006517          	auipc	a0,0x6
    8000249c:	03050513          	addi	a0,a0,48 # 800084c8 <syscalls+0xe8>
    800024a0:	00003097          	auipc	ra,0x3
    800024a4:	6b0080e7          	jalr	1712(ra) # 80005b50 <panic>

00000000800024a8 <bpin>:

void
bpin(struct buf *b) {
    800024a8:	1101                	addi	sp,sp,-32
    800024aa:	ec06                	sd	ra,24(sp)
    800024ac:	e822                	sd	s0,16(sp)
    800024ae:	e426                	sd	s1,8(sp)
    800024b0:	1000                	addi	s0,sp,32
    800024b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024b4:	0000d517          	auipc	a0,0xd
    800024b8:	be450513          	addi	a0,a0,-1052 # 8000f098 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	bcc080e7          	jalr	-1076(ra) # 80006088 <acquire>
  b->refcnt++;
    800024c4:	40bc                	lw	a5,64(s1)
    800024c6:	2785                	addiw	a5,a5,1
    800024c8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024ca:	0000d517          	auipc	a0,0xd
    800024ce:	bce50513          	addi	a0,a0,-1074 # 8000f098 <bcache>
    800024d2:	00004097          	auipc	ra,0x4
    800024d6:	c6a080e7          	jalr	-918(ra) # 8000613c <release>
}
    800024da:	60e2                	ld	ra,24(sp)
    800024dc:	6442                	ld	s0,16(sp)
    800024de:	64a2                	ld	s1,8(sp)
    800024e0:	6105                	addi	sp,sp,32
    800024e2:	8082                	ret

00000000800024e4 <bunpin>:

void
bunpin(struct buf *b) {
    800024e4:	1101                	addi	sp,sp,-32
    800024e6:	ec06                	sd	ra,24(sp)
    800024e8:	e822                	sd	s0,16(sp)
    800024ea:	e426                	sd	s1,8(sp)
    800024ec:	1000                	addi	s0,sp,32
    800024ee:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024f0:	0000d517          	auipc	a0,0xd
    800024f4:	ba850513          	addi	a0,a0,-1112 # 8000f098 <bcache>
    800024f8:	00004097          	auipc	ra,0x4
    800024fc:	b90080e7          	jalr	-1136(ra) # 80006088 <acquire>
  b->refcnt--;
    80002500:	40bc                	lw	a5,64(s1)
    80002502:	37fd                	addiw	a5,a5,-1
    80002504:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002506:	0000d517          	auipc	a0,0xd
    8000250a:	b9250513          	addi	a0,a0,-1134 # 8000f098 <bcache>
    8000250e:	00004097          	auipc	ra,0x4
    80002512:	c2e080e7          	jalr	-978(ra) # 8000613c <release>
}
    80002516:	60e2                	ld	ra,24(sp)
    80002518:	6442                	ld	s0,16(sp)
    8000251a:	64a2                	ld	s1,8(sp)
    8000251c:	6105                	addi	sp,sp,32
    8000251e:	8082                	ret

0000000080002520 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002520:	1101                	addi	sp,sp,-32
    80002522:	ec06                	sd	ra,24(sp)
    80002524:	e822                	sd	s0,16(sp)
    80002526:	e426                	sd	s1,8(sp)
    80002528:	e04a                	sd	s2,0(sp)
    8000252a:	1000                	addi	s0,sp,32
    8000252c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000252e:	00d5d59b          	srliw	a1,a1,0xd
    80002532:	00015797          	auipc	a5,0x15
    80002536:	2427a783          	lw	a5,578(a5) # 80017774 <sb+0x1c>
    8000253a:	9dbd                	addw	a1,a1,a5
    8000253c:	00000097          	auipc	ra,0x0
    80002540:	d9e080e7          	jalr	-610(ra) # 800022da <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002544:	0074f713          	andi	a4,s1,7
    80002548:	4785                	li	a5,1
    8000254a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000254e:	14ce                	slli	s1,s1,0x33
    80002550:	90d9                	srli	s1,s1,0x36
    80002552:	00950733          	add	a4,a0,s1
    80002556:	05874703          	lbu	a4,88(a4)
    8000255a:	00e7f6b3          	and	a3,a5,a4
    8000255e:	c69d                	beqz	a3,8000258c <bfree+0x6c>
    80002560:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002562:	94aa                	add	s1,s1,a0
    80002564:	fff7c793          	not	a5,a5
    80002568:	8f7d                	and	a4,a4,a5
    8000256a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000256e:	00001097          	auipc	ra,0x1
    80002572:	120080e7          	jalr	288(ra) # 8000368e <log_write>
  brelse(bp);
    80002576:	854a                	mv	a0,s2
    80002578:	00000097          	auipc	ra,0x0
    8000257c:	e92080e7          	jalr	-366(ra) # 8000240a <brelse>
}
    80002580:	60e2                	ld	ra,24(sp)
    80002582:	6442                	ld	s0,16(sp)
    80002584:	64a2                	ld	s1,8(sp)
    80002586:	6902                	ld	s2,0(sp)
    80002588:	6105                	addi	sp,sp,32
    8000258a:	8082                	ret
    panic("freeing free block");
    8000258c:	00006517          	auipc	a0,0x6
    80002590:	f4450513          	addi	a0,a0,-188 # 800084d0 <syscalls+0xf0>
    80002594:	00003097          	auipc	ra,0x3
    80002598:	5bc080e7          	jalr	1468(ra) # 80005b50 <panic>

000000008000259c <balloc>:
{
    8000259c:	711d                	addi	sp,sp,-96
    8000259e:	ec86                	sd	ra,88(sp)
    800025a0:	e8a2                	sd	s0,80(sp)
    800025a2:	e4a6                	sd	s1,72(sp)
    800025a4:	e0ca                	sd	s2,64(sp)
    800025a6:	fc4e                	sd	s3,56(sp)
    800025a8:	f852                	sd	s4,48(sp)
    800025aa:	f456                	sd	s5,40(sp)
    800025ac:	f05a                	sd	s6,32(sp)
    800025ae:	ec5e                	sd	s7,24(sp)
    800025b0:	e862                	sd	s8,16(sp)
    800025b2:	e466                	sd	s9,8(sp)
    800025b4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025b6:	00015797          	auipc	a5,0x15
    800025ba:	1a67a783          	lw	a5,422(a5) # 8001775c <sb+0x4>
    800025be:	cbc1                	beqz	a5,8000264e <balloc+0xb2>
    800025c0:	8baa                	mv	s7,a0
    800025c2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025c4:	00015b17          	auipc	s6,0x15
    800025c8:	194b0b13          	addi	s6,s6,404 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025cc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025ce:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025d0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025d2:	6c89                	lui	s9,0x2
    800025d4:	a831                	j	800025f0 <balloc+0x54>
    brelse(bp);
    800025d6:	854a                	mv	a0,s2
    800025d8:	00000097          	auipc	ra,0x0
    800025dc:	e32080e7          	jalr	-462(ra) # 8000240a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025e0:	015c87bb          	addw	a5,s9,s5
    800025e4:	00078a9b          	sext.w	s5,a5
    800025e8:	004b2703          	lw	a4,4(s6)
    800025ec:	06eaf163          	bgeu	s5,a4,8000264e <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800025f0:	41fad79b          	sraiw	a5,s5,0x1f
    800025f4:	0137d79b          	srliw	a5,a5,0x13
    800025f8:	015787bb          	addw	a5,a5,s5
    800025fc:	40d7d79b          	sraiw	a5,a5,0xd
    80002600:	01cb2583          	lw	a1,28(s6)
    80002604:	9dbd                	addw	a1,a1,a5
    80002606:	855e                	mv	a0,s7
    80002608:	00000097          	auipc	ra,0x0
    8000260c:	cd2080e7          	jalr	-814(ra) # 800022da <bread>
    80002610:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002612:	004b2503          	lw	a0,4(s6)
    80002616:	000a849b          	sext.w	s1,s5
    8000261a:	8762                	mv	a4,s8
    8000261c:	faa4fde3          	bgeu	s1,a0,800025d6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002620:	00777693          	andi	a3,a4,7
    80002624:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002628:	41f7579b          	sraiw	a5,a4,0x1f
    8000262c:	01d7d79b          	srliw	a5,a5,0x1d
    80002630:	9fb9                	addw	a5,a5,a4
    80002632:	4037d79b          	sraiw	a5,a5,0x3
    80002636:	00f90633          	add	a2,s2,a5
    8000263a:	05864603          	lbu	a2,88(a2)
    8000263e:	00c6f5b3          	and	a1,a3,a2
    80002642:	cd91                	beqz	a1,8000265e <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002644:	2705                	addiw	a4,a4,1
    80002646:	2485                	addiw	s1,s1,1
    80002648:	fd471ae3          	bne	a4,s4,8000261c <balloc+0x80>
    8000264c:	b769                	j	800025d6 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000264e:	00006517          	auipc	a0,0x6
    80002652:	e9a50513          	addi	a0,a0,-358 # 800084e8 <syscalls+0x108>
    80002656:	00003097          	auipc	ra,0x3
    8000265a:	4fa080e7          	jalr	1274(ra) # 80005b50 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000265e:	97ca                	add	a5,a5,s2
    80002660:	8e55                	or	a2,a2,a3
    80002662:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002666:	854a                	mv	a0,s2
    80002668:	00001097          	auipc	ra,0x1
    8000266c:	026080e7          	jalr	38(ra) # 8000368e <log_write>
        brelse(bp);
    80002670:	854a                	mv	a0,s2
    80002672:	00000097          	auipc	ra,0x0
    80002676:	d98080e7          	jalr	-616(ra) # 8000240a <brelse>
  bp = bread(dev, bno);
    8000267a:	85a6                	mv	a1,s1
    8000267c:	855e                	mv	a0,s7
    8000267e:	00000097          	auipc	ra,0x0
    80002682:	c5c080e7          	jalr	-932(ra) # 800022da <bread>
    80002686:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002688:	40000613          	li	a2,1024
    8000268c:	4581                	li	a1,0
    8000268e:	05850513          	addi	a0,a0,88
    80002692:	ffffe097          	auipc	ra,0xffffe
    80002696:	ae8080e7          	jalr	-1304(ra) # 8000017a <memset>
  log_write(bp);
    8000269a:	854a                	mv	a0,s2
    8000269c:	00001097          	auipc	ra,0x1
    800026a0:	ff2080e7          	jalr	-14(ra) # 8000368e <log_write>
  brelse(bp);
    800026a4:	854a                	mv	a0,s2
    800026a6:	00000097          	auipc	ra,0x0
    800026aa:	d64080e7          	jalr	-668(ra) # 8000240a <brelse>
}
    800026ae:	8526                	mv	a0,s1
    800026b0:	60e6                	ld	ra,88(sp)
    800026b2:	6446                	ld	s0,80(sp)
    800026b4:	64a6                	ld	s1,72(sp)
    800026b6:	6906                	ld	s2,64(sp)
    800026b8:	79e2                	ld	s3,56(sp)
    800026ba:	7a42                	ld	s4,48(sp)
    800026bc:	7aa2                	ld	s5,40(sp)
    800026be:	7b02                	ld	s6,32(sp)
    800026c0:	6be2                	ld	s7,24(sp)
    800026c2:	6c42                	ld	s8,16(sp)
    800026c4:	6ca2                	ld	s9,8(sp)
    800026c6:	6125                	addi	sp,sp,96
    800026c8:	8082                	ret

00000000800026ca <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800026ca:	7179                	addi	sp,sp,-48
    800026cc:	f406                	sd	ra,40(sp)
    800026ce:	f022                	sd	s0,32(sp)
    800026d0:	ec26                	sd	s1,24(sp)
    800026d2:	e84a                	sd	s2,16(sp)
    800026d4:	e44e                	sd	s3,8(sp)
    800026d6:	e052                	sd	s4,0(sp)
    800026d8:	1800                	addi	s0,sp,48
    800026da:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026dc:	47ad                	li	a5,11
    800026de:	04b7fe63          	bgeu	a5,a1,8000273a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026e2:	ff45849b          	addiw	s1,a1,-12
    800026e6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026ea:	0ff00793          	li	a5,255
    800026ee:	0ae7e463          	bltu	a5,a4,80002796 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800026f2:	08052583          	lw	a1,128(a0)
    800026f6:	c5b5                	beqz	a1,80002762 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800026f8:	00092503          	lw	a0,0(s2)
    800026fc:	00000097          	auipc	ra,0x0
    80002700:	bde080e7          	jalr	-1058(ra) # 800022da <bread>
    80002704:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002706:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000270a:	02049713          	slli	a4,s1,0x20
    8000270e:	01e75593          	srli	a1,a4,0x1e
    80002712:	00b784b3          	add	s1,a5,a1
    80002716:	0004a983          	lw	s3,0(s1)
    8000271a:	04098e63          	beqz	s3,80002776 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000271e:	8552                	mv	a0,s4
    80002720:	00000097          	auipc	ra,0x0
    80002724:	cea080e7          	jalr	-790(ra) # 8000240a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002728:	854e                	mv	a0,s3
    8000272a:	70a2                	ld	ra,40(sp)
    8000272c:	7402                	ld	s0,32(sp)
    8000272e:	64e2                	ld	s1,24(sp)
    80002730:	6942                	ld	s2,16(sp)
    80002732:	69a2                	ld	s3,8(sp)
    80002734:	6a02                	ld	s4,0(sp)
    80002736:	6145                	addi	sp,sp,48
    80002738:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000273a:	02059793          	slli	a5,a1,0x20
    8000273e:	01e7d593          	srli	a1,a5,0x1e
    80002742:	00b504b3          	add	s1,a0,a1
    80002746:	0504a983          	lw	s3,80(s1)
    8000274a:	fc099fe3          	bnez	s3,80002728 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000274e:	4108                	lw	a0,0(a0)
    80002750:	00000097          	auipc	ra,0x0
    80002754:	e4c080e7          	jalr	-436(ra) # 8000259c <balloc>
    80002758:	0005099b          	sext.w	s3,a0
    8000275c:	0534a823          	sw	s3,80(s1)
    80002760:	b7e1                	j	80002728 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002762:	4108                	lw	a0,0(a0)
    80002764:	00000097          	auipc	ra,0x0
    80002768:	e38080e7          	jalr	-456(ra) # 8000259c <balloc>
    8000276c:	0005059b          	sext.w	a1,a0
    80002770:	08b92023          	sw	a1,128(s2)
    80002774:	b751                	j	800026f8 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002776:	00092503          	lw	a0,0(s2)
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	e22080e7          	jalr	-478(ra) # 8000259c <balloc>
    80002782:	0005099b          	sext.w	s3,a0
    80002786:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000278a:	8552                	mv	a0,s4
    8000278c:	00001097          	auipc	ra,0x1
    80002790:	f02080e7          	jalr	-254(ra) # 8000368e <log_write>
    80002794:	b769                	j	8000271e <bmap+0x54>
  panic("bmap: out of range");
    80002796:	00006517          	auipc	a0,0x6
    8000279a:	d6a50513          	addi	a0,a0,-662 # 80008500 <syscalls+0x120>
    8000279e:	00003097          	auipc	ra,0x3
    800027a2:	3b2080e7          	jalr	946(ra) # 80005b50 <panic>

00000000800027a6 <iget>:
{
    800027a6:	7179                	addi	sp,sp,-48
    800027a8:	f406                	sd	ra,40(sp)
    800027aa:	f022                	sd	s0,32(sp)
    800027ac:	ec26                	sd	s1,24(sp)
    800027ae:	e84a                	sd	s2,16(sp)
    800027b0:	e44e                	sd	s3,8(sp)
    800027b2:	e052                	sd	s4,0(sp)
    800027b4:	1800                	addi	s0,sp,48
    800027b6:	89aa                	mv	s3,a0
    800027b8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027ba:	00015517          	auipc	a0,0x15
    800027be:	fbe50513          	addi	a0,a0,-66 # 80017778 <itable>
    800027c2:	00004097          	auipc	ra,0x4
    800027c6:	8c6080e7          	jalr	-1850(ra) # 80006088 <acquire>
  empty = 0;
    800027ca:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027cc:	00015497          	auipc	s1,0x15
    800027d0:	fc448493          	addi	s1,s1,-60 # 80017790 <itable+0x18>
    800027d4:	00017697          	auipc	a3,0x17
    800027d8:	a4c68693          	addi	a3,a3,-1460 # 80019220 <log>
    800027dc:	a039                	j	800027ea <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027de:	02090b63          	beqz	s2,80002814 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027e2:	08848493          	addi	s1,s1,136
    800027e6:	02d48a63          	beq	s1,a3,8000281a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027ea:	449c                	lw	a5,8(s1)
    800027ec:	fef059e3          	blez	a5,800027de <iget+0x38>
    800027f0:	4098                	lw	a4,0(s1)
    800027f2:	ff3716e3          	bne	a4,s3,800027de <iget+0x38>
    800027f6:	40d8                	lw	a4,4(s1)
    800027f8:	ff4713e3          	bne	a4,s4,800027de <iget+0x38>
      ip->ref++;
    800027fc:	2785                	addiw	a5,a5,1
    800027fe:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002800:	00015517          	auipc	a0,0x15
    80002804:	f7850513          	addi	a0,a0,-136 # 80017778 <itable>
    80002808:	00004097          	auipc	ra,0x4
    8000280c:	934080e7          	jalr	-1740(ra) # 8000613c <release>
      return ip;
    80002810:	8926                	mv	s2,s1
    80002812:	a03d                	j	80002840 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002814:	f7f9                	bnez	a5,800027e2 <iget+0x3c>
    80002816:	8926                	mv	s2,s1
    80002818:	b7e9                	j	800027e2 <iget+0x3c>
  if(empty == 0)
    8000281a:	02090c63          	beqz	s2,80002852 <iget+0xac>
  ip->dev = dev;
    8000281e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002822:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002826:	4785                	li	a5,1
    80002828:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000282c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002830:	00015517          	auipc	a0,0x15
    80002834:	f4850513          	addi	a0,a0,-184 # 80017778 <itable>
    80002838:	00004097          	auipc	ra,0x4
    8000283c:	904080e7          	jalr	-1788(ra) # 8000613c <release>
}
    80002840:	854a                	mv	a0,s2
    80002842:	70a2                	ld	ra,40(sp)
    80002844:	7402                	ld	s0,32(sp)
    80002846:	64e2                	ld	s1,24(sp)
    80002848:	6942                	ld	s2,16(sp)
    8000284a:	69a2                	ld	s3,8(sp)
    8000284c:	6a02                	ld	s4,0(sp)
    8000284e:	6145                	addi	sp,sp,48
    80002850:	8082                	ret
    panic("iget: no inodes");
    80002852:	00006517          	auipc	a0,0x6
    80002856:	cc650513          	addi	a0,a0,-826 # 80008518 <syscalls+0x138>
    8000285a:	00003097          	auipc	ra,0x3
    8000285e:	2f6080e7          	jalr	758(ra) # 80005b50 <panic>

0000000080002862 <fsinit>:
fsinit(int dev) {
    80002862:	7179                	addi	sp,sp,-48
    80002864:	f406                	sd	ra,40(sp)
    80002866:	f022                	sd	s0,32(sp)
    80002868:	ec26                	sd	s1,24(sp)
    8000286a:	e84a                	sd	s2,16(sp)
    8000286c:	e44e                	sd	s3,8(sp)
    8000286e:	1800                	addi	s0,sp,48
    80002870:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002872:	4585                	li	a1,1
    80002874:	00000097          	auipc	ra,0x0
    80002878:	a66080e7          	jalr	-1434(ra) # 800022da <bread>
    8000287c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000287e:	00015997          	auipc	s3,0x15
    80002882:	eda98993          	addi	s3,s3,-294 # 80017758 <sb>
    80002886:	02000613          	li	a2,32
    8000288a:	05850593          	addi	a1,a0,88
    8000288e:	854e                	mv	a0,s3
    80002890:	ffffe097          	auipc	ra,0xffffe
    80002894:	946080e7          	jalr	-1722(ra) # 800001d6 <memmove>
  brelse(bp);
    80002898:	8526                	mv	a0,s1
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	b70080e7          	jalr	-1168(ra) # 8000240a <brelse>
  if(sb.magic != FSMAGIC)
    800028a2:	0009a703          	lw	a4,0(s3)
    800028a6:	102037b7          	lui	a5,0x10203
    800028aa:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028ae:	02f71263          	bne	a4,a5,800028d2 <fsinit+0x70>
  initlog(dev, &sb);
    800028b2:	00015597          	auipc	a1,0x15
    800028b6:	ea658593          	addi	a1,a1,-346 # 80017758 <sb>
    800028ba:	854a                	mv	a0,s2
    800028bc:	00001097          	auipc	ra,0x1
    800028c0:	b56080e7          	jalr	-1194(ra) # 80003412 <initlog>
}
    800028c4:	70a2                	ld	ra,40(sp)
    800028c6:	7402                	ld	s0,32(sp)
    800028c8:	64e2                	ld	s1,24(sp)
    800028ca:	6942                	ld	s2,16(sp)
    800028cc:	69a2                	ld	s3,8(sp)
    800028ce:	6145                	addi	sp,sp,48
    800028d0:	8082                	ret
    panic("invalid file system");
    800028d2:	00006517          	auipc	a0,0x6
    800028d6:	c5650513          	addi	a0,a0,-938 # 80008528 <syscalls+0x148>
    800028da:	00003097          	auipc	ra,0x3
    800028de:	276080e7          	jalr	630(ra) # 80005b50 <panic>

00000000800028e2 <iinit>:
{
    800028e2:	7179                	addi	sp,sp,-48
    800028e4:	f406                	sd	ra,40(sp)
    800028e6:	f022                	sd	s0,32(sp)
    800028e8:	ec26                	sd	s1,24(sp)
    800028ea:	e84a                	sd	s2,16(sp)
    800028ec:	e44e                	sd	s3,8(sp)
    800028ee:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028f0:	00006597          	auipc	a1,0x6
    800028f4:	c5058593          	addi	a1,a1,-944 # 80008540 <syscalls+0x160>
    800028f8:	00015517          	auipc	a0,0x15
    800028fc:	e8050513          	addi	a0,a0,-384 # 80017778 <itable>
    80002900:	00003097          	auipc	ra,0x3
    80002904:	6f8080e7          	jalr	1784(ra) # 80005ff8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002908:	00015497          	auipc	s1,0x15
    8000290c:	e9848493          	addi	s1,s1,-360 # 800177a0 <itable+0x28>
    80002910:	00017997          	auipc	s3,0x17
    80002914:	92098993          	addi	s3,s3,-1760 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002918:	00006917          	auipc	s2,0x6
    8000291c:	c3090913          	addi	s2,s2,-976 # 80008548 <syscalls+0x168>
    80002920:	85ca                	mv	a1,s2
    80002922:	8526                	mv	a0,s1
    80002924:	00001097          	auipc	ra,0x1
    80002928:	e4e080e7          	jalr	-434(ra) # 80003772 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000292c:	08848493          	addi	s1,s1,136
    80002930:	ff3498e3          	bne	s1,s3,80002920 <iinit+0x3e>
}
    80002934:	70a2                	ld	ra,40(sp)
    80002936:	7402                	ld	s0,32(sp)
    80002938:	64e2                	ld	s1,24(sp)
    8000293a:	6942                	ld	s2,16(sp)
    8000293c:	69a2                	ld	s3,8(sp)
    8000293e:	6145                	addi	sp,sp,48
    80002940:	8082                	ret

0000000080002942 <ialloc>:
{
    80002942:	715d                	addi	sp,sp,-80
    80002944:	e486                	sd	ra,72(sp)
    80002946:	e0a2                	sd	s0,64(sp)
    80002948:	fc26                	sd	s1,56(sp)
    8000294a:	f84a                	sd	s2,48(sp)
    8000294c:	f44e                	sd	s3,40(sp)
    8000294e:	f052                	sd	s4,32(sp)
    80002950:	ec56                	sd	s5,24(sp)
    80002952:	e85a                	sd	s6,16(sp)
    80002954:	e45e                	sd	s7,8(sp)
    80002956:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002958:	00015717          	auipc	a4,0x15
    8000295c:	e0c72703          	lw	a4,-500(a4) # 80017764 <sb+0xc>
    80002960:	4785                	li	a5,1
    80002962:	04e7fa63          	bgeu	a5,a4,800029b6 <ialloc+0x74>
    80002966:	8aaa                	mv	s5,a0
    80002968:	8bae                	mv	s7,a1
    8000296a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000296c:	00015a17          	auipc	s4,0x15
    80002970:	deca0a13          	addi	s4,s4,-532 # 80017758 <sb>
    80002974:	00048b1b          	sext.w	s6,s1
    80002978:	0044d593          	srli	a1,s1,0x4
    8000297c:	018a2783          	lw	a5,24(s4)
    80002980:	9dbd                	addw	a1,a1,a5
    80002982:	8556                	mv	a0,s5
    80002984:	00000097          	auipc	ra,0x0
    80002988:	956080e7          	jalr	-1706(ra) # 800022da <bread>
    8000298c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000298e:	05850993          	addi	s3,a0,88
    80002992:	00f4f793          	andi	a5,s1,15
    80002996:	079a                	slli	a5,a5,0x6
    80002998:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000299a:	00099783          	lh	a5,0(s3)
    8000299e:	c785                	beqz	a5,800029c6 <ialloc+0x84>
    brelse(bp);
    800029a0:	00000097          	auipc	ra,0x0
    800029a4:	a6a080e7          	jalr	-1430(ra) # 8000240a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029a8:	0485                	addi	s1,s1,1
    800029aa:	00ca2703          	lw	a4,12(s4)
    800029ae:	0004879b          	sext.w	a5,s1
    800029b2:	fce7e1e3          	bltu	a5,a4,80002974 <ialloc+0x32>
  panic("ialloc: no inodes");
    800029b6:	00006517          	auipc	a0,0x6
    800029ba:	b9a50513          	addi	a0,a0,-1126 # 80008550 <syscalls+0x170>
    800029be:	00003097          	auipc	ra,0x3
    800029c2:	192080e7          	jalr	402(ra) # 80005b50 <panic>
      memset(dip, 0, sizeof(*dip));
    800029c6:	04000613          	li	a2,64
    800029ca:	4581                	li	a1,0
    800029cc:	854e                	mv	a0,s3
    800029ce:	ffffd097          	auipc	ra,0xffffd
    800029d2:	7ac080e7          	jalr	1964(ra) # 8000017a <memset>
      dip->type = type;
    800029d6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029da:	854a                	mv	a0,s2
    800029dc:	00001097          	auipc	ra,0x1
    800029e0:	cb2080e7          	jalr	-846(ra) # 8000368e <log_write>
      brelse(bp);
    800029e4:	854a                	mv	a0,s2
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	a24080e7          	jalr	-1500(ra) # 8000240a <brelse>
      return iget(dev, inum);
    800029ee:	85da                	mv	a1,s6
    800029f0:	8556                	mv	a0,s5
    800029f2:	00000097          	auipc	ra,0x0
    800029f6:	db4080e7          	jalr	-588(ra) # 800027a6 <iget>
}
    800029fa:	60a6                	ld	ra,72(sp)
    800029fc:	6406                	ld	s0,64(sp)
    800029fe:	74e2                	ld	s1,56(sp)
    80002a00:	7942                	ld	s2,48(sp)
    80002a02:	79a2                	ld	s3,40(sp)
    80002a04:	7a02                	ld	s4,32(sp)
    80002a06:	6ae2                	ld	s5,24(sp)
    80002a08:	6b42                	ld	s6,16(sp)
    80002a0a:	6ba2                	ld	s7,8(sp)
    80002a0c:	6161                	addi	sp,sp,80
    80002a0e:	8082                	ret

0000000080002a10 <iupdate>:
{
    80002a10:	1101                	addi	sp,sp,-32
    80002a12:	ec06                	sd	ra,24(sp)
    80002a14:	e822                	sd	s0,16(sp)
    80002a16:	e426                	sd	s1,8(sp)
    80002a18:	e04a                	sd	s2,0(sp)
    80002a1a:	1000                	addi	s0,sp,32
    80002a1c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a1e:	415c                	lw	a5,4(a0)
    80002a20:	0047d79b          	srliw	a5,a5,0x4
    80002a24:	00015597          	auipc	a1,0x15
    80002a28:	d4c5a583          	lw	a1,-692(a1) # 80017770 <sb+0x18>
    80002a2c:	9dbd                	addw	a1,a1,a5
    80002a2e:	4108                	lw	a0,0(a0)
    80002a30:	00000097          	auipc	ra,0x0
    80002a34:	8aa080e7          	jalr	-1878(ra) # 800022da <bread>
    80002a38:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a3a:	05850793          	addi	a5,a0,88
    80002a3e:	40d8                	lw	a4,4(s1)
    80002a40:	8b3d                	andi	a4,a4,15
    80002a42:	071a                	slli	a4,a4,0x6
    80002a44:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a46:	04449703          	lh	a4,68(s1)
    80002a4a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a4e:	04649703          	lh	a4,70(s1)
    80002a52:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a56:	04849703          	lh	a4,72(s1)
    80002a5a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a5e:	04a49703          	lh	a4,74(s1)
    80002a62:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a66:	44f8                	lw	a4,76(s1)
    80002a68:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a6a:	03400613          	li	a2,52
    80002a6e:	05048593          	addi	a1,s1,80
    80002a72:	00c78513          	addi	a0,a5,12
    80002a76:	ffffd097          	auipc	ra,0xffffd
    80002a7a:	760080e7          	jalr	1888(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a7e:	854a                	mv	a0,s2
    80002a80:	00001097          	auipc	ra,0x1
    80002a84:	c0e080e7          	jalr	-1010(ra) # 8000368e <log_write>
  brelse(bp);
    80002a88:	854a                	mv	a0,s2
    80002a8a:	00000097          	auipc	ra,0x0
    80002a8e:	980080e7          	jalr	-1664(ra) # 8000240a <brelse>
}
    80002a92:	60e2                	ld	ra,24(sp)
    80002a94:	6442                	ld	s0,16(sp)
    80002a96:	64a2                	ld	s1,8(sp)
    80002a98:	6902                	ld	s2,0(sp)
    80002a9a:	6105                	addi	sp,sp,32
    80002a9c:	8082                	ret

0000000080002a9e <idup>:
{
    80002a9e:	1101                	addi	sp,sp,-32
    80002aa0:	ec06                	sd	ra,24(sp)
    80002aa2:	e822                	sd	s0,16(sp)
    80002aa4:	e426                	sd	s1,8(sp)
    80002aa6:	1000                	addi	s0,sp,32
    80002aa8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002aaa:	00015517          	auipc	a0,0x15
    80002aae:	cce50513          	addi	a0,a0,-818 # 80017778 <itable>
    80002ab2:	00003097          	auipc	ra,0x3
    80002ab6:	5d6080e7          	jalr	1494(ra) # 80006088 <acquire>
  ip->ref++;
    80002aba:	449c                	lw	a5,8(s1)
    80002abc:	2785                	addiw	a5,a5,1
    80002abe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ac0:	00015517          	auipc	a0,0x15
    80002ac4:	cb850513          	addi	a0,a0,-840 # 80017778 <itable>
    80002ac8:	00003097          	auipc	ra,0x3
    80002acc:	674080e7          	jalr	1652(ra) # 8000613c <release>
}
    80002ad0:	8526                	mv	a0,s1
    80002ad2:	60e2                	ld	ra,24(sp)
    80002ad4:	6442                	ld	s0,16(sp)
    80002ad6:	64a2                	ld	s1,8(sp)
    80002ad8:	6105                	addi	sp,sp,32
    80002ada:	8082                	ret

0000000080002adc <ilock>:
{
    80002adc:	1101                	addi	sp,sp,-32
    80002ade:	ec06                	sd	ra,24(sp)
    80002ae0:	e822                	sd	s0,16(sp)
    80002ae2:	e426                	sd	s1,8(sp)
    80002ae4:	e04a                	sd	s2,0(sp)
    80002ae6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ae8:	c115                	beqz	a0,80002b0c <ilock+0x30>
    80002aea:	84aa                	mv	s1,a0
    80002aec:	451c                	lw	a5,8(a0)
    80002aee:	00f05f63          	blez	a5,80002b0c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002af2:	0541                	addi	a0,a0,16
    80002af4:	00001097          	auipc	ra,0x1
    80002af8:	cb8080e7          	jalr	-840(ra) # 800037ac <acquiresleep>
  if(ip->valid == 0){
    80002afc:	40bc                	lw	a5,64(s1)
    80002afe:	cf99                	beqz	a5,80002b1c <ilock+0x40>
}
    80002b00:	60e2                	ld	ra,24(sp)
    80002b02:	6442                	ld	s0,16(sp)
    80002b04:	64a2                	ld	s1,8(sp)
    80002b06:	6902                	ld	s2,0(sp)
    80002b08:	6105                	addi	sp,sp,32
    80002b0a:	8082                	ret
    panic("ilock");
    80002b0c:	00006517          	auipc	a0,0x6
    80002b10:	a5c50513          	addi	a0,a0,-1444 # 80008568 <syscalls+0x188>
    80002b14:	00003097          	auipc	ra,0x3
    80002b18:	03c080e7          	jalr	60(ra) # 80005b50 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b1c:	40dc                	lw	a5,4(s1)
    80002b1e:	0047d79b          	srliw	a5,a5,0x4
    80002b22:	00015597          	auipc	a1,0x15
    80002b26:	c4e5a583          	lw	a1,-946(a1) # 80017770 <sb+0x18>
    80002b2a:	9dbd                	addw	a1,a1,a5
    80002b2c:	4088                	lw	a0,0(s1)
    80002b2e:	fffff097          	auipc	ra,0xfffff
    80002b32:	7ac080e7          	jalr	1964(ra) # 800022da <bread>
    80002b36:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b38:	05850593          	addi	a1,a0,88
    80002b3c:	40dc                	lw	a5,4(s1)
    80002b3e:	8bbd                	andi	a5,a5,15
    80002b40:	079a                	slli	a5,a5,0x6
    80002b42:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b44:	00059783          	lh	a5,0(a1)
    80002b48:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b4c:	00259783          	lh	a5,2(a1)
    80002b50:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b54:	00459783          	lh	a5,4(a1)
    80002b58:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b5c:	00659783          	lh	a5,6(a1)
    80002b60:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b64:	459c                	lw	a5,8(a1)
    80002b66:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b68:	03400613          	li	a2,52
    80002b6c:	05b1                	addi	a1,a1,12
    80002b6e:	05048513          	addi	a0,s1,80
    80002b72:	ffffd097          	auipc	ra,0xffffd
    80002b76:	664080e7          	jalr	1636(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b7a:	854a                	mv	a0,s2
    80002b7c:	00000097          	auipc	ra,0x0
    80002b80:	88e080e7          	jalr	-1906(ra) # 8000240a <brelse>
    ip->valid = 1;
    80002b84:	4785                	li	a5,1
    80002b86:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b88:	04449783          	lh	a5,68(s1)
    80002b8c:	fbb5                	bnez	a5,80002b00 <ilock+0x24>
      panic("ilock: no type");
    80002b8e:	00006517          	auipc	a0,0x6
    80002b92:	9e250513          	addi	a0,a0,-1566 # 80008570 <syscalls+0x190>
    80002b96:	00003097          	auipc	ra,0x3
    80002b9a:	fba080e7          	jalr	-70(ra) # 80005b50 <panic>

0000000080002b9e <iunlock>:
{
    80002b9e:	1101                	addi	sp,sp,-32
    80002ba0:	ec06                	sd	ra,24(sp)
    80002ba2:	e822                	sd	s0,16(sp)
    80002ba4:	e426                	sd	s1,8(sp)
    80002ba6:	e04a                	sd	s2,0(sp)
    80002ba8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002baa:	c905                	beqz	a0,80002bda <iunlock+0x3c>
    80002bac:	84aa                	mv	s1,a0
    80002bae:	01050913          	addi	s2,a0,16
    80002bb2:	854a                	mv	a0,s2
    80002bb4:	00001097          	auipc	ra,0x1
    80002bb8:	c92080e7          	jalr	-878(ra) # 80003846 <holdingsleep>
    80002bbc:	cd19                	beqz	a0,80002bda <iunlock+0x3c>
    80002bbe:	449c                	lw	a5,8(s1)
    80002bc0:	00f05d63          	blez	a5,80002bda <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bc4:	854a                	mv	a0,s2
    80002bc6:	00001097          	auipc	ra,0x1
    80002bca:	c3c080e7          	jalr	-964(ra) # 80003802 <releasesleep>
}
    80002bce:	60e2                	ld	ra,24(sp)
    80002bd0:	6442                	ld	s0,16(sp)
    80002bd2:	64a2                	ld	s1,8(sp)
    80002bd4:	6902                	ld	s2,0(sp)
    80002bd6:	6105                	addi	sp,sp,32
    80002bd8:	8082                	ret
    panic("iunlock");
    80002bda:	00006517          	auipc	a0,0x6
    80002bde:	9a650513          	addi	a0,a0,-1626 # 80008580 <syscalls+0x1a0>
    80002be2:	00003097          	auipc	ra,0x3
    80002be6:	f6e080e7          	jalr	-146(ra) # 80005b50 <panic>

0000000080002bea <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bea:	7179                	addi	sp,sp,-48
    80002bec:	f406                	sd	ra,40(sp)
    80002bee:	f022                	sd	s0,32(sp)
    80002bf0:	ec26                	sd	s1,24(sp)
    80002bf2:	e84a                	sd	s2,16(sp)
    80002bf4:	e44e                	sd	s3,8(sp)
    80002bf6:	e052                	sd	s4,0(sp)
    80002bf8:	1800                	addi	s0,sp,48
    80002bfa:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002bfc:	05050493          	addi	s1,a0,80
    80002c00:	08050913          	addi	s2,a0,128
    80002c04:	a021                	j	80002c0c <itrunc+0x22>
    80002c06:	0491                	addi	s1,s1,4
    80002c08:	01248d63          	beq	s1,s2,80002c22 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c0c:	408c                	lw	a1,0(s1)
    80002c0e:	dde5                	beqz	a1,80002c06 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c10:	0009a503          	lw	a0,0(s3)
    80002c14:	00000097          	auipc	ra,0x0
    80002c18:	90c080e7          	jalr	-1780(ra) # 80002520 <bfree>
      ip->addrs[i] = 0;
    80002c1c:	0004a023          	sw	zero,0(s1)
    80002c20:	b7dd                	j	80002c06 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c22:	0809a583          	lw	a1,128(s3)
    80002c26:	e185                	bnez	a1,80002c46 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c28:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c2c:	854e                	mv	a0,s3
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	de2080e7          	jalr	-542(ra) # 80002a10 <iupdate>
}
    80002c36:	70a2                	ld	ra,40(sp)
    80002c38:	7402                	ld	s0,32(sp)
    80002c3a:	64e2                	ld	s1,24(sp)
    80002c3c:	6942                	ld	s2,16(sp)
    80002c3e:	69a2                	ld	s3,8(sp)
    80002c40:	6a02                	ld	s4,0(sp)
    80002c42:	6145                	addi	sp,sp,48
    80002c44:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c46:	0009a503          	lw	a0,0(s3)
    80002c4a:	fffff097          	auipc	ra,0xfffff
    80002c4e:	690080e7          	jalr	1680(ra) # 800022da <bread>
    80002c52:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c54:	05850493          	addi	s1,a0,88
    80002c58:	45850913          	addi	s2,a0,1112
    80002c5c:	a021                	j	80002c64 <itrunc+0x7a>
    80002c5e:	0491                	addi	s1,s1,4
    80002c60:	01248b63          	beq	s1,s2,80002c76 <itrunc+0x8c>
      if(a[j])
    80002c64:	408c                	lw	a1,0(s1)
    80002c66:	dde5                	beqz	a1,80002c5e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c68:	0009a503          	lw	a0,0(s3)
    80002c6c:	00000097          	auipc	ra,0x0
    80002c70:	8b4080e7          	jalr	-1868(ra) # 80002520 <bfree>
    80002c74:	b7ed                	j	80002c5e <itrunc+0x74>
    brelse(bp);
    80002c76:	8552                	mv	a0,s4
    80002c78:	fffff097          	auipc	ra,0xfffff
    80002c7c:	792080e7          	jalr	1938(ra) # 8000240a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c80:	0809a583          	lw	a1,128(s3)
    80002c84:	0009a503          	lw	a0,0(s3)
    80002c88:	00000097          	auipc	ra,0x0
    80002c8c:	898080e7          	jalr	-1896(ra) # 80002520 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c90:	0809a023          	sw	zero,128(s3)
    80002c94:	bf51                	j	80002c28 <itrunc+0x3e>

0000000080002c96 <iput>:
{
    80002c96:	1101                	addi	sp,sp,-32
    80002c98:	ec06                	sd	ra,24(sp)
    80002c9a:	e822                	sd	s0,16(sp)
    80002c9c:	e426                	sd	s1,8(sp)
    80002c9e:	e04a                	sd	s2,0(sp)
    80002ca0:	1000                	addi	s0,sp,32
    80002ca2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ca4:	00015517          	auipc	a0,0x15
    80002ca8:	ad450513          	addi	a0,a0,-1324 # 80017778 <itable>
    80002cac:	00003097          	auipc	ra,0x3
    80002cb0:	3dc080e7          	jalr	988(ra) # 80006088 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cb4:	4498                	lw	a4,8(s1)
    80002cb6:	4785                	li	a5,1
    80002cb8:	02f70363          	beq	a4,a5,80002cde <iput+0x48>
  ip->ref--;
    80002cbc:	449c                	lw	a5,8(s1)
    80002cbe:	37fd                	addiw	a5,a5,-1
    80002cc0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cc2:	00015517          	auipc	a0,0x15
    80002cc6:	ab650513          	addi	a0,a0,-1354 # 80017778 <itable>
    80002cca:	00003097          	auipc	ra,0x3
    80002cce:	472080e7          	jalr	1138(ra) # 8000613c <release>
}
    80002cd2:	60e2                	ld	ra,24(sp)
    80002cd4:	6442                	ld	s0,16(sp)
    80002cd6:	64a2                	ld	s1,8(sp)
    80002cd8:	6902                	ld	s2,0(sp)
    80002cda:	6105                	addi	sp,sp,32
    80002cdc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cde:	40bc                	lw	a5,64(s1)
    80002ce0:	dff1                	beqz	a5,80002cbc <iput+0x26>
    80002ce2:	04a49783          	lh	a5,74(s1)
    80002ce6:	fbf9                	bnez	a5,80002cbc <iput+0x26>
    acquiresleep(&ip->lock);
    80002ce8:	01048913          	addi	s2,s1,16
    80002cec:	854a                	mv	a0,s2
    80002cee:	00001097          	auipc	ra,0x1
    80002cf2:	abe080e7          	jalr	-1346(ra) # 800037ac <acquiresleep>
    release(&itable.lock);
    80002cf6:	00015517          	auipc	a0,0x15
    80002cfa:	a8250513          	addi	a0,a0,-1406 # 80017778 <itable>
    80002cfe:	00003097          	auipc	ra,0x3
    80002d02:	43e080e7          	jalr	1086(ra) # 8000613c <release>
    itrunc(ip);
    80002d06:	8526                	mv	a0,s1
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	ee2080e7          	jalr	-286(ra) # 80002bea <itrunc>
    ip->type = 0;
    80002d10:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d14:	8526                	mv	a0,s1
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	cfa080e7          	jalr	-774(ra) # 80002a10 <iupdate>
    ip->valid = 0;
    80002d1e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d22:	854a                	mv	a0,s2
    80002d24:	00001097          	auipc	ra,0x1
    80002d28:	ade080e7          	jalr	-1314(ra) # 80003802 <releasesleep>
    acquire(&itable.lock);
    80002d2c:	00015517          	auipc	a0,0x15
    80002d30:	a4c50513          	addi	a0,a0,-1460 # 80017778 <itable>
    80002d34:	00003097          	auipc	ra,0x3
    80002d38:	354080e7          	jalr	852(ra) # 80006088 <acquire>
    80002d3c:	b741                	j	80002cbc <iput+0x26>

0000000080002d3e <iunlockput>:
{
    80002d3e:	1101                	addi	sp,sp,-32
    80002d40:	ec06                	sd	ra,24(sp)
    80002d42:	e822                	sd	s0,16(sp)
    80002d44:	e426                	sd	s1,8(sp)
    80002d46:	1000                	addi	s0,sp,32
    80002d48:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d4a:	00000097          	auipc	ra,0x0
    80002d4e:	e54080e7          	jalr	-428(ra) # 80002b9e <iunlock>
  iput(ip);
    80002d52:	8526                	mv	a0,s1
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	f42080e7          	jalr	-190(ra) # 80002c96 <iput>
}
    80002d5c:	60e2                	ld	ra,24(sp)
    80002d5e:	6442                	ld	s0,16(sp)
    80002d60:	64a2                	ld	s1,8(sp)
    80002d62:	6105                	addi	sp,sp,32
    80002d64:	8082                	ret

0000000080002d66 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d66:	1141                	addi	sp,sp,-16
    80002d68:	e422                	sd	s0,8(sp)
    80002d6a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d6c:	411c                	lw	a5,0(a0)
    80002d6e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d70:	415c                	lw	a5,4(a0)
    80002d72:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d74:	04451783          	lh	a5,68(a0)
    80002d78:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d7c:	04a51783          	lh	a5,74(a0)
    80002d80:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d84:	04c56783          	lwu	a5,76(a0)
    80002d88:	e99c                	sd	a5,16(a1)
}
    80002d8a:	6422                	ld	s0,8(sp)
    80002d8c:	0141                	addi	sp,sp,16
    80002d8e:	8082                	ret

0000000080002d90 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d90:	457c                	lw	a5,76(a0)
    80002d92:	0ed7e963          	bltu	a5,a3,80002e84 <readi+0xf4>
{
    80002d96:	7159                	addi	sp,sp,-112
    80002d98:	f486                	sd	ra,104(sp)
    80002d9a:	f0a2                	sd	s0,96(sp)
    80002d9c:	eca6                	sd	s1,88(sp)
    80002d9e:	e8ca                	sd	s2,80(sp)
    80002da0:	e4ce                	sd	s3,72(sp)
    80002da2:	e0d2                	sd	s4,64(sp)
    80002da4:	fc56                	sd	s5,56(sp)
    80002da6:	f85a                	sd	s6,48(sp)
    80002da8:	f45e                	sd	s7,40(sp)
    80002daa:	f062                	sd	s8,32(sp)
    80002dac:	ec66                	sd	s9,24(sp)
    80002dae:	e86a                	sd	s10,16(sp)
    80002db0:	e46e                	sd	s11,8(sp)
    80002db2:	1880                	addi	s0,sp,112
    80002db4:	8baa                	mv	s7,a0
    80002db6:	8c2e                	mv	s8,a1
    80002db8:	8ab2                	mv	s5,a2
    80002dba:	84b6                	mv	s1,a3
    80002dbc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002dbe:	9f35                	addw	a4,a4,a3
    return 0;
    80002dc0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dc2:	0ad76063          	bltu	a4,a3,80002e62 <readi+0xd2>
  if(off + n > ip->size)
    80002dc6:	00e7f463          	bgeu	a5,a4,80002dce <readi+0x3e>
    n = ip->size - off;
    80002dca:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dce:	0a0b0963          	beqz	s6,80002e80 <readi+0xf0>
    80002dd2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dd4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dd8:	5cfd                	li	s9,-1
    80002dda:	a82d                	j	80002e14 <readi+0x84>
    80002ddc:	020a1d93          	slli	s11,s4,0x20
    80002de0:	020ddd93          	srli	s11,s11,0x20
    80002de4:	05890613          	addi	a2,s2,88
    80002de8:	86ee                	mv	a3,s11
    80002dea:	963a                	add	a2,a2,a4
    80002dec:	85d6                	mv	a1,s5
    80002dee:	8562                	mv	a0,s8
    80002df0:	fffff097          	auipc	ra,0xfffff
    80002df4:	ac4080e7          	jalr	-1340(ra) # 800018b4 <either_copyout>
    80002df8:	05950d63          	beq	a0,s9,80002e52 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002dfc:	854a                	mv	a0,s2
    80002dfe:	fffff097          	auipc	ra,0xfffff
    80002e02:	60c080e7          	jalr	1548(ra) # 8000240a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e06:	013a09bb          	addw	s3,s4,s3
    80002e0a:	009a04bb          	addw	s1,s4,s1
    80002e0e:	9aee                	add	s5,s5,s11
    80002e10:	0569f763          	bgeu	s3,s6,80002e5e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e14:	000ba903          	lw	s2,0(s7)
    80002e18:	00a4d59b          	srliw	a1,s1,0xa
    80002e1c:	855e                	mv	a0,s7
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	8ac080e7          	jalr	-1876(ra) # 800026ca <bmap>
    80002e26:	0005059b          	sext.w	a1,a0
    80002e2a:	854a                	mv	a0,s2
    80002e2c:	fffff097          	auipc	ra,0xfffff
    80002e30:	4ae080e7          	jalr	1198(ra) # 800022da <bread>
    80002e34:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e36:	3ff4f713          	andi	a4,s1,1023
    80002e3a:	40ed07bb          	subw	a5,s10,a4
    80002e3e:	413b06bb          	subw	a3,s6,s3
    80002e42:	8a3e                	mv	s4,a5
    80002e44:	2781                	sext.w	a5,a5
    80002e46:	0006861b          	sext.w	a2,a3
    80002e4a:	f8f679e3          	bgeu	a2,a5,80002ddc <readi+0x4c>
    80002e4e:	8a36                	mv	s4,a3
    80002e50:	b771                	j	80002ddc <readi+0x4c>
      brelse(bp);
    80002e52:	854a                	mv	a0,s2
    80002e54:	fffff097          	auipc	ra,0xfffff
    80002e58:	5b6080e7          	jalr	1462(ra) # 8000240a <brelse>
      tot = -1;
    80002e5c:	59fd                	li	s3,-1
  }
  return tot;
    80002e5e:	0009851b          	sext.w	a0,s3
}
    80002e62:	70a6                	ld	ra,104(sp)
    80002e64:	7406                	ld	s0,96(sp)
    80002e66:	64e6                	ld	s1,88(sp)
    80002e68:	6946                	ld	s2,80(sp)
    80002e6a:	69a6                	ld	s3,72(sp)
    80002e6c:	6a06                	ld	s4,64(sp)
    80002e6e:	7ae2                	ld	s5,56(sp)
    80002e70:	7b42                	ld	s6,48(sp)
    80002e72:	7ba2                	ld	s7,40(sp)
    80002e74:	7c02                	ld	s8,32(sp)
    80002e76:	6ce2                	ld	s9,24(sp)
    80002e78:	6d42                	ld	s10,16(sp)
    80002e7a:	6da2                	ld	s11,8(sp)
    80002e7c:	6165                	addi	sp,sp,112
    80002e7e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e80:	89da                	mv	s3,s6
    80002e82:	bff1                	j	80002e5e <readi+0xce>
    return 0;
    80002e84:	4501                	li	a0,0
}
    80002e86:	8082                	ret

0000000080002e88 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e88:	457c                	lw	a5,76(a0)
    80002e8a:	10d7e863          	bltu	a5,a3,80002f9a <writei+0x112>
{
    80002e8e:	7159                	addi	sp,sp,-112
    80002e90:	f486                	sd	ra,104(sp)
    80002e92:	f0a2                	sd	s0,96(sp)
    80002e94:	eca6                	sd	s1,88(sp)
    80002e96:	e8ca                	sd	s2,80(sp)
    80002e98:	e4ce                	sd	s3,72(sp)
    80002e9a:	e0d2                	sd	s4,64(sp)
    80002e9c:	fc56                	sd	s5,56(sp)
    80002e9e:	f85a                	sd	s6,48(sp)
    80002ea0:	f45e                	sd	s7,40(sp)
    80002ea2:	f062                	sd	s8,32(sp)
    80002ea4:	ec66                	sd	s9,24(sp)
    80002ea6:	e86a                	sd	s10,16(sp)
    80002ea8:	e46e                	sd	s11,8(sp)
    80002eaa:	1880                	addi	s0,sp,112
    80002eac:	8b2a                	mv	s6,a0
    80002eae:	8c2e                	mv	s8,a1
    80002eb0:	8ab2                	mv	s5,a2
    80002eb2:	8936                	mv	s2,a3
    80002eb4:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002eb6:	00e687bb          	addw	a5,a3,a4
    80002eba:	0ed7e263          	bltu	a5,a3,80002f9e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ebe:	00043737          	lui	a4,0x43
    80002ec2:	0ef76063          	bltu	a4,a5,80002fa2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ec6:	0c0b8863          	beqz	s7,80002f96 <writei+0x10e>
    80002eca:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ecc:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ed0:	5cfd                	li	s9,-1
    80002ed2:	a091                	j	80002f16 <writei+0x8e>
    80002ed4:	02099d93          	slli	s11,s3,0x20
    80002ed8:	020ddd93          	srli	s11,s11,0x20
    80002edc:	05848513          	addi	a0,s1,88
    80002ee0:	86ee                	mv	a3,s11
    80002ee2:	8656                	mv	a2,s5
    80002ee4:	85e2                	mv	a1,s8
    80002ee6:	953a                	add	a0,a0,a4
    80002ee8:	fffff097          	auipc	ra,0xfffff
    80002eec:	a22080e7          	jalr	-1502(ra) # 8000190a <either_copyin>
    80002ef0:	07950263          	beq	a0,s9,80002f54 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ef4:	8526                	mv	a0,s1
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	798080e7          	jalr	1944(ra) # 8000368e <log_write>
    brelse(bp);
    80002efe:	8526                	mv	a0,s1
    80002f00:	fffff097          	auipc	ra,0xfffff
    80002f04:	50a080e7          	jalr	1290(ra) # 8000240a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f08:	01498a3b          	addw	s4,s3,s4
    80002f0c:	0129893b          	addw	s2,s3,s2
    80002f10:	9aee                	add	s5,s5,s11
    80002f12:	057a7663          	bgeu	s4,s7,80002f5e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f16:	000b2483          	lw	s1,0(s6)
    80002f1a:	00a9559b          	srliw	a1,s2,0xa
    80002f1e:	855a                	mv	a0,s6
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	7aa080e7          	jalr	1962(ra) # 800026ca <bmap>
    80002f28:	0005059b          	sext.w	a1,a0
    80002f2c:	8526                	mv	a0,s1
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	3ac080e7          	jalr	940(ra) # 800022da <bread>
    80002f36:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f38:	3ff97713          	andi	a4,s2,1023
    80002f3c:	40ed07bb          	subw	a5,s10,a4
    80002f40:	414b86bb          	subw	a3,s7,s4
    80002f44:	89be                	mv	s3,a5
    80002f46:	2781                	sext.w	a5,a5
    80002f48:	0006861b          	sext.w	a2,a3
    80002f4c:	f8f674e3          	bgeu	a2,a5,80002ed4 <writei+0x4c>
    80002f50:	89b6                	mv	s3,a3
    80002f52:	b749                	j	80002ed4 <writei+0x4c>
      brelse(bp);
    80002f54:	8526                	mv	a0,s1
    80002f56:	fffff097          	auipc	ra,0xfffff
    80002f5a:	4b4080e7          	jalr	1204(ra) # 8000240a <brelse>
  }

  if(off > ip->size)
    80002f5e:	04cb2783          	lw	a5,76(s6)
    80002f62:	0127f463          	bgeu	a5,s2,80002f6a <writei+0xe2>
    ip->size = off;
    80002f66:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f6a:	855a                	mv	a0,s6
    80002f6c:	00000097          	auipc	ra,0x0
    80002f70:	aa4080e7          	jalr	-1372(ra) # 80002a10 <iupdate>

  return tot;
    80002f74:	000a051b          	sext.w	a0,s4
}
    80002f78:	70a6                	ld	ra,104(sp)
    80002f7a:	7406                	ld	s0,96(sp)
    80002f7c:	64e6                	ld	s1,88(sp)
    80002f7e:	6946                	ld	s2,80(sp)
    80002f80:	69a6                	ld	s3,72(sp)
    80002f82:	6a06                	ld	s4,64(sp)
    80002f84:	7ae2                	ld	s5,56(sp)
    80002f86:	7b42                	ld	s6,48(sp)
    80002f88:	7ba2                	ld	s7,40(sp)
    80002f8a:	7c02                	ld	s8,32(sp)
    80002f8c:	6ce2                	ld	s9,24(sp)
    80002f8e:	6d42                	ld	s10,16(sp)
    80002f90:	6da2                	ld	s11,8(sp)
    80002f92:	6165                	addi	sp,sp,112
    80002f94:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f96:	8a5e                	mv	s4,s7
    80002f98:	bfc9                	j	80002f6a <writei+0xe2>
    return -1;
    80002f9a:	557d                	li	a0,-1
}
    80002f9c:	8082                	ret
    return -1;
    80002f9e:	557d                	li	a0,-1
    80002fa0:	bfe1                	j	80002f78 <writei+0xf0>
    return -1;
    80002fa2:	557d                	li	a0,-1
    80002fa4:	bfd1                	j	80002f78 <writei+0xf0>

0000000080002fa6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fa6:	1141                	addi	sp,sp,-16
    80002fa8:	e406                	sd	ra,8(sp)
    80002faa:	e022                	sd	s0,0(sp)
    80002fac:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fae:	4639                	li	a2,14
    80002fb0:	ffffd097          	auipc	ra,0xffffd
    80002fb4:	29a080e7          	jalr	666(ra) # 8000024a <strncmp>
}
    80002fb8:	60a2                	ld	ra,8(sp)
    80002fba:	6402                	ld	s0,0(sp)
    80002fbc:	0141                	addi	sp,sp,16
    80002fbe:	8082                	ret

0000000080002fc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fc0:	7139                	addi	sp,sp,-64
    80002fc2:	fc06                	sd	ra,56(sp)
    80002fc4:	f822                	sd	s0,48(sp)
    80002fc6:	f426                	sd	s1,40(sp)
    80002fc8:	f04a                	sd	s2,32(sp)
    80002fca:	ec4e                	sd	s3,24(sp)
    80002fcc:	e852                	sd	s4,16(sp)
    80002fce:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fd0:	04451703          	lh	a4,68(a0)
    80002fd4:	4785                	li	a5,1
    80002fd6:	00f71a63          	bne	a4,a5,80002fea <dirlookup+0x2a>
    80002fda:	892a                	mv	s2,a0
    80002fdc:	89ae                	mv	s3,a1
    80002fde:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe0:	457c                	lw	a5,76(a0)
    80002fe2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fe4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe6:	e79d                	bnez	a5,80003014 <dirlookup+0x54>
    80002fe8:	a8a5                	j	80003060 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002fea:	00005517          	auipc	a0,0x5
    80002fee:	59e50513          	addi	a0,a0,1438 # 80008588 <syscalls+0x1a8>
    80002ff2:	00003097          	auipc	ra,0x3
    80002ff6:	b5e080e7          	jalr	-1186(ra) # 80005b50 <panic>
      panic("dirlookup read");
    80002ffa:	00005517          	auipc	a0,0x5
    80002ffe:	5a650513          	addi	a0,a0,1446 # 800085a0 <syscalls+0x1c0>
    80003002:	00003097          	auipc	ra,0x3
    80003006:	b4e080e7          	jalr	-1202(ra) # 80005b50 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000300a:	24c1                	addiw	s1,s1,16
    8000300c:	04c92783          	lw	a5,76(s2)
    80003010:	04f4f763          	bgeu	s1,a5,8000305e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003014:	4741                	li	a4,16
    80003016:	86a6                	mv	a3,s1
    80003018:	fc040613          	addi	a2,s0,-64
    8000301c:	4581                	li	a1,0
    8000301e:	854a                	mv	a0,s2
    80003020:	00000097          	auipc	ra,0x0
    80003024:	d70080e7          	jalr	-656(ra) # 80002d90 <readi>
    80003028:	47c1                	li	a5,16
    8000302a:	fcf518e3          	bne	a0,a5,80002ffa <dirlookup+0x3a>
    if(de.inum == 0)
    8000302e:	fc045783          	lhu	a5,-64(s0)
    80003032:	dfe1                	beqz	a5,8000300a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003034:	fc240593          	addi	a1,s0,-62
    80003038:	854e                	mv	a0,s3
    8000303a:	00000097          	auipc	ra,0x0
    8000303e:	f6c080e7          	jalr	-148(ra) # 80002fa6 <namecmp>
    80003042:	f561                	bnez	a0,8000300a <dirlookup+0x4a>
      if(poff)
    80003044:	000a0463          	beqz	s4,8000304c <dirlookup+0x8c>
        *poff = off;
    80003048:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000304c:	fc045583          	lhu	a1,-64(s0)
    80003050:	00092503          	lw	a0,0(s2)
    80003054:	fffff097          	auipc	ra,0xfffff
    80003058:	752080e7          	jalr	1874(ra) # 800027a6 <iget>
    8000305c:	a011                	j	80003060 <dirlookup+0xa0>
  return 0;
    8000305e:	4501                	li	a0,0
}
    80003060:	70e2                	ld	ra,56(sp)
    80003062:	7442                	ld	s0,48(sp)
    80003064:	74a2                	ld	s1,40(sp)
    80003066:	7902                	ld	s2,32(sp)
    80003068:	69e2                	ld	s3,24(sp)
    8000306a:	6a42                	ld	s4,16(sp)
    8000306c:	6121                	addi	sp,sp,64
    8000306e:	8082                	ret

0000000080003070 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003070:	711d                	addi	sp,sp,-96
    80003072:	ec86                	sd	ra,88(sp)
    80003074:	e8a2                	sd	s0,80(sp)
    80003076:	e4a6                	sd	s1,72(sp)
    80003078:	e0ca                	sd	s2,64(sp)
    8000307a:	fc4e                	sd	s3,56(sp)
    8000307c:	f852                	sd	s4,48(sp)
    8000307e:	f456                	sd	s5,40(sp)
    80003080:	f05a                	sd	s6,32(sp)
    80003082:	ec5e                	sd	s7,24(sp)
    80003084:	e862                	sd	s8,16(sp)
    80003086:	e466                	sd	s9,8(sp)
    80003088:	e06a                	sd	s10,0(sp)
    8000308a:	1080                	addi	s0,sp,96
    8000308c:	84aa                	mv	s1,a0
    8000308e:	8b2e                	mv	s6,a1
    80003090:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003092:	00054703          	lbu	a4,0(a0)
    80003096:	02f00793          	li	a5,47
    8000309a:	02f70363          	beq	a4,a5,800030c0 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000309e:	ffffe097          	auipc	ra,0xffffe
    800030a2:	da6080e7          	jalr	-602(ra) # 80000e44 <myproc>
    800030a6:	15053503          	ld	a0,336(a0)
    800030aa:	00000097          	auipc	ra,0x0
    800030ae:	9f4080e7          	jalr	-1548(ra) # 80002a9e <idup>
    800030b2:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030b4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030b8:	4cb5                	li	s9,13
  len = path - s;
    800030ba:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030bc:	4c05                	li	s8,1
    800030be:	a87d                	j	8000317c <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800030c0:	4585                	li	a1,1
    800030c2:	4505                	li	a0,1
    800030c4:	fffff097          	auipc	ra,0xfffff
    800030c8:	6e2080e7          	jalr	1762(ra) # 800027a6 <iget>
    800030cc:	8a2a                	mv	s4,a0
    800030ce:	b7dd                	j	800030b4 <namex+0x44>
      iunlockput(ip);
    800030d0:	8552                	mv	a0,s4
    800030d2:	00000097          	auipc	ra,0x0
    800030d6:	c6c080e7          	jalr	-916(ra) # 80002d3e <iunlockput>
      return 0;
    800030da:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030dc:	8552                	mv	a0,s4
    800030de:	60e6                	ld	ra,88(sp)
    800030e0:	6446                	ld	s0,80(sp)
    800030e2:	64a6                	ld	s1,72(sp)
    800030e4:	6906                	ld	s2,64(sp)
    800030e6:	79e2                	ld	s3,56(sp)
    800030e8:	7a42                	ld	s4,48(sp)
    800030ea:	7aa2                	ld	s5,40(sp)
    800030ec:	7b02                	ld	s6,32(sp)
    800030ee:	6be2                	ld	s7,24(sp)
    800030f0:	6c42                	ld	s8,16(sp)
    800030f2:	6ca2                	ld	s9,8(sp)
    800030f4:	6d02                	ld	s10,0(sp)
    800030f6:	6125                	addi	sp,sp,96
    800030f8:	8082                	ret
      iunlock(ip);
    800030fa:	8552                	mv	a0,s4
    800030fc:	00000097          	auipc	ra,0x0
    80003100:	aa2080e7          	jalr	-1374(ra) # 80002b9e <iunlock>
      return ip;
    80003104:	bfe1                	j	800030dc <namex+0x6c>
      iunlockput(ip);
    80003106:	8552                	mv	a0,s4
    80003108:	00000097          	auipc	ra,0x0
    8000310c:	c36080e7          	jalr	-970(ra) # 80002d3e <iunlockput>
      return 0;
    80003110:	8a4e                	mv	s4,s3
    80003112:	b7e9                	j	800030dc <namex+0x6c>
  len = path - s;
    80003114:	40998633          	sub	a2,s3,s1
    80003118:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000311c:	09acd863          	bge	s9,s10,800031ac <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003120:	4639                	li	a2,14
    80003122:	85a6                	mv	a1,s1
    80003124:	8556                	mv	a0,s5
    80003126:	ffffd097          	auipc	ra,0xffffd
    8000312a:	0b0080e7          	jalr	176(ra) # 800001d6 <memmove>
    8000312e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003130:	0004c783          	lbu	a5,0(s1)
    80003134:	01279763          	bne	a5,s2,80003142 <namex+0xd2>
    path++;
    80003138:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000313a:	0004c783          	lbu	a5,0(s1)
    8000313e:	ff278de3          	beq	a5,s2,80003138 <namex+0xc8>
    ilock(ip);
    80003142:	8552                	mv	a0,s4
    80003144:	00000097          	auipc	ra,0x0
    80003148:	998080e7          	jalr	-1640(ra) # 80002adc <ilock>
    if(ip->type != T_DIR){
    8000314c:	044a1783          	lh	a5,68(s4)
    80003150:	f98790e3          	bne	a5,s8,800030d0 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003154:	000b0563          	beqz	s6,8000315e <namex+0xee>
    80003158:	0004c783          	lbu	a5,0(s1)
    8000315c:	dfd9                	beqz	a5,800030fa <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000315e:	865e                	mv	a2,s7
    80003160:	85d6                	mv	a1,s5
    80003162:	8552                	mv	a0,s4
    80003164:	00000097          	auipc	ra,0x0
    80003168:	e5c080e7          	jalr	-420(ra) # 80002fc0 <dirlookup>
    8000316c:	89aa                	mv	s3,a0
    8000316e:	dd41                	beqz	a0,80003106 <namex+0x96>
    iunlockput(ip);
    80003170:	8552                	mv	a0,s4
    80003172:	00000097          	auipc	ra,0x0
    80003176:	bcc080e7          	jalr	-1076(ra) # 80002d3e <iunlockput>
    ip = next;
    8000317a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000317c:	0004c783          	lbu	a5,0(s1)
    80003180:	01279763          	bne	a5,s2,8000318e <namex+0x11e>
    path++;
    80003184:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003186:	0004c783          	lbu	a5,0(s1)
    8000318a:	ff278de3          	beq	a5,s2,80003184 <namex+0x114>
  if(*path == 0)
    8000318e:	cb9d                	beqz	a5,800031c4 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003190:	0004c783          	lbu	a5,0(s1)
    80003194:	89a6                	mv	s3,s1
  len = path - s;
    80003196:	8d5e                	mv	s10,s7
    80003198:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000319a:	01278963          	beq	a5,s2,800031ac <namex+0x13c>
    8000319e:	dbbd                	beqz	a5,80003114 <namex+0xa4>
    path++;
    800031a0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800031a2:	0009c783          	lbu	a5,0(s3)
    800031a6:	ff279ce3          	bne	a5,s2,8000319e <namex+0x12e>
    800031aa:	b7ad                	j	80003114 <namex+0xa4>
    memmove(name, s, len);
    800031ac:	2601                	sext.w	a2,a2
    800031ae:	85a6                	mv	a1,s1
    800031b0:	8556                	mv	a0,s5
    800031b2:	ffffd097          	auipc	ra,0xffffd
    800031b6:	024080e7          	jalr	36(ra) # 800001d6 <memmove>
    name[len] = 0;
    800031ba:	9d56                	add	s10,s10,s5
    800031bc:	000d0023          	sb	zero,0(s10)
    800031c0:	84ce                	mv	s1,s3
    800031c2:	b7bd                	j	80003130 <namex+0xc0>
  if(nameiparent){
    800031c4:	f00b0ce3          	beqz	s6,800030dc <namex+0x6c>
    iput(ip);
    800031c8:	8552                	mv	a0,s4
    800031ca:	00000097          	auipc	ra,0x0
    800031ce:	acc080e7          	jalr	-1332(ra) # 80002c96 <iput>
    return 0;
    800031d2:	4a01                	li	s4,0
    800031d4:	b721                	j	800030dc <namex+0x6c>

00000000800031d6 <dirlink>:
{
    800031d6:	7139                	addi	sp,sp,-64
    800031d8:	fc06                	sd	ra,56(sp)
    800031da:	f822                	sd	s0,48(sp)
    800031dc:	f426                	sd	s1,40(sp)
    800031de:	f04a                	sd	s2,32(sp)
    800031e0:	ec4e                	sd	s3,24(sp)
    800031e2:	e852                	sd	s4,16(sp)
    800031e4:	0080                	addi	s0,sp,64
    800031e6:	892a                	mv	s2,a0
    800031e8:	8a2e                	mv	s4,a1
    800031ea:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031ec:	4601                	li	a2,0
    800031ee:	00000097          	auipc	ra,0x0
    800031f2:	dd2080e7          	jalr	-558(ra) # 80002fc0 <dirlookup>
    800031f6:	e93d                	bnez	a0,8000326c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f8:	04c92483          	lw	s1,76(s2)
    800031fc:	c49d                	beqz	s1,8000322a <dirlink+0x54>
    800031fe:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003200:	4741                	li	a4,16
    80003202:	86a6                	mv	a3,s1
    80003204:	fc040613          	addi	a2,s0,-64
    80003208:	4581                	li	a1,0
    8000320a:	854a                	mv	a0,s2
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	b84080e7          	jalr	-1148(ra) # 80002d90 <readi>
    80003214:	47c1                	li	a5,16
    80003216:	06f51163          	bne	a0,a5,80003278 <dirlink+0xa2>
    if(de.inum == 0)
    8000321a:	fc045783          	lhu	a5,-64(s0)
    8000321e:	c791                	beqz	a5,8000322a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003220:	24c1                	addiw	s1,s1,16
    80003222:	04c92783          	lw	a5,76(s2)
    80003226:	fcf4ede3          	bltu	s1,a5,80003200 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000322a:	4639                	li	a2,14
    8000322c:	85d2                	mv	a1,s4
    8000322e:	fc240513          	addi	a0,s0,-62
    80003232:	ffffd097          	auipc	ra,0xffffd
    80003236:	054080e7          	jalr	84(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000323a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000323e:	4741                	li	a4,16
    80003240:	86a6                	mv	a3,s1
    80003242:	fc040613          	addi	a2,s0,-64
    80003246:	4581                	li	a1,0
    80003248:	854a                	mv	a0,s2
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	c3e080e7          	jalr	-962(ra) # 80002e88 <writei>
    80003252:	872a                	mv	a4,a0
    80003254:	47c1                	li	a5,16
  return 0;
    80003256:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003258:	02f71863          	bne	a4,a5,80003288 <dirlink+0xb2>
}
    8000325c:	70e2                	ld	ra,56(sp)
    8000325e:	7442                	ld	s0,48(sp)
    80003260:	74a2                	ld	s1,40(sp)
    80003262:	7902                	ld	s2,32(sp)
    80003264:	69e2                	ld	s3,24(sp)
    80003266:	6a42                	ld	s4,16(sp)
    80003268:	6121                	addi	sp,sp,64
    8000326a:	8082                	ret
    iput(ip);
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	a2a080e7          	jalr	-1494(ra) # 80002c96 <iput>
    return -1;
    80003274:	557d                	li	a0,-1
    80003276:	b7dd                	j	8000325c <dirlink+0x86>
      panic("dirlink read");
    80003278:	00005517          	auipc	a0,0x5
    8000327c:	33850513          	addi	a0,a0,824 # 800085b0 <syscalls+0x1d0>
    80003280:	00003097          	auipc	ra,0x3
    80003284:	8d0080e7          	jalr	-1840(ra) # 80005b50 <panic>
    panic("dirlink");
    80003288:	00005517          	auipc	a0,0x5
    8000328c:	43850513          	addi	a0,a0,1080 # 800086c0 <syscalls+0x2e0>
    80003290:	00003097          	auipc	ra,0x3
    80003294:	8c0080e7          	jalr	-1856(ra) # 80005b50 <panic>

0000000080003298 <namei>:

struct inode*
namei(char *path)
{
    80003298:	1101                	addi	sp,sp,-32
    8000329a:	ec06                	sd	ra,24(sp)
    8000329c:	e822                	sd	s0,16(sp)
    8000329e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032a0:	fe040613          	addi	a2,s0,-32
    800032a4:	4581                	li	a1,0
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	dca080e7          	jalr	-566(ra) # 80003070 <namex>
}
    800032ae:	60e2                	ld	ra,24(sp)
    800032b0:	6442                	ld	s0,16(sp)
    800032b2:	6105                	addi	sp,sp,32
    800032b4:	8082                	ret

00000000800032b6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032b6:	1141                	addi	sp,sp,-16
    800032b8:	e406                	sd	ra,8(sp)
    800032ba:	e022                	sd	s0,0(sp)
    800032bc:	0800                	addi	s0,sp,16
    800032be:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032c0:	4585                	li	a1,1
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	dae080e7          	jalr	-594(ra) # 80003070 <namex>
}
    800032ca:	60a2                	ld	ra,8(sp)
    800032cc:	6402                	ld	s0,0(sp)
    800032ce:	0141                	addi	sp,sp,16
    800032d0:	8082                	ret

00000000800032d2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032d2:	1101                	addi	sp,sp,-32
    800032d4:	ec06                	sd	ra,24(sp)
    800032d6:	e822                	sd	s0,16(sp)
    800032d8:	e426                	sd	s1,8(sp)
    800032da:	e04a                	sd	s2,0(sp)
    800032dc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032de:	00016917          	auipc	s2,0x16
    800032e2:	f4290913          	addi	s2,s2,-190 # 80019220 <log>
    800032e6:	01892583          	lw	a1,24(s2)
    800032ea:	02892503          	lw	a0,40(s2)
    800032ee:	fffff097          	auipc	ra,0xfffff
    800032f2:	fec080e7          	jalr	-20(ra) # 800022da <bread>
    800032f6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032f8:	02c92683          	lw	a3,44(s2)
    800032fc:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032fe:	02d05863          	blez	a3,8000332e <write_head+0x5c>
    80003302:	00016797          	auipc	a5,0x16
    80003306:	f4e78793          	addi	a5,a5,-178 # 80019250 <log+0x30>
    8000330a:	05c50713          	addi	a4,a0,92
    8000330e:	36fd                	addiw	a3,a3,-1
    80003310:	02069613          	slli	a2,a3,0x20
    80003314:	01e65693          	srli	a3,a2,0x1e
    80003318:	00016617          	auipc	a2,0x16
    8000331c:	f3c60613          	addi	a2,a2,-196 # 80019254 <log+0x34>
    80003320:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003322:	4390                	lw	a2,0(a5)
    80003324:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003326:	0791                	addi	a5,a5,4
    80003328:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000332a:	fed79ce3          	bne	a5,a3,80003322 <write_head+0x50>
  }
  bwrite(buf);
    8000332e:	8526                	mv	a0,s1
    80003330:	fffff097          	auipc	ra,0xfffff
    80003334:	09c080e7          	jalr	156(ra) # 800023cc <bwrite>
  brelse(buf);
    80003338:	8526                	mv	a0,s1
    8000333a:	fffff097          	auipc	ra,0xfffff
    8000333e:	0d0080e7          	jalr	208(ra) # 8000240a <brelse>
}
    80003342:	60e2                	ld	ra,24(sp)
    80003344:	6442                	ld	s0,16(sp)
    80003346:	64a2                	ld	s1,8(sp)
    80003348:	6902                	ld	s2,0(sp)
    8000334a:	6105                	addi	sp,sp,32
    8000334c:	8082                	ret

000000008000334e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000334e:	00016797          	auipc	a5,0x16
    80003352:	efe7a783          	lw	a5,-258(a5) # 8001924c <log+0x2c>
    80003356:	0af05d63          	blez	a5,80003410 <install_trans+0xc2>
{
    8000335a:	7139                	addi	sp,sp,-64
    8000335c:	fc06                	sd	ra,56(sp)
    8000335e:	f822                	sd	s0,48(sp)
    80003360:	f426                	sd	s1,40(sp)
    80003362:	f04a                	sd	s2,32(sp)
    80003364:	ec4e                	sd	s3,24(sp)
    80003366:	e852                	sd	s4,16(sp)
    80003368:	e456                	sd	s5,8(sp)
    8000336a:	e05a                	sd	s6,0(sp)
    8000336c:	0080                	addi	s0,sp,64
    8000336e:	8b2a                	mv	s6,a0
    80003370:	00016a97          	auipc	s5,0x16
    80003374:	ee0a8a93          	addi	s5,s5,-288 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003378:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000337a:	00016997          	auipc	s3,0x16
    8000337e:	ea698993          	addi	s3,s3,-346 # 80019220 <log>
    80003382:	a00d                	j	800033a4 <install_trans+0x56>
    brelse(lbuf);
    80003384:	854a                	mv	a0,s2
    80003386:	fffff097          	auipc	ra,0xfffff
    8000338a:	084080e7          	jalr	132(ra) # 8000240a <brelse>
    brelse(dbuf);
    8000338e:	8526                	mv	a0,s1
    80003390:	fffff097          	auipc	ra,0xfffff
    80003394:	07a080e7          	jalr	122(ra) # 8000240a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003398:	2a05                	addiw	s4,s4,1
    8000339a:	0a91                	addi	s5,s5,4
    8000339c:	02c9a783          	lw	a5,44(s3)
    800033a0:	04fa5e63          	bge	s4,a5,800033fc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033a4:	0189a583          	lw	a1,24(s3)
    800033a8:	014585bb          	addw	a1,a1,s4
    800033ac:	2585                	addiw	a1,a1,1
    800033ae:	0289a503          	lw	a0,40(s3)
    800033b2:	fffff097          	auipc	ra,0xfffff
    800033b6:	f28080e7          	jalr	-216(ra) # 800022da <bread>
    800033ba:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033bc:	000aa583          	lw	a1,0(s5)
    800033c0:	0289a503          	lw	a0,40(s3)
    800033c4:	fffff097          	auipc	ra,0xfffff
    800033c8:	f16080e7          	jalr	-234(ra) # 800022da <bread>
    800033cc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033ce:	40000613          	li	a2,1024
    800033d2:	05890593          	addi	a1,s2,88
    800033d6:	05850513          	addi	a0,a0,88
    800033da:	ffffd097          	auipc	ra,0xffffd
    800033de:	dfc080e7          	jalr	-516(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033e2:	8526                	mv	a0,s1
    800033e4:	fffff097          	auipc	ra,0xfffff
    800033e8:	fe8080e7          	jalr	-24(ra) # 800023cc <bwrite>
    if(recovering == 0)
    800033ec:	f80b1ce3          	bnez	s6,80003384 <install_trans+0x36>
      bunpin(dbuf);
    800033f0:	8526                	mv	a0,s1
    800033f2:	fffff097          	auipc	ra,0xfffff
    800033f6:	0f2080e7          	jalr	242(ra) # 800024e4 <bunpin>
    800033fa:	b769                	j	80003384 <install_trans+0x36>
}
    800033fc:	70e2                	ld	ra,56(sp)
    800033fe:	7442                	ld	s0,48(sp)
    80003400:	74a2                	ld	s1,40(sp)
    80003402:	7902                	ld	s2,32(sp)
    80003404:	69e2                	ld	s3,24(sp)
    80003406:	6a42                	ld	s4,16(sp)
    80003408:	6aa2                	ld	s5,8(sp)
    8000340a:	6b02                	ld	s6,0(sp)
    8000340c:	6121                	addi	sp,sp,64
    8000340e:	8082                	ret
    80003410:	8082                	ret

0000000080003412 <initlog>:
{
    80003412:	7179                	addi	sp,sp,-48
    80003414:	f406                	sd	ra,40(sp)
    80003416:	f022                	sd	s0,32(sp)
    80003418:	ec26                	sd	s1,24(sp)
    8000341a:	e84a                	sd	s2,16(sp)
    8000341c:	e44e                	sd	s3,8(sp)
    8000341e:	1800                	addi	s0,sp,48
    80003420:	892a                	mv	s2,a0
    80003422:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003424:	00016497          	auipc	s1,0x16
    80003428:	dfc48493          	addi	s1,s1,-516 # 80019220 <log>
    8000342c:	00005597          	auipc	a1,0x5
    80003430:	19458593          	addi	a1,a1,404 # 800085c0 <syscalls+0x1e0>
    80003434:	8526                	mv	a0,s1
    80003436:	00003097          	auipc	ra,0x3
    8000343a:	bc2080e7          	jalr	-1086(ra) # 80005ff8 <initlock>
  log.start = sb->logstart;
    8000343e:	0149a583          	lw	a1,20(s3)
    80003442:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003444:	0109a783          	lw	a5,16(s3)
    80003448:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000344a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000344e:	854a                	mv	a0,s2
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	e8a080e7          	jalr	-374(ra) # 800022da <bread>
  log.lh.n = lh->n;
    80003458:	4d34                	lw	a3,88(a0)
    8000345a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000345c:	02d05663          	blez	a3,80003488 <initlog+0x76>
    80003460:	05c50793          	addi	a5,a0,92
    80003464:	00016717          	auipc	a4,0x16
    80003468:	dec70713          	addi	a4,a4,-532 # 80019250 <log+0x30>
    8000346c:	36fd                	addiw	a3,a3,-1
    8000346e:	02069613          	slli	a2,a3,0x20
    80003472:	01e65693          	srli	a3,a2,0x1e
    80003476:	06050613          	addi	a2,a0,96
    8000347a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000347c:	4390                	lw	a2,0(a5)
    8000347e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003480:	0791                	addi	a5,a5,4
    80003482:	0711                	addi	a4,a4,4
    80003484:	fed79ce3          	bne	a5,a3,8000347c <initlog+0x6a>
  brelse(buf);
    80003488:	fffff097          	auipc	ra,0xfffff
    8000348c:	f82080e7          	jalr	-126(ra) # 8000240a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003490:	4505                	li	a0,1
    80003492:	00000097          	auipc	ra,0x0
    80003496:	ebc080e7          	jalr	-324(ra) # 8000334e <install_trans>
  log.lh.n = 0;
    8000349a:	00016797          	auipc	a5,0x16
    8000349e:	da07a923          	sw	zero,-590(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800034a2:	00000097          	auipc	ra,0x0
    800034a6:	e30080e7          	jalr	-464(ra) # 800032d2 <write_head>
}
    800034aa:	70a2                	ld	ra,40(sp)
    800034ac:	7402                	ld	s0,32(sp)
    800034ae:	64e2                	ld	s1,24(sp)
    800034b0:	6942                	ld	s2,16(sp)
    800034b2:	69a2                	ld	s3,8(sp)
    800034b4:	6145                	addi	sp,sp,48
    800034b6:	8082                	ret

00000000800034b8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034b8:	1101                	addi	sp,sp,-32
    800034ba:	ec06                	sd	ra,24(sp)
    800034bc:	e822                	sd	s0,16(sp)
    800034be:	e426                	sd	s1,8(sp)
    800034c0:	e04a                	sd	s2,0(sp)
    800034c2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034c4:	00016517          	auipc	a0,0x16
    800034c8:	d5c50513          	addi	a0,a0,-676 # 80019220 <log>
    800034cc:	00003097          	auipc	ra,0x3
    800034d0:	bbc080e7          	jalr	-1092(ra) # 80006088 <acquire>
  while(1){
    if(log.committing){
    800034d4:	00016497          	auipc	s1,0x16
    800034d8:	d4c48493          	addi	s1,s1,-692 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034dc:	4979                	li	s2,30
    800034de:	a039                	j	800034ec <begin_op+0x34>
      sleep(&log, &log.lock);
    800034e0:	85a6                	mv	a1,s1
    800034e2:	8526                	mv	a0,s1
    800034e4:	ffffe097          	auipc	ra,0xffffe
    800034e8:	02c080e7          	jalr	44(ra) # 80001510 <sleep>
    if(log.committing){
    800034ec:	50dc                	lw	a5,36(s1)
    800034ee:	fbed                	bnez	a5,800034e0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034f0:	5098                	lw	a4,32(s1)
    800034f2:	2705                	addiw	a4,a4,1
    800034f4:	0007069b          	sext.w	a3,a4
    800034f8:	0027179b          	slliw	a5,a4,0x2
    800034fc:	9fb9                	addw	a5,a5,a4
    800034fe:	0017979b          	slliw	a5,a5,0x1
    80003502:	54d8                	lw	a4,44(s1)
    80003504:	9fb9                	addw	a5,a5,a4
    80003506:	00f95963          	bge	s2,a5,80003518 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000350a:	85a6                	mv	a1,s1
    8000350c:	8526                	mv	a0,s1
    8000350e:	ffffe097          	auipc	ra,0xffffe
    80003512:	002080e7          	jalr	2(ra) # 80001510 <sleep>
    80003516:	bfd9                	j	800034ec <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003518:	00016517          	auipc	a0,0x16
    8000351c:	d0850513          	addi	a0,a0,-760 # 80019220 <log>
    80003520:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003522:	00003097          	auipc	ra,0x3
    80003526:	c1a080e7          	jalr	-998(ra) # 8000613c <release>
      break;
    }
  }
}
    8000352a:	60e2                	ld	ra,24(sp)
    8000352c:	6442                	ld	s0,16(sp)
    8000352e:	64a2                	ld	s1,8(sp)
    80003530:	6902                	ld	s2,0(sp)
    80003532:	6105                	addi	sp,sp,32
    80003534:	8082                	ret

0000000080003536 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003536:	7139                	addi	sp,sp,-64
    80003538:	fc06                	sd	ra,56(sp)
    8000353a:	f822                	sd	s0,48(sp)
    8000353c:	f426                	sd	s1,40(sp)
    8000353e:	f04a                	sd	s2,32(sp)
    80003540:	ec4e                	sd	s3,24(sp)
    80003542:	e852                	sd	s4,16(sp)
    80003544:	e456                	sd	s5,8(sp)
    80003546:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003548:	00016497          	auipc	s1,0x16
    8000354c:	cd848493          	addi	s1,s1,-808 # 80019220 <log>
    80003550:	8526                	mv	a0,s1
    80003552:	00003097          	auipc	ra,0x3
    80003556:	b36080e7          	jalr	-1226(ra) # 80006088 <acquire>
  log.outstanding -= 1;
    8000355a:	509c                	lw	a5,32(s1)
    8000355c:	37fd                	addiw	a5,a5,-1
    8000355e:	0007891b          	sext.w	s2,a5
    80003562:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003564:	50dc                	lw	a5,36(s1)
    80003566:	e7b9                	bnez	a5,800035b4 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003568:	04091e63          	bnez	s2,800035c4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000356c:	00016497          	auipc	s1,0x16
    80003570:	cb448493          	addi	s1,s1,-844 # 80019220 <log>
    80003574:	4785                	li	a5,1
    80003576:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003578:	8526                	mv	a0,s1
    8000357a:	00003097          	auipc	ra,0x3
    8000357e:	bc2080e7          	jalr	-1086(ra) # 8000613c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003582:	54dc                	lw	a5,44(s1)
    80003584:	06f04763          	bgtz	a5,800035f2 <end_op+0xbc>
    acquire(&log.lock);
    80003588:	00016497          	auipc	s1,0x16
    8000358c:	c9848493          	addi	s1,s1,-872 # 80019220 <log>
    80003590:	8526                	mv	a0,s1
    80003592:	00003097          	auipc	ra,0x3
    80003596:	af6080e7          	jalr	-1290(ra) # 80006088 <acquire>
    log.committing = 0;
    8000359a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000359e:	8526                	mv	a0,s1
    800035a0:	ffffe097          	auipc	ra,0xffffe
    800035a4:	0fc080e7          	jalr	252(ra) # 8000169c <wakeup>
    release(&log.lock);
    800035a8:	8526                	mv	a0,s1
    800035aa:	00003097          	auipc	ra,0x3
    800035ae:	b92080e7          	jalr	-1134(ra) # 8000613c <release>
}
    800035b2:	a03d                	j	800035e0 <end_op+0xaa>
    panic("log.committing");
    800035b4:	00005517          	auipc	a0,0x5
    800035b8:	01450513          	addi	a0,a0,20 # 800085c8 <syscalls+0x1e8>
    800035bc:	00002097          	auipc	ra,0x2
    800035c0:	594080e7          	jalr	1428(ra) # 80005b50 <panic>
    wakeup(&log);
    800035c4:	00016497          	auipc	s1,0x16
    800035c8:	c5c48493          	addi	s1,s1,-932 # 80019220 <log>
    800035cc:	8526                	mv	a0,s1
    800035ce:	ffffe097          	auipc	ra,0xffffe
    800035d2:	0ce080e7          	jalr	206(ra) # 8000169c <wakeup>
  release(&log.lock);
    800035d6:	8526                	mv	a0,s1
    800035d8:	00003097          	auipc	ra,0x3
    800035dc:	b64080e7          	jalr	-1180(ra) # 8000613c <release>
}
    800035e0:	70e2                	ld	ra,56(sp)
    800035e2:	7442                	ld	s0,48(sp)
    800035e4:	74a2                	ld	s1,40(sp)
    800035e6:	7902                	ld	s2,32(sp)
    800035e8:	69e2                	ld	s3,24(sp)
    800035ea:	6a42                	ld	s4,16(sp)
    800035ec:	6aa2                	ld	s5,8(sp)
    800035ee:	6121                	addi	sp,sp,64
    800035f0:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f2:	00016a97          	auipc	s5,0x16
    800035f6:	c5ea8a93          	addi	s5,s5,-930 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035fa:	00016a17          	auipc	s4,0x16
    800035fe:	c26a0a13          	addi	s4,s4,-986 # 80019220 <log>
    80003602:	018a2583          	lw	a1,24(s4)
    80003606:	012585bb          	addw	a1,a1,s2
    8000360a:	2585                	addiw	a1,a1,1
    8000360c:	028a2503          	lw	a0,40(s4)
    80003610:	fffff097          	auipc	ra,0xfffff
    80003614:	cca080e7          	jalr	-822(ra) # 800022da <bread>
    80003618:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000361a:	000aa583          	lw	a1,0(s5)
    8000361e:	028a2503          	lw	a0,40(s4)
    80003622:	fffff097          	auipc	ra,0xfffff
    80003626:	cb8080e7          	jalr	-840(ra) # 800022da <bread>
    8000362a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000362c:	40000613          	li	a2,1024
    80003630:	05850593          	addi	a1,a0,88
    80003634:	05848513          	addi	a0,s1,88
    80003638:	ffffd097          	auipc	ra,0xffffd
    8000363c:	b9e080e7          	jalr	-1122(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003640:	8526                	mv	a0,s1
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	d8a080e7          	jalr	-630(ra) # 800023cc <bwrite>
    brelse(from);
    8000364a:	854e                	mv	a0,s3
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	dbe080e7          	jalr	-578(ra) # 8000240a <brelse>
    brelse(to);
    80003654:	8526                	mv	a0,s1
    80003656:	fffff097          	auipc	ra,0xfffff
    8000365a:	db4080e7          	jalr	-588(ra) # 8000240a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000365e:	2905                	addiw	s2,s2,1
    80003660:	0a91                	addi	s5,s5,4
    80003662:	02ca2783          	lw	a5,44(s4)
    80003666:	f8f94ee3          	blt	s2,a5,80003602 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000366a:	00000097          	auipc	ra,0x0
    8000366e:	c68080e7          	jalr	-920(ra) # 800032d2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003672:	4501                	li	a0,0
    80003674:	00000097          	auipc	ra,0x0
    80003678:	cda080e7          	jalr	-806(ra) # 8000334e <install_trans>
    log.lh.n = 0;
    8000367c:	00016797          	auipc	a5,0x16
    80003680:	bc07a823          	sw	zero,-1072(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003684:	00000097          	auipc	ra,0x0
    80003688:	c4e080e7          	jalr	-946(ra) # 800032d2 <write_head>
    8000368c:	bdf5                	j	80003588 <end_op+0x52>

000000008000368e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000368e:	1101                	addi	sp,sp,-32
    80003690:	ec06                	sd	ra,24(sp)
    80003692:	e822                	sd	s0,16(sp)
    80003694:	e426                	sd	s1,8(sp)
    80003696:	e04a                	sd	s2,0(sp)
    80003698:	1000                	addi	s0,sp,32
    8000369a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000369c:	00016917          	auipc	s2,0x16
    800036a0:	b8490913          	addi	s2,s2,-1148 # 80019220 <log>
    800036a4:	854a                	mv	a0,s2
    800036a6:	00003097          	auipc	ra,0x3
    800036aa:	9e2080e7          	jalr	-1566(ra) # 80006088 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036ae:	02c92603          	lw	a2,44(s2)
    800036b2:	47f5                	li	a5,29
    800036b4:	06c7c563          	blt	a5,a2,8000371e <log_write+0x90>
    800036b8:	00016797          	auipc	a5,0x16
    800036bc:	b847a783          	lw	a5,-1148(a5) # 8001923c <log+0x1c>
    800036c0:	37fd                	addiw	a5,a5,-1
    800036c2:	04f65e63          	bge	a2,a5,8000371e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036c6:	00016797          	auipc	a5,0x16
    800036ca:	b7a7a783          	lw	a5,-1158(a5) # 80019240 <log+0x20>
    800036ce:	06f05063          	blez	a5,8000372e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036d2:	4781                	li	a5,0
    800036d4:	06c05563          	blez	a2,8000373e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036d8:	44cc                	lw	a1,12(s1)
    800036da:	00016717          	auipc	a4,0x16
    800036de:	b7670713          	addi	a4,a4,-1162 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036e2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036e4:	4314                	lw	a3,0(a4)
    800036e6:	04b68c63          	beq	a3,a1,8000373e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036ea:	2785                	addiw	a5,a5,1
    800036ec:	0711                	addi	a4,a4,4
    800036ee:	fef61be3          	bne	a2,a5,800036e4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036f2:	0621                	addi	a2,a2,8
    800036f4:	060a                	slli	a2,a2,0x2
    800036f6:	00016797          	auipc	a5,0x16
    800036fa:	b2a78793          	addi	a5,a5,-1238 # 80019220 <log>
    800036fe:	97b2                	add	a5,a5,a2
    80003700:	44d8                	lw	a4,12(s1)
    80003702:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003704:	8526                	mv	a0,s1
    80003706:	fffff097          	auipc	ra,0xfffff
    8000370a:	da2080e7          	jalr	-606(ra) # 800024a8 <bpin>
    log.lh.n++;
    8000370e:	00016717          	auipc	a4,0x16
    80003712:	b1270713          	addi	a4,a4,-1262 # 80019220 <log>
    80003716:	575c                	lw	a5,44(a4)
    80003718:	2785                	addiw	a5,a5,1
    8000371a:	d75c                	sw	a5,44(a4)
    8000371c:	a82d                	j	80003756 <log_write+0xc8>
    panic("too big a transaction");
    8000371e:	00005517          	auipc	a0,0x5
    80003722:	eba50513          	addi	a0,a0,-326 # 800085d8 <syscalls+0x1f8>
    80003726:	00002097          	auipc	ra,0x2
    8000372a:	42a080e7          	jalr	1066(ra) # 80005b50 <panic>
    panic("log_write outside of trans");
    8000372e:	00005517          	auipc	a0,0x5
    80003732:	ec250513          	addi	a0,a0,-318 # 800085f0 <syscalls+0x210>
    80003736:	00002097          	auipc	ra,0x2
    8000373a:	41a080e7          	jalr	1050(ra) # 80005b50 <panic>
  log.lh.block[i] = b->blockno;
    8000373e:	00878693          	addi	a3,a5,8
    80003742:	068a                	slli	a3,a3,0x2
    80003744:	00016717          	auipc	a4,0x16
    80003748:	adc70713          	addi	a4,a4,-1316 # 80019220 <log>
    8000374c:	9736                	add	a4,a4,a3
    8000374e:	44d4                	lw	a3,12(s1)
    80003750:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003752:	faf609e3          	beq	a2,a5,80003704 <log_write+0x76>
  }
  release(&log.lock);
    80003756:	00016517          	auipc	a0,0x16
    8000375a:	aca50513          	addi	a0,a0,-1334 # 80019220 <log>
    8000375e:	00003097          	auipc	ra,0x3
    80003762:	9de080e7          	jalr	-1570(ra) # 8000613c <release>
}
    80003766:	60e2                	ld	ra,24(sp)
    80003768:	6442                	ld	s0,16(sp)
    8000376a:	64a2                	ld	s1,8(sp)
    8000376c:	6902                	ld	s2,0(sp)
    8000376e:	6105                	addi	sp,sp,32
    80003770:	8082                	ret

0000000080003772 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003772:	1101                	addi	sp,sp,-32
    80003774:	ec06                	sd	ra,24(sp)
    80003776:	e822                	sd	s0,16(sp)
    80003778:	e426                	sd	s1,8(sp)
    8000377a:	e04a                	sd	s2,0(sp)
    8000377c:	1000                	addi	s0,sp,32
    8000377e:	84aa                	mv	s1,a0
    80003780:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003782:	00005597          	auipc	a1,0x5
    80003786:	e8e58593          	addi	a1,a1,-370 # 80008610 <syscalls+0x230>
    8000378a:	0521                	addi	a0,a0,8
    8000378c:	00003097          	auipc	ra,0x3
    80003790:	86c080e7          	jalr	-1940(ra) # 80005ff8 <initlock>
  lk->name = name;
    80003794:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003798:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000379c:	0204a423          	sw	zero,40(s1)
}
    800037a0:	60e2                	ld	ra,24(sp)
    800037a2:	6442                	ld	s0,16(sp)
    800037a4:	64a2                	ld	s1,8(sp)
    800037a6:	6902                	ld	s2,0(sp)
    800037a8:	6105                	addi	sp,sp,32
    800037aa:	8082                	ret

00000000800037ac <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037ac:	1101                	addi	sp,sp,-32
    800037ae:	ec06                	sd	ra,24(sp)
    800037b0:	e822                	sd	s0,16(sp)
    800037b2:	e426                	sd	s1,8(sp)
    800037b4:	e04a                	sd	s2,0(sp)
    800037b6:	1000                	addi	s0,sp,32
    800037b8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037ba:	00850913          	addi	s2,a0,8
    800037be:	854a                	mv	a0,s2
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	8c8080e7          	jalr	-1848(ra) # 80006088 <acquire>
  while (lk->locked) {
    800037c8:	409c                	lw	a5,0(s1)
    800037ca:	cb89                	beqz	a5,800037dc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037cc:	85ca                	mv	a1,s2
    800037ce:	8526                	mv	a0,s1
    800037d0:	ffffe097          	auipc	ra,0xffffe
    800037d4:	d40080e7          	jalr	-704(ra) # 80001510 <sleep>
  while (lk->locked) {
    800037d8:	409c                	lw	a5,0(s1)
    800037da:	fbed                	bnez	a5,800037cc <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037dc:	4785                	li	a5,1
    800037de:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037e0:	ffffd097          	auipc	ra,0xffffd
    800037e4:	664080e7          	jalr	1636(ra) # 80000e44 <myproc>
    800037e8:	591c                	lw	a5,48(a0)
    800037ea:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037ec:	854a                	mv	a0,s2
    800037ee:	00003097          	auipc	ra,0x3
    800037f2:	94e080e7          	jalr	-1714(ra) # 8000613c <release>
}
    800037f6:	60e2                	ld	ra,24(sp)
    800037f8:	6442                	ld	s0,16(sp)
    800037fa:	64a2                	ld	s1,8(sp)
    800037fc:	6902                	ld	s2,0(sp)
    800037fe:	6105                	addi	sp,sp,32
    80003800:	8082                	ret

0000000080003802 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003802:	1101                	addi	sp,sp,-32
    80003804:	ec06                	sd	ra,24(sp)
    80003806:	e822                	sd	s0,16(sp)
    80003808:	e426                	sd	s1,8(sp)
    8000380a:	e04a                	sd	s2,0(sp)
    8000380c:	1000                	addi	s0,sp,32
    8000380e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003810:	00850913          	addi	s2,a0,8
    80003814:	854a                	mv	a0,s2
    80003816:	00003097          	auipc	ra,0x3
    8000381a:	872080e7          	jalr	-1934(ra) # 80006088 <acquire>
  lk->locked = 0;
    8000381e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003822:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003826:	8526                	mv	a0,s1
    80003828:	ffffe097          	auipc	ra,0xffffe
    8000382c:	e74080e7          	jalr	-396(ra) # 8000169c <wakeup>
  release(&lk->lk);
    80003830:	854a                	mv	a0,s2
    80003832:	00003097          	auipc	ra,0x3
    80003836:	90a080e7          	jalr	-1782(ra) # 8000613c <release>
}
    8000383a:	60e2                	ld	ra,24(sp)
    8000383c:	6442                	ld	s0,16(sp)
    8000383e:	64a2                	ld	s1,8(sp)
    80003840:	6902                	ld	s2,0(sp)
    80003842:	6105                	addi	sp,sp,32
    80003844:	8082                	ret

0000000080003846 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003846:	7179                	addi	sp,sp,-48
    80003848:	f406                	sd	ra,40(sp)
    8000384a:	f022                	sd	s0,32(sp)
    8000384c:	ec26                	sd	s1,24(sp)
    8000384e:	e84a                	sd	s2,16(sp)
    80003850:	e44e                	sd	s3,8(sp)
    80003852:	1800                	addi	s0,sp,48
    80003854:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003856:	00850913          	addi	s2,a0,8
    8000385a:	854a                	mv	a0,s2
    8000385c:	00003097          	auipc	ra,0x3
    80003860:	82c080e7          	jalr	-2004(ra) # 80006088 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003864:	409c                	lw	a5,0(s1)
    80003866:	ef99                	bnez	a5,80003884 <holdingsleep+0x3e>
    80003868:	4481                	li	s1,0
  release(&lk->lk);
    8000386a:	854a                	mv	a0,s2
    8000386c:	00003097          	auipc	ra,0x3
    80003870:	8d0080e7          	jalr	-1840(ra) # 8000613c <release>
  return r;
}
    80003874:	8526                	mv	a0,s1
    80003876:	70a2                	ld	ra,40(sp)
    80003878:	7402                	ld	s0,32(sp)
    8000387a:	64e2                	ld	s1,24(sp)
    8000387c:	6942                	ld	s2,16(sp)
    8000387e:	69a2                	ld	s3,8(sp)
    80003880:	6145                	addi	sp,sp,48
    80003882:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003884:	0284a983          	lw	s3,40(s1)
    80003888:	ffffd097          	auipc	ra,0xffffd
    8000388c:	5bc080e7          	jalr	1468(ra) # 80000e44 <myproc>
    80003890:	5904                	lw	s1,48(a0)
    80003892:	413484b3          	sub	s1,s1,s3
    80003896:	0014b493          	seqz	s1,s1
    8000389a:	bfc1                	j	8000386a <holdingsleep+0x24>

000000008000389c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000389c:	1141                	addi	sp,sp,-16
    8000389e:	e406                	sd	ra,8(sp)
    800038a0:	e022                	sd	s0,0(sp)
    800038a2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038a4:	00005597          	auipc	a1,0x5
    800038a8:	d7c58593          	addi	a1,a1,-644 # 80008620 <syscalls+0x240>
    800038ac:	00016517          	auipc	a0,0x16
    800038b0:	abc50513          	addi	a0,a0,-1348 # 80019368 <ftable>
    800038b4:	00002097          	auipc	ra,0x2
    800038b8:	744080e7          	jalr	1860(ra) # 80005ff8 <initlock>
}
    800038bc:	60a2                	ld	ra,8(sp)
    800038be:	6402                	ld	s0,0(sp)
    800038c0:	0141                	addi	sp,sp,16
    800038c2:	8082                	ret

00000000800038c4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038c4:	1101                	addi	sp,sp,-32
    800038c6:	ec06                	sd	ra,24(sp)
    800038c8:	e822                	sd	s0,16(sp)
    800038ca:	e426                	sd	s1,8(sp)
    800038cc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038ce:	00016517          	auipc	a0,0x16
    800038d2:	a9a50513          	addi	a0,a0,-1382 # 80019368 <ftable>
    800038d6:	00002097          	auipc	ra,0x2
    800038da:	7b2080e7          	jalr	1970(ra) # 80006088 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038de:	00016497          	auipc	s1,0x16
    800038e2:	aa248493          	addi	s1,s1,-1374 # 80019380 <ftable+0x18>
    800038e6:	00017717          	auipc	a4,0x17
    800038ea:	a3a70713          	addi	a4,a4,-1478 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800038ee:	40dc                	lw	a5,4(s1)
    800038f0:	cf99                	beqz	a5,8000390e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038f2:	02848493          	addi	s1,s1,40
    800038f6:	fee49ce3          	bne	s1,a4,800038ee <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038fa:	00016517          	auipc	a0,0x16
    800038fe:	a6e50513          	addi	a0,a0,-1426 # 80019368 <ftable>
    80003902:	00003097          	auipc	ra,0x3
    80003906:	83a080e7          	jalr	-1990(ra) # 8000613c <release>
  return 0;
    8000390a:	4481                	li	s1,0
    8000390c:	a819                	j	80003922 <filealloc+0x5e>
      f->ref = 1;
    8000390e:	4785                	li	a5,1
    80003910:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003912:	00016517          	auipc	a0,0x16
    80003916:	a5650513          	addi	a0,a0,-1450 # 80019368 <ftable>
    8000391a:	00003097          	auipc	ra,0x3
    8000391e:	822080e7          	jalr	-2014(ra) # 8000613c <release>
}
    80003922:	8526                	mv	a0,s1
    80003924:	60e2                	ld	ra,24(sp)
    80003926:	6442                	ld	s0,16(sp)
    80003928:	64a2                	ld	s1,8(sp)
    8000392a:	6105                	addi	sp,sp,32
    8000392c:	8082                	ret

000000008000392e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000392e:	1101                	addi	sp,sp,-32
    80003930:	ec06                	sd	ra,24(sp)
    80003932:	e822                	sd	s0,16(sp)
    80003934:	e426                	sd	s1,8(sp)
    80003936:	1000                	addi	s0,sp,32
    80003938:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000393a:	00016517          	auipc	a0,0x16
    8000393e:	a2e50513          	addi	a0,a0,-1490 # 80019368 <ftable>
    80003942:	00002097          	auipc	ra,0x2
    80003946:	746080e7          	jalr	1862(ra) # 80006088 <acquire>
  if(f->ref < 1)
    8000394a:	40dc                	lw	a5,4(s1)
    8000394c:	02f05263          	blez	a5,80003970 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003950:	2785                	addiw	a5,a5,1
    80003952:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003954:	00016517          	auipc	a0,0x16
    80003958:	a1450513          	addi	a0,a0,-1516 # 80019368 <ftable>
    8000395c:	00002097          	auipc	ra,0x2
    80003960:	7e0080e7          	jalr	2016(ra) # 8000613c <release>
  return f;
}
    80003964:	8526                	mv	a0,s1
    80003966:	60e2                	ld	ra,24(sp)
    80003968:	6442                	ld	s0,16(sp)
    8000396a:	64a2                	ld	s1,8(sp)
    8000396c:	6105                	addi	sp,sp,32
    8000396e:	8082                	ret
    panic("filedup");
    80003970:	00005517          	auipc	a0,0x5
    80003974:	cb850513          	addi	a0,a0,-840 # 80008628 <syscalls+0x248>
    80003978:	00002097          	auipc	ra,0x2
    8000397c:	1d8080e7          	jalr	472(ra) # 80005b50 <panic>

0000000080003980 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003980:	7139                	addi	sp,sp,-64
    80003982:	fc06                	sd	ra,56(sp)
    80003984:	f822                	sd	s0,48(sp)
    80003986:	f426                	sd	s1,40(sp)
    80003988:	f04a                	sd	s2,32(sp)
    8000398a:	ec4e                	sd	s3,24(sp)
    8000398c:	e852                	sd	s4,16(sp)
    8000398e:	e456                	sd	s5,8(sp)
    80003990:	0080                	addi	s0,sp,64
    80003992:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003994:	00016517          	auipc	a0,0x16
    80003998:	9d450513          	addi	a0,a0,-1580 # 80019368 <ftable>
    8000399c:	00002097          	auipc	ra,0x2
    800039a0:	6ec080e7          	jalr	1772(ra) # 80006088 <acquire>
  if(f->ref < 1)
    800039a4:	40dc                	lw	a5,4(s1)
    800039a6:	06f05163          	blez	a5,80003a08 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800039aa:	37fd                	addiw	a5,a5,-1
    800039ac:	0007871b          	sext.w	a4,a5
    800039b0:	c0dc                	sw	a5,4(s1)
    800039b2:	06e04363          	bgtz	a4,80003a18 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039b6:	0004a903          	lw	s2,0(s1)
    800039ba:	0094ca83          	lbu	s5,9(s1)
    800039be:	0104ba03          	ld	s4,16(s1)
    800039c2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039c6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039ca:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039ce:	00016517          	auipc	a0,0x16
    800039d2:	99a50513          	addi	a0,a0,-1638 # 80019368 <ftable>
    800039d6:	00002097          	auipc	ra,0x2
    800039da:	766080e7          	jalr	1894(ra) # 8000613c <release>

  if(ff.type == FD_PIPE){
    800039de:	4785                	li	a5,1
    800039e0:	04f90d63          	beq	s2,a5,80003a3a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039e4:	3979                	addiw	s2,s2,-2
    800039e6:	4785                	li	a5,1
    800039e8:	0527e063          	bltu	a5,s2,80003a28 <fileclose+0xa8>
    begin_op();
    800039ec:	00000097          	auipc	ra,0x0
    800039f0:	acc080e7          	jalr	-1332(ra) # 800034b8 <begin_op>
    iput(ff.ip);
    800039f4:	854e                	mv	a0,s3
    800039f6:	fffff097          	auipc	ra,0xfffff
    800039fa:	2a0080e7          	jalr	672(ra) # 80002c96 <iput>
    end_op();
    800039fe:	00000097          	auipc	ra,0x0
    80003a02:	b38080e7          	jalr	-1224(ra) # 80003536 <end_op>
    80003a06:	a00d                	j	80003a28 <fileclose+0xa8>
    panic("fileclose");
    80003a08:	00005517          	auipc	a0,0x5
    80003a0c:	c2850513          	addi	a0,a0,-984 # 80008630 <syscalls+0x250>
    80003a10:	00002097          	auipc	ra,0x2
    80003a14:	140080e7          	jalr	320(ra) # 80005b50 <panic>
    release(&ftable.lock);
    80003a18:	00016517          	auipc	a0,0x16
    80003a1c:	95050513          	addi	a0,a0,-1712 # 80019368 <ftable>
    80003a20:	00002097          	auipc	ra,0x2
    80003a24:	71c080e7          	jalr	1820(ra) # 8000613c <release>
  }
}
    80003a28:	70e2                	ld	ra,56(sp)
    80003a2a:	7442                	ld	s0,48(sp)
    80003a2c:	74a2                	ld	s1,40(sp)
    80003a2e:	7902                	ld	s2,32(sp)
    80003a30:	69e2                	ld	s3,24(sp)
    80003a32:	6a42                	ld	s4,16(sp)
    80003a34:	6aa2                	ld	s5,8(sp)
    80003a36:	6121                	addi	sp,sp,64
    80003a38:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a3a:	85d6                	mv	a1,s5
    80003a3c:	8552                	mv	a0,s4
    80003a3e:	00000097          	auipc	ra,0x0
    80003a42:	34c080e7          	jalr	844(ra) # 80003d8a <pipeclose>
    80003a46:	b7cd                	j	80003a28 <fileclose+0xa8>

0000000080003a48 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a48:	715d                	addi	sp,sp,-80
    80003a4a:	e486                	sd	ra,72(sp)
    80003a4c:	e0a2                	sd	s0,64(sp)
    80003a4e:	fc26                	sd	s1,56(sp)
    80003a50:	f84a                	sd	s2,48(sp)
    80003a52:	f44e                	sd	s3,40(sp)
    80003a54:	0880                	addi	s0,sp,80
    80003a56:	84aa                	mv	s1,a0
    80003a58:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a5a:	ffffd097          	auipc	ra,0xffffd
    80003a5e:	3ea080e7          	jalr	1002(ra) # 80000e44 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a62:	409c                	lw	a5,0(s1)
    80003a64:	37f9                	addiw	a5,a5,-2
    80003a66:	4705                	li	a4,1
    80003a68:	04f76763          	bltu	a4,a5,80003ab6 <filestat+0x6e>
    80003a6c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a6e:	6c88                	ld	a0,24(s1)
    80003a70:	fffff097          	auipc	ra,0xfffff
    80003a74:	06c080e7          	jalr	108(ra) # 80002adc <ilock>
    stati(f->ip, &st);
    80003a78:	fb840593          	addi	a1,s0,-72
    80003a7c:	6c88                	ld	a0,24(s1)
    80003a7e:	fffff097          	auipc	ra,0xfffff
    80003a82:	2e8080e7          	jalr	744(ra) # 80002d66 <stati>
    iunlock(f->ip);
    80003a86:	6c88                	ld	a0,24(s1)
    80003a88:	fffff097          	auipc	ra,0xfffff
    80003a8c:	116080e7          	jalr	278(ra) # 80002b9e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a90:	46e1                	li	a3,24
    80003a92:	fb840613          	addi	a2,s0,-72
    80003a96:	85ce                	mv	a1,s3
    80003a98:	05093503          	ld	a0,80(s2)
    80003a9c:	ffffd097          	auipc	ra,0xffffd
    80003aa0:	06c080e7          	jalr	108(ra) # 80000b08 <copyout>
    80003aa4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003aa8:	60a6                	ld	ra,72(sp)
    80003aaa:	6406                	ld	s0,64(sp)
    80003aac:	74e2                	ld	s1,56(sp)
    80003aae:	7942                	ld	s2,48(sp)
    80003ab0:	79a2                	ld	s3,40(sp)
    80003ab2:	6161                	addi	sp,sp,80
    80003ab4:	8082                	ret
  return -1;
    80003ab6:	557d                	li	a0,-1
    80003ab8:	bfc5                	j	80003aa8 <filestat+0x60>

0000000080003aba <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003aba:	7179                	addi	sp,sp,-48
    80003abc:	f406                	sd	ra,40(sp)
    80003abe:	f022                	sd	s0,32(sp)
    80003ac0:	ec26                	sd	s1,24(sp)
    80003ac2:	e84a                	sd	s2,16(sp)
    80003ac4:	e44e                	sd	s3,8(sp)
    80003ac6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ac8:	00854783          	lbu	a5,8(a0)
    80003acc:	c3d5                	beqz	a5,80003b70 <fileread+0xb6>
    80003ace:	84aa                	mv	s1,a0
    80003ad0:	89ae                	mv	s3,a1
    80003ad2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ad4:	411c                	lw	a5,0(a0)
    80003ad6:	4705                	li	a4,1
    80003ad8:	04e78963          	beq	a5,a4,80003b2a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003adc:	470d                	li	a4,3
    80003ade:	04e78d63          	beq	a5,a4,80003b38 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ae2:	4709                	li	a4,2
    80003ae4:	06e79e63          	bne	a5,a4,80003b60 <fileread+0xa6>
    ilock(f->ip);
    80003ae8:	6d08                	ld	a0,24(a0)
    80003aea:	fffff097          	auipc	ra,0xfffff
    80003aee:	ff2080e7          	jalr	-14(ra) # 80002adc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003af2:	874a                	mv	a4,s2
    80003af4:	5094                	lw	a3,32(s1)
    80003af6:	864e                	mv	a2,s3
    80003af8:	4585                	li	a1,1
    80003afa:	6c88                	ld	a0,24(s1)
    80003afc:	fffff097          	auipc	ra,0xfffff
    80003b00:	294080e7          	jalr	660(ra) # 80002d90 <readi>
    80003b04:	892a                	mv	s2,a0
    80003b06:	00a05563          	blez	a0,80003b10 <fileread+0x56>
      f->off += r;
    80003b0a:	509c                	lw	a5,32(s1)
    80003b0c:	9fa9                	addw	a5,a5,a0
    80003b0e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b10:	6c88                	ld	a0,24(s1)
    80003b12:	fffff097          	auipc	ra,0xfffff
    80003b16:	08c080e7          	jalr	140(ra) # 80002b9e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b1a:	854a                	mv	a0,s2
    80003b1c:	70a2                	ld	ra,40(sp)
    80003b1e:	7402                	ld	s0,32(sp)
    80003b20:	64e2                	ld	s1,24(sp)
    80003b22:	6942                	ld	s2,16(sp)
    80003b24:	69a2                	ld	s3,8(sp)
    80003b26:	6145                	addi	sp,sp,48
    80003b28:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b2a:	6908                	ld	a0,16(a0)
    80003b2c:	00000097          	auipc	ra,0x0
    80003b30:	3c0080e7          	jalr	960(ra) # 80003eec <piperead>
    80003b34:	892a                	mv	s2,a0
    80003b36:	b7d5                	j	80003b1a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b38:	02451783          	lh	a5,36(a0)
    80003b3c:	03079693          	slli	a3,a5,0x30
    80003b40:	92c1                	srli	a3,a3,0x30
    80003b42:	4725                	li	a4,9
    80003b44:	02d76863          	bltu	a4,a3,80003b74 <fileread+0xba>
    80003b48:	0792                	slli	a5,a5,0x4
    80003b4a:	00015717          	auipc	a4,0x15
    80003b4e:	77e70713          	addi	a4,a4,1918 # 800192c8 <devsw>
    80003b52:	97ba                	add	a5,a5,a4
    80003b54:	639c                	ld	a5,0(a5)
    80003b56:	c38d                	beqz	a5,80003b78 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b58:	4505                	li	a0,1
    80003b5a:	9782                	jalr	a5
    80003b5c:	892a                	mv	s2,a0
    80003b5e:	bf75                	j	80003b1a <fileread+0x60>
    panic("fileread");
    80003b60:	00005517          	auipc	a0,0x5
    80003b64:	ae050513          	addi	a0,a0,-1312 # 80008640 <syscalls+0x260>
    80003b68:	00002097          	auipc	ra,0x2
    80003b6c:	fe8080e7          	jalr	-24(ra) # 80005b50 <panic>
    return -1;
    80003b70:	597d                	li	s2,-1
    80003b72:	b765                	j	80003b1a <fileread+0x60>
      return -1;
    80003b74:	597d                	li	s2,-1
    80003b76:	b755                	j	80003b1a <fileread+0x60>
    80003b78:	597d                	li	s2,-1
    80003b7a:	b745                	j	80003b1a <fileread+0x60>

0000000080003b7c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b7c:	715d                	addi	sp,sp,-80
    80003b7e:	e486                	sd	ra,72(sp)
    80003b80:	e0a2                	sd	s0,64(sp)
    80003b82:	fc26                	sd	s1,56(sp)
    80003b84:	f84a                	sd	s2,48(sp)
    80003b86:	f44e                	sd	s3,40(sp)
    80003b88:	f052                	sd	s4,32(sp)
    80003b8a:	ec56                	sd	s5,24(sp)
    80003b8c:	e85a                	sd	s6,16(sp)
    80003b8e:	e45e                	sd	s7,8(sp)
    80003b90:	e062                	sd	s8,0(sp)
    80003b92:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b94:	00954783          	lbu	a5,9(a0)
    80003b98:	10078663          	beqz	a5,80003ca4 <filewrite+0x128>
    80003b9c:	892a                	mv	s2,a0
    80003b9e:	8b2e                	mv	s6,a1
    80003ba0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ba2:	411c                	lw	a5,0(a0)
    80003ba4:	4705                	li	a4,1
    80003ba6:	02e78263          	beq	a5,a4,80003bca <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003baa:	470d                	li	a4,3
    80003bac:	02e78663          	beq	a5,a4,80003bd8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bb0:	4709                	li	a4,2
    80003bb2:	0ee79163          	bne	a5,a4,80003c94 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003bb6:	0ac05d63          	blez	a2,80003c70 <filewrite+0xf4>
    int i = 0;
    80003bba:	4981                	li	s3,0
    80003bbc:	6b85                	lui	s7,0x1
    80003bbe:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003bc2:	6c05                	lui	s8,0x1
    80003bc4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003bc8:	a861                	j	80003c60 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003bca:	6908                	ld	a0,16(a0)
    80003bcc:	00000097          	auipc	ra,0x0
    80003bd0:	22e080e7          	jalr	558(ra) # 80003dfa <pipewrite>
    80003bd4:	8a2a                	mv	s4,a0
    80003bd6:	a045                	j	80003c76 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bd8:	02451783          	lh	a5,36(a0)
    80003bdc:	03079693          	slli	a3,a5,0x30
    80003be0:	92c1                	srli	a3,a3,0x30
    80003be2:	4725                	li	a4,9
    80003be4:	0cd76263          	bltu	a4,a3,80003ca8 <filewrite+0x12c>
    80003be8:	0792                	slli	a5,a5,0x4
    80003bea:	00015717          	auipc	a4,0x15
    80003bee:	6de70713          	addi	a4,a4,1758 # 800192c8 <devsw>
    80003bf2:	97ba                	add	a5,a5,a4
    80003bf4:	679c                	ld	a5,8(a5)
    80003bf6:	cbdd                	beqz	a5,80003cac <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003bf8:	4505                	li	a0,1
    80003bfa:	9782                	jalr	a5
    80003bfc:	8a2a                	mv	s4,a0
    80003bfe:	a8a5                	j	80003c76 <filewrite+0xfa>
    80003c00:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c04:	00000097          	auipc	ra,0x0
    80003c08:	8b4080e7          	jalr	-1868(ra) # 800034b8 <begin_op>
      ilock(f->ip);
    80003c0c:	01893503          	ld	a0,24(s2)
    80003c10:	fffff097          	auipc	ra,0xfffff
    80003c14:	ecc080e7          	jalr	-308(ra) # 80002adc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c18:	8756                	mv	a4,s5
    80003c1a:	02092683          	lw	a3,32(s2)
    80003c1e:	01698633          	add	a2,s3,s6
    80003c22:	4585                	li	a1,1
    80003c24:	01893503          	ld	a0,24(s2)
    80003c28:	fffff097          	auipc	ra,0xfffff
    80003c2c:	260080e7          	jalr	608(ra) # 80002e88 <writei>
    80003c30:	84aa                	mv	s1,a0
    80003c32:	00a05763          	blez	a0,80003c40 <filewrite+0xc4>
        f->off += r;
    80003c36:	02092783          	lw	a5,32(s2)
    80003c3a:	9fa9                	addw	a5,a5,a0
    80003c3c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c40:	01893503          	ld	a0,24(s2)
    80003c44:	fffff097          	auipc	ra,0xfffff
    80003c48:	f5a080e7          	jalr	-166(ra) # 80002b9e <iunlock>
      end_op();
    80003c4c:	00000097          	auipc	ra,0x0
    80003c50:	8ea080e7          	jalr	-1814(ra) # 80003536 <end_op>

      if(r != n1){
    80003c54:	009a9f63          	bne	s5,s1,80003c72 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003c58:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c5c:	0149db63          	bge	s3,s4,80003c72 <filewrite+0xf6>
      int n1 = n - i;
    80003c60:	413a04bb          	subw	s1,s4,s3
    80003c64:	0004879b          	sext.w	a5,s1
    80003c68:	f8fbdce3          	bge	s7,a5,80003c00 <filewrite+0x84>
    80003c6c:	84e2                	mv	s1,s8
    80003c6e:	bf49                	j	80003c00 <filewrite+0x84>
    int i = 0;
    80003c70:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c72:	013a1f63          	bne	s4,s3,80003c90 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c76:	8552                	mv	a0,s4
    80003c78:	60a6                	ld	ra,72(sp)
    80003c7a:	6406                	ld	s0,64(sp)
    80003c7c:	74e2                	ld	s1,56(sp)
    80003c7e:	7942                	ld	s2,48(sp)
    80003c80:	79a2                	ld	s3,40(sp)
    80003c82:	7a02                	ld	s4,32(sp)
    80003c84:	6ae2                	ld	s5,24(sp)
    80003c86:	6b42                	ld	s6,16(sp)
    80003c88:	6ba2                	ld	s7,8(sp)
    80003c8a:	6c02                	ld	s8,0(sp)
    80003c8c:	6161                	addi	sp,sp,80
    80003c8e:	8082                	ret
    ret = (i == n ? n : -1);
    80003c90:	5a7d                	li	s4,-1
    80003c92:	b7d5                	j	80003c76 <filewrite+0xfa>
    panic("filewrite");
    80003c94:	00005517          	auipc	a0,0x5
    80003c98:	9bc50513          	addi	a0,a0,-1604 # 80008650 <syscalls+0x270>
    80003c9c:	00002097          	auipc	ra,0x2
    80003ca0:	eb4080e7          	jalr	-332(ra) # 80005b50 <panic>
    return -1;
    80003ca4:	5a7d                	li	s4,-1
    80003ca6:	bfc1                	j	80003c76 <filewrite+0xfa>
      return -1;
    80003ca8:	5a7d                	li	s4,-1
    80003caa:	b7f1                	j	80003c76 <filewrite+0xfa>
    80003cac:	5a7d                	li	s4,-1
    80003cae:	b7e1                	j	80003c76 <filewrite+0xfa>

0000000080003cb0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cb0:	7179                	addi	sp,sp,-48
    80003cb2:	f406                	sd	ra,40(sp)
    80003cb4:	f022                	sd	s0,32(sp)
    80003cb6:	ec26                	sd	s1,24(sp)
    80003cb8:	e84a                	sd	s2,16(sp)
    80003cba:	e44e                	sd	s3,8(sp)
    80003cbc:	e052                	sd	s4,0(sp)
    80003cbe:	1800                	addi	s0,sp,48
    80003cc0:	84aa                	mv	s1,a0
    80003cc2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cc4:	0005b023          	sd	zero,0(a1)
    80003cc8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ccc:	00000097          	auipc	ra,0x0
    80003cd0:	bf8080e7          	jalr	-1032(ra) # 800038c4 <filealloc>
    80003cd4:	e088                	sd	a0,0(s1)
    80003cd6:	c551                	beqz	a0,80003d62 <pipealloc+0xb2>
    80003cd8:	00000097          	auipc	ra,0x0
    80003cdc:	bec080e7          	jalr	-1044(ra) # 800038c4 <filealloc>
    80003ce0:	00aa3023          	sd	a0,0(s4)
    80003ce4:	c92d                	beqz	a0,80003d56 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ce6:	ffffc097          	auipc	ra,0xffffc
    80003cea:	434080e7          	jalr	1076(ra) # 8000011a <kalloc>
    80003cee:	892a                	mv	s2,a0
    80003cf0:	c125                	beqz	a0,80003d50 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003cf2:	4985                	li	s3,1
    80003cf4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003cf8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003cfc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d00:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d04:	00005597          	auipc	a1,0x5
    80003d08:	95c58593          	addi	a1,a1,-1700 # 80008660 <syscalls+0x280>
    80003d0c:	00002097          	auipc	ra,0x2
    80003d10:	2ec080e7          	jalr	748(ra) # 80005ff8 <initlock>
  (*f0)->type = FD_PIPE;
    80003d14:	609c                	ld	a5,0(s1)
    80003d16:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d1a:	609c                	ld	a5,0(s1)
    80003d1c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d20:	609c                	ld	a5,0(s1)
    80003d22:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d26:	609c                	ld	a5,0(s1)
    80003d28:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d2c:	000a3783          	ld	a5,0(s4)
    80003d30:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d34:	000a3783          	ld	a5,0(s4)
    80003d38:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d3c:	000a3783          	ld	a5,0(s4)
    80003d40:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d44:	000a3783          	ld	a5,0(s4)
    80003d48:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d4c:	4501                	li	a0,0
    80003d4e:	a025                	j	80003d76 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d50:	6088                	ld	a0,0(s1)
    80003d52:	e501                	bnez	a0,80003d5a <pipealloc+0xaa>
    80003d54:	a039                	j	80003d62 <pipealloc+0xb2>
    80003d56:	6088                	ld	a0,0(s1)
    80003d58:	c51d                	beqz	a0,80003d86 <pipealloc+0xd6>
    fileclose(*f0);
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	c26080e7          	jalr	-986(ra) # 80003980 <fileclose>
  if(*f1)
    80003d62:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d66:	557d                	li	a0,-1
  if(*f1)
    80003d68:	c799                	beqz	a5,80003d76 <pipealloc+0xc6>
    fileclose(*f1);
    80003d6a:	853e                	mv	a0,a5
    80003d6c:	00000097          	auipc	ra,0x0
    80003d70:	c14080e7          	jalr	-1004(ra) # 80003980 <fileclose>
  return -1;
    80003d74:	557d                	li	a0,-1
}
    80003d76:	70a2                	ld	ra,40(sp)
    80003d78:	7402                	ld	s0,32(sp)
    80003d7a:	64e2                	ld	s1,24(sp)
    80003d7c:	6942                	ld	s2,16(sp)
    80003d7e:	69a2                	ld	s3,8(sp)
    80003d80:	6a02                	ld	s4,0(sp)
    80003d82:	6145                	addi	sp,sp,48
    80003d84:	8082                	ret
  return -1;
    80003d86:	557d                	li	a0,-1
    80003d88:	b7fd                	j	80003d76 <pipealloc+0xc6>

0000000080003d8a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d8a:	1101                	addi	sp,sp,-32
    80003d8c:	ec06                	sd	ra,24(sp)
    80003d8e:	e822                	sd	s0,16(sp)
    80003d90:	e426                	sd	s1,8(sp)
    80003d92:	e04a                	sd	s2,0(sp)
    80003d94:	1000                	addi	s0,sp,32
    80003d96:	84aa                	mv	s1,a0
    80003d98:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d9a:	00002097          	auipc	ra,0x2
    80003d9e:	2ee080e7          	jalr	750(ra) # 80006088 <acquire>
  if(writable){
    80003da2:	02090d63          	beqz	s2,80003ddc <pipeclose+0x52>
    pi->writeopen = 0;
    80003da6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003daa:	21848513          	addi	a0,s1,536
    80003dae:	ffffe097          	auipc	ra,0xffffe
    80003db2:	8ee080e7          	jalr	-1810(ra) # 8000169c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003db6:	2204b783          	ld	a5,544(s1)
    80003dba:	eb95                	bnez	a5,80003dee <pipeclose+0x64>
    release(&pi->lock);
    80003dbc:	8526                	mv	a0,s1
    80003dbe:	00002097          	auipc	ra,0x2
    80003dc2:	37e080e7          	jalr	894(ra) # 8000613c <release>
    kfree((char*)pi);
    80003dc6:	8526                	mv	a0,s1
    80003dc8:	ffffc097          	auipc	ra,0xffffc
    80003dcc:	254080e7          	jalr	596(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003dd0:	60e2                	ld	ra,24(sp)
    80003dd2:	6442                	ld	s0,16(sp)
    80003dd4:	64a2                	ld	s1,8(sp)
    80003dd6:	6902                	ld	s2,0(sp)
    80003dd8:	6105                	addi	sp,sp,32
    80003dda:	8082                	ret
    pi->readopen = 0;
    80003ddc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003de0:	21c48513          	addi	a0,s1,540
    80003de4:	ffffe097          	auipc	ra,0xffffe
    80003de8:	8b8080e7          	jalr	-1864(ra) # 8000169c <wakeup>
    80003dec:	b7e9                	j	80003db6 <pipeclose+0x2c>
    release(&pi->lock);
    80003dee:	8526                	mv	a0,s1
    80003df0:	00002097          	auipc	ra,0x2
    80003df4:	34c080e7          	jalr	844(ra) # 8000613c <release>
}
    80003df8:	bfe1                	j	80003dd0 <pipeclose+0x46>

0000000080003dfa <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003dfa:	711d                	addi	sp,sp,-96
    80003dfc:	ec86                	sd	ra,88(sp)
    80003dfe:	e8a2                	sd	s0,80(sp)
    80003e00:	e4a6                	sd	s1,72(sp)
    80003e02:	e0ca                	sd	s2,64(sp)
    80003e04:	fc4e                	sd	s3,56(sp)
    80003e06:	f852                	sd	s4,48(sp)
    80003e08:	f456                	sd	s5,40(sp)
    80003e0a:	f05a                	sd	s6,32(sp)
    80003e0c:	ec5e                	sd	s7,24(sp)
    80003e0e:	e862                	sd	s8,16(sp)
    80003e10:	1080                	addi	s0,sp,96
    80003e12:	84aa                	mv	s1,a0
    80003e14:	8aae                	mv	s5,a1
    80003e16:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e18:	ffffd097          	auipc	ra,0xffffd
    80003e1c:	02c080e7          	jalr	44(ra) # 80000e44 <myproc>
    80003e20:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e22:	8526                	mv	a0,s1
    80003e24:	00002097          	auipc	ra,0x2
    80003e28:	264080e7          	jalr	612(ra) # 80006088 <acquire>
  while(i < n){
    80003e2c:	0b405363          	blez	s4,80003ed2 <pipewrite+0xd8>
  int i = 0;
    80003e30:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e32:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e34:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e38:	21c48b93          	addi	s7,s1,540
    80003e3c:	a089                	j	80003e7e <pipewrite+0x84>
      release(&pi->lock);
    80003e3e:	8526                	mv	a0,s1
    80003e40:	00002097          	auipc	ra,0x2
    80003e44:	2fc080e7          	jalr	764(ra) # 8000613c <release>
      return -1;
    80003e48:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e4a:	854a                	mv	a0,s2
    80003e4c:	60e6                	ld	ra,88(sp)
    80003e4e:	6446                	ld	s0,80(sp)
    80003e50:	64a6                	ld	s1,72(sp)
    80003e52:	6906                	ld	s2,64(sp)
    80003e54:	79e2                	ld	s3,56(sp)
    80003e56:	7a42                	ld	s4,48(sp)
    80003e58:	7aa2                	ld	s5,40(sp)
    80003e5a:	7b02                	ld	s6,32(sp)
    80003e5c:	6be2                	ld	s7,24(sp)
    80003e5e:	6c42                	ld	s8,16(sp)
    80003e60:	6125                	addi	sp,sp,96
    80003e62:	8082                	ret
      wakeup(&pi->nread);
    80003e64:	8562                	mv	a0,s8
    80003e66:	ffffe097          	auipc	ra,0xffffe
    80003e6a:	836080e7          	jalr	-1994(ra) # 8000169c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e6e:	85a6                	mv	a1,s1
    80003e70:	855e                	mv	a0,s7
    80003e72:	ffffd097          	auipc	ra,0xffffd
    80003e76:	69e080e7          	jalr	1694(ra) # 80001510 <sleep>
  while(i < n){
    80003e7a:	05495d63          	bge	s2,s4,80003ed4 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003e7e:	2204a783          	lw	a5,544(s1)
    80003e82:	dfd5                	beqz	a5,80003e3e <pipewrite+0x44>
    80003e84:	0289a783          	lw	a5,40(s3)
    80003e88:	fbdd                	bnez	a5,80003e3e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e8a:	2184a783          	lw	a5,536(s1)
    80003e8e:	21c4a703          	lw	a4,540(s1)
    80003e92:	2007879b          	addiw	a5,a5,512
    80003e96:	fcf707e3          	beq	a4,a5,80003e64 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e9a:	4685                	li	a3,1
    80003e9c:	01590633          	add	a2,s2,s5
    80003ea0:	faf40593          	addi	a1,s0,-81
    80003ea4:	0509b503          	ld	a0,80(s3)
    80003ea8:	ffffd097          	auipc	ra,0xffffd
    80003eac:	cec080e7          	jalr	-788(ra) # 80000b94 <copyin>
    80003eb0:	03650263          	beq	a0,s6,80003ed4 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003eb4:	21c4a783          	lw	a5,540(s1)
    80003eb8:	0017871b          	addiw	a4,a5,1
    80003ebc:	20e4ae23          	sw	a4,540(s1)
    80003ec0:	1ff7f793          	andi	a5,a5,511
    80003ec4:	97a6                	add	a5,a5,s1
    80003ec6:	faf44703          	lbu	a4,-81(s0)
    80003eca:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ece:	2905                	addiw	s2,s2,1
    80003ed0:	b76d                	j	80003e7a <pipewrite+0x80>
  int i = 0;
    80003ed2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003ed4:	21848513          	addi	a0,s1,536
    80003ed8:	ffffd097          	auipc	ra,0xffffd
    80003edc:	7c4080e7          	jalr	1988(ra) # 8000169c <wakeup>
  release(&pi->lock);
    80003ee0:	8526                	mv	a0,s1
    80003ee2:	00002097          	auipc	ra,0x2
    80003ee6:	25a080e7          	jalr	602(ra) # 8000613c <release>
  return i;
    80003eea:	b785                	j	80003e4a <pipewrite+0x50>

0000000080003eec <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003eec:	715d                	addi	sp,sp,-80
    80003eee:	e486                	sd	ra,72(sp)
    80003ef0:	e0a2                	sd	s0,64(sp)
    80003ef2:	fc26                	sd	s1,56(sp)
    80003ef4:	f84a                	sd	s2,48(sp)
    80003ef6:	f44e                	sd	s3,40(sp)
    80003ef8:	f052                	sd	s4,32(sp)
    80003efa:	ec56                	sd	s5,24(sp)
    80003efc:	e85a                	sd	s6,16(sp)
    80003efe:	0880                	addi	s0,sp,80
    80003f00:	84aa                	mv	s1,a0
    80003f02:	892e                	mv	s2,a1
    80003f04:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f06:	ffffd097          	auipc	ra,0xffffd
    80003f0a:	f3e080e7          	jalr	-194(ra) # 80000e44 <myproc>
    80003f0e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f10:	8526                	mv	a0,s1
    80003f12:	00002097          	auipc	ra,0x2
    80003f16:	176080e7          	jalr	374(ra) # 80006088 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f1a:	2184a703          	lw	a4,536(s1)
    80003f1e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f22:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f26:	02f71463          	bne	a4,a5,80003f4e <piperead+0x62>
    80003f2a:	2244a783          	lw	a5,548(s1)
    80003f2e:	c385                	beqz	a5,80003f4e <piperead+0x62>
    if(pr->killed){
    80003f30:	028a2783          	lw	a5,40(s4)
    80003f34:	ebc9                	bnez	a5,80003fc6 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f36:	85a6                	mv	a1,s1
    80003f38:	854e                	mv	a0,s3
    80003f3a:	ffffd097          	auipc	ra,0xffffd
    80003f3e:	5d6080e7          	jalr	1494(ra) # 80001510 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f42:	2184a703          	lw	a4,536(s1)
    80003f46:	21c4a783          	lw	a5,540(s1)
    80003f4a:	fef700e3          	beq	a4,a5,80003f2a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f4e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f50:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f52:	05505463          	blez	s5,80003f9a <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80003f56:	2184a783          	lw	a5,536(s1)
    80003f5a:	21c4a703          	lw	a4,540(s1)
    80003f5e:	02f70e63          	beq	a4,a5,80003f9a <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f62:	0017871b          	addiw	a4,a5,1
    80003f66:	20e4ac23          	sw	a4,536(s1)
    80003f6a:	1ff7f793          	andi	a5,a5,511
    80003f6e:	97a6                	add	a5,a5,s1
    80003f70:	0187c783          	lbu	a5,24(a5)
    80003f74:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f78:	4685                	li	a3,1
    80003f7a:	fbf40613          	addi	a2,s0,-65
    80003f7e:	85ca                	mv	a1,s2
    80003f80:	050a3503          	ld	a0,80(s4)
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	b84080e7          	jalr	-1148(ra) # 80000b08 <copyout>
    80003f8c:	01650763          	beq	a0,s6,80003f9a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f90:	2985                	addiw	s3,s3,1
    80003f92:	0905                	addi	s2,s2,1
    80003f94:	fd3a91e3          	bne	s5,s3,80003f56 <piperead+0x6a>
    80003f98:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f9a:	21c48513          	addi	a0,s1,540
    80003f9e:	ffffd097          	auipc	ra,0xffffd
    80003fa2:	6fe080e7          	jalr	1790(ra) # 8000169c <wakeup>
  release(&pi->lock);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	00002097          	auipc	ra,0x2
    80003fac:	194080e7          	jalr	404(ra) # 8000613c <release>
  return i;
}
    80003fb0:	854e                	mv	a0,s3
    80003fb2:	60a6                	ld	ra,72(sp)
    80003fb4:	6406                	ld	s0,64(sp)
    80003fb6:	74e2                	ld	s1,56(sp)
    80003fb8:	7942                	ld	s2,48(sp)
    80003fba:	79a2                	ld	s3,40(sp)
    80003fbc:	7a02                	ld	s4,32(sp)
    80003fbe:	6ae2                	ld	s5,24(sp)
    80003fc0:	6b42                	ld	s6,16(sp)
    80003fc2:	6161                	addi	sp,sp,80
    80003fc4:	8082                	ret
      release(&pi->lock);
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	00002097          	auipc	ra,0x2
    80003fcc:	174080e7          	jalr	372(ra) # 8000613c <release>
      return -1;
    80003fd0:	59fd                	li	s3,-1
    80003fd2:	bff9                	j	80003fb0 <piperead+0xc4>

0000000080003fd4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80003fd4:	de010113          	addi	sp,sp,-544
    80003fd8:	20113c23          	sd	ra,536(sp)
    80003fdc:	20813823          	sd	s0,528(sp)
    80003fe0:	20913423          	sd	s1,520(sp)
    80003fe4:	21213023          	sd	s2,512(sp)
    80003fe8:	ffce                	sd	s3,504(sp)
    80003fea:	fbd2                	sd	s4,496(sp)
    80003fec:	f7d6                	sd	s5,488(sp)
    80003fee:	f3da                	sd	s6,480(sp)
    80003ff0:	efde                	sd	s7,472(sp)
    80003ff2:	ebe2                	sd	s8,464(sp)
    80003ff4:	e7e6                	sd	s9,456(sp)
    80003ff6:	e3ea                	sd	s10,448(sp)
    80003ff8:	ff6e                	sd	s11,440(sp)
    80003ffa:	1400                	addi	s0,sp,544
    80003ffc:	892a                	mv	s2,a0
    80003ffe:	dea43423          	sd	a0,-536(s0)
    80004002:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004006:	ffffd097          	auipc	ra,0xffffd
    8000400a:	e3e080e7          	jalr	-450(ra) # 80000e44 <myproc>
    8000400e:	84aa                	mv	s1,a0

  begin_op();
    80004010:	fffff097          	auipc	ra,0xfffff
    80004014:	4a8080e7          	jalr	1192(ra) # 800034b8 <begin_op>

  if((ip = namei(path)) == 0){
    80004018:	854a                	mv	a0,s2
    8000401a:	fffff097          	auipc	ra,0xfffff
    8000401e:	27e080e7          	jalr	638(ra) # 80003298 <namei>
    80004022:	c93d                	beqz	a0,80004098 <exec+0xc4>
    80004024:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004026:	fffff097          	auipc	ra,0xfffff
    8000402a:	ab6080e7          	jalr	-1354(ra) # 80002adc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000402e:	04000713          	li	a4,64
    80004032:	4681                	li	a3,0
    80004034:	e5040613          	addi	a2,s0,-432
    80004038:	4581                	li	a1,0
    8000403a:	8556                	mv	a0,s5
    8000403c:	fffff097          	auipc	ra,0xfffff
    80004040:	d54080e7          	jalr	-684(ra) # 80002d90 <readi>
    80004044:	04000793          	li	a5,64
    80004048:	00f51a63          	bne	a0,a5,8000405c <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000404c:	e5042703          	lw	a4,-432(s0)
    80004050:	464c47b7          	lui	a5,0x464c4
    80004054:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004058:	04f70663          	beq	a4,a5,800040a4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000405c:	8556                	mv	a0,s5
    8000405e:	fffff097          	auipc	ra,0xfffff
    80004062:	ce0080e7          	jalr	-800(ra) # 80002d3e <iunlockput>
    end_op();
    80004066:	fffff097          	auipc	ra,0xfffff
    8000406a:	4d0080e7          	jalr	1232(ra) # 80003536 <end_op>
  }
  return -1;
    8000406e:	557d                	li	a0,-1
}
    80004070:	21813083          	ld	ra,536(sp)
    80004074:	21013403          	ld	s0,528(sp)
    80004078:	20813483          	ld	s1,520(sp)
    8000407c:	20013903          	ld	s2,512(sp)
    80004080:	79fe                	ld	s3,504(sp)
    80004082:	7a5e                	ld	s4,496(sp)
    80004084:	7abe                	ld	s5,488(sp)
    80004086:	7b1e                	ld	s6,480(sp)
    80004088:	6bfe                	ld	s7,472(sp)
    8000408a:	6c5e                	ld	s8,464(sp)
    8000408c:	6cbe                	ld	s9,456(sp)
    8000408e:	6d1e                	ld	s10,448(sp)
    80004090:	7dfa                	ld	s11,440(sp)
    80004092:	22010113          	addi	sp,sp,544
    80004096:	8082                	ret
    end_op();
    80004098:	fffff097          	auipc	ra,0xfffff
    8000409c:	49e080e7          	jalr	1182(ra) # 80003536 <end_op>
    return -1;
    800040a0:	557d                	li	a0,-1
    800040a2:	b7f9                	j	80004070 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800040a4:	8526                	mv	a0,s1
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	e62080e7          	jalr	-414(ra) # 80000f08 <proc_pagetable>
    800040ae:	8b2a                	mv	s6,a0
    800040b0:	d555                	beqz	a0,8000405c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040b2:	e7042783          	lw	a5,-400(s0)
    800040b6:	e8845703          	lhu	a4,-376(s0)
    800040ba:	c735                	beqz	a4,80004126 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040bc:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040be:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800040c2:	6a05                	lui	s4,0x1
    800040c4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800040c8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800040cc:	6d85                	lui	s11,0x1
    800040ce:	7d7d                	lui	s10,0xfffff
    800040d0:	ac1d                	j	80004306 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800040d2:	00004517          	auipc	a0,0x4
    800040d6:	59650513          	addi	a0,a0,1430 # 80008668 <syscalls+0x288>
    800040da:	00002097          	auipc	ra,0x2
    800040de:	a76080e7          	jalr	-1418(ra) # 80005b50 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040e2:	874a                	mv	a4,s2
    800040e4:	009c86bb          	addw	a3,s9,s1
    800040e8:	4581                	li	a1,0
    800040ea:	8556                	mv	a0,s5
    800040ec:	fffff097          	auipc	ra,0xfffff
    800040f0:	ca4080e7          	jalr	-860(ra) # 80002d90 <readi>
    800040f4:	2501                	sext.w	a0,a0
    800040f6:	1aa91863          	bne	s2,a0,800042a6 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800040fa:	009d84bb          	addw	s1,s11,s1
    800040fe:	013d09bb          	addw	s3,s10,s3
    80004102:	1f74f263          	bgeu	s1,s7,800042e6 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004106:	02049593          	slli	a1,s1,0x20
    8000410a:	9181                	srli	a1,a1,0x20
    8000410c:	95e2                	add	a1,a1,s8
    8000410e:	855a                	mv	a0,s6
    80004110:	ffffc097          	auipc	ra,0xffffc
    80004114:	3f0080e7          	jalr	1008(ra) # 80000500 <walkaddr>
    80004118:	862a                	mv	a2,a0
    if(pa == 0)
    8000411a:	dd45                	beqz	a0,800040d2 <exec+0xfe>
      n = PGSIZE;
    8000411c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000411e:	fd49f2e3          	bgeu	s3,s4,800040e2 <exec+0x10e>
      n = sz - i;
    80004122:	894e                	mv	s2,s3
    80004124:	bf7d                	j	800040e2 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004126:	4481                	li	s1,0
  iunlockput(ip);
    80004128:	8556                	mv	a0,s5
    8000412a:	fffff097          	auipc	ra,0xfffff
    8000412e:	c14080e7          	jalr	-1004(ra) # 80002d3e <iunlockput>
  end_op();
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	404080e7          	jalr	1028(ra) # 80003536 <end_op>
  p = myproc();
    8000413a:	ffffd097          	auipc	ra,0xffffd
    8000413e:	d0a080e7          	jalr	-758(ra) # 80000e44 <myproc>
    80004142:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004144:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004148:	6785                	lui	a5,0x1
    8000414a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000414c:	97a6                	add	a5,a5,s1
    8000414e:	777d                	lui	a4,0xfffff
    80004150:	8ff9                	and	a5,a5,a4
    80004152:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004156:	6609                	lui	a2,0x2
    80004158:	963e                	add	a2,a2,a5
    8000415a:	85be                	mv	a1,a5
    8000415c:	855a                	mv	a0,s6
    8000415e:	ffffc097          	auipc	ra,0xffffc
    80004162:	756080e7          	jalr	1878(ra) # 800008b4 <uvmalloc>
    80004166:	8c2a                	mv	s8,a0
  ip = 0;
    80004168:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000416a:	12050e63          	beqz	a0,800042a6 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000416e:	75f9                	lui	a1,0xffffe
    80004170:	95aa                	add	a1,a1,a0
    80004172:	855a                	mv	a0,s6
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	962080e7          	jalr	-1694(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000417c:	7afd                	lui	s5,0xfffff
    8000417e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004180:	df043783          	ld	a5,-528(s0)
    80004184:	6388                	ld	a0,0(a5)
    80004186:	c925                	beqz	a0,800041f6 <exec+0x222>
    80004188:	e9040993          	addi	s3,s0,-368
    8000418c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004190:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004192:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004194:	ffffc097          	auipc	ra,0xffffc
    80004198:	162080e7          	jalr	354(ra) # 800002f6 <strlen>
    8000419c:	0015079b          	addiw	a5,a0,1
    800041a0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041a4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800041a8:	13596363          	bltu	s2,s5,800042ce <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041ac:	df043d83          	ld	s11,-528(s0)
    800041b0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800041b4:	8552                	mv	a0,s4
    800041b6:	ffffc097          	auipc	ra,0xffffc
    800041ba:	140080e7          	jalr	320(ra) # 800002f6 <strlen>
    800041be:	0015069b          	addiw	a3,a0,1
    800041c2:	8652                	mv	a2,s4
    800041c4:	85ca                	mv	a1,s2
    800041c6:	855a                	mv	a0,s6
    800041c8:	ffffd097          	auipc	ra,0xffffd
    800041cc:	940080e7          	jalr	-1728(ra) # 80000b08 <copyout>
    800041d0:	10054363          	bltz	a0,800042d6 <exec+0x302>
    ustack[argc] = sp;
    800041d4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800041d8:	0485                	addi	s1,s1,1
    800041da:	008d8793          	addi	a5,s11,8
    800041de:	def43823          	sd	a5,-528(s0)
    800041e2:	008db503          	ld	a0,8(s11)
    800041e6:	c911                	beqz	a0,800041fa <exec+0x226>
    if(argc >= MAXARG)
    800041e8:	09a1                	addi	s3,s3,8
    800041ea:	fb3c95e3          	bne	s9,s3,80004194 <exec+0x1c0>
  sz = sz1;
    800041ee:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800041f2:	4a81                	li	s5,0
    800041f4:	a84d                	j	800042a6 <exec+0x2d2>
  sp = sz;
    800041f6:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800041f8:	4481                	li	s1,0
  ustack[argc] = 0;
    800041fa:	00349793          	slli	a5,s1,0x3
    800041fe:	f9078793          	addi	a5,a5,-112
    80004202:	97a2                	add	a5,a5,s0
    80004204:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004208:	00148693          	addi	a3,s1,1
    8000420c:	068e                	slli	a3,a3,0x3
    8000420e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004212:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004216:	01597663          	bgeu	s2,s5,80004222 <exec+0x24e>
  sz = sz1;
    8000421a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000421e:	4a81                	li	s5,0
    80004220:	a059                	j	800042a6 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004222:	e9040613          	addi	a2,s0,-368
    80004226:	85ca                	mv	a1,s2
    80004228:	855a                	mv	a0,s6
    8000422a:	ffffd097          	auipc	ra,0xffffd
    8000422e:	8de080e7          	jalr	-1826(ra) # 80000b08 <copyout>
    80004232:	0a054663          	bltz	a0,800042de <exec+0x30a>
  p->trapframe->a1 = sp;
    80004236:	058bb783          	ld	a5,88(s7)
    8000423a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000423e:	de843783          	ld	a5,-536(s0)
    80004242:	0007c703          	lbu	a4,0(a5)
    80004246:	cf11                	beqz	a4,80004262 <exec+0x28e>
    80004248:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000424a:	02f00693          	li	a3,47
    8000424e:	a039                	j	8000425c <exec+0x288>
      last = s+1;
    80004250:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004254:	0785                	addi	a5,a5,1
    80004256:	fff7c703          	lbu	a4,-1(a5)
    8000425a:	c701                	beqz	a4,80004262 <exec+0x28e>
    if(*s == '/')
    8000425c:	fed71ce3          	bne	a4,a3,80004254 <exec+0x280>
    80004260:	bfc5                	j	80004250 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004262:	4641                	li	a2,16
    80004264:	de843583          	ld	a1,-536(s0)
    80004268:	158b8513          	addi	a0,s7,344
    8000426c:	ffffc097          	auipc	ra,0xffffc
    80004270:	058080e7          	jalr	88(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004274:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004278:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000427c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004280:	058bb783          	ld	a5,88(s7)
    80004284:	e6843703          	ld	a4,-408(s0)
    80004288:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000428a:	058bb783          	ld	a5,88(s7)
    8000428e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004292:	85ea                	mv	a1,s10
    80004294:	ffffd097          	auipc	ra,0xffffd
    80004298:	d10080e7          	jalr	-752(ra) # 80000fa4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000429c:	0004851b          	sext.w	a0,s1
    800042a0:	bbc1                	j	80004070 <exec+0x9c>
    800042a2:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800042a6:	df843583          	ld	a1,-520(s0)
    800042aa:	855a                	mv	a0,s6
    800042ac:	ffffd097          	auipc	ra,0xffffd
    800042b0:	cf8080e7          	jalr	-776(ra) # 80000fa4 <proc_freepagetable>
  if(ip){
    800042b4:	da0a94e3          	bnez	s5,8000405c <exec+0x88>
  return -1;
    800042b8:	557d                	li	a0,-1
    800042ba:	bb5d                	j	80004070 <exec+0x9c>
    800042bc:	de943c23          	sd	s1,-520(s0)
    800042c0:	b7dd                	j	800042a6 <exec+0x2d2>
    800042c2:	de943c23          	sd	s1,-520(s0)
    800042c6:	b7c5                	j	800042a6 <exec+0x2d2>
    800042c8:	de943c23          	sd	s1,-520(s0)
    800042cc:	bfe9                	j	800042a6 <exec+0x2d2>
  sz = sz1;
    800042ce:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042d2:	4a81                	li	s5,0
    800042d4:	bfc9                	j	800042a6 <exec+0x2d2>
  sz = sz1;
    800042d6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042da:	4a81                	li	s5,0
    800042dc:	b7e9                	j	800042a6 <exec+0x2d2>
  sz = sz1;
    800042de:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042e2:	4a81                	li	s5,0
    800042e4:	b7c9                	j	800042a6 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042e6:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ea:	e0843783          	ld	a5,-504(s0)
    800042ee:	0017869b          	addiw	a3,a5,1
    800042f2:	e0d43423          	sd	a3,-504(s0)
    800042f6:	e0043783          	ld	a5,-512(s0)
    800042fa:	0387879b          	addiw	a5,a5,56
    800042fe:	e8845703          	lhu	a4,-376(s0)
    80004302:	e2e6d3e3          	bge	a3,a4,80004128 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004306:	2781                	sext.w	a5,a5
    80004308:	e0f43023          	sd	a5,-512(s0)
    8000430c:	03800713          	li	a4,56
    80004310:	86be                	mv	a3,a5
    80004312:	e1840613          	addi	a2,s0,-488
    80004316:	4581                	li	a1,0
    80004318:	8556                	mv	a0,s5
    8000431a:	fffff097          	auipc	ra,0xfffff
    8000431e:	a76080e7          	jalr	-1418(ra) # 80002d90 <readi>
    80004322:	03800793          	li	a5,56
    80004326:	f6f51ee3          	bne	a0,a5,800042a2 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000432a:	e1842783          	lw	a5,-488(s0)
    8000432e:	4705                	li	a4,1
    80004330:	fae79de3          	bne	a5,a4,800042ea <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004334:	e4043603          	ld	a2,-448(s0)
    80004338:	e3843783          	ld	a5,-456(s0)
    8000433c:	f8f660e3          	bltu	a2,a5,800042bc <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004340:	e2843783          	ld	a5,-472(s0)
    80004344:	963e                	add	a2,a2,a5
    80004346:	f6f66ee3          	bltu	a2,a5,800042c2 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000434a:	85a6                	mv	a1,s1
    8000434c:	855a                	mv	a0,s6
    8000434e:	ffffc097          	auipc	ra,0xffffc
    80004352:	566080e7          	jalr	1382(ra) # 800008b4 <uvmalloc>
    80004356:	dea43c23          	sd	a0,-520(s0)
    8000435a:	d53d                	beqz	a0,800042c8 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000435c:	e2843c03          	ld	s8,-472(s0)
    80004360:	de043783          	ld	a5,-544(s0)
    80004364:	00fc77b3          	and	a5,s8,a5
    80004368:	ff9d                	bnez	a5,800042a6 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000436a:	e2042c83          	lw	s9,-480(s0)
    8000436e:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004372:	f60b8ae3          	beqz	s7,800042e6 <exec+0x312>
    80004376:	89de                	mv	s3,s7
    80004378:	4481                	li	s1,0
    8000437a:	b371                	j	80004106 <exec+0x132>

000000008000437c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000437c:	7179                	addi	sp,sp,-48
    8000437e:	f406                	sd	ra,40(sp)
    80004380:	f022                	sd	s0,32(sp)
    80004382:	ec26                	sd	s1,24(sp)
    80004384:	e84a                	sd	s2,16(sp)
    80004386:	1800                	addi	s0,sp,48
    80004388:	892e                	mv	s2,a1
    8000438a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000438c:	fdc40593          	addi	a1,s0,-36
    80004390:	ffffe097          	auipc	ra,0xffffe
    80004394:	b72080e7          	jalr	-1166(ra) # 80001f02 <argint>
    80004398:	04054063          	bltz	a0,800043d8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000439c:	fdc42703          	lw	a4,-36(s0)
    800043a0:	47bd                	li	a5,15
    800043a2:	02e7ed63          	bltu	a5,a4,800043dc <argfd+0x60>
    800043a6:	ffffd097          	auipc	ra,0xffffd
    800043aa:	a9e080e7          	jalr	-1378(ra) # 80000e44 <myproc>
    800043ae:	fdc42703          	lw	a4,-36(s0)
    800043b2:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    800043b6:	078e                	slli	a5,a5,0x3
    800043b8:	953e                	add	a0,a0,a5
    800043ba:	611c                	ld	a5,0(a0)
    800043bc:	c395                	beqz	a5,800043e0 <argfd+0x64>
    return -1;
  if(pfd)
    800043be:	00090463          	beqz	s2,800043c6 <argfd+0x4a>
    *pfd = fd;
    800043c2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043c6:	4501                	li	a0,0
  if(pf)
    800043c8:	c091                	beqz	s1,800043cc <argfd+0x50>
    *pf = f;
    800043ca:	e09c                	sd	a5,0(s1)
}
    800043cc:	70a2                	ld	ra,40(sp)
    800043ce:	7402                	ld	s0,32(sp)
    800043d0:	64e2                	ld	s1,24(sp)
    800043d2:	6942                	ld	s2,16(sp)
    800043d4:	6145                	addi	sp,sp,48
    800043d6:	8082                	ret
    return -1;
    800043d8:	557d                	li	a0,-1
    800043da:	bfcd                	j	800043cc <argfd+0x50>
    return -1;
    800043dc:	557d                	li	a0,-1
    800043de:	b7fd                	j	800043cc <argfd+0x50>
    800043e0:	557d                	li	a0,-1
    800043e2:	b7ed                	j	800043cc <argfd+0x50>

00000000800043e4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800043e4:	1101                	addi	sp,sp,-32
    800043e6:	ec06                	sd	ra,24(sp)
    800043e8:	e822                	sd	s0,16(sp)
    800043ea:	e426                	sd	s1,8(sp)
    800043ec:	1000                	addi	s0,sp,32
    800043ee:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800043f0:	ffffd097          	auipc	ra,0xffffd
    800043f4:	a54080e7          	jalr	-1452(ra) # 80000e44 <myproc>
    800043f8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800043fa:	0d050793          	addi	a5,a0,208
    800043fe:	4501                	li	a0,0
    80004400:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004402:	6398                	ld	a4,0(a5)
    80004404:	cb19                	beqz	a4,8000441a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004406:	2505                	addiw	a0,a0,1
    80004408:	07a1                	addi	a5,a5,8
    8000440a:	fed51ce3          	bne	a0,a3,80004402 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000440e:	557d                	li	a0,-1
}
    80004410:	60e2                	ld	ra,24(sp)
    80004412:	6442                	ld	s0,16(sp)
    80004414:	64a2                	ld	s1,8(sp)
    80004416:	6105                	addi	sp,sp,32
    80004418:	8082                	ret
      p->ofile[fd] = f;
    8000441a:	01a50793          	addi	a5,a0,26
    8000441e:	078e                	slli	a5,a5,0x3
    80004420:	963e                	add	a2,a2,a5
    80004422:	e204                	sd	s1,0(a2)
      return fd;
    80004424:	b7f5                	j	80004410 <fdalloc+0x2c>

0000000080004426 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004426:	715d                	addi	sp,sp,-80
    80004428:	e486                	sd	ra,72(sp)
    8000442a:	e0a2                	sd	s0,64(sp)
    8000442c:	fc26                	sd	s1,56(sp)
    8000442e:	f84a                	sd	s2,48(sp)
    80004430:	f44e                	sd	s3,40(sp)
    80004432:	f052                	sd	s4,32(sp)
    80004434:	ec56                	sd	s5,24(sp)
    80004436:	0880                	addi	s0,sp,80
    80004438:	89ae                	mv	s3,a1
    8000443a:	8ab2                	mv	s5,a2
    8000443c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000443e:	fb040593          	addi	a1,s0,-80
    80004442:	fffff097          	auipc	ra,0xfffff
    80004446:	e74080e7          	jalr	-396(ra) # 800032b6 <nameiparent>
    8000444a:	892a                	mv	s2,a0
    8000444c:	12050e63          	beqz	a0,80004588 <create+0x162>
    return 0;

  ilock(dp);
    80004450:	ffffe097          	auipc	ra,0xffffe
    80004454:	68c080e7          	jalr	1676(ra) # 80002adc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004458:	4601                	li	a2,0
    8000445a:	fb040593          	addi	a1,s0,-80
    8000445e:	854a                	mv	a0,s2
    80004460:	fffff097          	auipc	ra,0xfffff
    80004464:	b60080e7          	jalr	-1184(ra) # 80002fc0 <dirlookup>
    80004468:	84aa                	mv	s1,a0
    8000446a:	c921                	beqz	a0,800044ba <create+0x94>
    iunlockput(dp);
    8000446c:	854a                	mv	a0,s2
    8000446e:	fffff097          	auipc	ra,0xfffff
    80004472:	8d0080e7          	jalr	-1840(ra) # 80002d3e <iunlockput>
    ilock(ip);
    80004476:	8526                	mv	a0,s1
    80004478:	ffffe097          	auipc	ra,0xffffe
    8000447c:	664080e7          	jalr	1636(ra) # 80002adc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004480:	2981                	sext.w	s3,s3
    80004482:	4789                	li	a5,2
    80004484:	02f99463          	bne	s3,a5,800044ac <create+0x86>
    80004488:	0444d783          	lhu	a5,68(s1)
    8000448c:	37f9                	addiw	a5,a5,-2
    8000448e:	17c2                	slli	a5,a5,0x30
    80004490:	93c1                	srli	a5,a5,0x30
    80004492:	4705                	li	a4,1
    80004494:	00f76c63          	bltu	a4,a5,800044ac <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004498:	8526                	mv	a0,s1
    8000449a:	60a6                	ld	ra,72(sp)
    8000449c:	6406                	ld	s0,64(sp)
    8000449e:	74e2                	ld	s1,56(sp)
    800044a0:	7942                	ld	s2,48(sp)
    800044a2:	79a2                	ld	s3,40(sp)
    800044a4:	7a02                	ld	s4,32(sp)
    800044a6:	6ae2                	ld	s5,24(sp)
    800044a8:	6161                	addi	sp,sp,80
    800044aa:	8082                	ret
    iunlockput(ip);
    800044ac:	8526                	mv	a0,s1
    800044ae:	fffff097          	auipc	ra,0xfffff
    800044b2:	890080e7          	jalr	-1904(ra) # 80002d3e <iunlockput>
    return 0;
    800044b6:	4481                	li	s1,0
    800044b8:	b7c5                	j	80004498 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800044ba:	85ce                	mv	a1,s3
    800044bc:	00092503          	lw	a0,0(s2)
    800044c0:	ffffe097          	auipc	ra,0xffffe
    800044c4:	482080e7          	jalr	1154(ra) # 80002942 <ialloc>
    800044c8:	84aa                	mv	s1,a0
    800044ca:	c521                	beqz	a0,80004512 <create+0xec>
  ilock(ip);
    800044cc:	ffffe097          	auipc	ra,0xffffe
    800044d0:	610080e7          	jalr	1552(ra) # 80002adc <ilock>
  ip->major = major;
    800044d4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800044d8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800044dc:	4a05                	li	s4,1
    800044de:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800044e2:	8526                	mv	a0,s1
    800044e4:	ffffe097          	auipc	ra,0xffffe
    800044e8:	52c080e7          	jalr	1324(ra) # 80002a10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800044ec:	2981                	sext.w	s3,s3
    800044ee:	03498a63          	beq	s3,s4,80004522 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800044f2:	40d0                	lw	a2,4(s1)
    800044f4:	fb040593          	addi	a1,s0,-80
    800044f8:	854a                	mv	a0,s2
    800044fa:	fffff097          	auipc	ra,0xfffff
    800044fe:	cdc080e7          	jalr	-804(ra) # 800031d6 <dirlink>
    80004502:	06054b63          	bltz	a0,80004578 <create+0x152>
  iunlockput(dp);
    80004506:	854a                	mv	a0,s2
    80004508:	fffff097          	auipc	ra,0xfffff
    8000450c:	836080e7          	jalr	-1994(ra) # 80002d3e <iunlockput>
  return ip;
    80004510:	b761                	j	80004498 <create+0x72>
    panic("create: ialloc");
    80004512:	00004517          	auipc	a0,0x4
    80004516:	17650513          	addi	a0,a0,374 # 80008688 <syscalls+0x2a8>
    8000451a:	00001097          	auipc	ra,0x1
    8000451e:	636080e7          	jalr	1590(ra) # 80005b50 <panic>
    dp->nlink++;  // for ".."
    80004522:	04a95783          	lhu	a5,74(s2)
    80004526:	2785                	addiw	a5,a5,1
    80004528:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000452c:	854a                	mv	a0,s2
    8000452e:	ffffe097          	auipc	ra,0xffffe
    80004532:	4e2080e7          	jalr	1250(ra) # 80002a10 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004536:	40d0                	lw	a2,4(s1)
    80004538:	00004597          	auipc	a1,0x4
    8000453c:	16058593          	addi	a1,a1,352 # 80008698 <syscalls+0x2b8>
    80004540:	8526                	mv	a0,s1
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	c94080e7          	jalr	-876(ra) # 800031d6 <dirlink>
    8000454a:	00054f63          	bltz	a0,80004568 <create+0x142>
    8000454e:	00492603          	lw	a2,4(s2)
    80004552:	00004597          	auipc	a1,0x4
    80004556:	14e58593          	addi	a1,a1,334 # 800086a0 <syscalls+0x2c0>
    8000455a:	8526                	mv	a0,s1
    8000455c:	fffff097          	auipc	ra,0xfffff
    80004560:	c7a080e7          	jalr	-902(ra) # 800031d6 <dirlink>
    80004564:	f80557e3          	bgez	a0,800044f2 <create+0xcc>
      panic("create dots");
    80004568:	00004517          	auipc	a0,0x4
    8000456c:	14050513          	addi	a0,a0,320 # 800086a8 <syscalls+0x2c8>
    80004570:	00001097          	auipc	ra,0x1
    80004574:	5e0080e7          	jalr	1504(ra) # 80005b50 <panic>
    panic("create: dirlink");
    80004578:	00004517          	auipc	a0,0x4
    8000457c:	14050513          	addi	a0,a0,320 # 800086b8 <syscalls+0x2d8>
    80004580:	00001097          	auipc	ra,0x1
    80004584:	5d0080e7          	jalr	1488(ra) # 80005b50 <panic>
    return 0;
    80004588:	84aa                	mv	s1,a0
    8000458a:	b739                	j	80004498 <create+0x72>

000000008000458c <sys_dup>:
{
    8000458c:	7179                	addi	sp,sp,-48
    8000458e:	f406                	sd	ra,40(sp)
    80004590:	f022                	sd	s0,32(sp)
    80004592:	ec26                	sd	s1,24(sp)
    80004594:	e84a                	sd	s2,16(sp)
    80004596:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004598:	fd840613          	addi	a2,s0,-40
    8000459c:	4581                	li	a1,0
    8000459e:	4501                	li	a0,0
    800045a0:	00000097          	auipc	ra,0x0
    800045a4:	ddc080e7          	jalr	-548(ra) # 8000437c <argfd>
    return -1;
    800045a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045aa:	02054363          	bltz	a0,800045d0 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800045ae:	fd843903          	ld	s2,-40(s0)
    800045b2:	854a                	mv	a0,s2
    800045b4:	00000097          	auipc	ra,0x0
    800045b8:	e30080e7          	jalr	-464(ra) # 800043e4 <fdalloc>
    800045bc:	84aa                	mv	s1,a0
    return -1;
    800045be:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045c0:	00054863          	bltz	a0,800045d0 <sys_dup+0x44>
  filedup(f);
    800045c4:	854a                	mv	a0,s2
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	368080e7          	jalr	872(ra) # 8000392e <filedup>
  return fd;
    800045ce:	87a6                	mv	a5,s1
}
    800045d0:	853e                	mv	a0,a5
    800045d2:	70a2                	ld	ra,40(sp)
    800045d4:	7402                	ld	s0,32(sp)
    800045d6:	64e2                	ld	s1,24(sp)
    800045d8:	6942                	ld	s2,16(sp)
    800045da:	6145                	addi	sp,sp,48
    800045dc:	8082                	ret

00000000800045de <sys_read>:
{
    800045de:	7179                	addi	sp,sp,-48
    800045e0:	f406                	sd	ra,40(sp)
    800045e2:	f022                	sd	s0,32(sp)
    800045e4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045e6:	fe840613          	addi	a2,s0,-24
    800045ea:	4581                	li	a1,0
    800045ec:	4501                	li	a0,0
    800045ee:	00000097          	auipc	ra,0x0
    800045f2:	d8e080e7          	jalr	-626(ra) # 8000437c <argfd>
    return -1;
    800045f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045f8:	04054163          	bltz	a0,8000463a <sys_read+0x5c>
    800045fc:	fe440593          	addi	a1,s0,-28
    80004600:	4509                	li	a0,2
    80004602:	ffffe097          	auipc	ra,0xffffe
    80004606:	900080e7          	jalr	-1792(ra) # 80001f02 <argint>
    return -1;
    8000460a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000460c:	02054763          	bltz	a0,8000463a <sys_read+0x5c>
    80004610:	fd840593          	addi	a1,s0,-40
    80004614:	4505                	li	a0,1
    80004616:	ffffe097          	auipc	ra,0xffffe
    8000461a:	90e080e7          	jalr	-1778(ra) # 80001f24 <argaddr>
    return -1;
    8000461e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004620:	00054d63          	bltz	a0,8000463a <sys_read+0x5c>
  return fileread(f, p, n);
    80004624:	fe442603          	lw	a2,-28(s0)
    80004628:	fd843583          	ld	a1,-40(s0)
    8000462c:	fe843503          	ld	a0,-24(s0)
    80004630:	fffff097          	auipc	ra,0xfffff
    80004634:	48a080e7          	jalr	1162(ra) # 80003aba <fileread>
    80004638:	87aa                	mv	a5,a0
}
    8000463a:	853e                	mv	a0,a5
    8000463c:	70a2                	ld	ra,40(sp)
    8000463e:	7402                	ld	s0,32(sp)
    80004640:	6145                	addi	sp,sp,48
    80004642:	8082                	ret

0000000080004644 <sys_write>:
{
    80004644:	7179                	addi	sp,sp,-48
    80004646:	f406                	sd	ra,40(sp)
    80004648:	f022                	sd	s0,32(sp)
    8000464a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000464c:	fe840613          	addi	a2,s0,-24
    80004650:	4581                	li	a1,0
    80004652:	4501                	li	a0,0
    80004654:	00000097          	auipc	ra,0x0
    80004658:	d28080e7          	jalr	-728(ra) # 8000437c <argfd>
    return -1;
    8000465c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000465e:	04054163          	bltz	a0,800046a0 <sys_write+0x5c>
    80004662:	fe440593          	addi	a1,s0,-28
    80004666:	4509                	li	a0,2
    80004668:	ffffe097          	auipc	ra,0xffffe
    8000466c:	89a080e7          	jalr	-1894(ra) # 80001f02 <argint>
    return -1;
    80004670:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004672:	02054763          	bltz	a0,800046a0 <sys_write+0x5c>
    80004676:	fd840593          	addi	a1,s0,-40
    8000467a:	4505                	li	a0,1
    8000467c:	ffffe097          	auipc	ra,0xffffe
    80004680:	8a8080e7          	jalr	-1880(ra) # 80001f24 <argaddr>
    return -1;
    80004684:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004686:	00054d63          	bltz	a0,800046a0 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000468a:	fe442603          	lw	a2,-28(s0)
    8000468e:	fd843583          	ld	a1,-40(s0)
    80004692:	fe843503          	ld	a0,-24(s0)
    80004696:	fffff097          	auipc	ra,0xfffff
    8000469a:	4e6080e7          	jalr	1254(ra) # 80003b7c <filewrite>
    8000469e:	87aa                	mv	a5,a0
}
    800046a0:	853e                	mv	a0,a5
    800046a2:	70a2                	ld	ra,40(sp)
    800046a4:	7402                	ld	s0,32(sp)
    800046a6:	6145                	addi	sp,sp,48
    800046a8:	8082                	ret

00000000800046aa <sys_close>:
{
    800046aa:	1101                	addi	sp,sp,-32
    800046ac:	ec06                	sd	ra,24(sp)
    800046ae:	e822                	sd	s0,16(sp)
    800046b0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046b2:	fe040613          	addi	a2,s0,-32
    800046b6:	fec40593          	addi	a1,s0,-20
    800046ba:	4501                	li	a0,0
    800046bc:	00000097          	auipc	ra,0x0
    800046c0:	cc0080e7          	jalr	-832(ra) # 8000437c <argfd>
    return -1;
    800046c4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046c6:	02054463          	bltz	a0,800046ee <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046ca:	ffffc097          	auipc	ra,0xffffc
    800046ce:	77a080e7          	jalr	1914(ra) # 80000e44 <myproc>
    800046d2:	fec42783          	lw	a5,-20(s0)
    800046d6:	07e9                	addi	a5,a5,26
    800046d8:	078e                	slli	a5,a5,0x3
    800046da:	953e                	add	a0,a0,a5
    800046dc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800046e0:	fe043503          	ld	a0,-32(s0)
    800046e4:	fffff097          	auipc	ra,0xfffff
    800046e8:	29c080e7          	jalr	668(ra) # 80003980 <fileclose>
  return 0;
    800046ec:	4781                	li	a5,0
}
    800046ee:	853e                	mv	a0,a5
    800046f0:	60e2                	ld	ra,24(sp)
    800046f2:	6442                	ld	s0,16(sp)
    800046f4:	6105                	addi	sp,sp,32
    800046f6:	8082                	ret

00000000800046f8 <sys_fstat>:
{
    800046f8:	1101                	addi	sp,sp,-32
    800046fa:	ec06                	sd	ra,24(sp)
    800046fc:	e822                	sd	s0,16(sp)
    800046fe:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004700:	fe840613          	addi	a2,s0,-24
    80004704:	4581                	li	a1,0
    80004706:	4501                	li	a0,0
    80004708:	00000097          	auipc	ra,0x0
    8000470c:	c74080e7          	jalr	-908(ra) # 8000437c <argfd>
    return -1;
    80004710:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004712:	02054563          	bltz	a0,8000473c <sys_fstat+0x44>
    80004716:	fe040593          	addi	a1,s0,-32
    8000471a:	4505                	li	a0,1
    8000471c:	ffffe097          	auipc	ra,0xffffe
    80004720:	808080e7          	jalr	-2040(ra) # 80001f24 <argaddr>
    return -1;
    80004724:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004726:	00054b63          	bltz	a0,8000473c <sys_fstat+0x44>
  return filestat(f, st);
    8000472a:	fe043583          	ld	a1,-32(s0)
    8000472e:	fe843503          	ld	a0,-24(s0)
    80004732:	fffff097          	auipc	ra,0xfffff
    80004736:	316080e7          	jalr	790(ra) # 80003a48 <filestat>
    8000473a:	87aa                	mv	a5,a0
}
    8000473c:	853e                	mv	a0,a5
    8000473e:	60e2                	ld	ra,24(sp)
    80004740:	6442                	ld	s0,16(sp)
    80004742:	6105                	addi	sp,sp,32
    80004744:	8082                	ret

0000000080004746 <sys_link>:
{
    80004746:	7169                	addi	sp,sp,-304
    80004748:	f606                	sd	ra,296(sp)
    8000474a:	f222                	sd	s0,288(sp)
    8000474c:	ee26                	sd	s1,280(sp)
    8000474e:	ea4a                	sd	s2,272(sp)
    80004750:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004752:	08000613          	li	a2,128
    80004756:	ed040593          	addi	a1,s0,-304
    8000475a:	4501                	li	a0,0
    8000475c:	ffffd097          	auipc	ra,0xffffd
    80004760:	7ea080e7          	jalr	2026(ra) # 80001f46 <argstr>
    return -1;
    80004764:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004766:	10054e63          	bltz	a0,80004882 <sys_link+0x13c>
    8000476a:	08000613          	li	a2,128
    8000476e:	f5040593          	addi	a1,s0,-176
    80004772:	4505                	li	a0,1
    80004774:	ffffd097          	auipc	ra,0xffffd
    80004778:	7d2080e7          	jalr	2002(ra) # 80001f46 <argstr>
    return -1;
    8000477c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000477e:	10054263          	bltz	a0,80004882 <sys_link+0x13c>
  begin_op();
    80004782:	fffff097          	auipc	ra,0xfffff
    80004786:	d36080e7          	jalr	-714(ra) # 800034b8 <begin_op>
  if((ip = namei(old)) == 0){
    8000478a:	ed040513          	addi	a0,s0,-304
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	b0a080e7          	jalr	-1270(ra) # 80003298 <namei>
    80004796:	84aa                	mv	s1,a0
    80004798:	c551                	beqz	a0,80004824 <sys_link+0xde>
  ilock(ip);
    8000479a:	ffffe097          	auipc	ra,0xffffe
    8000479e:	342080e7          	jalr	834(ra) # 80002adc <ilock>
  if(ip->type == T_DIR){
    800047a2:	04449703          	lh	a4,68(s1)
    800047a6:	4785                	li	a5,1
    800047a8:	08f70463          	beq	a4,a5,80004830 <sys_link+0xea>
  ip->nlink++;
    800047ac:	04a4d783          	lhu	a5,74(s1)
    800047b0:	2785                	addiw	a5,a5,1
    800047b2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047b6:	8526                	mv	a0,s1
    800047b8:	ffffe097          	auipc	ra,0xffffe
    800047bc:	258080e7          	jalr	600(ra) # 80002a10 <iupdate>
  iunlock(ip);
    800047c0:	8526                	mv	a0,s1
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	3dc080e7          	jalr	988(ra) # 80002b9e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047ca:	fd040593          	addi	a1,s0,-48
    800047ce:	f5040513          	addi	a0,s0,-176
    800047d2:	fffff097          	auipc	ra,0xfffff
    800047d6:	ae4080e7          	jalr	-1308(ra) # 800032b6 <nameiparent>
    800047da:	892a                	mv	s2,a0
    800047dc:	c935                	beqz	a0,80004850 <sys_link+0x10a>
  ilock(dp);
    800047de:	ffffe097          	auipc	ra,0xffffe
    800047e2:	2fe080e7          	jalr	766(ra) # 80002adc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800047e6:	00092703          	lw	a4,0(s2)
    800047ea:	409c                	lw	a5,0(s1)
    800047ec:	04f71d63          	bne	a4,a5,80004846 <sys_link+0x100>
    800047f0:	40d0                	lw	a2,4(s1)
    800047f2:	fd040593          	addi	a1,s0,-48
    800047f6:	854a                	mv	a0,s2
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	9de080e7          	jalr	-1570(ra) # 800031d6 <dirlink>
    80004800:	04054363          	bltz	a0,80004846 <sys_link+0x100>
  iunlockput(dp);
    80004804:	854a                	mv	a0,s2
    80004806:	ffffe097          	auipc	ra,0xffffe
    8000480a:	538080e7          	jalr	1336(ra) # 80002d3e <iunlockput>
  iput(ip);
    8000480e:	8526                	mv	a0,s1
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	486080e7          	jalr	1158(ra) # 80002c96 <iput>
  end_op();
    80004818:	fffff097          	auipc	ra,0xfffff
    8000481c:	d1e080e7          	jalr	-738(ra) # 80003536 <end_op>
  return 0;
    80004820:	4781                	li	a5,0
    80004822:	a085                	j	80004882 <sys_link+0x13c>
    end_op();
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	d12080e7          	jalr	-750(ra) # 80003536 <end_op>
    return -1;
    8000482c:	57fd                	li	a5,-1
    8000482e:	a891                	j	80004882 <sys_link+0x13c>
    iunlockput(ip);
    80004830:	8526                	mv	a0,s1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	50c080e7          	jalr	1292(ra) # 80002d3e <iunlockput>
    end_op();
    8000483a:	fffff097          	auipc	ra,0xfffff
    8000483e:	cfc080e7          	jalr	-772(ra) # 80003536 <end_op>
    return -1;
    80004842:	57fd                	li	a5,-1
    80004844:	a83d                	j	80004882 <sys_link+0x13c>
    iunlockput(dp);
    80004846:	854a                	mv	a0,s2
    80004848:	ffffe097          	auipc	ra,0xffffe
    8000484c:	4f6080e7          	jalr	1270(ra) # 80002d3e <iunlockput>
  ilock(ip);
    80004850:	8526                	mv	a0,s1
    80004852:	ffffe097          	auipc	ra,0xffffe
    80004856:	28a080e7          	jalr	650(ra) # 80002adc <ilock>
  ip->nlink--;
    8000485a:	04a4d783          	lhu	a5,74(s1)
    8000485e:	37fd                	addiw	a5,a5,-1
    80004860:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004864:	8526                	mv	a0,s1
    80004866:	ffffe097          	auipc	ra,0xffffe
    8000486a:	1aa080e7          	jalr	426(ra) # 80002a10 <iupdate>
  iunlockput(ip);
    8000486e:	8526                	mv	a0,s1
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	4ce080e7          	jalr	1230(ra) # 80002d3e <iunlockput>
  end_op();
    80004878:	fffff097          	auipc	ra,0xfffff
    8000487c:	cbe080e7          	jalr	-834(ra) # 80003536 <end_op>
  return -1;
    80004880:	57fd                	li	a5,-1
}
    80004882:	853e                	mv	a0,a5
    80004884:	70b2                	ld	ra,296(sp)
    80004886:	7412                	ld	s0,288(sp)
    80004888:	64f2                	ld	s1,280(sp)
    8000488a:	6952                	ld	s2,272(sp)
    8000488c:	6155                	addi	sp,sp,304
    8000488e:	8082                	ret

0000000080004890 <sys_unlink>:
{
    80004890:	7151                	addi	sp,sp,-240
    80004892:	f586                	sd	ra,232(sp)
    80004894:	f1a2                	sd	s0,224(sp)
    80004896:	eda6                	sd	s1,216(sp)
    80004898:	e9ca                	sd	s2,208(sp)
    8000489a:	e5ce                	sd	s3,200(sp)
    8000489c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000489e:	08000613          	li	a2,128
    800048a2:	f3040593          	addi	a1,s0,-208
    800048a6:	4501                	li	a0,0
    800048a8:	ffffd097          	auipc	ra,0xffffd
    800048ac:	69e080e7          	jalr	1694(ra) # 80001f46 <argstr>
    800048b0:	18054163          	bltz	a0,80004a32 <sys_unlink+0x1a2>
  begin_op();
    800048b4:	fffff097          	auipc	ra,0xfffff
    800048b8:	c04080e7          	jalr	-1020(ra) # 800034b8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048bc:	fb040593          	addi	a1,s0,-80
    800048c0:	f3040513          	addi	a0,s0,-208
    800048c4:	fffff097          	auipc	ra,0xfffff
    800048c8:	9f2080e7          	jalr	-1550(ra) # 800032b6 <nameiparent>
    800048cc:	84aa                	mv	s1,a0
    800048ce:	c979                	beqz	a0,800049a4 <sys_unlink+0x114>
  ilock(dp);
    800048d0:	ffffe097          	auipc	ra,0xffffe
    800048d4:	20c080e7          	jalr	524(ra) # 80002adc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048d8:	00004597          	auipc	a1,0x4
    800048dc:	dc058593          	addi	a1,a1,-576 # 80008698 <syscalls+0x2b8>
    800048e0:	fb040513          	addi	a0,s0,-80
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	6c2080e7          	jalr	1730(ra) # 80002fa6 <namecmp>
    800048ec:	14050a63          	beqz	a0,80004a40 <sys_unlink+0x1b0>
    800048f0:	00004597          	auipc	a1,0x4
    800048f4:	db058593          	addi	a1,a1,-592 # 800086a0 <syscalls+0x2c0>
    800048f8:	fb040513          	addi	a0,s0,-80
    800048fc:	ffffe097          	auipc	ra,0xffffe
    80004900:	6aa080e7          	jalr	1706(ra) # 80002fa6 <namecmp>
    80004904:	12050e63          	beqz	a0,80004a40 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004908:	f2c40613          	addi	a2,s0,-212
    8000490c:	fb040593          	addi	a1,s0,-80
    80004910:	8526                	mv	a0,s1
    80004912:	ffffe097          	auipc	ra,0xffffe
    80004916:	6ae080e7          	jalr	1710(ra) # 80002fc0 <dirlookup>
    8000491a:	892a                	mv	s2,a0
    8000491c:	12050263          	beqz	a0,80004a40 <sys_unlink+0x1b0>
  ilock(ip);
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	1bc080e7          	jalr	444(ra) # 80002adc <ilock>
  if(ip->nlink < 1)
    80004928:	04a91783          	lh	a5,74(s2)
    8000492c:	08f05263          	blez	a5,800049b0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004930:	04491703          	lh	a4,68(s2)
    80004934:	4785                	li	a5,1
    80004936:	08f70563          	beq	a4,a5,800049c0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000493a:	4641                	li	a2,16
    8000493c:	4581                	li	a1,0
    8000493e:	fc040513          	addi	a0,s0,-64
    80004942:	ffffc097          	auipc	ra,0xffffc
    80004946:	838080e7          	jalr	-1992(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000494a:	4741                	li	a4,16
    8000494c:	f2c42683          	lw	a3,-212(s0)
    80004950:	fc040613          	addi	a2,s0,-64
    80004954:	4581                	li	a1,0
    80004956:	8526                	mv	a0,s1
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	530080e7          	jalr	1328(ra) # 80002e88 <writei>
    80004960:	47c1                	li	a5,16
    80004962:	0af51563          	bne	a0,a5,80004a0c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004966:	04491703          	lh	a4,68(s2)
    8000496a:	4785                	li	a5,1
    8000496c:	0af70863          	beq	a4,a5,80004a1c <sys_unlink+0x18c>
  iunlockput(dp);
    80004970:	8526                	mv	a0,s1
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	3cc080e7          	jalr	972(ra) # 80002d3e <iunlockput>
  ip->nlink--;
    8000497a:	04a95783          	lhu	a5,74(s2)
    8000497e:	37fd                	addiw	a5,a5,-1
    80004980:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004984:	854a                	mv	a0,s2
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	08a080e7          	jalr	138(ra) # 80002a10 <iupdate>
  iunlockput(ip);
    8000498e:	854a                	mv	a0,s2
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	3ae080e7          	jalr	942(ra) # 80002d3e <iunlockput>
  end_op();
    80004998:	fffff097          	auipc	ra,0xfffff
    8000499c:	b9e080e7          	jalr	-1122(ra) # 80003536 <end_op>
  return 0;
    800049a0:	4501                	li	a0,0
    800049a2:	a84d                	j	80004a54 <sys_unlink+0x1c4>
    end_op();
    800049a4:	fffff097          	auipc	ra,0xfffff
    800049a8:	b92080e7          	jalr	-1134(ra) # 80003536 <end_op>
    return -1;
    800049ac:	557d                	li	a0,-1
    800049ae:	a05d                	j	80004a54 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049b0:	00004517          	auipc	a0,0x4
    800049b4:	d1850513          	addi	a0,a0,-744 # 800086c8 <syscalls+0x2e8>
    800049b8:	00001097          	auipc	ra,0x1
    800049bc:	198080e7          	jalr	408(ra) # 80005b50 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049c0:	04c92703          	lw	a4,76(s2)
    800049c4:	02000793          	li	a5,32
    800049c8:	f6e7f9e3          	bgeu	a5,a4,8000493a <sys_unlink+0xaa>
    800049cc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049d0:	4741                	li	a4,16
    800049d2:	86ce                	mv	a3,s3
    800049d4:	f1840613          	addi	a2,s0,-232
    800049d8:	4581                	li	a1,0
    800049da:	854a                	mv	a0,s2
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	3b4080e7          	jalr	948(ra) # 80002d90 <readi>
    800049e4:	47c1                	li	a5,16
    800049e6:	00f51b63          	bne	a0,a5,800049fc <sys_unlink+0x16c>
    if(de.inum != 0)
    800049ea:	f1845783          	lhu	a5,-232(s0)
    800049ee:	e7a1                	bnez	a5,80004a36 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049f0:	29c1                	addiw	s3,s3,16
    800049f2:	04c92783          	lw	a5,76(s2)
    800049f6:	fcf9ede3          	bltu	s3,a5,800049d0 <sys_unlink+0x140>
    800049fa:	b781                	j	8000493a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800049fc:	00004517          	auipc	a0,0x4
    80004a00:	ce450513          	addi	a0,a0,-796 # 800086e0 <syscalls+0x300>
    80004a04:	00001097          	auipc	ra,0x1
    80004a08:	14c080e7          	jalr	332(ra) # 80005b50 <panic>
    panic("unlink: writei");
    80004a0c:	00004517          	auipc	a0,0x4
    80004a10:	cec50513          	addi	a0,a0,-788 # 800086f8 <syscalls+0x318>
    80004a14:	00001097          	auipc	ra,0x1
    80004a18:	13c080e7          	jalr	316(ra) # 80005b50 <panic>
    dp->nlink--;
    80004a1c:	04a4d783          	lhu	a5,74(s1)
    80004a20:	37fd                	addiw	a5,a5,-1
    80004a22:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a26:	8526                	mv	a0,s1
    80004a28:	ffffe097          	auipc	ra,0xffffe
    80004a2c:	fe8080e7          	jalr	-24(ra) # 80002a10 <iupdate>
    80004a30:	b781                	j	80004970 <sys_unlink+0xe0>
    return -1;
    80004a32:	557d                	li	a0,-1
    80004a34:	a005                	j	80004a54 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a36:	854a                	mv	a0,s2
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	306080e7          	jalr	774(ra) # 80002d3e <iunlockput>
  iunlockput(dp);
    80004a40:	8526                	mv	a0,s1
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	2fc080e7          	jalr	764(ra) # 80002d3e <iunlockput>
  end_op();
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	aec080e7          	jalr	-1300(ra) # 80003536 <end_op>
  return -1;
    80004a52:	557d                	li	a0,-1
}
    80004a54:	70ae                	ld	ra,232(sp)
    80004a56:	740e                	ld	s0,224(sp)
    80004a58:	64ee                	ld	s1,216(sp)
    80004a5a:	694e                	ld	s2,208(sp)
    80004a5c:	69ae                	ld	s3,200(sp)
    80004a5e:	616d                	addi	sp,sp,240
    80004a60:	8082                	ret

0000000080004a62 <sys_open>:

uint64
sys_open(void)
{
    80004a62:	7131                	addi	sp,sp,-192
    80004a64:	fd06                	sd	ra,184(sp)
    80004a66:	f922                	sd	s0,176(sp)
    80004a68:	f526                	sd	s1,168(sp)
    80004a6a:	f14a                	sd	s2,160(sp)
    80004a6c:	ed4e                	sd	s3,152(sp)
    80004a6e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004a70:	08000613          	li	a2,128
    80004a74:	f5040593          	addi	a1,s0,-176
    80004a78:	4501                	li	a0,0
    80004a7a:	ffffd097          	auipc	ra,0xffffd
    80004a7e:	4cc080e7          	jalr	1228(ra) # 80001f46 <argstr>
    return -1;
    80004a82:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004a84:	0c054163          	bltz	a0,80004b46 <sys_open+0xe4>
    80004a88:	f4c40593          	addi	a1,s0,-180
    80004a8c:	4505                	li	a0,1
    80004a8e:	ffffd097          	auipc	ra,0xffffd
    80004a92:	474080e7          	jalr	1140(ra) # 80001f02 <argint>
    80004a96:	0a054863          	bltz	a0,80004b46 <sys_open+0xe4>

  begin_op();
    80004a9a:	fffff097          	auipc	ra,0xfffff
    80004a9e:	a1e080e7          	jalr	-1506(ra) # 800034b8 <begin_op>

  if(omode & O_CREATE){
    80004aa2:	f4c42783          	lw	a5,-180(s0)
    80004aa6:	2007f793          	andi	a5,a5,512
    80004aaa:	cbdd                	beqz	a5,80004b60 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004aac:	4681                	li	a3,0
    80004aae:	4601                	li	a2,0
    80004ab0:	4589                	li	a1,2
    80004ab2:	f5040513          	addi	a0,s0,-176
    80004ab6:	00000097          	auipc	ra,0x0
    80004aba:	970080e7          	jalr	-1680(ra) # 80004426 <create>
    80004abe:	892a                	mv	s2,a0
    if(ip == 0){
    80004ac0:	c959                	beqz	a0,80004b56 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ac2:	04491703          	lh	a4,68(s2)
    80004ac6:	478d                	li	a5,3
    80004ac8:	00f71763          	bne	a4,a5,80004ad6 <sys_open+0x74>
    80004acc:	04695703          	lhu	a4,70(s2)
    80004ad0:	47a5                	li	a5,9
    80004ad2:	0ce7ec63          	bltu	a5,a4,80004baa <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	dee080e7          	jalr	-530(ra) # 800038c4 <filealloc>
    80004ade:	89aa                	mv	s3,a0
    80004ae0:	10050263          	beqz	a0,80004be4 <sys_open+0x182>
    80004ae4:	00000097          	auipc	ra,0x0
    80004ae8:	900080e7          	jalr	-1792(ra) # 800043e4 <fdalloc>
    80004aec:	84aa                	mv	s1,a0
    80004aee:	0e054663          	bltz	a0,80004bda <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004af2:	04491703          	lh	a4,68(s2)
    80004af6:	478d                	li	a5,3
    80004af8:	0cf70463          	beq	a4,a5,80004bc0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004afc:	4789                	li	a5,2
    80004afe:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b02:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b06:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b0a:	f4c42783          	lw	a5,-180(s0)
    80004b0e:	0017c713          	xori	a4,a5,1
    80004b12:	8b05                	andi	a4,a4,1
    80004b14:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b18:	0037f713          	andi	a4,a5,3
    80004b1c:	00e03733          	snez	a4,a4
    80004b20:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b24:	4007f793          	andi	a5,a5,1024
    80004b28:	c791                	beqz	a5,80004b34 <sys_open+0xd2>
    80004b2a:	04491703          	lh	a4,68(s2)
    80004b2e:	4789                	li	a5,2
    80004b30:	08f70f63          	beq	a4,a5,80004bce <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b34:	854a                	mv	a0,s2
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	068080e7          	jalr	104(ra) # 80002b9e <iunlock>
  end_op();
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	9f8080e7          	jalr	-1544(ra) # 80003536 <end_op>

  return fd;
}
    80004b46:	8526                	mv	a0,s1
    80004b48:	70ea                	ld	ra,184(sp)
    80004b4a:	744a                	ld	s0,176(sp)
    80004b4c:	74aa                	ld	s1,168(sp)
    80004b4e:	790a                	ld	s2,160(sp)
    80004b50:	69ea                	ld	s3,152(sp)
    80004b52:	6129                	addi	sp,sp,192
    80004b54:	8082                	ret
      end_op();
    80004b56:	fffff097          	auipc	ra,0xfffff
    80004b5a:	9e0080e7          	jalr	-1568(ra) # 80003536 <end_op>
      return -1;
    80004b5e:	b7e5                	j	80004b46 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b60:	f5040513          	addi	a0,s0,-176
    80004b64:	ffffe097          	auipc	ra,0xffffe
    80004b68:	734080e7          	jalr	1844(ra) # 80003298 <namei>
    80004b6c:	892a                	mv	s2,a0
    80004b6e:	c905                	beqz	a0,80004b9e <sys_open+0x13c>
    ilock(ip);
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	f6c080e7          	jalr	-148(ra) # 80002adc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b78:	04491703          	lh	a4,68(s2)
    80004b7c:	4785                	li	a5,1
    80004b7e:	f4f712e3          	bne	a4,a5,80004ac2 <sys_open+0x60>
    80004b82:	f4c42783          	lw	a5,-180(s0)
    80004b86:	dba1                	beqz	a5,80004ad6 <sys_open+0x74>
      iunlockput(ip);
    80004b88:	854a                	mv	a0,s2
    80004b8a:	ffffe097          	auipc	ra,0xffffe
    80004b8e:	1b4080e7          	jalr	436(ra) # 80002d3e <iunlockput>
      end_op();
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	9a4080e7          	jalr	-1628(ra) # 80003536 <end_op>
      return -1;
    80004b9a:	54fd                	li	s1,-1
    80004b9c:	b76d                	j	80004b46 <sys_open+0xe4>
      end_op();
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	998080e7          	jalr	-1640(ra) # 80003536 <end_op>
      return -1;
    80004ba6:	54fd                	li	s1,-1
    80004ba8:	bf79                	j	80004b46 <sys_open+0xe4>
    iunlockput(ip);
    80004baa:	854a                	mv	a0,s2
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	192080e7          	jalr	402(ra) # 80002d3e <iunlockput>
    end_op();
    80004bb4:	fffff097          	auipc	ra,0xfffff
    80004bb8:	982080e7          	jalr	-1662(ra) # 80003536 <end_op>
    return -1;
    80004bbc:	54fd                	li	s1,-1
    80004bbe:	b761                	j	80004b46 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004bc0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004bc4:	04691783          	lh	a5,70(s2)
    80004bc8:	02f99223          	sh	a5,36(s3)
    80004bcc:	bf2d                	j	80004b06 <sys_open+0xa4>
    itrunc(ip);
    80004bce:	854a                	mv	a0,s2
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	01a080e7          	jalr	26(ra) # 80002bea <itrunc>
    80004bd8:	bfb1                	j	80004b34 <sys_open+0xd2>
      fileclose(f);
    80004bda:	854e                	mv	a0,s3
    80004bdc:	fffff097          	auipc	ra,0xfffff
    80004be0:	da4080e7          	jalr	-604(ra) # 80003980 <fileclose>
    iunlockput(ip);
    80004be4:	854a                	mv	a0,s2
    80004be6:	ffffe097          	auipc	ra,0xffffe
    80004bea:	158080e7          	jalr	344(ra) # 80002d3e <iunlockput>
    end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	948080e7          	jalr	-1720(ra) # 80003536 <end_op>
    return -1;
    80004bf6:	54fd                	li	s1,-1
    80004bf8:	b7b9                	j	80004b46 <sys_open+0xe4>

0000000080004bfa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004bfa:	7175                	addi	sp,sp,-144
    80004bfc:	e506                	sd	ra,136(sp)
    80004bfe:	e122                	sd	s0,128(sp)
    80004c00:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	8b6080e7          	jalr	-1866(ra) # 800034b8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c0a:	08000613          	li	a2,128
    80004c0e:	f7040593          	addi	a1,s0,-144
    80004c12:	4501                	li	a0,0
    80004c14:	ffffd097          	auipc	ra,0xffffd
    80004c18:	332080e7          	jalr	818(ra) # 80001f46 <argstr>
    80004c1c:	02054963          	bltz	a0,80004c4e <sys_mkdir+0x54>
    80004c20:	4681                	li	a3,0
    80004c22:	4601                	li	a2,0
    80004c24:	4585                	li	a1,1
    80004c26:	f7040513          	addi	a0,s0,-144
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	7fc080e7          	jalr	2044(ra) # 80004426 <create>
    80004c32:	cd11                	beqz	a0,80004c4e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	10a080e7          	jalr	266(ra) # 80002d3e <iunlockput>
  end_op();
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	8fa080e7          	jalr	-1798(ra) # 80003536 <end_op>
  return 0;
    80004c44:	4501                	li	a0,0
}
    80004c46:	60aa                	ld	ra,136(sp)
    80004c48:	640a                	ld	s0,128(sp)
    80004c4a:	6149                	addi	sp,sp,144
    80004c4c:	8082                	ret
    end_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	8e8080e7          	jalr	-1816(ra) # 80003536 <end_op>
    return -1;
    80004c56:	557d                	li	a0,-1
    80004c58:	b7fd                	j	80004c46 <sys_mkdir+0x4c>

0000000080004c5a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c5a:	7135                	addi	sp,sp,-160
    80004c5c:	ed06                	sd	ra,152(sp)
    80004c5e:	e922                	sd	s0,144(sp)
    80004c60:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c62:	fffff097          	auipc	ra,0xfffff
    80004c66:	856080e7          	jalr	-1962(ra) # 800034b8 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c6a:	08000613          	li	a2,128
    80004c6e:	f7040593          	addi	a1,s0,-144
    80004c72:	4501                	li	a0,0
    80004c74:	ffffd097          	auipc	ra,0xffffd
    80004c78:	2d2080e7          	jalr	722(ra) # 80001f46 <argstr>
    80004c7c:	04054a63          	bltz	a0,80004cd0 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004c80:	f6c40593          	addi	a1,s0,-148
    80004c84:	4505                	li	a0,1
    80004c86:	ffffd097          	auipc	ra,0xffffd
    80004c8a:	27c080e7          	jalr	636(ra) # 80001f02 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c8e:	04054163          	bltz	a0,80004cd0 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004c92:	f6840593          	addi	a1,s0,-152
    80004c96:	4509                	li	a0,2
    80004c98:	ffffd097          	auipc	ra,0xffffd
    80004c9c:	26a080e7          	jalr	618(ra) # 80001f02 <argint>
     argint(1, &major) < 0 ||
    80004ca0:	02054863          	bltz	a0,80004cd0 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ca4:	f6841683          	lh	a3,-152(s0)
    80004ca8:	f6c41603          	lh	a2,-148(s0)
    80004cac:	458d                	li	a1,3
    80004cae:	f7040513          	addi	a0,s0,-144
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	774080e7          	jalr	1908(ra) # 80004426 <create>
     argint(2, &minor) < 0 ||
    80004cba:	c919                	beqz	a0,80004cd0 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cbc:	ffffe097          	auipc	ra,0xffffe
    80004cc0:	082080e7          	jalr	130(ra) # 80002d3e <iunlockput>
  end_op();
    80004cc4:	fffff097          	auipc	ra,0xfffff
    80004cc8:	872080e7          	jalr	-1934(ra) # 80003536 <end_op>
  return 0;
    80004ccc:	4501                	li	a0,0
    80004cce:	a031                	j	80004cda <sys_mknod+0x80>
    end_op();
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	866080e7          	jalr	-1946(ra) # 80003536 <end_op>
    return -1;
    80004cd8:	557d                	li	a0,-1
}
    80004cda:	60ea                	ld	ra,152(sp)
    80004cdc:	644a                	ld	s0,144(sp)
    80004cde:	610d                	addi	sp,sp,160
    80004ce0:	8082                	ret

0000000080004ce2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ce2:	7135                	addi	sp,sp,-160
    80004ce4:	ed06                	sd	ra,152(sp)
    80004ce6:	e922                	sd	s0,144(sp)
    80004ce8:	e526                	sd	s1,136(sp)
    80004cea:	e14a                	sd	s2,128(sp)
    80004cec:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004cee:	ffffc097          	auipc	ra,0xffffc
    80004cf2:	156080e7          	jalr	342(ra) # 80000e44 <myproc>
    80004cf6:	892a                	mv	s2,a0
  
  begin_op();
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	7c0080e7          	jalr	1984(ra) # 800034b8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d00:	08000613          	li	a2,128
    80004d04:	f6040593          	addi	a1,s0,-160
    80004d08:	4501                	li	a0,0
    80004d0a:	ffffd097          	auipc	ra,0xffffd
    80004d0e:	23c080e7          	jalr	572(ra) # 80001f46 <argstr>
    80004d12:	04054b63          	bltz	a0,80004d68 <sys_chdir+0x86>
    80004d16:	f6040513          	addi	a0,s0,-160
    80004d1a:	ffffe097          	auipc	ra,0xffffe
    80004d1e:	57e080e7          	jalr	1406(ra) # 80003298 <namei>
    80004d22:	84aa                	mv	s1,a0
    80004d24:	c131                	beqz	a0,80004d68 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	db6080e7          	jalr	-586(ra) # 80002adc <ilock>
  if(ip->type != T_DIR){
    80004d2e:	04449703          	lh	a4,68(s1)
    80004d32:	4785                	li	a5,1
    80004d34:	04f71063          	bne	a4,a5,80004d74 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d38:	8526                	mv	a0,s1
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	e64080e7          	jalr	-412(ra) # 80002b9e <iunlock>
  iput(p->cwd);
    80004d42:	15093503          	ld	a0,336(s2)
    80004d46:	ffffe097          	auipc	ra,0xffffe
    80004d4a:	f50080e7          	jalr	-176(ra) # 80002c96 <iput>
  end_op();
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	7e8080e7          	jalr	2024(ra) # 80003536 <end_op>
  p->cwd = ip;
    80004d56:	14993823          	sd	s1,336(s2)
  return 0;
    80004d5a:	4501                	li	a0,0
}
    80004d5c:	60ea                	ld	ra,152(sp)
    80004d5e:	644a                	ld	s0,144(sp)
    80004d60:	64aa                	ld	s1,136(sp)
    80004d62:	690a                	ld	s2,128(sp)
    80004d64:	610d                	addi	sp,sp,160
    80004d66:	8082                	ret
    end_op();
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	7ce080e7          	jalr	1998(ra) # 80003536 <end_op>
    return -1;
    80004d70:	557d                	li	a0,-1
    80004d72:	b7ed                	j	80004d5c <sys_chdir+0x7a>
    iunlockput(ip);
    80004d74:	8526                	mv	a0,s1
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	fc8080e7          	jalr	-56(ra) # 80002d3e <iunlockput>
    end_op();
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	7b8080e7          	jalr	1976(ra) # 80003536 <end_op>
    return -1;
    80004d86:	557d                	li	a0,-1
    80004d88:	bfd1                	j	80004d5c <sys_chdir+0x7a>

0000000080004d8a <sys_exec>:

uint64
sys_exec(void)
{
    80004d8a:	7145                	addi	sp,sp,-464
    80004d8c:	e786                	sd	ra,456(sp)
    80004d8e:	e3a2                	sd	s0,448(sp)
    80004d90:	ff26                	sd	s1,440(sp)
    80004d92:	fb4a                	sd	s2,432(sp)
    80004d94:	f74e                	sd	s3,424(sp)
    80004d96:	f352                	sd	s4,416(sp)
    80004d98:	ef56                	sd	s5,408(sp)
    80004d9a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d9c:	08000613          	li	a2,128
    80004da0:	f4040593          	addi	a1,s0,-192
    80004da4:	4501                	li	a0,0
    80004da6:	ffffd097          	auipc	ra,0xffffd
    80004daa:	1a0080e7          	jalr	416(ra) # 80001f46 <argstr>
    return -1;
    80004dae:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004db0:	0c054b63          	bltz	a0,80004e86 <sys_exec+0xfc>
    80004db4:	e3840593          	addi	a1,s0,-456
    80004db8:	4505                	li	a0,1
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	16a080e7          	jalr	362(ra) # 80001f24 <argaddr>
    80004dc2:	0c054263          	bltz	a0,80004e86 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004dc6:	10000613          	li	a2,256
    80004dca:	4581                	li	a1,0
    80004dcc:	e4040513          	addi	a0,s0,-448
    80004dd0:	ffffb097          	auipc	ra,0xffffb
    80004dd4:	3aa080e7          	jalr	938(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004dd8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ddc:	89a6                	mv	s3,s1
    80004dde:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004de0:	02000a13          	li	s4,32
    80004de4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004de8:	00391513          	slli	a0,s2,0x3
    80004dec:	e3040593          	addi	a1,s0,-464
    80004df0:	e3843783          	ld	a5,-456(s0)
    80004df4:	953e                	add	a0,a0,a5
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	072080e7          	jalr	114(ra) # 80001e68 <fetchaddr>
    80004dfe:	02054a63          	bltz	a0,80004e32 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004e02:	e3043783          	ld	a5,-464(s0)
    80004e06:	c3b9                	beqz	a5,80004e4c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e08:	ffffb097          	auipc	ra,0xffffb
    80004e0c:	312080e7          	jalr	786(ra) # 8000011a <kalloc>
    80004e10:	85aa                	mv	a1,a0
    80004e12:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e16:	cd11                	beqz	a0,80004e32 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e18:	6605                	lui	a2,0x1
    80004e1a:	e3043503          	ld	a0,-464(s0)
    80004e1e:	ffffd097          	auipc	ra,0xffffd
    80004e22:	09c080e7          	jalr	156(ra) # 80001eba <fetchstr>
    80004e26:	00054663          	bltz	a0,80004e32 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004e2a:	0905                	addi	s2,s2,1
    80004e2c:	09a1                	addi	s3,s3,8
    80004e2e:	fb491be3          	bne	s2,s4,80004de4 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e32:	f4040913          	addi	s2,s0,-192
    80004e36:	6088                	ld	a0,0(s1)
    80004e38:	c531                	beqz	a0,80004e84 <sys_exec+0xfa>
    kfree(argv[i]);
    80004e3a:	ffffb097          	auipc	ra,0xffffb
    80004e3e:	1e2080e7          	jalr	482(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e42:	04a1                	addi	s1,s1,8
    80004e44:	ff2499e3          	bne	s1,s2,80004e36 <sys_exec+0xac>
  return -1;
    80004e48:	597d                	li	s2,-1
    80004e4a:	a835                	j	80004e86 <sys_exec+0xfc>
      argv[i] = 0;
    80004e4c:	0a8e                	slli	s5,s5,0x3
    80004e4e:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80004e52:	00878ab3          	add	s5,a5,s0
    80004e56:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e5a:	e4040593          	addi	a1,s0,-448
    80004e5e:	f4040513          	addi	a0,s0,-192
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	172080e7          	jalr	370(ra) # 80003fd4 <exec>
    80004e6a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e6c:	f4040993          	addi	s3,s0,-192
    80004e70:	6088                	ld	a0,0(s1)
    80004e72:	c911                	beqz	a0,80004e86 <sys_exec+0xfc>
    kfree(argv[i]);
    80004e74:	ffffb097          	auipc	ra,0xffffb
    80004e78:	1a8080e7          	jalr	424(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e7c:	04a1                	addi	s1,s1,8
    80004e7e:	ff3499e3          	bne	s1,s3,80004e70 <sys_exec+0xe6>
    80004e82:	a011                	j	80004e86 <sys_exec+0xfc>
  return -1;
    80004e84:	597d                	li	s2,-1
}
    80004e86:	854a                	mv	a0,s2
    80004e88:	60be                	ld	ra,456(sp)
    80004e8a:	641e                	ld	s0,448(sp)
    80004e8c:	74fa                	ld	s1,440(sp)
    80004e8e:	795a                	ld	s2,432(sp)
    80004e90:	79ba                	ld	s3,424(sp)
    80004e92:	7a1a                	ld	s4,416(sp)
    80004e94:	6afa                	ld	s5,408(sp)
    80004e96:	6179                	addi	sp,sp,464
    80004e98:	8082                	ret

0000000080004e9a <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e9a:	7139                	addi	sp,sp,-64
    80004e9c:	fc06                	sd	ra,56(sp)
    80004e9e:	f822                	sd	s0,48(sp)
    80004ea0:	f426                	sd	s1,40(sp)
    80004ea2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004ea4:	ffffc097          	auipc	ra,0xffffc
    80004ea8:	fa0080e7          	jalr	-96(ra) # 80000e44 <myproc>
    80004eac:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004eae:	fd840593          	addi	a1,s0,-40
    80004eb2:	4501                	li	a0,0
    80004eb4:	ffffd097          	auipc	ra,0xffffd
    80004eb8:	070080e7          	jalr	112(ra) # 80001f24 <argaddr>
    return -1;
    80004ebc:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004ebe:	0e054063          	bltz	a0,80004f9e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004ec2:	fc840593          	addi	a1,s0,-56
    80004ec6:	fd040513          	addi	a0,s0,-48
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	de6080e7          	jalr	-538(ra) # 80003cb0 <pipealloc>
    return -1;
    80004ed2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ed4:	0c054563          	bltz	a0,80004f9e <sys_pipe+0x104>
  fd0 = -1;
    80004ed8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004edc:	fd043503          	ld	a0,-48(s0)
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	504080e7          	jalr	1284(ra) # 800043e4 <fdalloc>
    80004ee8:	fca42223          	sw	a0,-60(s0)
    80004eec:	08054c63          	bltz	a0,80004f84 <sys_pipe+0xea>
    80004ef0:	fc843503          	ld	a0,-56(s0)
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	4f0080e7          	jalr	1264(ra) # 800043e4 <fdalloc>
    80004efc:	fca42023          	sw	a0,-64(s0)
    80004f00:	06054963          	bltz	a0,80004f72 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f04:	4691                	li	a3,4
    80004f06:	fc440613          	addi	a2,s0,-60
    80004f0a:	fd843583          	ld	a1,-40(s0)
    80004f0e:	68a8                	ld	a0,80(s1)
    80004f10:	ffffc097          	auipc	ra,0xffffc
    80004f14:	bf8080e7          	jalr	-1032(ra) # 80000b08 <copyout>
    80004f18:	02054063          	bltz	a0,80004f38 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f1c:	4691                	li	a3,4
    80004f1e:	fc040613          	addi	a2,s0,-64
    80004f22:	fd843583          	ld	a1,-40(s0)
    80004f26:	0591                	addi	a1,a1,4
    80004f28:	68a8                	ld	a0,80(s1)
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	bde080e7          	jalr	-1058(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f32:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f34:	06055563          	bgez	a0,80004f9e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004f38:	fc442783          	lw	a5,-60(s0)
    80004f3c:	07e9                	addi	a5,a5,26
    80004f3e:	078e                	slli	a5,a5,0x3
    80004f40:	97a6                	add	a5,a5,s1
    80004f42:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f46:	fc042783          	lw	a5,-64(s0)
    80004f4a:	07e9                	addi	a5,a5,26
    80004f4c:	078e                	slli	a5,a5,0x3
    80004f4e:	00f48533          	add	a0,s1,a5
    80004f52:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004f56:	fd043503          	ld	a0,-48(s0)
    80004f5a:	fffff097          	auipc	ra,0xfffff
    80004f5e:	a26080e7          	jalr	-1498(ra) # 80003980 <fileclose>
    fileclose(wf);
    80004f62:	fc843503          	ld	a0,-56(s0)
    80004f66:	fffff097          	auipc	ra,0xfffff
    80004f6a:	a1a080e7          	jalr	-1510(ra) # 80003980 <fileclose>
    return -1;
    80004f6e:	57fd                	li	a5,-1
    80004f70:	a03d                	j	80004f9e <sys_pipe+0x104>
    if(fd0 >= 0)
    80004f72:	fc442783          	lw	a5,-60(s0)
    80004f76:	0007c763          	bltz	a5,80004f84 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004f7a:	07e9                	addi	a5,a5,26
    80004f7c:	078e                	slli	a5,a5,0x3
    80004f7e:	97a6                	add	a5,a5,s1
    80004f80:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004f84:	fd043503          	ld	a0,-48(s0)
    80004f88:	fffff097          	auipc	ra,0xfffff
    80004f8c:	9f8080e7          	jalr	-1544(ra) # 80003980 <fileclose>
    fileclose(wf);
    80004f90:	fc843503          	ld	a0,-56(s0)
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	9ec080e7          	jalr	-1556(ra) # 80003980 <fileclose>
    return -1;
    80004f9c:	57fd                	li	a5,-1
}
    80004f9e:	853e                	mv	a0,a5
    80004fa0:	70e2                	ld	ra,56(sp)
    80004fa2:	7442                	ld	s0,48(sp)
    80004fa4:	74a2                	ld	s1,40(sp)
    80004fa6:	6121                	addi	sp,sp,64
    80004fa8:	8082                	ret
    80004faa:	0000                	unimp
    80004fac:	0000                	unimp
	...

0000000080004fb0 <kernelvec>:
    80004fb0:	7111                	addi	sp,sp,-256
    80004fb2:	e006                	sd	ra,0(sp)
    80004fb4:	e40a                	sd	sp,8(sp)
    80004fb6:	e80e                	sd	gp,16(sp)
    80004fb8:	ec12                	sd	tp,24(sp)
    80004fba:	f016                	sd	t0,32(sp)
    80004fbc:	f41a                	sd	t1,40(sp)
    80004fbe:	f81e                	sd	t2,48(sp)
    80004fc0:	fc22                	sd	s0,56(sp)
    80004fc2:	e0a6                	sd	s1,64(sp)
    80004fc4:	e4aa                	sd	a0,72(sp)
    80004fc6:	e8ae                	sd	a1,80(sp)
    80004fc8:	ecb2                	sd	a2,88(sp)
    80004fca:	f0b6                	sd	a3,96(sp)
    80004fcc:	f4ba                	sd	a4,104(sp)
    80004fce:	f8be                	sd	a5,112(sp)
    80004fd0:	fcc2                	sd	a6,120(sp)
    80004fd2:	e146                	sd	a7,128(sp)
    80004fd4:	e54a                	sd	s2,136(sp)
    80004fd6:	e94e                	sd	s3,144(sp)
    80004fd8:	ed52                	sd	s4,152(sp)
    80004fda:	f156                	sd	s5,160(sp)
    80004fdc:	f55a                	sd	s6,168(sp)
    80004fde:	f95e                	sd	s7,176(sp)
    80004fe0:	fd62                	sd	s8,184(sp)
    80004fe2:	e1e6                	sd	s9,192(sp)
    80004fe4:	e5ea                	sd	s10,200(sp)
    80004fe6:	e9ee                	sd	s11,208(sp)
    80004fe8:	edf2                	sd	t3,216(sp)
    80004fea:	f1f6                	sd	t4,224(sp)
    80004fec:	f5fa                	sd	t5,232(sp)
    80004fee:	f9fe                	sd	t6,240(sp)
    80004ff0:	d45fc0ef          	jal	ra,80001d34 <kerneltrap>
    80004ff4:	6082                	ld	ra,0(sp)
    80004ff6:	6122                	ld	sp,8(sp)
    80004ff8:	61c2                	ld	gp,16(sp)
    80004ffa:	7282                	ld	t0,32(sp)
    80004ffc:	7322                	ld	t1,40(sp)
    80004ffe:	73c2                	ld	t2,48(sp)
    80005000:	7462                	ld	s0,56(sp)
    80005002:	6486                	ld	s1,64(sp)
    80005004:	6526                	ld	a0,72(sp)
    80005006:	65c6                	ld	a1,80(sp)
    80005008:	6666                	ld	a2,88(sp)
    8000500a:	7686                	ld	a3,96(sp)
    8000500c:	7726                	ld	a4,104(sp)
    8000500e:	77c6                	ld	a5,112(sp)
    80005010:	7866                	ld	a6,120(sp)
    80005012:	688a                	ld	a7,128(sp)
    80005014:	692a                	ld	s2,136(sp)
    80005016:	69ca                	ld	s3,144(sp)
    80005018:	6a6a                	ld	s4,152(sp)
    8000501a:	7a8a                	ld	s5,160(sp)
    8000501c:	7b2a                	ld	s6,168(sp)
    8000501e:	7bca                	ld	s7,176(sp)
    80005020:	7c6a                	ld	s8,184(sp)
    80005022:	6c8e                	ld	s9,192(sp)
    80005024:	6d2e                	ld	s10,200(sp)
    80005026:	6dce                	ld	s11,208(sp)
    80005028:	6e6e                	ld	t3,216(sp)
    8000502a:	7e8e                	ld	t4,224(sp)
    8000502c:	7f2e                	ld	t5,232(sp)
    8000502e:	7fce                	ld	t6,240(sp)
    80005030:	6111                	addi	sp,sp,256
    80005032:	10200073          	sret
    80005036:	00000013          	nop
    8000503a:	00000013          	nop
    8000503e:	0001                	nop

0000000080005040 <timervec>:
    80005040:	34051573          	csrrw	a0,mscratch,a0
    80005044:	e10c                	sd	a1,0(a0)
    80005046:	e510                	sd	a2,8(a0)
    80005048:	e914                	sd	a3,16(a0)
    8000504a:	6d0c                	ld	a1,24(a0)
    8000504c:	7110                	ld	a2,32(a0)
    8000504e:	6194                	ld	a3,0(a1)
    80005050:	96b2                	add	a3,a3,a2
    80005052:	e194                	sd	a3,0(a1)
    80005054:	4589                	li	a1,2
    80005056:	14459073          	csrw	sip,a1
    8000505a:	6914                	ld	a3,16(a0)
    8000505c:	6510                	ld	a2,8(a0)
    8000505e:	610c                	ld	a1,0(a0)
    80005060:	34051573          	csrrw	a0,mscratch,a0
    80005064:	30200073          	mret
	...

000000008000506a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000506a:	1141                	addi	sp,sp,-16
    8000506c:	e422                	sd	s0,8(sp)
    8000506e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005070:	0c0007b7          	lui	a5,0xc000
    80005074:	4705                	li	a4,1
    80005076:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005078:	c3d8                	sw	a4,4(a5)
}
    8000507a:	6422                	ld	s0,8(sp)
    8000507c:	0141                	addi	sp,sp,16
    8000507e:	8082                	ret

0000000080005080 <plicinithart>:

void
plicinithart(void)
{
    80005080:	1141                	addi	sp,sp,-16
    80005082:	e406                	sd	ra,8(sp)
    80005084:	e022                	sd	s0,0(sp)
    80005086:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005088:	ffffc097          	auipc	ra,0xffffc
    8000508c:	d90080e7          	jalr	-624(ra) # 80000e18 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005090:	0085171b          	slliw	a4,a0,0x8
    80005094:	0c0027b7          	lui	a5,0xc002
    80005098:	97ba                	add	a5,a5,a4
    8000509a:	40200713          	li	a4,1026
    8000509e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050a2:	00d5151b          	slliw	a0,a0,0xd
    800050a6:	0c2017b7          	lui	a5,0xc201
    800050aa:	97aa                	add	a5,a5,a0
    800050ac:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800050b0:	60a2                	ld	ra,8(sp)
    800050b2:	6402                	ld	s0,0(sp)
    800050b4:	0141                	addi	sp,sp,16
    800050b6:	8082                	ret

00000000800050b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050b8:	1141                	addi	sp,sp,-16
    800050ba:	e406                	sd	ra,8(sp)
    800050bc:	e022                	sd	s0,0(sp)
    800050be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	d58080e7          	jalr	-680(ra) # 80000e18 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050c8:	00d5151b          	slliw	a0,a0,0xd
    800050cc:	0c2017b7          	lui	a5,0xc201
    800050d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800050d2:	43c8                	lw	a0,4(a5)
    800050d4:	60a2                	ld	ra,8(sp)
    800050d6:	6402                	ld	s0,0(sp)
    800050d8:	0141                	addi	sp,sp,16
    800050da:	8082                	ret

00000000800050dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050dc:	1101                	addi	sp,sp,-32
    800050de:	ec06                	sd	ra,24(sp)
    800050e0:	e822                	sd	s0,16(sp)
    800050e2:	e426                	sd	s1,8(sp)
    800050e4:	1000                	addi	s0,sp,32
    800050e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	d30080e7          	jalr	-720(ra) # 80000e18 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800050f0:	00d5151b          	slliw	a0,a0,0xd
    800050f4:	0c2017b7          	lui	a5,0xc201
    800050f8:	97aa                	add	a5,a5,a0
    800050fa:	c3c4                	sw	s1,4(a5)
}
    800050fc:	60e2                	ld	ra,24(sp)
    800050fe:	6442                	ld	s0,16(sp)
    80005100:	64a2                	ld	s1,8(sp)
    80005102:	6105                	addi	sp,sp,32
    80005104:	8082                	ret

0000000080005106 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005106:	1141                	addi	sp,sp,-16
    80005108:	e406                	sd	ra,8(sp)
    8000510a:	e022                	sd	s0,0(sp)
    8000510c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000510e:	479d                	li	a5,7
    80005110:	06a7c863          	blt	a5,a0,80005180 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005114:	00016717          	auipc	a4,0x16
    80005118:	eec70713          	addi	a4,a4,-276 # 8001b000 <disk>
    8000511c:	972a                	add	a4,a4,a0
    8000511e:	6789                	lui	a5,0x2
    80005120:	97ba                	add	a5,a5,a4
    80005122:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005126:	e7ad                	bnez	a5,80005190 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005128:	00451793          	slli	a5,a0,0x4
    8000512c:	00018717          	auipc	a4,0x18
    80005130:	ed470713          	addi	a4,a4,-300 # 8001d000 <disk+0x2000>
    80005134:	6314                	ld	a3,0(a4)
    80005136:	96be                	add	a3,a3,a5
    80005138:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000513c:	6314                	ld	a3,0(a4)
    8000513e:	96be                	add	a3,a3,a5
    80005140:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005144:	6314                	ld	a3,0(a4)
    80005146:	96be                	add	a3,a3,a5
    80005148:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000514c:	6318                	ld	a4,0(a4)
    8000514e:	97ba                	add	a5,a5,a4
    80005150:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005154:	00016717          	auipc	a4,0x16
    80005158:	eac70713          	addi	a4,a4,-340 # 8001b000 <disk>
    8000515c:	972a                	add	a4,a4,a0
    8000515e:	6789                	lui	a5,0x2
    80005160:	97ba                	add	a5,a5,a4
    80005162:	4705                	li	a4,1
    80005164:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005168:	00018517          	auipc	a0,0x18
    8000516c:	eb050513          	addi	a0,a0,-336 # 8001d018 <disk+0x2018>
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	52c080e7          	jalr	1324(ra) # 8000169c <wakeup>
}
    80005178:	60a2                	ld	ra,8(sp)
    8000517a:	6402                	ld	s0,0(sp)
    8000517c:	0141                	addi	sp,sp,16
    8000517e:	8082                	ret
    panic("free_desc 1");
    80005180:	00003517          	auipc	a0,0x3
    80005184:	58850513          	addi	a0,a0,1416 # 80008708 <syscalls+0x328>
    80005188:	00001097          	auipc	ra,0x1
    8000518c:	9c8080e7          	jalr	-1592(ra) # 80005b50 <panic>
    panic("free_desc 2");
    80005190:	00003517          	auipc	a0,0x3
    80005194:	58850513          	addi	a0,a0,1416 # 80008718 <syscalls+0x338>
    80005198:	00001097          	auipc	ra,0x1
    8000519c:	9b8080e7          	jalr	-1608(ra) # 80005b50 <panic>

00000000800051a0 <virtio_disk_init>:
{
    800051a0:	1101                	addi	sp,sp,-32
    800051a2:	ec06                	sd	ra,24(sp)
    800051a4:	e822                	sd	s0,16(sp)
    800051a6:	e426                	sd	s1,8(sp)
    800051a8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051aa:	00003597          	auipc	a1,0x3
    800051ae:	57e58593          	addi	a1,a1,1406 # 80008728 <syscalls+0x348>
    800051b2:	00018517          	auipc	a0,0x18
    800051b6:	f7650513          	addi	a0,a0,-138 # 8001d128 <disk+0x2128>
    800051ba:	00001097          	auipc	ra,0x1
    800051be:	e3e080e7          	jalr	-450(ra) # 80005ff8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051c2:	100017b7          	lui	a5,0x10001
    800051c6:	4398                	lw	a4,0(a5)
    800051c8:	2701                	sext.w	a4,a4
    800051ca:	747277b7          	lui	a5,0x74727
    800051ce:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051d2:	0ef71063          	bne	a4,a5,800052b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800051d6:	100017b7          	lui	a5,0x10001
    800051da:	43dc                	lw	a5,4(a5)
    800051dc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051de:	4705                	li	a4,1
    800051e0:	0ce79963          	bne	a5,a4,800052b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051e4:	100017b7          	lui	a5,0x10001
    800051e8:	479c                	lw	a5,8(a5)
    800051ea:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800051ec:	4709                	li	a4,2
    800051ee:	0ce79263          	bne	a5,a4,800052b2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051f2:	100017b7          	lui	a5,0x10001
    800051f6:	47d8                	lw	a4,12(a5)
    800051f8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051fa:	554d47b7          	lui	a5,0x554d4
    800051fe:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005202:	0af71863          	bne	a4,a5,800052b2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005206:	100017b7          	lui	a5,0x10001
    8000520a:	4705                	li	a4,1
    8000520c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520e:	470d                	li	a4,3
    80005210:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005212:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005214:	c7ffe6b7          	lui	a3,0xc7ffe
    80005218:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000521c:	8f75                	and	a4,a4,a3
    8000521e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005220:	472d                	li	a4,11
    80005222:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005224:	473d                	li	a4,15
    80005226:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005228:	6705                	lui	a4,0x1
    8000522a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000522c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005230:	5bdc                	lw	a5,52(a5)
    80005232:	2781                	sext.w	a5,a5
  if(max == 0)
    80005234:	c7d9                	beqz	a5,800052c2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005236:	471d                	li	a4,7
    80005238:	08f77d63          	bgeu	a4,a5,800052d2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000523c:	100014b7          	lui	s1,0x10001
    80005240:	47a1                	li	a5,8
    80005242:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005244:	6609                	lui	a2,0x2
    80005246:	4581                	li	a1,0
    80005248:	00016517          	auipc	a0,0x16
    8000524c:	db850513          	addi	a0,a0,-584 # 8001b000 <disk>
    80005250:	ffffb097          	auipc	ra,0xffffb
    80005254:	f2a080e7          	jalr	-214(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005258:	00016717          	auipc	a4,0x16
    8000525c:	da870713          	addi	a4,a4,-600 # 8001b000 <disk>
    80005260:	00c75793          	srli	a5,a4,0xc
    80005264:	2781                	sext.w	a5,a5
    80005266:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005268:	00018797          	auipc	a5,0x18
    8000526c:	d9878793          	addi	a5,a5,-616 # 8001d000 <disk+0x2000>
    80005270:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005272:	00016717          	auipc	a4,0x16
    80005276:	e0e70713          	addi	a4,a4,-498 # 8001b080 <disk+0x80>
    8000527a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000527c:	00017717          	auipc	a4,0x17
    80005280:	d8470713          	addi	a4,a4,-636 # 8001c000 <disk+0x1000>
    80005284:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005286:	4705                	li	a4,1
    80005288:	00e78c23          	sb	a4,24(a5)
    8000528c:	00e78ca3          	sb	a4,25(a5)
    80005290:	00e78d23          	sb	a4,26(a5)
    80005294:	00e78da3          	sb	a4,27(a5)
    80005298:	00e78e23          	sb	a4,28(a5)
    8000529c:	00e78ea3          	sb	a4,29(a5)
    800052a0:	00e78f23          	sb	a4,30(a5)
    800052a4:	00e78fa3          	sb	a4,31(a5)
}
    800052a8:	60e2                	ld	ra,24(sp)
    800052aa:	6442                	ld	s0,16(sp)
    800052ac:	64a2                	ld	s1,8(sp)
    800052ae:	6105                	addi	sp,sp,32
    800052b0:	8082                	ret
    panic("could not find virtio disk");
    800052b2:	00003517          	auipc	a0,0x3
    800052b6:	48650513          	addi	a0,a0,1158 # 80008738 <syscalls+0x358>
    800052ba:	00001097          	auipc	ra,0x1
    800052be:	896080e7          	jalr	-1898(ra) # 80005b50 <panic>
    panic("virtio disk has no queue 0");
    800052c2:	00003517          	auipc	a0,0x3
    800052c6:	49650513          	addi	a0,a0,1174 # 80008758 <syscalls+0x378>
    800052ca:	00001097          	auipc	ra,0x1
    800052ce:	886080e7          	jalr	-1914(ra) # 80005b50 <panic>
    panic("virtio disk max queue too short");
    800052d2:	00003517          	auipc	a0,0x3
    800052d6:	4a650513          	addi	a0,a0,1190 # 80008778 <syscalls+0x398>
    800052da:	00001097          	auipc	ra,0x1
    800052de:	876080e7          	jalr	-1930(ra) # 80005b50 <panic>

00000000800052e2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800052e2:	7119                	addi	sp,sp,-128
    800052e4:	fc86                	sd	ra,120(sp)
    800052e6:	f8a2                	sd	s0,112(sp)
    800052e8:	f4a6                	sd	s1,104(sp)
    800052ea:	f0ca                	sd	s2,96(sp)
    800052ec:	ecce                	sd	s3,88(sp)
    800052ee:	e8d2                	sd	s4,80(sp)
    800052f0:	e4d6                	sd	s5,72(sp)
    800052f2:	e0da                	sd	s6,64(sp)
    800052f4:	fc5e                	sd	s7,56(sp)
    800052f6:	f862                	sd	s8,48(sp)
    800052f8:	f466                	sd	s9,40(sp)
    800052fa:	f06a                	sd	s10,32(sp)
    800052fc:	ec6e                	sd	s11,24(sp)
    800052fe:	0100                	addi	s0,sp,128
    80005300:	8aaa                	mv	s5,a0
    80005302:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005304:	00c52c83          	lw	s9,12(a0)
    80005308:	001c9c9b          	slliw	s9,s9,0x1
    8000530c:	1c82                	slli	s9,s9,0x20
    8000530e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005312:	00018517          	auipc	a0,0x18
    80005316:	e1650513          	addi	a0,a0,-490 # 8001d128 <disk+0x2128>
    8000531a:	00001097          	auipc	ra,0x1
    8000531e:	d6e080e7          	jalr	-658(ra) # 80006088 <acquire>
  for(int i = 0; i < 3; i++){
    80005322:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005324:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005326:	00016c17          	auipc	s8,0x16
    8000532a:	cdac0c13          	addi	s8,s8,-806 # 8001b000 <disk>
    8000532e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005330:	4b0d                	li	s6,3
    80005332:	a0ad                	j	8000539c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005334:	00fc0733          	add	a4,s8,a5
    80005338:	975e                	add	a4,a4,s7
    8000533a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000533e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005340:	0207c563          	bltz	a5,8000536a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005344:	2905                	addiw	s2,s2,1
    80005346:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005348:	19690c63          	beq	s2,s6,800054e0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000534c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000534e:	00018717          	auipc	a4,0x18
    80005352:	cca70713          	addi	a4,a4,-822 # 8001d018 <disk+0x2018>
    80005356:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005358:	00074683          	lbu	a3,0(a4)
    8000535c:	fee1                	bnez	a3,80005334 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000535e:	2785                	addiw	a5,a5,1
    80005360:	0705                	addi	a4,a4,1
    80005362:	fe979be3          	bne	a5,s1,80005358 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005366:	57fd                	li	a5,-1
    80005368:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000536a:	01205d63          	blez	s2,80005384 <virtio_disk_rw+0xa2>
    8000536e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005370:	000a2503          	lw	a0,0(s4)
    80005374:	00000097          	auipc	ra,0x0
    80005378:	d92080e7          	jalr	-622(ra) # 80005106 <free_desc>
      for(int j = 0; j < i; j++)
    8000537c:	2d85                	addiw	s11,s11,1
    8000537e:	0a11                	addi	s4,s4,4
    80005380:	ff2d98e3          	bne	s11,s2,80005370 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005384:	00018597          	auipc	a1,0x18
    80005388:	da458593          	addi	a1,a1,-604 # 8001d128 <disk+0x2128>
    8000538c:	00018517          	auipc	a0,0x18
    80005390:	c8c50513          	addi	a0,a0,-884 # 8001d018 <disk+0x2018>
    80005394:	ffffc097          	auipc	ra,0xffffc
    80005398:	17c080e7          	jalr	380(ra) # 80001510 <sleep>
  for(int i = 0; i < 3; i++){
    8000539c:	f8040a13          	addi	s4,s0,-128
{
    800053a0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800053a2:	894e                	mv	s2,s3
    800053a4:	b765                	j	8000534c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800053a6:	00018697          	auipc	a3,0x18
    800053aa:	c5a6b683          	ld	a3,-934(a3) # 8001d000 <disk+0x2000>
    800053ae:	96ba                	add	a3,a3,a4
    800053b0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800053b4:	00016817          	auipc	a6,0x16
    800053b8:	c4c80813          	addi	a6,a6,-948 # 8001b000 <disk>
    800053bc:	00018697          	auipc	a3,0x18
    800053c0:	c4468693          	addi	a3,a3,-956 # 8001d000 <disk+0x2000>
    800053c4:	6290                	ld	a2,0(a3)
    800053c6:	963a                	add	a2,a2,a4
    800053c8:	00c65583          	lhu	a1,12(a2)
    800053cc:	0015e593          	ori	a1,a1,1
    800053d0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800053d4:	f8842603          	lw	a2,-120(s0)
    800053d8:	628c                	ld	a1,0(a3)
    800053da:	972e                	add	a4,a4,a1
    800053dc:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800053e0:	20050593          	addi	a1,a0,512
    800053e4:	0592                	slli	a1,a1,0x4
    800053e6:	95c2                	add	a1,a1,a6
    800053e8:	577d                	li	a4,-1
    800053ea:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800053ee:	00461713          	slli	a4,a2,0x4
    800053f2:	6290                	ld	a2,0(a3)
    800053f4:	963a                	add	a2,a2,a4
    800053f6:	03078793          	addi	a5,a5,48
    800053fa:	97c2                	add	a5,a5,a6
    800053fc:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800053fe:	629c                	ld	a5,0(a3)
    80005400:	97ba                	add	a5,a5,a4
    80005402:	4605                	li	a2,1
    80005404:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005406:	629c                	ld	a5,0(a3)
    80005408:	97ba                	add	a5,a5,a4
    8000540a:	4809                	li	a6,2
    8000540c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005410:	629c                	ld	a5,0(a3)
    80005412:	97ba                	add	a5,a5,a4
    80005414:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005418:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000541c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005420:	6698                	ld	a4,8(a3)
    80005422:	00275783          	lhu	a5,2(a4)
    80005426:	8b9d                	andi	a5,a5,7
    80005428:	0786                	slli	a5,a5,0x1
    8000542a:	973e                	add	a4,a4,a5
    8000542c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005430:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005434:	6698                	ld	a4,8(a3)
    80005436:	00275783          	lhu	a5,2(a4)
    8000543a:	2785                	addiw	a5,a5,1
    8000543c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005440:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005444:	100017b7          	lui	a5,0x10001
    80005448:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000544c:	004aa783          	lw	a5,4(s5)
    80005450:	02c79163          	bne	a5,a2,80005472 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005454:	00018917          	auipc	s2,0x18
    80005458:	cd490913          	addi	s2,s2,-812 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000545c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000545e:	85ca                	mv	a1,s2
    80005460:	8556                	mv	a0,s5
    80005462:	ffffc097          	auipc	ra,0xffffc
    80005466:	0ae080e7          	jalr	174(ra) # 80001510 <sleep>
  while(b->disk == 1) {
    8000546a:	004aa783          	lw	a5,4(s5)
    8000546e:	fe9788e3          	beq	a5,s1,8000545e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005472:	f8042903          	lw	s2,-128(s0)
    80005476:	20090713          	addi	a4,s2,512
    8000547a:	0712                	slli	a4,a4,0x4
    8000547c:	00016797          	auipc	a5,0x16
    80005480:	b8478793          	addi	a5,a5,-1148 # 8001b000 <disk>
    80005484:	97ba                	add	a5,a5,a4
    80005486:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000548a:	00018997          	auipc	s3,0x18
    8000548e:	b7698993          	addi	s3,s3,-1162 # 8001d000 <disk+0x2000>
    80005492:	00491713          	slli	a4,s2,0x4
    80005496:	0009b783          	ld	a5,0(s3)
    8000549a:	97ba                	add	a5,a5,a4
    8000549c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800054a0:	854a                	mv	a0,s2
    800054a2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800054a6:	00000097          	auipc	ra,0x0
    800054aa:	c60080e7          	jalr	-928(ra) # 80005106 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800054ae:	8885                	andi	s1,s1,1
    800054b0:	f0ed                	bnez	s1,80005492 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800054b2:	00018517          	auipc	a0,0x18
    800054b6:	c7650513          	addi	a0,a0,-906 # 8001d128 <disk+0x2128>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	c82080e7          	jalr	-894(ra) # 8000613c <release>
}
    800054c2:	70e6                	ld	ra,120(sp)
    800054c4:	7446                	ld	s0,112(sp)
    800054c6:	74a6                	ld	s1,104(sp)
    800054c8:	7906                	ld	s2,96(sp)
    800054ca:	69e6                	ld	s3,88(sp)
    800054cc:	6a46                	ld	s4,80(sp)
    800054ce:	6aa6                	ld	s5,72(sp)
    800054d0:	6b06                	ld	s6,64(sp)
    800054d2:	7be2                	ld	s7,56(sp)
    800054d4:	7c42                	ld	s8,48(sp)
    800054d6:	7ca2                	ld	s9,40(sp)
    800054d8:	7d02                	ld	s10,32(sp)
    800054da:	6de2                	ld	s11,24(sp)
    800054dc:	6109                	addi	sp,sp,128
    800054de:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054e0:	f8042503          	lw	a0,-128(s0)
    800054e4:	20050793          	addi	a5,a0,512
    800054e8:	0792                	slli	a5,a5,0x4
  if(write)
    800054ea:	00016817          	auipc	a6,0x16
    800054ee:	b1680813          	addi	a6,a6,-1258 # 8001b000 <disk>
    800054f2:	00f80733          	add	a4,a6,a5
    800054f6:	01a036b3          	snez	a3,s10
    800054fa:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800054fe:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005502:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005506:	7679                	lui	a2,0xffffe
    80005508:	963e                	add	a2,a2,a5
    8000550a:	00018697          	auipc	a3,0x18
    8000550e:	af668693          	addi	a3,a3,-1290 # 8001d000 <disk+0x2000>
    80005512:	6298                	ld	a4,0(a3)
    80005514:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005516:	0a878593          	addi	a1,a5,168
    8000551a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000551c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000551e:	6298                	ld	a4,0(a3)
    80005520:	9732                	add	a4,a4,a2
    80005522:	45c1                	li	a1,16
    80005524:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005526:	6298                	ld	a4,0(a3)
    80005528:	9732                	add	a4,a4,a2
    8000552a:	4585                	li	a1,1
    8000552c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005530:	f8442703          	lw	a4,-124(s0)
    80005534:	628c                	ld	a1,0(a3)
    80005536:	962e                	add	a2,a2,a1
    80005538:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000553c:	0712                	slli	a4,a4,0x4
    8000553e:	6290                	ld	a2,0(a3)
    80005540:	963a                	add	a2,a2,a4
    80005542:	058a8593          	addi	a1,s5,88
    80005546:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005548:	6294                	ld	a3,0(a3)
    8000554a:	96ba                	add	a3,a3,a4
    8000554c:	40000613          	li	a2,1024
    80005550:	c690                	sw	a2,8(a3)
  if(write)
    80005552:	e40d1ae3          	bnez	s10,800053a6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005556:	00018697          	auipc	a3,0x18
    8000555a:	aaa6b683          	ld	a3,-1366(a3) # 8001d000 <disk+0x2000>
    8000555e:	96ba                	add	a3,a3,a4
    80005560:	4609                	li	a2,2
    80005562:	00c69623          	sh	a2,12(a3)
    80005566:	b5b9                	j	800053b4 <virtio_disk_rw+0xd2>

0000000080005568 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005568:	1101                	addi	sp,sp,-32
    8000556a:	ec06                	sd	ra,24(sp)
    8000556c:	e822                	sd	s0,16(sp)
    8000556e:	e426                	sd	s1,8(sp)
    80005570:	e04a                	sd	s2,0(sp)
    80005572:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005574:	00018517          	auipc	a0,0x18
    80005578:	bb450513          	addi	a0,a0,-1100 # 8001d128 <disk+0x2128>
    8000557c:	00001097          	auipc	ra,0x1
    80005580:	b0c080e7          	jalr	-1268(ra) # 80006088 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005584:	10001737          	lui	a4,0x10001
    80005588:	533c                	lw	a5,96(a4)
    8000558a:	8b8d                	andi	a5,a5,3
    8000558c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000558e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005592:	00018797          	auipc	a5,0x18
    80005596:	a6e78793          	addi	a5,a5,-1426 # 8001d000 <disk+0x2000>
    8000559a:	6b94                	ld	a3,16(a5)
    8000559c:	0207d703          	lhu	a4,32(a5)
    800055a0:	0026d783          	lhu	a5,2(a3)
    800055a4:	06f70163          	beq	a4,a5,80005606 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055a8:	00016917          	auipc	s2,0x16
    800055ac:	a5890913          	addi	s2,s2,-1448 # 8001b000 <disk>
    800055b0:	00018497          	auipc	s1,0x18
    800055b4:	a5048493          	addi	s1,s1,-1456 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800055b8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055bc:	6898                	ld	a4,16(s1)
    800055be:	0204d783          	lhu	a5,32(s1)
    800055c2:	8b9d                	andi	a5,a5,7
    800055c4:	078e                	slli	a5,a5,0x3
    800055c6:	97ba                	add	a5,a5,a4
    800055c8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800055ca:	20078713          	addi	a4,a5,512
    800055ce:	0712                	slli	a4,a4,0x4
    800055d0:	974a                	add	a4,a4,s2
    800055d2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800055d6:	e731                	bnez	a4,80005622 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800055d8:	20078793          	addi	a5,a5,512
    800055dc:	0792                	slli	a5,a5,0x4
    800055de:	97ca                	add	a5,a5,s2
    800055e0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800055e2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800055e6:	ffffc097          	auipc	ra,0xffffc
    800055ea:	0b6080e7          	jalr	182(ra) # 8000169c <wakeup>

    disk.used_idx += 1;
    800055ee:	0204d783          	lhu	a5,32(s1)
    800055f2:	2785                	addiw	a5,a5,1
    800055f4:	17c2                	slli	a5,a5,0x30
    800055f6:	93c1                	srli	a5,a5,0x30
    800055f8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800055fc:	6898                	ld	a4,16(s1)
    800055fe:	00275703          	lhu	a4,2(a4)
    80005602:	faf71be3          	bne	a4,a5,800055b8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005606:	00018517          	auipc	a0,0x18
    8000560a:	b2250513          	addi	a0,a0,-1246 # 8001d128 <disk+0x2128>
    8000560e:	00001097          	auipc	ra,0x1
    80005612:	b2e080e7          	jalr	-1234(ra) # 8000613c <release>
}
    80005616:	60e2                	ld	ra,24(sp)
    80005618:	6442                	ld	s0,16(sp)
    8000561a:	64a2                	ld	s1,8(sp)
    8000561c:	6902                	ld	s2,0(sp)
    8000561e:	6105                	addi	sp,sp,32
    80005620:	8082                	ret
      panic("virtio_disk_intr status");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	17650513          	addi	a0,a0,374 # 80008798 <syscalls+0x3b8>
    8000562a:	00000097          	auipc	ra,0x0
    8000562e:	526080e7          	jalr	1318(ra) # 80005b50 <panic>

0000000080005632 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005632:	1141                	addi	sp,sp,-16
    80005634:	e422                	sd	s0,8(sp)
    80005636:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005638:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000563c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005640:	0037979b          	slliw	a5,a5,0x3
    80005644:	02004737          	lui	a4,0x2004
    80005648:	97ba                	add	a5,a5,a4
    8000564a:	0200c737          	lui	a4,0x200c
    8000564e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005652:	000f4637          	lui	a2,0xf4
    80005656:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000565a:	9732                	add	a4,a4,a2
    8000565c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000565e:	00259693          	slli	a3,a1,0x2
    80005662:	96ae                	add	a3,a3,a1
    80005664:	068e                	slli	a3,a3,0x3
    80005666:	00019717          	auipc	a4,0x19
    8000566a:	99a70713          	addi	a4,a4,-1638 # 8001e000 <timer_scratch>
    8000566e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005670:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005672:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005674:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005678:	00000797          	auipc	a5,0x0
    8000567c:	9c878793          	addi	a5,a5,-1592 # 80005040 <timervec>
    80005680:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005684:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005688:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000568c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005690:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005694:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005698:	30479073          	csrw	mie,a5
}
    8000569c:	6422                	ld	s0,8(sp)
    8000569e:	0141                	addi	sp,sp,16
    800056a0:	8082                	ret

00000000800056a2 <start>:
{
    800056a2:	1141                	addi	sp,sp,-16
    800056a4:	e406                	sd	ra,8(sp)
    800056a6:	e022                	sd	s0,0(sp)
    800056a8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056aa:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800056ae:	7779                	lui	a4,0xffffe
    800056b0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800056b4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800056b6:	6705                	lui	a4,0x1
    800056b8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800056bc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056be:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800056c2:	ffffb797          	auipc	a5,0xffffb
    800056c6:	c5e78793          	addi	a5,a5,-930 # 80000320 <main>
    800056ca:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800056ce:	4781                	li	a5,0
    800056d0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800056d4:	67c1                	lui	a5,0x10
    800056d6:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800056d8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800056dc:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800056e0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800056e4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800056e8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800056ec:	57fd                	li	a5,-1
    800056ee:	83a9                	srli	a5,a5,0xa
    800056f0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800056f4:	47bd                	li	a5,15
    800056f6:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800056fa:	00000097          	auipc	ra,0x0
    800056fe:	f38080e7          	jalr	-200(ra) # 80005632 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005702:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005706:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005708:	823e                	mv	tp,a5
  asm volatile("mret");
    8000570a:	30200073          	mret
}
    8000570e:	60a2                	ld	ra,8(sp)
    80005710:	6402                	ld	s0,0(sp)
    80005712:	0141                	addi	sp,sp,16
    80005714:	8082                	ret

0000000080005716 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005716:	715d                	addi	sp,sp,-80
    80005718:	e486                	sd	ra,72(sp)
    8000571a:	e0a2                	sd	s0,64(sp)
    8000571c:	fc26                	sd	s1,56(sp)
    8000571e:	f84a                	sd	s2,48(sp)
    80005720:	f44e                	sd	s3,40(sp)
    80005722:	f052                	sd	s4,32(sp)
    80005724:	ec56                	sd	s5,24(sp)
    80005726:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005728:	04c05763          	blez	a2,80005776 <consolewrite+0x60>
    8000572c:	8a2a                	mv	s4,a0
    8000572e:	84ae                	mv	s1,a1
    80005730:	89b2                	mv	s3,a2
    80005732:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005734:	5afd                	li	s5,-1
    80005736:	4685                	li	a3,1
    80005738:	8626                	mv	a2,s1
    8000573a:	85d2                	mv	a1,s4
    8000573c:	fbf40513          	addi	a0,s0,-65
    80005740:	ffffc097          	auipc	ra,0xffffc
    80005744:	1ca080e7          	jalr	458(ra) # 8000190a <either_copyin>
    80005748:	01550d63          	beq	a0,s5,80005762 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000574c:	fbf44503          	lbu	a0,-65(s0)
    80005750:	00000097          	auipc	ra,0x0
    80005754:	77e080e7          	jalr	1918(ra) # 80005ece <uartputc>
  for(i = 0; i < n; i++){
    80005758:	2905                	addiw	s2,s2,1
    8000575a:	0485                	addi	s1,s1,1
    8000575c:	fd299de3          	bne	s3,s2,80005736 <consolewrite+0x20>
    80005760:	894e                	mv	s2,s3
  }

  return i;
}
    80005762:	854a                	mv	a0,s2
    80005764:	60a6                	ld	ra,72(sp)
    80005766:	6406                	ld	s0,64(sp)
    80005768:	74e2                	ld	s1,56(sp)
    8000576a:	7942                	ld	s2,48(sp)
    8000576c:	79a2                	ld	s3,40(sp)
    8000576e:	7a02                	ld	s4,32(sp)
    80005770:	6ae2                	ld	s5,24(sp)
    80005772:	6161                	addi	sp,sp,80
    80005774:	8082                	ret
  for(i = 0; i < n; i++){
    80005776:	4901                	li	s2,0
    80005778:	b7ed                	j	80005762 <consolewrite+0x4c>

000000008000577a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000577a:	7159                	addi	sp,sp,-112
    8000577c:	f486                	sd	ra,104(sp)
    8000577e:	f0a2                	sd	s0,96(sp)
    80005780:	eca6                	sd	s1,88(sp)
    80005782:	e8ca                	sd	s2,80(sp)
    80005784:	e4ce                	sd	s3,72(sp)
    80005786:	e0d2                	sd	s4,64(sp)
    80005788:	fc56                	sd	s5,56(sp)
    8000578a:	f85a                	sd	s6,48(sp)
    8000578c:	f45e                	sd	s7,40(sp)
    8000578e:	f062                	sd	s8,32(sp)
    80005790:	ec66                	sd	s9,24(sp)
    80005792:	e86a                	sd	s10,16(sp)
    80005794:	1880                	addi	s0,sp,112
    80005796:	8aaa                	mv	s5,a0
    80005798:	8a2e                	mv	s4,a1
    8000579a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000579c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800057a0:	00021517          	auipc	a0,0x21
    800057a4:	9a050513          	addi	a0,a0,-1632 # 80026140 <cons>
    800057a8:	00001097          	auipc	ra,0x1
    800057ac:	8e0080e7          	jalr	-1824(ra) # 80006088 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800057b0:	00021497          	auipc	s1,0x21
    800057b4:	99048493          	addi	s1,s1,-1648 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800057b8:	00021917          	auipc	s2,0x21
    800057bc:	a2090913          	addi	s2,s2,-1504 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800057c0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800057c2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800057c4:	4ca9                	li	s9,10
  while(n > 0){
    800057c6:	07305863          	blez	s3,80005836 <consoleread+0xbc>
    while(cons.r == cons.w){
    800057ca:	0984a783          	lw	a5,152(s1)
    800057ce:	09c4a703          	lw	a4,156(s1)
    800057d2:	02f71463          	bne	a4,a5,800057fa <consoleread+0x80>
      if(myproc()->killed){
    800057d6:	ffffb097          	auipc	ra,0xffffb
    800057da:	66e080e7          	jalr	1646(ra) # 80000e44 <myproc>
    800057de:	551c                	lw	a5,40(a0)
    800057e0:	e7b5                	bnez	a5,8000584c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800057e2:	85a6                	mv	a1,s1
    800057e4:	854a                	mv	a0,s2
    800057e6:	ffffc097          	auipc	ra,0xffffc
    800057ea:	d2a080e7          	jalr	-726(ra) # 80001510 <sleep>
    while(cons.r == cons.w){
    800057ee:	0984a783          	lw	a5,152(s1)
    800057f2:	09c4a703          	lw	a4,156(s1)
    800057f6:	fef700e3          	beq	a4,a5,800057d6 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800057fa:	0017871b          	addiw	a4,a5,1
    800057fe:	08e4ac23          	sw	a4,152(s1)
    80005802:	07f7f713          	andi	a4,a5,127
    80005806:	9726                	add	a4,a4,s1
    80005808:	01874703          	lbu	a4,24(a4)
    8000580c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005810:	077d0563          	beq	s10,s7,8000587a <consoleread+0x100>
    cbuf = c;
    80005814:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005818:	4685                	li	a3,1
    8000581a:	f9f40613          	addi	a2,s0,-97
    8000581e:	85d2                	mv	a1,s4
    80005820:	8556                	mv	a0,s5
    80005822:	ffffc097          	auipc	ra,0xffffc
    80005826:	092080e7          	jalr	146(ra) # 800018b4 <either_copyout>
    8000582a:	01850663          	beq	a0,s8,80005836 <consoleread+0xbc>
    dst++;
    8000582e:	0a05                	addi	s4,s4,1
    --n;
    80005830:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005832:	f99d1ae3          	bne	s10,s9,800057c6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005836:	00021517          	auipc	a0,0x21
    8000583a:	90a50513          	addi	a0,a0,-1782 # 80026140 <cons>
    8000583e:	00001097          	auipc	ra,0x1
    80005842:	8fe080e7          	jalr	-1794(ra) # 8000613c <release>

  return target - n;
    80005846:	413b053b          	subw	a0,s6,s3
    8000584a:	a811                	j	8000585e <consoleread+0xe4>
        release(&cons.lock);
    8000584c:	00021517          	auipc	a0,0x21
    80005850:	8f450513          	addi	a0,a0,-1804 # 80026140 <cons>
    80005854:	00001097          	auipc	ra,0x1
    80005858:	8e8080e7          	jalr	-1816(ra) # 8000613c <release>
        return -1;
    8000585c:	557d                	li	a0,-1
}
    8000585e:	70a6                	ld	ra,104(sp)
    80005860:	7406                	ld	s0,96(sp)
    80005862:	64e6                	ld	s1,88(sp)
    80005864:	6946                	ld	s2,80(sp)
    80005866:	69a6                	ld	s3,72(sp)
    80005868:	6a06                	ld	s4,64(sp)
    8000586a:	7ae2                	ld	s5,56(sp)
    8000586c:	7b42                	ld	s6,48(sp)
    8000586e:	7ba2                	ld	s7,40(sp)
    80005870:	7c02                	ld	s8,32(sp)
    80005872:	6ce2                	ld	s9,24(sp)
    80005874:	6d42                	ld	s10,16(sp)
    80005876:	6165                	addi	sp,sp,112
    80005878:	8082                	ret
      if(n < target){
    8000587a:	0009871b          	sext.w	a4,s3
    8000587e:	fb677ce3          	bgeu	a4,s6,80005836 <consoleread+0xbc>
        cons.r--;
    80005882:	00021717          	auipc	a4,0x21
    80005886:	94f72b23          	sw	a5,-1706(a4) # 800261d8 <cons+0x98>
    8000588a:	b775                	j	80005836 <consoleread+0xbc>

000000008000588c <consputc>:
{
    8000588c:	1141                	addi	sp,sp,-16
    8000588e:	e406                	sd	ra,8(sp)
    80005890:	e022                	sd	s0,0(sp)
    80005892:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005894:	10000793          	li	a5,256
    80005898:	00f50a63          	beq	a0,a5,800058ac <consputc+0x20>
    uartputc_sync(c);
    8000589c:	00000097          	auipc	ra,0x0
    800058a0:	560080e7          	jalr	1376(ra) # 80005dfc <uartputc_sync>
}
    800058a4:	60a2                	ld	ra,8(sp)
    800058a6:	6402                	ld	s0,0(sp)
    800058a8:	0141                	addi	sp,sp,16
    800058aa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058ac:	4521                	li	a0,8
    800058ae:	00000097          	auipc	ra,0x0
    800058b2:	54e080e7          	jalr	1358(ra) # 80005dfc <uartputc_sync>
    800058b6:	02000513          	li	a0,32
    800058ba:	00000097          	auipc	ra,0x0
    800058be:	542080e7          	jalr	1346(ra) # 80005dfc <uartputc_sync>
    800058c2:	4521                	li	a0,8
    800058c4:	00000097          	auipc	ra,0x0
    800058c8:	538080e7          	jalr	1336(ra) # 80005dfc <uartputc_sync>
    800058cc:	bfe1                	j	800058a4 <consputc+0x18>

00000000800058ce <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800058ce:	1101                	addi	sp,sp,-32
    800058d0:	ec06                	sd	ra,24(sp)
    800058d2:	e822                	sd	s0,16(sp)
    800058d4:	e426                	sd	s1,8(sp)
    800058d6:	e04a                	sd	s2,0(sp)
    800058d8:	1000                	addi	s0,sp,32
    800058da:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800058dc:	00021517          	auipc	a0,0x21
    800058e0:	86450513          	addi	a0,a0,-1948 # 80026140 <cons>
    800058e4:	00000097          	auipc	ra,0x0
    800058e8:	7a4080e7          	jalr	1956(ra) # 80006088 <acquire>

  switch(c){
    800058ec:	47d5                	li	a5,21
    800058ee:	0af48663          	beq	s1,a5,8000599a <consoleintr+0xcc>
    800058f2:	0297ca63          	blt	a5,s1,80005926 <consoleintr+0x58>
    800058f6:	47a1                	li	a5,8
    800058f8:	0ef48763          	beq	s1,a5,800059e6 <consoleintr+0x118>
    800058fc:	47c1                	li	a5,16
    800058fe:	10f49a63          	bne	s1,a5,80005a12 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005902:	ffffc097          	auipc	ra,0xffffc
    80005906:	05e080e7          	jalr	94(ra) # 80001960 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000590a:	00021517          	auipc	a0,0x21
    8000590e:	83650513          	addi	a0,a0,-1994 # 80026140 <cons>
    80005912:	00001097          	auipc	ra,0x1
    80005916:	82a080e7          	jalr	-2006(ra) # 8000613c <release>
}
    8000591a:	60e2                	ld	ra,24(sp)
    8000591c:	6442                	ld	s0,16(sp)
    8000591e:	64a2                	ld	s1,8(sp)
    80005920:	6902                	ld	s2,0(sp)
    80005922:	6105                	addi	sp,sp,32
    80005924:	8082                	ret
  switch(c){
    80005926:	07f00793          	li	a5,127
    8000592a:	0af48e63          	beq	s1,a5,800059e6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000592e:	00021717          	auipc	a4,0x21
    80005932:	81270713          	addi	a4,a4,-2030 # 80026140 <cons>
    80005936:	0a072783          	lw	a5,160(a4)
    8000593a:	09872703          	lw	a4,152(a4)
    8000593e:	9f99                	subw	a5,a5,a4
    80005940:	07f00713          	li	a4,127
    80005944:	fcf763e3          	bltu	a4,a5,8000590a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005948:	47b5                	li	a5,13
    8000594a:	0cf48763          	beq	s1,a5,80005a18 <consoleintr+0x14a>
      consputc(c);
    8000594e:	8526                	mv	a0,s1
    80005950:	00000097          	auipc	ra,0x0
    80005954:	f3c080e7          	jalr	-196(ra) # 8000588c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005958:	00020797          	auipc	a5,0x20
    8000595c:	7e878793          	addi	a5,a5,2024 # 80026140 <cons>
    80005960:	0a07a703          	lw	a4,160(a5)
    80005964:	0017069b          	addiw	a3,a4,1
    80005968:	0006861b          	sext.w	a2,a3
    8000596c:	0ad7a023          	sw	a3,160(a5)
    80005970:	07f77713          	andi	a4,a4,127
    80005974:	97ba                	add	a5,a5,a4
    80005976:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000597a:	47a9                	li	a5,10
    8000597c:	0cf48563          	beq	s1,a5,80005a46 <consoleintr+0x178>
    80005980:	4791                	li	a5,4
    80005982:	0cf48263          	beq	s1,a5,80005a46 <consoleintr+0x178>
    80005986:	00021797          	auipc	a5,0x21
    8000598a:	8527a783          	lw	a5,-1966(a5) # 800261d8 <cons+0x98>
    8000598e:	0807879b          	addiw	a5,a5,128
    80005992:	f6f61ce3          	bne	a2,a5,8000590a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005996:	863e                	mv	a2,a5
    80005998:	a07d                	j	80005a46 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000599a:	00020717          	auipc	a4,0x20
    8000599e:	7a670713          	addi	a4,a4,1958 # 80026140 <cons>
    800059a2:	0a072783          	lw	a5,160(a4)
    800059a6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800059aa:	00020497          	auipc	s1,0x20
    800059ae:	79648493          	addi	s1,s1,1942 # 80026140 <cons>
    while(cons.e != cons.w &&
    800059b2:	4929                	li	s2,10
    800059b4:	f4f70be3          	beq	a4,a5,8000590a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800059b8:	37fd                	addiw	a5,a5,-1
    800059ba:	07f7f713          	andi	a4,a5,127
    800059be:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800059c0:	01874703          	lbu	a4,24(a4)
    800059c4:	f52703e3          	beq	a4,s2,8000590a <consoleintr+0x3c>
      cons.e--;
    800059c8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800059cc:	10000513          	li	a0,256
    800059d0:	00000097          	auipc	ra,0x0
    800059d4:	ebc080e7          	jalr	-324(ra) # 8000588c <consputc>
    while(cons.e != cons.w &&
    800059d8:	0a04a783          	lw	a5,160(s1)
    800059dc:	09c4a703          	lw	a4,156(s1)
    800059e0:	fcf71ce3          	bne	a4,a5,800059b8 <consoleintr+0xea>
    800059e4:	b71d                	j	8000590a <consoleintr+0x3c>
    if(cons.e != cons.w){
    800059e6:	00020717          	auipc	a4,0x20
    800059ea:	75a70713          	addi	a4,a4,1882 # 80026140 <cons>
    800059ee:	0a072783          	lw	a5,160(a4)
    800059f2:	09c72703          	lw	a4,156(a4)
    800059f6:	f0f70ae3          	beq	a4,a5,8000590a <consoleintr+0x3c>
      cons.e--;
    800059fa:	37fd                	addiw	a5,a5,-1
    800059fc:	00020717          	auipc	a4,0x20
    80005a00:	7ef72223          	sw	a5,2020(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a04:	10000513          	li	a0,256
    80005a08:	00000097          	auipc	ra,0x0
    80005a0c:	e84080e7          	jalr	-380(ra) # 8000588c <consputc>
    80005a10:	bded                	j	8000590a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a12:	ee048ce3          	beqz	s1,8000590a <consoleintr+0x3c>
    80005a16:	bf21                	j	8000592e <consoleintr+0x60>
      consputc(c);
    80005a18:	4529                	li	a0,10
    80005a1a:	00000097          	auipc	ra,0x0
    80005a1e:	e72080e7          	jalr	-398(ra) # 8000588c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a22:	00020797          	auipc	a5,0x20
    80005a26:	71e78793          	addi	a5,a5,1822 # 80026140 <cons>
    80005a2a:	0a07a703          	lw	a4,160(a5)
    80005a2e:	0017069b          	addiw	a3,a4,1
    80005a32:	0006861b          	sext.w	a2,a3
    80005a36:	0ad7a023          	sw	a3,160(a5)
    80005a3a:	07f77713          	andi	a4,a4,127
    80005a3e:	97ba                	add	a5,a5,a4
    80005a40:	4729                	li	a4,10
    80005a42:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a46:	00020797          	auipc	a5,0x20
    80005a4a:	78c7ab23          	sw	a2,1942(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005a4e:	00020517          	auipc	a0,0x20
    80005a52:	78a50513          	addi	a0,a0,1930 # 800261d8 <cons+0x98>
    80005a56:	ffffc097          	auipc	ra,0xffffc
    80005a5a:	c46080e7          	jalr	-954(ra) # 8000169c <wakeup>
    80005a5e:	b575                	j	8000590a <consoleintr+0x3c>

0000000080005a60 <consoleinit>:

void
consoleinit(void)
{
    80005a60:	1141                	addi	sp,sp,-16
    80005a62:	e406                	sd	ra,8(sp)
    80005a64:	e022                	sd	s0,0(sp)
    80005a66:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005a68:	00003597          	auipc	a1,0x3
    80005a6c:	d4858593          	addi	a1,a1,-696 # 800087b0 <syscalls+0x3d0>
    80005a70:	00020517          	auipc	a0,0x20
    80005a74:	6d050513          	addi	a0,a0,1744 # 80026140 <cons>
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	580080e7          	jalr	1408(ra) # 80005ff8 <initlock>

  uartinit();
    80005a80:	00000097          	auipc	ra,0x0
    80005a84:	32c080e7          	jalr	812(ra) # 80005dac <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005a88:	00014797          	auipc	a5,0x14
    80005a8c:	84078793          	addi	a5,a5,-1984 # 800192c8 <devsw>
    80005a90:	00000717          	auipc	a4,0x0
    80005a94:	cea70713          	addi	a4,a4,-790 # 8000577a <consoleread>
    80005a98:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005a9a:	00000717          	auipc	a4,0x0
    80005a9e:	c7c70713          	addi	a4,a4,-900 # 80005716 <consolewrite>
    80005aa2:	ef98                	sd	a4,24(a5)
}
    80005aa4:	60a2                	ld	ra,8(sp)
    80005aa6:	6402                	ld	s0,0(sp)
    80005aa8:	0141                	addi	sp,sp,16
    80005aaa:	8082                	ret

0000000080005aac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005aac:	7179                	addi	sp,sp,-48
    80005aae:	f406                	sd	ra,40(sp)
    80005ab0:	f022                	sd	s0,32(sp)
    80005ab2:	ec26                	sd	s1,24(sp)
    80005ab4:	e84a                	sd	s2,16(sp)
    80005ab6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ab8:	c219                	beqz	a2,80005abe <printint+0x12>
    80005aba:	08054763          	bltz	a0,80005b48 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005abe:	2501                	sext.w	a0,a0
    80005ac0:	4881                	li	a7,0
    80005ac2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ac6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ac8:	2581                	sext.w	a1,a1
    80005aca:	00003617          	auipc	a2,0x3
    80005ace:	d1660613          	addi	a2,a2,-746 # 800087e0 <digits>
    80005ad2:	883a                	mv	a6,a4
    80005ad4:	2705                	addiw	a4,a4,1
    80005ad6:	02b577bb          	remuw	a5,a0,a1
    80005ada:	1782                	slli	a5,a5,0x20
    80005adc:	9381                	srli	a5,a5,0x20
    80005ade:	97b2                	add	a5,a5,a2
    80005ae0:	0007c783          	lbu	a5,0(a5)
    80005ae4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ae8:	0005079b          	sext.w	a5,a0
    80005aec:	02b5553b          	divuw	a0,a0,a1
    80005af0:	0685                	addi	a3,a3,1
    80005af2:	feb7f0e3          	bgeu	a5,a1,80005ad2 <printint+0x26>

  if(sign)
    80005af6:	00088c63          	beqz	a7,80005b0e <printint+0x62>
    buf[i++] = '-';
    80005afa:	fe070793          	addi	a5,a4,-32
    80005afe:	00878733          	add	a4,a5,s0
    80005b02:	02d00793          	li	a5,45
    80005b06:	fef70823          	sb	a5,-16(a4)
    80005b0a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b0e:	02e05763          	blez	a4,80005b3c <printint+0x90>
    80005b12:	fd040793          	addi	a5,s0,-48
    80005b16:	00e784b3          	add	s1,a5,a4
    80005b1a:	fff78913          	addi	s2,a5,-1
    80005b1e:	993a                	add	s2,s2,a4
    80005b20:	377d                	addiw	a4,a4,-1
    80005b22:	1702                	slli	a4,a4,0x20
    80005b24:	9301                	srli	a4,a4,0x20
    80005b26:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b2a:	fff4c503          	lbu	a0,-1(s1)
    80005b2e:	00000097          	auipc	ra,0x0
    80005b32:	d5e080e7          	jalr	-674(ra) # 8000588c <consputc>
  while(--i >= 0)
    80005b36:	14fd                	addi	s1,s1,-1
    80005b38:	ff2499e3          	bne	s1,s2,80005b2a <printint+0x7e>
}
    80005b3c:	70a2                	ld	ra,40(sp)
    80005b3e:	7402                	ld	s0,32(sp)
    80005b40:	64e2                	ld	s1,24(sp)
    80005b42:	6942                	ld	s2,16(sp)
    80005b44:	6145                	addi	sp,sp,48
    80005b46:	8082                	ret
    x = -xx;
    80005b48:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b4c:	4885                	li	a7,1
    x = -xx;
    80005b4e:	bf95                	j	80005ac2 <printint+0x16>

0000000080005b50 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b50:	1101                	addi	sp,sp,-32
    80005b52:	ec06                	sd	ra,24(sp)
    80005b54:	e822                	sd	s0,16(sp)
    80005b56:	e426                	sd	s1,8(sp)
    80005b58:	1000                	addi	s0,sp,32
    80005b5a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b5c:	00020797          	auipc	a5,0x20
    80005b60:	6a07a223          	sw	zero,1700(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005b64:	00003517          	auipc	a0,0x3
    80005b68:	c5450513          	addi	a0,a0,-940 # 800087b8 <syscalls+0x3d8>
    80005b6c:	00000097          	auipc	ra,0x0
    80005b70:	02e080e7          	jalr	46(ra) # 80005b9a <printf>
  printf(s);
    80005b74:	8526                	mv	a0,s1
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	024080e7          	jalr	36(ra) # 80005b9a <printf>
  printf("\n");
    80005b7e:	00002517          	auipc	a0,0x2
    80005b82:	4ca50513          	addi	a0,a0,1226 # 80008048 <etext+0x48>
    80005b86:	00000097          	auipc	ra,0x0
    80005b8a:	014080e7          	jalr	20(ra) # 80005b9a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005b8e:	4785                	li	a5,1
    80005b90:	00003717          	auipc	a4,0x3
    80005b94:	48f72623          	sw	a5,1164(a4) # 8000901c <panicked>
  for(;;)
    80005b98:	a001                	j	80005b98 <panic+0x48>

0000000080005b9a <printf>:
{
    80005b9a:	7131                	addi	sp,sp,-192
    80005b9c:	fc86                	sd	ra,120(sp)
    80005b9e:	f8a2                	sd	s0,112(sp)
    80005ba0:	f4a6                	sd	s1,104(sp)
    80005ba2:	f0ca                	sd	s2,96(sp)
    80005ba4:	ecce                	sd	s3,88(sp)
    80005ba6:	e8d2                	sd	s4,80(sp)
    80005ba8:	e4d6                	sd	s5,72(sp)
    80005baa:	e0da                	sd	s6,64(sp)
    80005bac:	fc5e                	sd	s7,56(sp)
    80005bae:	f862                	sd	s8,48(sp)
    80005bb0:	f466                	sd	s9,40(sp)
    80005bb2:	f06a                	sd	s10,32(sp)
    80005bb4:	ec6e                	sd	s11,24(sp)
    80005bb6:	0100                	addi	s0,sp,128
    80005bb8:	8a2a                	mv	s4,a0
    80005bba:	e40c                	sd	a1,8(s0)
    80005bbc:	e810                	sd	a2,16(s0)
    80005bbe:	ec14                	sd	a3,24(s0)
    80005bc0:	f018                	sd	a4,32(s0)
    80005bc2:	f41c                	sd	a5,40(s0)
    80005bc4:	03043823          	sd	a6,48(s0)
    80005bc8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005bcc:	00020d97          	auipc	s11,0x20
    80005bd0:	634dad83          	lw	s11,1588(s11) # 80026200 <pr+0x18>
  if(locking)
    80005bd4:	020d9b63          	bnez	s11,80005c0a <printf+0x70>
  if (fmt == 0)
    80005bd8:	040a0263          	beqz	s4,80005c1c <printf+0x82>
  va_start(ap, fmt);
    80005bdc:	00840793          	addi	a5,s0,8
    80005be0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005be4:	000a4503          	lbu	a0,0(s4)
    80005be8:	14050f63          	beqz	a0,80005d46 <printf+0x1ac>
    80005bec:	4981                	li	s3,0
    if(c != '%'){
    80005bee:	02500a93          	li	s5,37
    switch(c){
    80005bf2:	07000b93          	li	s7,112
  consputc('x');
    80005bf6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005bf8:	00003b17          	auipc	s6,0x3
    80005bfc:	be8b0b13          	addi	s6,s6,-1048 # 800087e0 <digits>
    switch(c){
    80005c00:	07300c93          	li	s9,115
    80005c04:	06400c13          	li	s8,100
    80005c08:	a82d                	j	80005c42 <printf+0xa8>
    acquire(&pr.lock);
    80005c0a:	00020517          	auipc	a0,0x20
    80005c0e:	5de50513          	addi	a0,a0,1502 # 800261e8 <pr>
    80005c12:	00000097          	auipc	ra,0x0
    80005c16:	476080e7          	jalr	1142(ra) # 80006088 <acquire>
    80005c1a:	bf7d                	j	80005bd8 <printf+0x3e>
    panic("null fmt");
    80005c1c:	00003517          	auipc	a0,0x3
    80005c20:	bac50513          	addi	a0,a0,-1108 # 800087c8 <syscalls+0x3e8>
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	f2c080e7          	jalr	-212(ra) # 80005b50 <panic>
      consputc(c);
    80005c2c:	00000097          	auipc	ra,0x0
    80005c30:	c60080e7          	jalr	-928(ra) # 8000588c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c34:	2985                	addiw	s3,s3,1
    80005c36:	013a07b3          	add	a5,s4,s3
    80005c3a:	0007c503          	lbu	a0,0(a5)
    80005c3e:	10050463          	beqz	a0,80005d46 <printf+0x1ac>
    if(c != '%'){
    80005c42:	ff5515e3          	bne	a0,s5,80005c2c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c46:	2985                	addiw	s3,s3,1
    80005c48:	013a07b3          	add	a5,s4,s3
    80005c4c:	0007c783          	lbu	a5,0(a5)
    80005c50:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005c54:	cbed                	beqz	a5,80005d46 <printf+0x1ac>
    switch(c){
    80005c56:	05778a63          	beq	a5,s7,80005caa <printf+0x110>
    80005c5a:	02fbf663          	bgeu	s7,a5,80005c86 <printf+0xec>
    80005c5e:	09978863          	beq	a5,s9,80005cee <printf+0x154>
    80005c62:	07800713          	li	a4,120
    80005c66:	0ce79563          	bne	a5,a4,80005d30 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005c6a:	f8843783          	ld	a5,-120(s0)
    80005c6e:	00878713          	addi	a4,a5,8
    80005c72:	f8e43423          	sd	a4,-120(s0)
    80005c76:	4605                	li	a2,1
    80005c78:	85ea                	mv	a1,s10
    80005c7a:	4388                	lw	a0,0(a5)
    80005c7c:	00000097          	auipc	ra,0x0
    80005c80:	e30080e7          	jalr	-464(ra) # 80005aac <printint>
      break;
    80005c84:	bf45                	j	80005c34 <printf+0x9a>
    switch(c){
    80005c86:	09578f63          	beq	a5,s5,80005d24 <printf+0x18a>
    80005c8a:	0b879363          	bne	a5,s8,80005d30 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005c8e:	f8843783          	ld	a5,-120(s0)
    80005c92:	00878713          	addi	a4,a5,8
    80005c96:	f8e43423          	sd	a4,-120(s0)
    80005c9a:	4605                	li	a2,1
    80005c9c:	45a9                	li	a1,10
    80005c9e:	4388                	lw	a0,0(a5)
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	e0c080e7          	jalr	-500(ra) # 80005aac <printint>
      break;
    80005ca8:	b771                	j	80005c34 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005caa:	f8843783          	ld	a5,-120(s0)
    80005cae:	00878713          	addi	a4,a5,8
    80005cb2:	f8e43423          	sd	a4,-120(s0)
    80005cb6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005cba:	03000513          	li	a0,48
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	bce080e7          	jalr	-1074(ra) # 8000588c <consputc>
  consputc('x');
    80005cc6:	07800513          	li	a0,120
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	bc2080e7          	jalr	-1086(ra) # 8000588c <consputc>
    80005cd2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cd4:	03c95793          	srli	a5,s2,0x3c
    80005cd8:	97da                	add	a5,a5,s6
    80005cda:	0007c503          	lbu	a0,0(a5)
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	bae080e7          	jalr	-1106(ra) # 8000588c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ce6:	0912                	slli	s2,s2,0x4
    80005ce8:	34fd                	addiw	s1,s1,-1
    80005cea:	f4ed                	bnez	s1,80005cd4 <printf+0x13a>
    80005cec:	b7a1                	j	80005c34 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005cee:	f8843783          	ld	a5,-120(s0)
    80005cf2:	00878713          	addi	a4,a5,8
    80005cf6:	f8e43423          	sd	a4,-120(s0)
    80005cfa:	6384                	ld	s1,0(a5)
    80005cfc:	cc89                	beqz	s1,80005d16 <printf+0x17c>
      for(; *s; s++)
    80005cfe:	0004c503          	lbu	a0,0(s1)
    80005d02:	d90d                	beqz	a0,80005c34 <printf+0x9a>
        consputc(*s);
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	b88080e7          	jalr	-1144(ra) # 8000588c <consputc>
      for(; *s; s++)
    80005d0c:	0485                	addi	s1,s1,1
    80005d0e:	0004c503          	lbu	a0,0(s1)
    80005d12:	f96d                	bnez	a0,80005d04 <printf+0x16a>
    80005d14:	b705                	j	80005c34 <printf+0x9a>
        s = "(null)";
    80005d16:	00003497          	auipc	s1,0x3
    80005d1a:	aaa48493          	addi	s1,s1,-1366 # 800087c0 <syscalls+0x3e0>
      for(; *s; s++)
    80005d1e:	02800513          	li	a0,40
    80005d22:	b7cd                	j	80005d04 <printf+0x16a>
      consputc('%');
    80005d24:	8556                	mv	a0,s5
    80005d26:	00000097          	auipc	ra,0x0
    80005d2a:	b66080e7          	jalr	-1178(ra) # 8000588c <consputc>
      break;
    80005d2e:	b719                	j	80005c34 <printf+0x9a>
      consputc('%');
    80005d30:	8556                	mv	a0,s5
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	b5a080e7          	jalr	-1190(ra) # 8000588c <consputc>
      consputc(c);
    80005d3a:	8526                	mv	a0,s1
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	b50080e7          	jalr	-1200(ra) # 8000588c <consputc>
      break;
    80005d44:	bdc5                	j	80005c34 <printf+0x9a>
  if(locking)
    80005d46:	020d9163          	bnez	s11,80005d68 <printf+0x1ce>
}
    80005d4a:	70e6                	ld	ra,120(sp)
    80005d4c:	7446                	ld	s0,112(sp)
    80005d4e:	74a6                	ld	s1,104(sp)
    80005d50:	7906                	ld	s2,96(sp)
    80005d52:	69e6                	ld	s3,88(sp)
    80005d54:	6a46                	ld	s4,80(sp)
    80005d56:	6aa6                	ld	s5,72(sp)
    80005d58:	6b06                	ld	s6,64(sp)
    80005d5a:	7be2                	ld	s7,56(sp)
    80005d5c:	7c42                	ld	s8,48(sp)
    80005d5e:	7ca2                	ld	s9,40(sp)
    80005d60:	7d02                	ld	s10,32(sp)
    80005d62:	6de2                	ld	s11,24(sp)
    80005d64:	6129                	addi	sp,sp,192
    80005d66:	8082                	ret
    release(&pr.lock);
    80005d68:	00020517          	auipc	a0,0x20
    80005d6c:	48050513          	addi	a0,a0,1152 # 800261e8 <pr>
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	3cc080e7          	jalr	972(ra) # 8000613c <release>
}
    80005d78:	bfc9                	j	80005d4a <printf+0x1b0>

0000000080005d7a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d7a:	1101                	addi	sp,sp,-32
    80005d7c:	ec06                	sd	ra,24(sp)
    80005d7e:	e822                	sd	s0,16(sp)
    80005d80:	e426                	sd	s1,8(sp)
    80005d82:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d84:	00020497          	auipc	s1,0x20
    80005d88:	46448493          	addi	s1,s1,1124 # 800261e8 <pr>
    80005d8c:	00003597          	auipc	a1,0x3
    80005d90:	a4c58593          	addi	a1,a1,-1460 # 800087d8 <syscalls+0x3f8>
    80005d94:	8526                	mv	a0,s1
    80005d96:	00000097          	auipc	ra,0x0
    80005d9a:	262080e7          	jalr	610(ra) # 80005ff8 <initlock>
  pr.locking = 1;
    80005d9e:	4785                	li	a5,1
    80005da0:	cc9c                	sw	a5,24(s1)
}
    80005da2:	60e2                	ld	ra,24(sp)
    80005da4:	6442                	ld	s0,16(sp)
    80005da6:	64a2                	ld	s1,8(sp)
    80005da8:	6105                	addi	sp,sp,32
    80005daa:	8082                	ret

0000000080005dac <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005dac:	1141                	addi	sp,sp,-16
    80005dae:	e406                	sd	ra,8(sp)
    80005db0:	e022                	sd	s0,0(sp)
    80005db2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005db4:	100007b7          	lui	a5,0x10000
    80005db8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005dbc:	f8000713          	li	a4,-128
    80005dc0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005dc4:	470d                	li	a4,3
    80005dc6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005dca:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005dce:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005dd2:	469d                	li	a3,7
    80005dd4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005dd8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ddc:	00003597          	auipc	a1,0x3
    80005de0:	a1c58593          	addi	a1,a1,-1508 # 800087f8 <digits+0x18>
    80005de4:	00020517          	auipc	a0,0x20
    80005de8:	42450513          	addi	a0,a0,1060 # 80026208 <uart_tx_lock>
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	20c080e7          	jalr	524(ra) # 80005ff8 <initlock>
}
    80005df4:	60a2                	ld	ra,8(sp)
    80005df6:	6402                	ld	s0,0(sp)
    80005df8:	0141                	addi	sp,sp,16
    80005dfa:	8082                	ret

0000000080005dfc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005dfc:	1101                	addi	sp,sp,-32
    80005dfe:	ec06                	sd	ra,24(sp)
    80005e00:	e822                	sd	s0,16(sp)
    80005e02:	e426                	sd	s1,8(sp)
    80005e04:	1000                	addi	s0,sp,32
    80005e06:	84aa                	mv	s1,a0
  push_off();
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	234080e7          	jalr	564(ra) # 8000603c <push_off>

  if(panicked){
    80005e10:	00003797          	auipc	a5,0x3
    80005e14:	20c7a783          	lw	a5,524(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e18:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e1c:	c391                	beqz	a5,80005e20 <uartputc_sync+0x24>
    for(;;)
    80005e1e:	a001                	j	80005e1e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e20:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e24:	0207f793          	andi	a5,a5,32
    80005e28:	dfe5                	beqz	a5,80005e20 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e2a:	0ff4f513          	zext.b	a0,s1
    80005e2e:	100007b7          	lui	a5,0x10000
    80005e32:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	2a6080e7          	jalr	678(ra) # 800060dc <pop_off>
}
    80005e3e:	60e2                	ld	ra,24(sp)
    80005e40:	6442                	ld	s0,16(sp)
    80005e42:	64a2                	ld	s1,8(sp)
    80005e44:	6105                	addi	sp,sp,32
    80005e46:	8082                	ret

0000000080005e48 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e48:	00003797          	auipc	a5,0x3
    80005e4c:	1d87b783          	ld	a5,472(a5) # 80009020 <uart_tx_r>
    80005e50:	00003717          	auipc	a4,0x3
    80005e54:	1d873703          	ld	a4,472(a4) # 80009028 <uart_tx_w>
    80005e58:	06f70a63          	beq	a4,a5,80005ecc <uartstart+0x84>
{
    80005e5c:	7139                	addi	sp,sp,-64
    80005e5e:	fc06                	sd	ra,56(sp)
    80005e60:	f822                	sd	s0,48(sp)
    80005e62:	f426                	sd	s1,40(sp)
    80005e64:	f04a                	sd	s2,32(sp)
    80005e66:	ec4e                	sd	s3,24(sp)
    80005e68:	e852                	sd	s4,16(sp)
    80005e6a:	e456                	sd	s5,8(sp)
    80005e6c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e6e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e72:	00020a17          	auipc	s4,0x20
    80005e76:	396a0a13          	addi	s4,s4,918 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005e7a:	00003497          	auipc	s1,0x3
    80005e7e:	1a648493          	addi	s1,s1,422 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005e82:	00003997          	auipc	s3,0x3
    80005e86:	1a698993          	addi	s3,s3,422 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e8a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005e8e:	02077713          	andi	a4,a4,32
    80005e92:	c705                	beqz	a4,80005eba <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e94:	01f7f713          	andi	a4,a5,31
    80005e98:	9752                	add	a4,a4,s4
    80005e9a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005e9e:	0785                	addi	a5,a5,1
    80005ea0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ea2:	8526                	mv	a0,s1
    80005ea4:	ffffb097          	auipc	ra,0xffffb
    80005ea8:	7f8080e7          	jalr	2040(ra) # 8000169c <wakeup>
    
    WriteReg(THR, c);
    80005eac:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005eb0:	609c                	ld	a5,0(s1)
    80005eb2:	0009b703          	ld	a4,0(s3)
    80005eb6:	fcf71ae3          	bne	a4,a5,80005e8a <uartstart+0x42>
  }
}
    80005eba:	70e2                	ld	ra,56(sp)
    80005ebc:	7442                	ld	s0,48(sp)
    80005ebe:	74a2                	ld	s1,40(sp)
    80005ec0:	7902                	ld	s2,32(sp)
    80005ec2:	69e2                	ld	s3,24(sp)
    80005ec4:	6a42                	ld	s4,16(sp)
    80005ec6:	6aa2                	ld	s5,8(sp)
    80005ec8:	6121                	addi	sp,sp,64
    80005eca:	8082                	ret
    80005ecc:	8082                	ret

0000000080005ece <uartputc>:
{
    80005ece:	7179                	addi	sp,sp,-48
    80005ed0:	f406                	sd	ra,40(sp)
    80005ed2:	f022                	sd	s0,32(sp)
    80005ed4:	ec26                	sd	s1,24(sp)
    80005ed6:	e84a                	sd	s2,16(sp)
    80005ed8:	e44e                	sd	s3,8(sp)
    80005eda:	e052                	sd	s4,0(sp)
    80005edc:	1800                	addi	s0,sp,48
    80005ede:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005ee0:	00020517          	auipc	a0,0x20
    80005ee4:	32850513          	addi	a0,a0,808 # 80026208 <uart_tx_lock>
    80005ee8:	00000097          	auipc	ra,0x0
    80005eec:	1a0080e7          	jalr	416(ra) # 80006088 <acquire>
  if(panicked){
    80005ef0:	00003797          	auipc	a5,0x3
    80005ef4:	12c7a783          	lw	a5,300(a5) # 8000901c <panicked>
    80005ef8:	c391                	beqz	a5,80005efc <uartputc+0x2e>
    for(;;)
    80005efa:	a001                	j	80005efa <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005efc:	00003717          	auipc	a4,0x3
    80005f00:	12c73703          	ld	a4,300(a4) # 80009028 <uart_tx_w>
    80005f04:	00003797          	auipc	a5,0x3
    80005f08:	11c7b783          	ld	a5,284(a5) # 80009020 <uart_tx_r>
    80005f0c:	02078793          	addi	a5,a5,32
    80005f10:	02e79b63          	bne	a5,a4,80005f46 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005f14:	00020997          	auipc	s3,0x20
    80005f18:	2f498993          	addi	s3,s3,756 # 80026208 <uart_tx_lock>
    80005f1c:	00003497          	auipc	s1,0x3
    80005f20:	10448493          	addi	s1,s1,260 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f24:	00003917          	auipc	s2,0x3
    80005f28:	10490913          	addi	s2,s2,260 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005f2c:	85ce                	mv	a1,s3
    80005f2e:	8526                	mv	a0,s1
    80005f30:	ffffb097          	auipc	ra,0xffffb
    80005f34:	5e0080e7          	jalr	1504(ra) # 80001510 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f38:	00093703          	ld	a4,0(s2)
    80005f3c:	609c                	ld	a5,0(s1)
    80005f3e:	02078793          	addi	a5,a5,32
    80005f42:	fee785e3          	beq	a5,a4,80005f2c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f46:	00020497          	auipc	s1,0x20
    80005f4a:	2c248493          	addi	s1,s1,706 # 80026208 <uart_tx_lock>
    80005f4e:	01f77793          	andi	a5,a4,31
    80005f52:	97a6                	add	a5,a5,s1
    80005f54:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80005f58:	0705                	addi	a4,a4,1
    80005f5a:	00003797          	auipc	a5,0x3
    80005f5e:	0ce7b723          	sd	a4,206(a5) # 80009028 <uart_tx_w>
      uartstart();
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	ee6080e7          	jalr	-282(ra) # 80005e48 <uartstart>
      release(&uart_tx_lock);
    80005f6a:	8526                	mv	a0,s1
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	1d0080e7          	jalr	464(ra) # 8000613c <release>
}
    80005f74:	70a2                	ld	ra,40(sp)
    80005f76:	7402                	ld	s0,32(sp)
    80005f78:	64e2                	ld	s1,24(sp)
    80005f7a:	6942                	ld	s2,16(sp)
    80005f7c:	69a2                	ld	s3,8(sp)
    80005f7e:	6a02                	ld	s4,0(sp)
    80005f80:	6145                	addi	sp,sp,48
    80005f82:	8082                	ret

0000000080005f84 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005f84:	1141                	addi	sp,sp,-16
    80005f86:	e422                	sd	s0,8(sp)
    80005f88:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005f8a:	100007b7          	lui	a5,0x10000
    80005f8e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005f92:	8b85                	andi	a5,a5,1
    80005f94:	cb81                	beqz	a5,80005fa4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005f96:	100007b7          	lui	a5,0x10000
    80005f9a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005f9e:	6422                	ld	s0,8(sp)
    80005fa0:	0141                	addi	sp,sp,16
    80005fa2:	8082                	ret
    return -1;
    80005fa4:	557d                	li	a0,-1
    80005fa6:	bfe5                	j	80005f9e <uartgetc+0x1a>

0000000080005fa8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80005fa8:	1101                	addi	sp,sp,-32
    80005faa:	ec06                	sd	ra,24(sp)
    80005fac:	e822                	sd	s0,16(sp)
    80005fae:	e426                	sd	s1,8(sp)
    80005fb0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005fb2:	54fd                	li	s1,-1
    80005fb4:	a029                	j	80005fbe <uartintr+0x16>
      break;
    consoleintr(c);
    80005fb6:	00000097          	auipc	ra,0x0
    80005fba:	918080e7          	jalr	-1768(ra) # 800058ce <consoleintr>
    int c = uartgetc();
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	fc6080e7          	jalr	-58(ra) # 80005f84 <uartgetc>
    if(c == -1)
    80005fc6:	fe9518e3          	bne	a0,s1,80005fb6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005fca:	00020497          	auipc	s1,0x20
    80005fce:	23e48493          	addi	s1,s1,574 # 80026208 <uart_tx_lock>
    80005fd2:	8526                	mv	a0,s1
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	0b4080e7          	jalr	180(ra) # 80006088 <acquire>
  uartstart();
    80005fdc:	00000097          	auipc	ra,0x0
    80005fe0:	e6c080e7          	jalr	-404(ra) # 80005e48 <uartstart>
  release(&uart_tx_lock);
    80005fe4:	8526                	mv	a0,s1
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	156080e7          	jalr	342(ra) # 8000613c <release>
}
    80005fee:	60e2                	ld	ra,24(sp)
    80005ff0:	6442                	ld	s0,16(sp)
    80005ff2:	64a2                	ld	s1,8(sp)
    80005ff4:	6105                	addi	sp,sp,32
    80005ff6:	8082                	ret

0000000080005ff8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005ff8:	1141                	addi	sp,sp,-16
    80005ffa:	e422                	sd	s0,8(sp)
    80005ffc:	0800                	addi	s0,sp,16
  lk->name = name;
    80005ffe:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006000:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006004:	00053823          	sd	zero,16(a0)
}
    80006008:	6422                	ld	s0,8(sp)
    8000600a:	0141                	addi	sp,sp,16
    8000600c:	8082                	ret

000000008000600e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000600e:	411c                	lw	a5,0(a0)
    80006010:	e399                	bnez	a5,80006016 <holding+0x8>
    80006012:	4501                	li	a0,0
  return r;
}
    80006014:	8082                	ret
{
    80006016:	1101                	addi	sp,sp,-32
    80006018:	ec06                	sd	ra,24(sp)
    8000601a:	e822                	sd	s0,16(sp)
    8000601c:	e426                	sd	s1,8(sp)
    8000601e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006020:	6904                	ld	s1,16(a0)
    80006022:	ffffb097          	auipc	ra,0xffffb
    80006026:	e06080e7          	jalr	-506(ra) # 80000e28 <mycpu>
    8000602a:	40a48533          	sub	a0,s1,a0
    8000602e:	00153513          	seqz	a0,a0
}
    80006032:	60e2                	ld	ra,24(sp)
    80006034:	6442                	ld	s0,16(sp)
    80006036:	64a2                	ld	s1,8(sp)
    80006038:	6105                	addi	sp,sp,32
    8000603a:	8082                	ret

000000008000603c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000603c:	1101                	addi	sp,sp,-32
    8000603e:	ec06                	sd	ra,24(sp)
    80006040:	e822                	sd	s0,16(sp)
    80006042:	e426                	sd	s1,8(sp)
    80006044:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006046:	100024f3          	csrr	s1,sstatus
    8000604a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000604e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006050:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006054:	ffffb097          	auipc	ra,0xffffb
    80006058:	dd4080e7          	jalr	-556(ra) # 80000e28 <mycpu>
    8000605c:	5d3c                	lw	a5,120(a0)
    8000605e:	cf89                	beqz	a5,80006078 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006060:	ffffb097          	auipc	ra,0xffffb
    80006064:	dc8080e7          	jalr	-568(ra) # 80000e28 <mycpu>
    80006068:	5d3c                	lw	a5,120(a0)
    8000606a:	2785                	addiw	a5,a5,1
    8000606c:	dd3c                	sw	a5,120(a0)
}
    8000606e:	60e2                	ld	ra,24(sp)
    80006070:	6442                	ld	s0,16(sp)
    80006072:	64a2                	ld	s1,8(sp)
    80006074:	6105                	addi	sp,sp,32
    80006076:	8082                	ret
    mycpu()->intena = old;
    80006078:	ffffb097          	auipc	ra,0xffffb
    8000607c:	db0080e7          	jalr	-592(ra) # 80000e28 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006080:	8085                	srli	s1,s1,0x1
    80006082:	8885                	andi	s1,s1,1
    80006084:	dd64                	sw	s1,124(a0)
    80006086:	bfe9                	j	80006060 <push_off+0x24>

0000000080006088 <acquire>:
{
    80006088:	1101                	addi	sp,sp,-32
    8000608a:	ec06                	sd	ra,24(sp)
    8000608c:	e822                	sd	s0,16(sp)
    8000608e:	e426                	sd	s1,8(sp)
    80006090:	1000                	addi	s0,sp,32
    80006092:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006094:	00000097          	auipc	ra,0x0
    80006098:	fa8080e7          	jalr	-88(ra) # 8000603c <push_off>
  if(holding(lk))
    8000609c:	8526                	mv	a0,s1
    8000609e:	00000097          	auipc	ra,0x0
    800060a2:	f70080e7          	jalr	-144(ra) # 8000600e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060a6:	4705                	li	a4,1
  if(holding(lk))
    800060a8:	e115                	bnez	a0,800060cc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060aa:	87ba                	mv	a5,a4
    800060ac:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800060b0:	2781                	sext.w	a5,a5
    800060b2:	ffe5                	bnez	a5,800060aa <acquire+0x22>
  __sync_synchronize();
    800060b4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800060b8:	ffffb097          	auipc	ra,0xffffb
    800060bc:	d70080e7          	jalr	-656(ra) # 80000e28 <mycpu>
    800060c0:	e888                	sd	a0,16(s1)
}
    800060c2:	60e2                	ld	ra,24(sp)
    800060c4:	6442                	ld	s0,16(sp)
    800060c6:	64a2                	ld	s1,8(sp)
    800060c8:	6105                	addi	sp,sp,32
    800060ca:	8082                	ret
    panic("acquire");
    800060cc:	00002517          	auipc	a0,0x2
    800060d0:	73450513          	addi	a0,a0,1844 # 80008800 <digits+0x20>
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	a7c080e7          	jalr	-1412(ra) # 80005b50 <panic>

00000000800060dc <pop_off>:

void
pop_off(void)
{
    800060dc:	1141                	addi	sp,sp,-16
    800060de:	e406                	sd	ra,8(sp)
    800060e0:	e022                	sd	s0,0(sp)
    800060e2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800060e4:	ffffb097          	auipc	ra,0xffffb
    800060e8:	d44080e7          	jalr	-700(ra) # 80000e28 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060ec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800060f0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800060f2:	e78d                	bnez	a5,8000611c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800060f4:	5d3c                	lw	a5,120(a0)
    800060f6:	02f05b63          	blez	a5,8000612c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800060fa:	37fd                	addiw	a5,a5,-1
    800060fc:	0007871b          	sext.w	a4,a5
    80006100:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006102:	eb09                	bnez	a4,80006114 <pop_off+0x38>
    80006104:	5d7c                	lw	a5,124(a0)
    80006106:	c799                	beqz	a5,80006114 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006108:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000610c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006110:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006114:	60a2                	ld	ra,8(sp)
    80006116:	6402                	ld	s0,0(sp)
    80006118:	0141                	addi	sp,sp,16
    8000611a:	8082                	ret
    panic("pop_off - interruptible");
    8000611c:	00002517          	auipc	a0,0x2
    80006120:	6ec50513          	addi	a0,a0,1772 # 80008808 <digits+0x28>
    80006124:	00000097          	auipc	ra,0x0
    80006128:	a2c080e7          	jalr	-1492(ra) # 80005b50 <panic>
    panic("pop_off");
    8000612c:	00002517          	auipc	a0,0x2
    80006130:	6f450513          	addi	a0,a0,1780 # 80008820 <digits+0x40>
    80006134:	00000097          	auipc	ra,0x0
    80006138:	a1c080e7          	jalr	-1508(ra) # 80005b50 <panic>

000000008000613c <release>:
{
    8000613c:	1101                	addi	sp,sp,-32
    8000613e:	ec06                	sd	ra,24(sp)
    80006140:	e822                	sd	s0,16(sp)
    80006142:	e426                	sd	s1,8(sp)
    80006144:	1000                	addi	s0,sp,32
    80006146:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006148:	00000097          	auipc	ra,0x0
    8000614c:	ec6080e7          	jalr	-314(ra) # 8000600e <holding>
    80006150:	c115                	beqz	a0,80006174 <release+0x38>
  lk->cpu = 0;
    80006152:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006156:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000615a:	0f50000f          	fence	iorw,ow
    8000615e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006162:	00000097          	auipc	ra,0x0
    80006166:	f7a080e7          	jalr	-134(ra) # 800060dc <pop_off>
}
    8000616a:	60e2                	ld	ra,24(sp)
    8000616c:	6442                	ld	s0,16(sp)
    8000616e:	64a2                	ld	s1,8(sp)
    80006170:	6105                	addi	sp,sp,32
    80006172:	8082                	ret
    panic("release");
    80006174:	00002517          	auipc	a0,0x2
    80006178:	6b450513          	addi	a0,a0,1716 # 80008828 <digits+0x48>
    8000617c:	00000097          	auipc	ra,0x0
    80006180:	9d4080e7          	jalr	-1580(ra) # 80005b50 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
