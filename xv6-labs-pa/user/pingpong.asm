
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
  int p2c[2],c2p[2];
  pipe(p2c);
   8:	fe840513          	addi	a0,s0,-24
   c:	00000097          	auipc	ra,0x0
  10:	372080e7          	jalr	882(ra) # 37e <pipe>
  pipe(c2p);
  14:	fe040513          	addi	a0,s0,-32
  18:	00000097          	auipc	ra,0x0
  1c:	366080e7          	jalr	870(ra) # 37e <pipe>
  
  if(fork() == 0){
  20:	00000097          	auipc	ra,0x0
  24:	346080e7          	jalr	838(ra) # 366 <fork>
  28:	e53d                	bnez	a0,96 <main+0x96>
    close(p2c[1]);
  2a:	fec42503          	lw	a0,-20(s0)
  2e:	00000097          	auipc	ra,0x0
  32:	368080e7          	jalr	872(ra) # 396 <close>
    close(c2p[0]);
  36:	fe042503          	lw	a0,-32(s0)
  3a:	00000097          	auipc	ra,0x0
  3e:	35c080e7          	jalr	860(ra) # 396 <close>
    
    char buff[8];
    if(read(p2c[0], buff, 1) == 1){
  42:	4605                	li	a2,1
  44:	fd840593          	addi	a1,s0,-40
  48:	fe842503          	lw	a0,-24(s0)
  4c:	00000097          	auipc	ra,0x0
  50:	33a080e7          	jalr	826(ra) # 386 <read>
  54:	4785                	li	a5,1
  56:	02f50263          	beq	a0,a5,7a <main+0x7a>
      printf("%d: received ping\n", getpid());
    }
    write(c2p[1], "1", 1);
  5a:	4605                	li	a2,1
  5c:	00001597          	auipc	a1,0x1
  60:	84458593          	addi	a1,a1,-1980 # 8a0 <malloc+0x100>
  64:	fe442503          	lw	a0,-28(s0)
  68:	00000097          	auipc	ra,0x0
  6c:	326080e7          	jalr	806(ra) # 38e <write>
    
    exit(0);
  70:	4501                	li	a0,0
  72:	00000097          	auipc	ra,0x0
  76:	2fc080e7          	jalr	764(ra) # 36e <exit>
      printf("%d: received ping\n", getpid());
  7a:	00000097          	auipc	ra,0x0
  7e:	374080e7          	jalr	884(ra) # 3ee <getpid>
  82:	85aa                	mv	a1,a0
  84:	00001517          	auipc	a0,0x1
  88:	80450513          	addi	a0,a0,-2044 # 888 <malloc+0xe8>
  8c:	00000097          	auipc	ra,0x0
  90:	65c080e7          	jalr	1628(ra) # 6e8 <printf>
  94:	b7d9                	j	5a <main+0x5a>
  }
  else{
    close(c2p[1]);
  96:	fe442503          	lw	a0,-28(s0)
  9a:	00000097          	auipc	ra,0x0
  9e:	2fc080e7          	jalr	764(ra) # 396 <close>
    close(p2c[0]);
  a2:	fe842503          	lw	a0,-24(s0)
  a6:	00000097          	auipc	ra,0x0
  aa:	2f0080e7          	jalr	752(ra) # 396 <close>
    
    char buff[8];
    write(p2c[1], "2", 1);
  ae:	4605                	li	a2,1
  b0:	00000597          	auipc	a1,0x0
  b4:	7f858593          	addi	a1,a1,2040 # 8a8 <malloc+0x108>
  b8:	fec42503          	lw	a0,-20(s0)
  bc:	00000097          	auipc	ra,0x0
  c0:	2d2080e7          	jalr	722(ra) # 38e <write>
    if(read(c2p[0], buff, 1) == 1){
  c4:	4605                	li	a2,1
  c6:	fd840593          	addi	a1,s0,-40
  ca:	fe042503          	lw	a0,-32(s0)
  ce:	00000097          	auipc	ra,0x0
  d2:	2b8080e7          	jalr	696(ra) # 386 <read>
  d6:	4785                	li	a5,1
  d8:	00f50763          	beq	a0,a5,e6 <main+0xe6>
      printf("%d: received pong\n", getpid());
    }
  }
  
  exit(0);
  dc:	4501                	li	a0,0
  de:	00000097          	auipc	ra,0x0
  e2:	290080e7          	jalr	656(ra) # 36e <exit>
      printf("%d: received pong\n", getpid());
  e6:	00000097          	auipc	ra,0x0
  ea:	308080e7          	jalr	776(ra) # 3ee <getpid>
  ee:	85aa                	mv	a1,a0
  f0:	00000517          	auipc	a0,0x0
  f4:	7c050513          	addi	a0,a0,1984 # 8b0 <malloc+0x110>
  f8:	00000097          	auipc	ra,0x0
  fc:	5f0080e7          	jalr	1520(ra) # 6e8 <printf>
 100:	bff1                	j	dc <main+0xdc>

0000000000000102 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 102:	1141                	addi	sp,sp,-16
 104:	e422                	sd	s0,8(sp)
 106:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 108:	87aa                	mv	a5,a0
 10a:	0585                	addi	a1,a1,1
 10c:	0785                	addi	a5,a5,1
 10e:	fff5c703          	lbu	a4,-1(a1)
 112:	fee78fa3          	sb	a4,-1(a5)
 116:	fb75                	bnez	a4,10a <strcpy+0x8>
    ;
  return os;
}
 118:	6422                	ld	s0,8(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 124:	00054783          	lbu	a5,0(a0)
 128:	cb91                	beqz	a5,13c <strcmp+0x1e>
 12a:	0005c703          	lbu	a4,0(a1)
 12e:	00f71763          	bne	a4,a5,13c <strcmp+0x1e>
    p++, q++;
 132:	0505                	addi	a0,a0,1
 134:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 136:	00054783          	lbu	a5,0(a0)
 13a:	fbe5                	bnez	a5,12a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 13c:	0005c503          	lbu	a0,0(a1)
}
 140:	40a7853b          	subw	a0,a5,a0
 144:	6422                	ld	s0,8(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret

000000000000014a <strlen>:

uint
strlen(const char *s)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e422                	sd	s0,8(sp)
 14e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cf91                	beqz	a5,170 <strlen+0x26>
 156:	0505                	addi	a0,a0,1
 158:	87aa                	mv	a5,a0
 15a:	4685                	li	a3,1
 15c:	9e89                	subw	a3,a3,a0
 15e:	00f6853b          	addw	a0,a3,a5
 162:	0785                	addi	a5,a5,1
 164:	fff7c703          	lbu	a4,-1(a5)
 168:	fb7d                	bnez	a4,15e <strlen+0x14>
    ;
  return n;
}
 16a:	6422                	ld	s0,8(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret
  for(n = 0; s[n]; n++)
 170:	4501                	li	a0,0
 172:	bfe5                	j	16a <strlen+0x20>

0000000000000174 <memset>:

void*
memset(void *dst, int c, uint n)
{
 174:	1141                	addi	sp,sp,-16
 176:	e422                	sd	s0,8(sp)
 178:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 17a:	ca19                	beqz	a2,190 <memset+0x1c>
 17c:	87aa                	mv	a5,a0
 17e:	1602                	slli	a2,a2,0x20
 180:	9201                	srli	a2,a2,0x20
 182:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 186:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 18a:	0785                	addi	a5,a5,1
 18c:	fee79de3          	bne	a5,a4,186 <memset+0x12>
  }
  return dst;
}
 190:	6422                	ld	s0,8(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret

0000000000000196 <strchr>:

char*
strchr(const char *s, char c)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	cb99                	beqz	a5,1b6 <strchr+0x20>
    if(*s == c)
 1a2:	00f58763          	beq	a1,a5,1b0 <strchr+0x1a>
  for(; *s; s++)
 1a6:	0505                	addi	a0,a0,1
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	fbfd                	bnez	a5,1a2 <strchr+0xc>
      return (char*)s;
  return 0;
 1ae:	4501                	li	a0,0
}
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret
  return 0;
 1b6:	4501                	li	a0,0
 1b8:	bfe5                	j	1b0 <strchr+0x1a>

00000000000001ba <gets>:

char*
gets(char *buf, int max)
{
 1ba:	711d                	addi	sp,sp,-96
 1bc:	ec86                	sd	ra,88(sp)
 1be:	e8a2                	sd	s0,80(sp)
 1c0:	e4a6                	sd	s1,72(sp)
 1c2:	e0ca                	sd	s2,64(sp)
 1c4:	fc4e                	sd	s3,56(sp)
 1c6:	f852                	sd	s4,48(sp)
 1c8:	f456                	sd	s5,40(sp)
 1ca:	f05a                	sd	s6,32(sp)
 1cc:	ec5e                	sd	s7,24(sp)
 1ce:	1080                	addi	s0,sp,96
 1d0:	8baa                	mv	s7,a0
 1d2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d4:	892a                	mv	s2,a0
 1d6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d8:	4aa9                	li	s5,10
 1da:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1dc:	89a6                	mv	s3,s1
 1de:	2485                	addiw	s1,s1,1
 1e0:	0344d863          	bge	s1,s4,210 <gets+0x56>
    cc = read(0, &c, 1);
 1e4:	4605                	li	a2,1
 1e6:	faf40593          	addi	a1,s0,-81
 1ea:	4501                	li	a0,0
 1ec:	00000097          	auipc	ra,0x0
 1f0:	19a080e7          	jalr	410(ra) # 386 <read>
    if(cc < 1)
 1f4:	00a05e63          	blez	a0,210 <gets+0x56>
    buf[i++] = c;
 1f8:	faf44783          	lbu	a5,-81(s0)
 1fc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 200:	01578763          	beq	a5,s5,20e <gets+0x54>
 204:	0905                	addi	s2,s2,1
 206:	fd679be3          	bne	a5,s6,1dc <gets+0x22>
  for(i=0; i+1 < max; ){
 20a:	89a6                	mv	s3,s1
 20c:	a011                	j	210 <gets+0x56>
 20e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 210:	99de                	add	s3,s3,s7
 212:	00098023          	sb	zero,0(s3)
  return buf;
}
 216:	855e                	mv	a0,s7
 218:	60e6                	ld	ra,88(sp)
 21a:	6446                	ld	s0,80(sp)
 21c:	64a6                	ld	s1,72(sp)
 21e:	6906                	ld	s2,64(sp)
 220:	79e2                	ld	s3,56(sp)
 222:	7a42                	ld	s4,48(sp)
 224:	7aa2                	ld	s5,40(sp)
 226:	7b02                	ld	s6,32(sp)
 228:	6be2                	ld	s7,24(sp)
 22a:	6125                	addi	sp,sp,96
 22c:	8082                	ret

000000000000022e <stat>:

int
stat(const char *n, struct stat *st)
{
 22e:	1101                	addi	sp,sp,-32
 230:	ec06                	sd	ra,24(sp)
 232:	e822                	sd	s0,16(sp)
 234:	e426                	sd	s1,8(sp)
 236:	e04a                	sd	s2,0(sp)
 238:	1000                	addi	s0,sp,32
 23a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23c:	4581                	li	a1,0
 23e:	00000097          	auipc	ra,0x0
 242:	170080e7          	jalr	368(ra) # 3ae <open>
  if(fd < 0)
 246:	02054563          	bltz	a0,270 <stat+0x42>
 24a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 24c:	85ca                	mv	a1,s2
 24e:	00000097          	auipc	ra,0x0
 252:	178080e7          	jalr	376(ra) # 3c6 <fstat>
 256:	892a                	mv	s2,a0
  close(fd);
 258:	8526                	mv	a0,s1
 25a:	00000097          	auipc	ra,0x0
 25e:	13c080e7          	jalr	316(ra) # 396 <close>
  return r;
}
 262:	854a                	mv	a0,s2
 264:	60e2                	ld	ra,24(sp)
 266:	6442                	ld	s0,16(sp)
 268:	64a2                	ld	s1,8(sp)
 26a:	6902                	ld	s2,0(sp)
 26c:	6105                	addi	sp,sp,32
 26e:	8082                	ret
    return -1;
 270:	597d                	li	s2,-1
 272:	bfc5                	j	262 <stat+0x34>

0000000000000274 <atoi>:

int
atoi(const char *s)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27a:	00054683          	lbu	a3,0(a0)
 27e:	fd06879b          	addiw	a5,a3,-48
 282:	0ff7f793          	zext.b	a5,a5
 286:	4625                	li	a2,9
 288:	02f66863          	bltu	a2,a5,2b8 <atoi+0x44>
 28c:	872a                	mv	a4,a0
  n = 0;
 28e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 290:	0705                	addi	a4,a4,1
 292:	0025179b          	slliw	a5,a0,0x2
 296:	9fa9                	addw	a5,a5,a0
 298:	0017979b          	slliw	a5,a5,0x1
 29c:	9fb5                	addw	a5,a5,a3
 29e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a2:	00074683          	lbu	a3,0(a4)
 2a6:	fd06879b          	addiw	a5,a3,-48
 2aa:	0ff7f793          	zext.b	a5,a5
 2ae:	fef671e3          	bgeu	a2,a5,290 <atoi+0x1c>
  return n;
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  n = 0;
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <atoi+0x3e>

00000000000002bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c2:	02b57463          	bgeu	a0,a1,2ea <memmove+0x2e>
    while(n-- > 0)
 2c6:	00c05f63          	blez	a2,2e4 <memmove+0x28>
 2ca:	1602                	slli	a2,a2,0x20
 2cc:	9201                	srli	a2,a2,0x20
 2ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d4:	0585                	addi	a1,a1,1
 2d6:	0705                	addi	a4,a4,1
 2d8:	fff5c683          	lbu	a3,-1(a1)
 2dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e0:	fee79ae3          	bne	a5,a4,2d4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
    dst += n;
 2ea:	00c50733          	add	a4,a0,a2
    src += n;
 2ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f0:	fec05ae3          	blez	a2,2e4 <memmove+0x28>
 2f4:	fff6079b          	addiw	a5,a2,-1
 2f8:	1782                	slli	a5,a5,0x20
 2fa:	9381                	srli	a5,a5,0x20
 2fc:	fff7c793          	not	a5,a5
 300:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 302:	15fd                	addi	a1,a1,-1
 304:	177d                	addi	a4,a4,-1
 306:	0005c683          	lbu	a3,0(a1)
 30a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 30e:	fee79ae3          	bne	a5,a4,302 <memmove+0x46>
 312:	bfc9                	j	2e4 <memmove+0x28>

0000000000000314 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31a:	ca05                	beqz	a2,34a <memcmp+0x36>
 31c:	fff6069b          	addiw	a3,a2,-1
 320:	1682                	slli	a3,a3,0x20
 322:	9281                	srli	a3,a3,0x20
 324:	0685                	addi	a3,a3,1
 326:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 328:	00054783          	lbu	a5,0(a0)
 32c:	0005c703          	lbu	a4,0(a1)
 330:	00e79863          	bne	a5,a4,340 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 334:	0505                	addi	a0,a0,1
    p2++;
 336:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 338:	fed518e3          	bne	a0,a3,328 <memcmp+0x14>
  }
  return 0;
 33c:	4501                	li	a0,0
 33e:	a019                	j	344 <memcmp+0x30>
      return *p1 - *p2;
 340:	40e7853b          	subw	a0,a5,a4
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
  return 0;
 34a:	4501                	li	a0,0
 34c:	bfe5                	j	344 <memcmp+0x30>

000000000000034e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e406                	sd	ra,8(sp)
 352:	e022                	sd	s0,0(sp)
 354:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 356:	00000097          	auipc	ra,0x0
 35a:	f66080e7          	jalr	-154(ra) # 2bc <memmove>
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 366:	4885                	li	a7,1
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <exit>:
.global exit
exit:
 li a7, SYS_exit
 36e:	4889                	li	a7,2
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <wait>:
.global wait
wait:
 li a7, SYS_wait
 376:	488d                	li	a7,3
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 37e:	4891                	li	a7,4
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <read>:
.global read
read:
 li a7, SYS_read
 386:	4895                	li	a7,5
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <write>:
.global write
write:
 li a7, SYS_write
 38e:	48c1                	li	a7,16
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <close>:
.global close
close:
 li a7, SYS_close
 396:	48d5                	li	a7,21
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <kill>:
.global kill
kill:
 li a7, SYS_kill
 39e:	4899                	li	a7,6
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a6:	489d                	li	a7,7
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <open>:
.global open
open:
 li a7, SYS_open
 3ae:	48bd                	li	a7,15
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b6:	48c5                	li	a7,17
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3be:	48c9                	li	a7,18
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c6:	48a1                	li	a7,8
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <link>:
.global link
link:
 li a7, SYS_link
 3ce:	48cd                	li	a7,19
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d6:	48d1                	li	a7,20
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3de:	48a5                	li	a7,9
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e6:	48a9                	li	a7,10
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ee:	48ad                	li	a7,11
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3f6:	48b1                	li	a7,12
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3fe:	48b5                	li	a7,13
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 406:	48b9                	li	a7,14
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40e:	1101                	addi	sp,sp,-32
 410:	ec06                	sd	ra,24(sp)
 412:	e822                	sd	s0,16(sp)
 414:	1000                	addi	s0,sp,32
 416:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41a:	4605                	li	a2,1
 41c:	fef40593          	addi	a1,s0,-17
 420:	00000097          	auipc	ra,0x0
 424:	f6e080e7          	jalr	-146(ra) # 38e <write>
}
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6105                	addi	sp,sp,32
 42e:	8082                	ret

0000000000000430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	7139                	addi	sp,sp,-64
 432:	fc06                	sd	ra,56(sp)
 434:	f822                	sd	s0,48(sp)
 436:	f426                	sd	s1,40(sp)
 438:	f04a                	sd	s2,32(sp)
 43a:	ec4e                	sd	s3,24(sp)
 43c:	0080                	addi	s0,sp,64
 43e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 440:	c299                	beqz	a3,446 <printint+0x16>
 442:	0805c963          	bltz	a1,4d4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 446:	2581                	sext.w	a1,a1
  neg = 0;
 448:	4881                	li	a7,0
 44a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 44e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 450:	2601                	sext.w	a2,a2
 452:	00000517          	auipc	a0,0x0
 456:	4d650513          	addi	a0,a0,1238 # 928 <digits>
 45a:	883a                	mv	a6,a4
 45c:	2705                	addiw	a4,a4,1
 45e:	02c5f7bb          	remuw	a5,a1,a2
 462:	1782                	slli	a5,a5,0x20
 464:	9381                	srli	a5,a5,0x20
 466:	97aa                	add	a5,a5,a0
 468:	0007c783          	lbu	a5,0(a5)
 46c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 470:	0005879b          	sext.w	a5,a1
 474:	02c5d5bb          	divuw	a1,a1,a2
 478:	0685                	addi	a3,a3,1
 47a:	fec7f0e3          	bgeu	a5,a2,45a <printint+0x2a>
  if(neg)
 47e:	00088c63          	beqz	a7,496 <printint+0x66>
    buf[i++] = '-';
 482:	fd070793          	addi	a5,a4,-48
 486:	00878733          	add	a4,a5,s0
 48a:	02d00793          	li	a5,45
 48e:	fef70823          	sb	a5,-16(a4)
 492:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 496:	02e05863          	blez	a4,4c6 <printint+0x96>
 49a:	fc040793          	addi	a5,s0,-64
 49e:	00e78933          	add	s2,a5,a4
 4a2:	fff78993          	addi	s3,a5,-1
 4a6:	99ba                	add	s3,s3,a4
 4a8:	377d                	addiw	a4,a4,-1
 4aa:	1702                	slli	a4,a4,0x20
 4ac:	9301                	srli	a4,a4,0x20
 4ae:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b2:	fff94583          	lbu	a1,-1(s2)
 4b6:	8526                	mv	a0,s1
 4b8:	00000097          	auipc	ra,0x0
 4bc:	f56080e7          	jalr	-170(ra) # 40e <putc>
  while(--i >= 0)
 4c0:	197d                	addi	s2,s2,-1
 4c2:	ff3918e3          	bne	s2,s3,4b2 <printint+0x82>
}
 4c6:	70e2                	ld	ra,56(sp)
 4c8:	7442                	ld	s0,48(sp)
 4ca:	74a2                	ld	s1,40(sp)
 4cc:	7902                	ld	s2,32(sp)
 4ce:	69e2                	ld	s3,24(sp)
 4d0:	6121                	addi	sp,sp,64
 4d2:	8082                	ret
    x = -xx;
 4d4:	40b005bb          	negw	a1,a1
    neg = 1;
 4d8:	4885                	li	a7,1
    x = -xx;
 4da:	bf85                	j	44a <printint+0x1a>

00000000000004dc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4dc:	7119                	addi	sp,sp,-128
 4de:	fc86                	sd	ra,120(sp)
 4e0:	f8a2                	sd	s0,112(sp)
 4e2:	f4a6                	sd	s1,104(sp)
 4e4:	f0ca                	sd	s2,96(sp)
 4e6:	ecce                	sd	s3,88(sp)
 4e8:	e8d2                	sd	s4,80(sp)
 4ea:	e4d6                	sd	s5,72(sp)
 4ec:	e0da                	sd	s6,64(sp)
 4ee:	fc5e                	sd	s7,56(sp)
 4f0:	f862                	sd	s8,48(sp)
 4f2:	f466                	sd	s9,40(sp)
 4f4:	f06a                	sd	s10,32(sp)
 4f6:	ec6e                	sd	s11,24(sp)
 4f8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4fa:	0005c903          	lbu	s2,0(a1)
 4fe:	18090f63          	beqz	s2,69c <vprintf+0x1c0>
 502:	8aaa                	mv	s5,a0
 504:	8b32                	mv	s6,a2
 506:	00158493          	addi	s1,a1,1
  state = 0;
 50a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 50c:	02500a13          	li	s4,37
 510:	4c55                	li	s8,21
 512:	00000c97          	auipc	s9,0x0
 516:	3bec8c93          	addi	s9,s9,958 # 8d0 <malloc+0x130>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 51a:	02800d93          	li	s11,40
  putc(fd, 'x');
 51e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 520:	00000b97          	auipc	s7,0x0
 524:	408b8b93          	addi	s7,s7,1032 # 928 <digits>
 528:	a839                	j	546 <vprintf+0x6a>
        putc(fd, c);
 52a:	85ca                	mv	a1,s2
 52c:	8556                	mv	a0,s5
 52e:	00000097          	auipc	ra,0x0
 532:	ee0080e7          	jalr	-288(ra) # 40e <putc>
 536:	a019                	j	53c <vprintf+0x60>
    } else if(state == '%'){
 538:	01498d63          	beq	s3,s4,552 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 53c:	0485                	addi	s1,s1,1
 53e:	fff4c903          	lbu	s2,-1(s1)
 542:	14090d63          	beqz	s2,69c <vprintf+0x1c0>
    if(state == 0){
 546:	fe0999e3          	bnez	s3,538 <vprintf+0x5c>
      if(c == '%'){
 54a:	ff4910e3          	bne	s2,s4,52a <vprintf+0x4e>
        state = '%';
 54e:	89d2                	mv	s3,s4
 550:	b7f5                	j	53c <vprintf+0x60>
      if(c == 'd'){
 552:	11490c63          	beq	s2,s4,66a <vprintf+0x18e>
 556:	f9d9079b          	addiw	a5,s2,-99
 55a:	0ff7f793          	zext.b	a5,a5
 55e:	10fc6e63          	bltu	s8,a5,67a <vprintf+0x19e>
 562:	f9d9079b          	addiw	a5,s2,-99
 566:	0ff7f713          	zext.b	a4,a5
 56a:	10ec6863          	bltu	s8,a4,67a <vprintf+0x19e>
 56e:	00271793          	slli	a5,a4,0x2
 572:	97e6                	add	a5,a5,s9
 574:	439c                	lw	a5,0(a5)
 576:	97e6                	add	a5,a5,s9
 578:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 57a:	008b0913          	addi	s2,s6,8
 57e:	4685                	li	a3,1
 580:	4629                	li	a2,10
 582:	000b2583          	lw	a1,0(s6)
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	ea8080e7          	jalr	-344(ra) # 430 <printint>
 590:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 592:	4981                	li	s3,0
 594:	b765                	j	53c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 596:	008b0913          	addi	s2,s6,8
 59a:	4681                	li	a3,0
 59c:	4629                	li	a2,10
 59e:	000b2583          	lw	a1,0(s6)
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e8c080e7          	jalr	-372(ra) # 430 <printint>
 5ac:	8b4a                	mv	s6,s2
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b771                	j	53c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5b2:	008b0913          	addi	s2,s6,8
 5b6:	4681                	li	a3,0
 5b8:	866a                	mv	a2,s10
 5ba:	000b2583          	lw	a1,0(s6)
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e70080e7          	jalr	-400(ra) # 430 <printint>
 5c8:	8b4a                	mv	s6,s2
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	bf85                	j	53c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5ce:	008b0793          	addi	a5,s6,8
 5d2:	f8f43423          	sd	a5,-120(s0)
 5d6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5da:	03000593          	li	a1,48
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e2e080e7          	jalr	-466(ra) # 40e <putc>
  putc(fd, 'x');
 5e8:	07800593          	li	a1,120
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e20080e7          	jalr	-480(ra) # 40e <putc>
 5f6:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f8:	03c9d793          	srli	a5,s3,0x3c
 5fc:	97de                	add	a5,a5,s7
 5fe:	0007c583          	lbu	a1,0(a5)
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	e0a080e7          	jalr	-502(ra) # 40e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60c:	0992                	slli	s3,s3,0x4
 60e:	397d                	addiw	s2,s2,-1
 610:	fe0914e3          	bnez	s2,5f8 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 614:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 618:	4981                	li	s3,0
 61a:	b70d                	j	53c <vprintf+0x60>
        s = va_arg(ap, char*);
 61c:	008b0913          	addi	s2,s6,8
 620:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 624:	02098163          	beqz	s3,646 <vprintf+0x16a>
        while(*s != 0){
 628:	0009c583          	lbu	a1,0(s3)
 62c:	c5ad                	beqz	a1,696 <vprintf+0x1ba>
          putc(fd, *s);
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	dde080e7          	jalr	-546(ra) # 40e <putc>
          s++;
 638:	0985                	addi	s3,s3,1
        while(*s != 0){
 63a:	0009c583          	lbu	a1,0(s3)
 63e:	f9e5                	bnez	a1,62e <vprintf+0x152>
        s = va_arg(ap, char*);
 640:	8b4a                	mv	s6,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	bde5                	j	53c <vprintf+0x60>
          s = "(null)";
 646:	00000997          	auipc	s3,0x0
 64a:	28298993          	addi	s3,s3,642 # 8c8 <malloc+0x128>
        while(*s != 0){
 64e:	85ee                	mv	a1,s11
 650:	bff9                	j	62e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 652:	008b0913          	addi	s2,s6,8
 656:	000b4583          	lbu	a1,0(s6)
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	db2080e7          	jalr	-590(ra) # 40e <putc>
 664:	8b4a                	mv	s6,s2
      state = 0;
 666:	4981                	li	s3,0
 668:	bdd1                	j	53c <vprintf+0x60>
        putc(fd, c);
 66a:	85d2                	mv	a1,s4
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	da0080e7          	jalr	-608(ra) # 40e <putc>
      state = 0;
 676:	4981                	li	s3,0
 678:	b5d1                	j	53c <vprintf+0x60>
        putc(fd, '%');
 67a:	85d2                	mv	a1,s4
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	d90080e7          	jalr	-624(ra) # 40e <putc>
        putc(fd, c);
 686:	85ca                	mv	a1,s2
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	d84080e7          	jalr	-636(ra) # 40e <putc>
      state = 0;
 692:	4981                	li	s3,0
 694:	b565                	j	53c <vprintf+0x60>
        s = va_arg(ap, char*);
 696:	8b4a                	mv	s6,s2
      state = 0;
 698:	4981                	li	s3,0
 69a:	b54d                	j	53c <vprintf+0x60>
    }
  }
}
 69c:	70e6                	ld	ra,120(sp)
 69e:	7446                	ld	s0,112(sp)
 6a0:	74a6                	ld	s1,104(sp)
 6a2:	7906                	ld	s2,96(sp)
 6a4:	69e6                	ld	s3,88(sp)
 6a6:	6a46                	ld	s4,80(sp)
 6a8:	6aa6                	ld	s5,72(sp)
 6aa:	6b06                	ld	s6,64(sp)
 6ac:	7be2                	ld	s7,56(sp)
 6ae:	7c42                	ld	s8,48(sp)
 6b0:	7ca2                	ld	s9,40(sp)
 6b2:	7d02                	ld	s10,32(sp)
 6b4:	6de2                	ld	s11,24(sp)
 6b6:	6109                	addi	sp,sp,128
 6b8:	8082                	ret

00000000000006ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ba:	715d                	addi	sp,sp,-80
 6bc:	ec06                	sd	ra,24(sp)
 6be:	e822                	sd	s0,16(sp)
 6c0:	1000                	addi	s0,sp,32
 6c2:	e010                	sd	a2,0(s0)
 6c4:	e414                	sd	a3,8(s0)
 6c6:	e818                	sd	a4,16(s0)
 6c8:	ec1c                	sd	a5,24(s0)
 6ca:	03043023          	sd	a6,32(s0)
 6ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d6:	8622                	mv	a2,s0
 6d8:	00000097          	auipc	ra,0x0
 6dc:	e04080e7          	jalr	-508(ra) # 4dc <vprintf>
}
 6e0:	60e2                	ld	ra,24(sp)
 6e2:	6442                	ld	s0,16(sp)
 6e4:	6161                	addi	sp,sp,80
 6e6:	8082                	ret

00000000000006e8 <printf>:

void
printf(const char *fmt, ...)
{
 6e8:	711d                	addi	sp,sp,-96
 6ea:	ec06                	sd	ra,24(sp)
 6ec:	e822                	sd	s0,16(sp)
 6ee:	1000                	addi	s0,sp,32
 6f0:	e40c                	sd	a1,8(s0)
 6f2:	e810                	sd	a2,16(s0)
 6f4:	ec14                	sd	a3,24(s0)
 6f6:	f018                	sd	a4,32(s0)
 6f8:	f41c                	sd	a5,40(s0)
 6fa:	03043823          	sd	a6,48(s0)
 6fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	00840613          	addi	a2,s0,8
 706:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 70a:	85aa                	mv	a1,a0
 70c:	4505                	li	a0,1
 70e:	00000097          	auipc	ra,0x0
 712:	dce080e7          	jalr	-562(ra) # 4dc <vprintf>
}
 716:	60e2                	ld	ra,24(sp)
 718:	6442                	ld	s0,16(sp)
 71a:	6125                	addi	sp,sp,96
 71c:	8082                	ret

000000000000071e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71e:	1141                	addi	sp,sp,-16
 720:	e422                	sd	s0,8(sp)
 722:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 724:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	00000797          	auipc	a5,0x0
 72c:	2187b783          	ld	a5,536(a5) # 940 <freep>
 730:	a02d                	j	75a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 732:	4618                	lw	a4,8(a2)
 734:	9f2d                	addw	a4,a4,a1
 736:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 73a:	6398                	ld	a4,0(a5)
 73c:	6310                	ld	a2,0(a4)
 73e:	a83d                	j	77c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 740:	ff852703          	lw	a4,-8(a0)
 744:	9f31                	addw	a4,a4,a2
 746:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 748:	ff053683          	ld	a3,-16(a0)
 74c:	a091                	j	790 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74e:	6398                	ld	a4,0(a5)
 750:	00e7e463          	bltu	a5,a4,758 <free+0x3a>
 754:	00e6ea63          	bltu	a3,a4,768 <free+0x4a>
{
 758:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75a:	fed7fae3          	bgeu	a5,a3,74e <free+0x30>
 75e:	6398                	ld	a4,0(a5)
 760:	00e6e463          	bltu	a3,a4,768 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 764:	fee7eae3          	bltu	a5,a4,758 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 768:	ff852583          	lw	a1,-8(a0)
 76c:	6390                	ld	a2,0(a5)
 76e:	02059813          	slli	a6,a1,0x20
 772:	01c85713          	srli	a4,a6,0x1c
 776:	9736                	add	a4,a4,a3
 778:	fae60de3          	beq	a2,a4,732 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 77c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 780:	4790                	lw	a2,8(a5)
 782:	02061593          	slli	a1,a2,0x20
 786:	01c5d713          	srli	a4,a1,0x1c
 78a:	973e                	add	a4,a4,a5
 78c:	fae68ae3          	beq	a3,a4,740 <free+0x22>
    p->s.ptr = bp->s.ptr;
 790:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 792:	00000717          	auipc	a4,0x0
 796:	1af73723          	sd	a5,430(a4) # 940 <freep>
}
 79a:	6422                	ld	s0,8(sp)
 79c:	0141                	addi	sp,sp,16
 79e:	8082                	ret

00000000000007a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a0:	7139                	addi	sp,sp,-64
 7a2:	fc06                	sd	ra,56(sp)
 7a4:	f822                	sd	s0,48(sp)
 7a6:	f426                	sd	s1,40(sp)
 7a8:	f04a                	sd	s2,32(sp)
 7aa:	ec4e                	sd	s3,24(sp)
 7ac:	e852                	sd	s4,16(sp)
 7ae:	e456                	sd	s5,8(sp)
 7b0:	e05a                	sd	s6,0(sp)
 7b2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b4:	02051493          	slli	s1,a0,0x20
 7b8:	9081                	srli	s1,s1,0x20
 7ba:	04bd                	addi	s1,s1,15
 7bc:	8091                	srli	s1,s1,0x4
 7be:	0014899b          	addiw	s3,s1,1
 7c2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c4:	00000517          	auipc	a0,0x0
 7c8:	17c53503          	ld	a0,380(a0) # 940 <freep>
 7cc:	c515                	beqz	a0,7f8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d0:	4798                	lw	a4,8(a5)
 7d2:	02977f63          	bgeu	a4,s1,810 <malloc+0x70>
 7d6:	8a4e                	mv	s4,s3
 7d8:	0009871b          	sext.w	a4,s3
 7dc:	6685                	lui	a3,0x1
 7de:	00d77363          	bgeu	a4,a3,7e4 <malloc+0x44>
 7e2:	6a05                	lui	s4,0x1
 7e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ec:	00000917          	auipc	s2,0x0
 7f0:	15490913          	addi	s2,s2,340 # 940 <freep>
  if(p == (char*)-1)
 7f4:	5afd                	li	s5,-1
 7f6:	a895                	j	86a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7f8:	00000797          	auipc	a5,0x0
 7fc:	15078793          	addi	a5,a5,336 # 948 <base>
 800:	00000717          	auipc	a4,0x0
 804:	14f73023          	sd	a5,320(a4) # 940 <freep>
 808:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 80a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 80e:	b7e1                	j	7d6 <malloc+0x36>
      if(p->s.size == nunits)
 810:	02e48c63          	beq	s1,a4,848 <malloc+0xa8>
        p->s.size -= nunits;
 814:	4137073b          	subw	a4,a4,s3
 818:	c798                	sw	a4,8(a5)
        p += p->s.size;
 81a:	02071693          	slli	a3,a4,0x20
 81e:	01c6d713          	srli	a4,a3,0x1c
 822:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 824:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 828:	00000717          	auipc	a4,0x0
 82c:	10a73c23          	sd	a0,280(a4) # 940 <freep>
      return (void*)(p + 1);
 830:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 834:	70e2                	ld	ra,56(sp)
 836:	7442                	ld	s0,48(sp)
 838:	74a2                	ld	s1,40(sp)
 83a:	7902                	ld	s2,32(sp)
 83c:	69e2                	ld	s3,24(sp)
 83e:	6a42                	ld	s4,16(sp)
 840:	6aa2                	ld	s5,8(sp)
 842:	6b02                	ld	s6,0(sp)
 844:	6121                	addi	sp,sp,64
 846:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 848:	6398                	ld	a4,0(a5)
 84a:	e118                	sd	a4,0(a0)
 84c:	bff1                	j	828 <malloc+0x88>
  hp->s.size = nu;
 84e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 852:	0541                	addi	a0,a0,16
 854:	00000097          	auipc	ra,0x0
 858:	eca080e7          	jalr	-310(ra) # 71e <free>
  return freep;
 85c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 860:	d971                	beqz	a0,834 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 862:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 864:	4798                	lw	a4,8(a5)
 866:	fa9775e3          	bgeu	a4,s1,810 <malloc+0x70>
    if(p == freep)
 86a:	00093703          	ld	a4,0(s2)
 86e:	853e                	mv	a0,a5
 870:	fef719e3          	bne	a4,a5,862 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 874:	8552                	mv	a0,s4
 876:	00000097          	auipc	ra,0x0
 87a:	b80080e7          	jalr	-1152(ra) # 3f6 <sbrk>
  if(p == (char*)-1)
 87e:	fd5518e3          	bne	a0,s5,84e <malloc+0xae>
        return 0;
 882:	4501                	li	a0,0
 884:	bf45                	j	834 <malloc+0x94>
