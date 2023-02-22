
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmt_subname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmt_subname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   e:	00000097          	auipc	ra,0x0
  12:	2b0080e7          	jalr	688(ra) # 2be <strlen>
  16:	02051593          	slli	a1,a0,0x20
  1a:	9181                	srli	a1,a1,0x20
  1c:	95a6                	add	a1,a1,s1
  1e:	02f00713          	li	a4,47
  22:	0095e963          	bltu	a1,s1,34 <fmt_subname+0x34>
  26:	0005c783          	lbu	a5,0(a1)
  2a:	00e78563          	beq	a5,a4,34 <fmt_subname+0x34>
  2e:	15fd                	addi	a1,a1,-1
  30:	fe95fbe3          	bgeu	a1,s1,26 <fmt_subname+0x26>
    ;
  p++;
  34:	00158493          	addi	s1,a1,1

  memmove(buf, p, strlen(p)+1);
  38:	8526                	mv	a0,s1
  3a:	00000097          	auipc	ra,0x0
  3e:	284080e7          	jalr	644(ra) # 2be <strlen>
  42:	00001917          	auipc	s2,0x1
  46:	abe90913          	addi	s2,s2,-1346 # b00 <buf.0>
  4a:	0015061b          	addiw	a2,a0,1
  4e:	85a6                	mv	a1,s1
  50:	854a                	mv	a0,s2
  52:	00000097          	auipc	ra,0x0
  56:	3de080e7          	jalr	990(ra) # 430 <memmove>
  
  //memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  //printf("%s\n",buf);
  return buf;
}
  5a:	854a                	mv	a0,s2
  5c:	60e2                	ld	ra,24(sp)
  5e:	6442                	ld	s0,16(sp)
  60:	64a2                	ld	s1,8(sp)
  62:	6902                	ld	s2,0(sp)
  64:	6105                	addi	sp,sp,32
  66:	8082                	ret

0000000000000068 <find>:

void
find(char *path,char *tar){
  68:	d9010113          	addi	sp,sp,-624
  6c:	26113423          	sd	ra,616(sp)
  70:	26813023          	sd	s0,608(sp)
  74:	24913c23          	sd	s1,600(sp)
  78:	25213823          	sd	s2,592(sp)
  7c:	25313423          	sd	s3,584(sp)
  80:	25413023          	sd	s4,576(sp)
  84:	23513c23          	sd	s5,568(sp)
  88:	1c80                	addi	s0,sp,624
  8a:	892a                	mv	s2,a0
  8c:	89ae                	mv	s3,a1
  char *p;
  int fd;
  struct dirent de;
  struct stat st;
	
  if((fd = open(path, 0)) < 0){
  8e:	4581                	li	a1,0
  90:	00000097          	auipc	ra,0x0
  94:	492080e7          	jalr	1170(ra) # 522 <open>
  98:	06054663          	bltz	a0,104 <find+0x9c>
  9c:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  9e:	d9840593          	addi	a1,s0,-616
  a2:	00000097          	auipc	ra,0x0
  a6:	498080e7          	jalr	1176(ra) # 53a <fstat>
  aa:	06054863          	bltz	a0,11a <find+0xb2>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  ae:	da041783          	lh	a5,-608(s0)
  b2:	0007869b          	sext.w	a3,a5
  b6:	4705                	li	a4,1
  b8:	08e68b63          	beq	a3,a4,14e <find+0xe6>
  bc:	4709                	li	a4,2
  be:	00e69d63          	bne	a3,a4,d8 <find+0x70>
  //judge the name
  case T_FILE:
    if(strcmp(fmt_subname(path),tar)==0)
  c2:	854a                	mv	a0,s2
  c4:	00000097          	auipc	ra,0x0
  c8:	f3c080e7          	jalr	-196(ra) # 0 <fmt_subname>
  cc:	85ce                	mv	a1,s3
  ce:	00000097          	auipc	ra,0x0
  d2:	1c4080e7          	jalr	452(ra) # 292 <strcmp>
  d6:	c135                	beqz	a0,13a <find+0xd2>
      p[strlen(de.name)] = 0;
      find(buf, tar);
    }
    break;
  }
  close(fd);
  d8:	8526                	mv	a0,s1
  da:	00000097          	auipc	ra,0x0
  de:	430080e7          	jalr	1072(ra) # 50a <close>
}
  e2:	26813083          	ld	ra,616(sp)
  e6:	26013403          	ld	s0,608(sp)
  ea:	25813483          	ld	s1,600(sp)
  ee:	25013903          	ld	s2,592(sp)
  f2:	24813983          	ld	s3,584(sp)
  f6:	24013a03          	ld	s4,576(sp)
  fa:	23813a83          	ld	s5,568(sp)
  fe:	27010113          	addi	sp,sp,624
 102:	8082                	ret
    fprintf(2, "find: cannot open %s\n", path);
 104:	864a                	mv	a2,s2
 106:	00001597          	auipc	a1,0x1
 10a:	8fa58593          	addi	a1,a1,-1798 # a00 <malloc+0xec>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	71e080e7          	jalr	1822(ra) # 82e <fprintf>
    return;
 118:	b7e9                	j	e2 <find+0x7a>
    fprintf(2, "find: cannot stat %s\n", path);
 11a:	864a                	mv	a2,s2
 11c:	00001597          	auipc	a1,0x1
 120:	8fc58593          	addi	a1,a1,-1796 # a18 <malloc+0x104>
 124:	4509                	li	a0,2
 126:	00000097          	auipc	ra,0x0
 12a:	708080e7          	jalr	1800(ra) # 82e <fprintf>
    close(fd);
 12e:	8526                	mv	a0,s1
 130:	00000097          	auipc	ra,0x0
 134:	3da080e7          	jalr	986(ra) # 50a <close>
    return;
 138:	b76d                	j	e2 <find+0x7a>
      printf("%s\n",path);
 13a:	85ca                	mv	a1,s2
 13c:	00001517          	auipc	a0,0x1
 140:	8f450513          	addi	a0,a0,-1804 # a30 <malloc+0x11c>
 144:	00000097          	auipc	ra,0x0
 148:	718080e7          	jalr	1816(ra) # 85c <printf>
 14c:	b771                	j	d8 <find+0x70>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 14e:	854a                	mv	a0,s2
 150:	00000097          	auipc	ra,0x0
 154:	16e080e7          	jalr	366(ra) # 2be <strlen>
 158:	2541                	addiw	a0,a0,16
 15a:	20000793          	li	a5,512
 15e:	00a7fb63          	bgeu	a5,a0,174 <find+0x10c>
      printf("ls: path too long\n");
 162:	00001517          	auipc	a0,0x1
 166:	8d650513          	addi	a0,a0,-1834 # a38 <malloc+0x124>
 16a:	00000097          	auipc	ra,0x0
 16e:	6f2080e7          	jalr	1778(ra) # 85c <printf>
      break;
 172:	b79d                	j	d8 <find+0x70>
    strcpy(buf, path);
 174:	85ca                	mv	a1,s2
 176:	dc040513          	addi	a0,s0,-576
 17a:	00000097          	auipc	ra,0x0
 17e:	0fc080e7          	jalr	252(ra) # 276 <strcpy>
    p = buf+strlen(buf);
 182:	dc040513          	addi	a0,s0,-576
 186:	00000097          	auipc	ra,0x0
 18a:	138080e7          	jalr	312(ra) # 2be <strlen>
 18e:	1502                	slli	a0,a0,0x20
 190:	9101                	srli	a0,a0,0x20
 192:	dc040793          	addi	a5,s0,-576
 196:	97aa                	add	a5,a5,a0
    *p++ = '/';
 198:	00178a13          	addi	s4,a5,1
 19c:	02f00713          	li	a4,47
 1a0:	00e78023          	sb	a4,0(a5)
      if(de.inum == 0 || strcmp(de.name, ".")==0 || strcmp(de.name,"..")==0)
 1a4:	00001917          	auipc	s2,0x1
 1a8:	8ac90913          	addi	s2,s2,-1876 # a50 <malloc+0x13c>
 1ac:	00001a97          	auipc	s5,0x1
 1b0:	8aca8a93          	addi	s5,s5,-1876 # a58 <malloc+0x144>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b4:	4641                	li	a2,16
 1b6:	db040593          	addi	a1,s0,-592
 1ba:	8526                	mv	a0,s1
 1bc:	00000097          	auipc	ra,0x0
 1c0:	33e080e7          	jalr	830(ra) # 4fa <read>
 1c4:	47c1                	li	a5,16
 1c6:	f0f519e3          	bne	a0,a5,d8 <find+0x70>
      if(de.inum == 0 || strcmp(de.name, ".")==0 || strcmp(de.name,"..")==0)
 1ca:	db045783          	lhu	a5,-592(s0)
 1ce:	d3fd                	beqz	a5,1b4 <find+0x14c>
 1d0:	85ca                	mv	a1,s2
 1d2:	db240513          	addi	a0,s0,-590
 1d6:	00000097          	auipc	ra,0x0
 1da:	0bc080e7          	jalr	188(ra) # 292 <strcmp>
 1de:	d979                	beqz	a0,1b4 <find+0x14c>
 1e0:	85d6                	mv	a1,s5
 1e2:	db240513          	addi	a0,s0,-590
 1e6:	00000097          	auipc	ra,0x0
 1ea:	0ac080e7          	jalr	172(ra) # 292 <strcmp>
 1ee:	d179                	beqz	a0,1b4 <find+0x14c>
      memmove(p, de.name, strlen(de.name));
 1f0:	db240513          	addi	a0,s0,-590
 1f4:	00000097          	auipc	ra,0x0
 1f8:	0ca080e7          	jalr	202(ra) # 2be <strlen>
 1fc:	0005061b          	sext.w	a2,a0
 200:	db240593          	addi	a1,s0,-590
 204:	8552                	mv	a0,s4
 206:	00000097          	auipc	ra,0x0
 20a:	22a080e7          	jalr	554(ra) # 430 <memmove>
      p[strlen(de.name)] = 0;
 20e:	db240513          	addi	a0,s0,-590
 212:	00000097          	auipc	ra,0x0
 216:	0ac080e7          	jalr	172(ra) # 2be <strlen>
 21a:	02051793          	slli	a5,a0,0x20
 21e:	9381                	srli	a5,a5,0x20
 220:	97d2                	add	a5,a5,s4
 222:	00078023          	sb	zero,0(a5)
      find(buf, tar);
 226:	85ce                	mv	a1,s3
 228:	dc040513          	addi	a0,s0,-576
 22c:	00000097          	auipc	ra,0x0
 230:	e3c080e7          	jalr	-452(ra) # 68 <find>
 234:	b741                	j	1b4 <find+0x14c>

0000000000000236 <main>:

int main(int argc,char *argv[]){
 236:	1141                	addi	sp,sp,-16
 238:	e406                	sd	ra,8(sp)
 23a:	e022                	sd	s0,0(sp)
 23c:	0800                	addi	s0,sp,16
  if(argc!=3){
 23e:	470d                	li	a4,3
 240:	00e50f63          	beq	a0,a4,25e <main+0x28>
    printf("Usage:find [dir] [name]\n");
 244:	00001517          	auipc	a0,0x1
 248:	81c50513          	addi	a0,a0,-2020 # a60 <malloc+0x14c>
 24c:	00000097          	auipc	ra,0x0
 250:	610080e7          	jalr	1552(ra) # 85c <printf>
    exit(0);
 254:	4501                	li	a0,0
 256:	00000097          	auipc	ra,0x0
 25a:	28c080e7          	jalr	652(ra) # 4e2 <exit>
 25e:	87ae                	mv	a5,a1
  }
  
  find(argv[1],argv[2]);
 260:	698c                	ld	a1,16(a1)
 262:	6788                	ld	a0,8(a5)
 264:	00000097          	auipc	ra,0x0
 268:	e04080e7          	jalr	-508(ra) # 68 <find>
  exit(0);
 26c:	4501                	li	a0,0
 26e:	00000097          	auipc	ra,0x0
 272:	274080e7          	jalr	628(ra) # 4e2 <exit>

0000000000000276 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27c:	87aa                	mv	a5,a0
 27e:	0585                	addi	a1,a1,1
 280:	0785                	addi	a5,a5,1
 282:	fff5c703          	lbu	a4,-1(a1)
 286:	fee78fa3          	sb	a4,-1(a5)
 28a:	fb75                	bnez	a4,27e <strcpy+0x8>
    ;
  return os;
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 298:	00054783          	lbu	a5,0(a0)
 29c:	cb91                	beqz	a5,2b0 <strcmp+0x1e>
 29e:	0005c703          	lbu	a4,0(a1)
 2a2:	00f71763          	bne	a4,a5,2b0 <strcmp+0x1e>
    p++, q++;
 2a6:	0505                	addi	a0,a0,1
 2a8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	fbe5                	bnez	a5,29e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b0:	0005c503          	lbu	a0,0(a1)
}
 2b4:	40a7853b          	subw	a0,a5,a0
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <strlen>:

uint
strlen(const char *s)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cf91                	beqz	a5,2e4 <strlen+0x26>
 2ca:	0505                	addi	a0,a0,1
 2cc:	87aa                	mv	a5,a0
 2ce:	4685                	li	a3,1
 2d0:	9e89                	subw	a3,a3,a0
 2d2:	00f6853b          	addw	a0,a3,a5
 2d6:	0785                	addi	a5,a5,1
 2d8:	fff7c703          	lbu	a4,-1(a5)
 2dc:	fb7d                	bnez	a4,2d2 <strlen+0x14>
    ;
  return n;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  for(n = 0; s[n]; n++)
 2e4:	4501                	li	a0,0
 2e6:	bfe5                	j	2de <strlen+0x20>

00000000000002e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ee:	ca19                	beqz	a2,304 <memset+0x1c>
 2f0:	87aa                	mv	a5,a0
 2f2:	1602                	slli	a2,a2,0x20
 2f4:	9201                	srli	a2,a2,0x20
 2f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fe:	0785                	addi	a5,a5,1
 300:	fee79de3          	bne	a5,a4,2fa <memset+0x12>
  }
  return dst;
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <strchr>:

char*
strchr(const char *s, char c)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 310:	00054783          	lbu	a5,0(a0)
 314:	cb99                	beqz	a5,32a <strchr+0x20>
    if(*s == c)
 316:	00f58763          	beq	a1,a5,324 <strchr+0x1a>
  for(; *s; s++)
 31a:	0505                	addi	a0,a0,1
 31c:	00054783          	lbu	a5,0(a0)
 320:	fbfd                	bnez	a5,316 <strchr+0xc>
      return (char*)s;
  return 0;
 322:	4501                	li	a0,0
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
  return 0;
 32a:	4501                	li	a0,0
 32c:	bfe5                	j	324 <strchr+0x1a>

000000000000032e <gets>:

char*
gets(char *buf, int max)
{
 32e:	711d                	addi	sp,sp,-96
 330:	ec86                	sd	ra,88(sp)
 332:	e8a2                	sd	s0,80(sp)
 334:	e4a6                	sd	s1,72(sp)
 336:	e0ca                	sd	s2,64(sp)
 338:	fc4e                	sd	s3,56(sp)
 33a:	f852                	sd	s4,48(sp)
 33c:	f456                	sd	s5,40(sp)
 33e:	f05a                	sd	s6,32(sp)
 340:	ec5e                	sd	s7,24(sp)
 342:	1080                	addi	s0,sp,96
 344:	8baa                	mv	s7,a0
 346:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 348:	892a                	mv	s2,a0
 34a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 34c:	4aa9                	li	s5,10
 34e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 350:	89a6                	mv	s3,s1
 352:	2485                	addiw	s1,s1,1
 354:	0344d863          	bge	s1,s4,384 <gets+0x56>
    cc = read(0, &c, 1);
 358:	4605                	li	a2,1
 35a:	faf40593          	addi	a1,s0,-81
 35e:	4501                	li	a0,0
 360:	00000097          	auipc	ra,0x0
 364:	19a080e7          	jalr	410(ra) # 4fa <read>
    if(cc < 1)
 368:	00a05e63          	blez	a0,384 <gets+0x56>
    buf[i++] = c;
 36c:	faf44783          	lbu	a5,-81(s0)
 370:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 374:	01578763          	beq	a5,s5,382 <gets+0x54>
 378:	0905                	addi	s2,s2,1
 37a:	fd679be3          	bne	a5,s6,350 <gets+0x22>
  for(i=0; i+1 < max; ){
 37e:	89a6                	mv	s3,s1
 380:	a011                	j	384 <gets+0x56>
 382:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 384:	99de                	add	s3,s3,s7
 386:	00098023          	sb	zero,0(s3)
  return buf;
}
 38a:	855e                	mv	a0,s7
 38c:	60e6                	ld	ra,88(sp)
 38e:	6446                	ld	s0,80(sp)
 390:	64a6                	ld	s1,72(sp)
 392:	6906                	ld	s2,64(sp)
 394:	79e2                	ld	s3,56(sp)
 396:	7a42                	ld	s4,48(sp)
 398:	7aa2                	ld	s5,40(sp)
 39a:	7b02                	ld	s6,32(sp)
 39c:	6be2                	ld	s7,24(sp)
 39e:	6125                	addi	sp,sp,96
 3a0:	8082                	ret

00000000000003a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a2:	1101                	addi	sp,sp,-32
 3a4:	ec06                	sd	ra,24(sp)
 3a6:	e822                	sd	s0,16(sp)
 3a8:	e426                	sd	s1,8(sp)
 3aa:	e04a                	sd	s2,0(sp)
 3ac:	1000                	addi	s0,sp,32
 3ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b0:	4581                	li	a1,0
 3b2:	00000097          	auipc	ra,0x0
 3b6:	170080e7          	jalr	368(ra) # 522 <open>
  if(fd < 0)
 3ba:	02054563          	bltz	a0,3e4 <stat+0x42>
 3be:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c0:	85ca                	mv	a1,s2
 3c2:	00000097          	auipc	ra,0x0
 3c6:	178080e7          	jalr	376(ra) # 53a <fstat>
 3ca:	892a                	mv	s2,a0
  close(fd);
 3cc:	8526                	mv	a0,s1
 3ce:	00000097          	auipc	ra,0x0
 3d2:	13c080e7          	jalr	316(ra) # 50a <close>
  return r;
}
 3d6:	854a                	mv	a0,s2
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	64a2                	ld	s1,8(sp)
 3de:	6902                	ld	s2,0(sp)
 3e0:	6105                	addi	sp,sp,32
 3e2:	8082                	ret
    return -1;
 3e4:	597d                	li	s2,-1
 3e6:	bfc5                	j	3d6 <stat+0x34>

00000000000003e8 <atoi>:

int
atoi(const char *s)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e422                	sd	s0,8(sp)
 3ec:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ee:	00054683          	lbu	a3,0(a0)
 3f2:	fd06879b          	addiw	a5,a3,-48
 3f6:	0ff7f793          	zext.b	a5,a5
 3fa:	4625                	li	a2,9
 3fc:	02f66863          	bltu	a2,a5,42c <atoi+0x44>
 400:	872a                	mv	a4,a0
  n = 0;
 402:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 404:	0705                	addi	a4,a4,1
 406:	0025179b          	slliw	a5,a0,0x2
 40a:	9fa9                	addw	a5,a5,a0
 40c:	0017979b          	slliw	a5,a5,0x1
 410:	9fb5                	addw	a5,a5,a3
 412:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 416:	00074683          	lbu	a3,0(a4)
 41a:	fd06879b          	addiw	a5,a3,-48
 41e:	0ff7f793          	zext.b	a5,a5
 422:	fef671e3          	bgeu	a2,a5,404 <atoi+0x1c>
  return n;
}
 426:	6422                	ld	s0,8(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret
  n = 0;
 42c:	4501                	li	a0,0
 42e:	bfe5                	j	426 <atoi+0x3e>

0000000000000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	1141                	addi	sp,sp,-16
 432:	e422                	sd	s0,8(sp)
 434:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 436:	02b57463          	bgeu	a0,a1,45e <memmove+0x2e>
    while(n-- > 0)
 43a:	00c05f63          	blez	a2,458 <memmove+0x28>
 43e:	1602                	slli	a2,a2,0x20
 440:	9201                	srli	a2,a2,0x20
 442:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 446:	872a                	mv	a4,a0
      *dst++ = *src++;
 448:	0585                	addi	a1,a1,1
 44a:	0705                	addi	a4,a4,1
 44c:	fff5c683          	lbu	a3,-1(a1)
 450:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 454:	fee79ae3          	bne	a5,a4,448 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 458:	6422                	ld	s0,8(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret
    dst += n;
 45e:	00c50733          	add	a4,a0,a2
    src += n;
 462:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 464:	fec05ae3          	blez	a2,458 <memmove+0x28>
 468:	fff6079b          	addiw	a5,a2,-1
 46c:	1782                	slli	a5,a5,0x20
 46e:	9381                	srli	a5,a5,0x20
 470:	fff7c793          	not	a5,a5
 474:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 476:	15fd                	addi	a1,a1,-1
 478:	177d                	addi	a4,a4,-1
 47a:	0005c683          	lbu	a3,0(a1)
 47e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 482:	fee79ae3          	bne	a5,a4,476 <memmove+0x46>
 486:	bfc9                	j	458 <memmove+0x28>

0000000000000488 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 488:	1141                	addi	sp,sp,-16
 48a:	e422                	sd	s0,8(sp)
 48c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 48e:	ca05                	beqz	a2,4be <memcmp+0x36>
 490:	fff6069b          	addiw	a3,a2,-1
 494:	1682                	slli	a3,a3,0x20
 496:	9281                	srli	a3,a3,0x20
 498:	0685                	addi	a3,a3,1
 49a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 49c:	00054783          	lbu	a5,0(a0)
 4a0:	0005c703          	lbu	a4,0(a1)
 4a4:	00e79863          	bne	a5,a4,4b4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4a8:	0505                	addi	a0,a0,1
    p2++;
 4aa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ac:	fed518e3          	bne	a0,a3,49c <memcmp+0x14>
  }
  return 0;
 4b0:	4501                	li	a0,0
 4b2:	a019                	j	4b8 <memcmp+0x30>
      return *p1 - *p2;
 4b4:	40e7853b          	subw	a0,a5,a4
}
 4b8:	6422                	ld	s0,8(sp)
 4ba:	0141                	addi	sp,sp,16
 4bc:	8082                	ret
  return 0;
 4be:	4501                	li	a0,0
 4c0:	bfe5                	j	4b8 <memcmp+0x30>

00000000000004c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c2:	1141                	addi	sp,sp,-16
 4c4:	e406                	sd	ra,8(sp)
 4c6:	e022                	sd	s0,0(sp)
 4c8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ca:	00000097          	auipc	ra,0x0
 4ce:	f66080e7          	jalr	-154(ra) # 430 <memmove>
}
 4d2:	60a2                	ld	ra,8(sp)
 4d4:	6402                	ld	s0,0(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret

00000000000004da <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4da:	4885                	li	a7,1
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e2:	4889                	li	a7,2
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ea:	488d                	li	a7,3
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f2:	4891                	li	a7,4
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <read>:
.global read
read:
 li a7, SYS_read
 4fa:	4895                	li	a7,5
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <write>:
.global write
write:
 li a7, SYS_write
 502:	48c1                	li	a7,16
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <close>:
.global close
close:
 li a7, SYS_close
 50a:	48d5                	li	a7,21
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <kill>:
.global kill
kill:
 li a7, SYS_kill
 512:	4899                	li	a7,6
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <exec>:
.global exec
exec:
 li a7, SYS_exec
 51a:	489d                	li	a7,7
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <open>:
.global open
open:
 li a7, SYS_open
 522:	48bd                	li	a7,15
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 52a:	48c5                	li	a7,17
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 532:	48c9                	li	a7,18
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 53a:	48a1                	li	a7,8
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <link>:
.global link
link:
 li a7, SYS_link
 542:	48cd                	li	a7,19
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 54a:	48d1                	li	a7,20
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 552:	48a5                	li	a7,9
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <dup>:
.global dup
dup:
 li a7, SYS_dup
 55a:	48a9                	li	a7,10
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 562:	48ad                	li	a7,11
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 56a:	48b1                	li	a7,12
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 572:	48b5                	li	a7,13
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 57a:	48b9                	li	a7,14
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 582:	1101                	addi	sp,sp,-32
 584:	ec06                	sd	ra,24(sp)
 586:	e822                	sd	s0,16(sp)
 588:	1000                	addi	s0,sp,32
 58a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 58e:	4605                	li	a2,1
 590:	fef40593          	addi	a1,s0,-17
 594:	00000097          	auipc	ra,0x0
 598:	f6e080e7          	jalr	-146(ra) # 502 <write>
}
 59c:	60e2                	ld	ra,24(sp)
 59e:	6442                	ld	s0,16(sp)
 5a0:	6105                	addi	sp,sp,32
 5a2:	8082                	ret

00000000000005a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a4:	7139                	addi	sp,sp,-64
 5a6:	fc06                	sd	ra,56(sp)
 5a8:	f822                	sd	s0,48(sp)
 5aa:	f426                	sd	s1,40(sp)
 5ac:	f04a                	sd	s2,32(sp)
 5ae:	ec4e                	sd	s3,24(sp)
 5b0:	0080                	addi	s0,sp,64
 5b2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5b4:	c299                	beqz	a3,5ba <printint+0x16>
 5b6:	0805c963          	bltz	a1,648 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ba:	2581                	sext.w	a1,a1
  neg = 0;
 5bc:	4881                	li	a7,0
 5be:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5c2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5c4:	2601                	sext.w	a2,a2
 5c6:	00000517          	auipc	a0,0x0
 5ca:	51a50513          	addi	a0,a0,1306 # ae0 <digits>
 5ce:	883a                	mv	a6,a4
 5d0:	2705                	addiw	a4,a4,1
 5d2:	02c5f7bb          	remuw	a5,a1,a2
 5d6:	1782                	slli	a5,a5,0x20
 5d8:	9381                	srli	a5,a5,0x20
 5da:	97aa                	add	a5,a5,a0
 5dc:	0007c783          	lbu	a5,0(a5)
 5e0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5e4:	0005879b          	sext.w	a5,a1
 5e8:	02c5d5bb          	divuw	a1,a1,a2
 5ec:	0685                	addi	a3,a3,1
 5ee:	fec7f0e3          	bgeu	a5,a2,5ce <printint+0x2a>
  if(neg)
 5f2:	00088c63          	beqz	a7,60a <printint+0x66>
    buf[i++] = '-';
 5f6:	fd070793          	addi	a5,a4,-48
 5fa:	00878733          	add	a4,a5,s0
 5fe:	02d00793          	li	a5,45
 602:	fef70823          	sb	a5,-16(a4)
 606:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 60a:	02e05863          	blez	a4,63a <printint+0x96>
 60e:	fc040793          	addi	a5,s0,-64
 612:	00e78933          	add	s2,a5,a4
 616:	fff78993          	addi	s3,a5,-1
 61a:	99ba                	add	s3,s3,a4
 61c:	377d                	addiw	a4,a4,-1
 61e:	1702                	slli	a4,a4,0x20
 620:	9301                	srli	a4,a4,0x20
 622:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 626:	fff94583          	lbu	a1,-1(s2)
 62a:	8526                	mv	a0,s1
 62c:	00000097          	auipc	ra,0x0
 630:	f56080e7          	jalr	-170(ra) # 582 <putc>
  while(--i >= 0)
 634:	197d                	addi	s2,s2,-1
 636:	ff3918e3          	bne	s2,s3,626 <printint+0x82>
}
 63a:	70e2                	ld	ra,56(sp)
 63c:	7442                	ld	s0,48(sp)
 63e:	74a2                	ld	s1,40(sp)
 640:	7902                	ld	s2,32(sp)
 642:	69e2                	ld	s3,24(sp)
 644:	6121                	addi	sp,sp,64
 646:	8082                	ret
    x = -xx;
 648:	40b005bb          	negw	a1,a1
    neg = 1;
 64c:	4885                	li	a7,1
    x = -xx;
 64e:	bf85                	j	5be <printint+0x1a>

0000000000000650 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 650:	7119                	addi	sp,sp,-128
 652:	fc86                	sd	ra,120(sp)
 654:	f8a2                	sd	s0,112(sp)
 656:	f4a6                	sd	s1,104(sp)
 658:	f0ca                	sd	s2,96(sp)
 65a:	ecce                	sd	s3,88(sp)
 65c:	e8d2                	sd	s4,80(sp)
 65e:	e4d6                	sd	s5,72(sp)
 660:	e0da                	sd	s6,64(sp)
 662:	fc5e                	sd	s7,56(sp)
 664:	f862                	sd	s8,48(sp)
 666:	f466                	sd	s9,40(sp)
 668:	f06a                	sd	s10,32(sp)
 66a:	ec6e                	sd	s11,24(sp)
 66c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 66e:	0005c903          	lbu	s2,0(a1)
 672:	18090f63          	beqz	s2,810 <vprintf+0x1c0>
 676:	8aaa                	mv	s5,a0
 678:	8b32                	mv	s6,a2
 67a:	00158493          	addi	s1,a1,1
  state = 0;
 67e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 680:	02500a13          	li	s4,37
 684:	4c55                	li	s8,21
 686:	00000c97          	auipc	s9,0x0
 68a:	402c8c93          	addi	s9,s9,1026 # a88 <malloc+0x174>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 68e:	02800d93          	li	s11,40
  putc(fd, 'x');
 692:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 694:	00000b97          	auipc	s7,0x0
 698:	44cb8b93          	addi	s7,s7,1100 # ae0 <digits>
 69c:	a839                	j	6ba <vprintf+0x6a>
        putc(fd, c);
 69e:	85ca                	mv	a1,s2
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	ee0080e7          	jalr	-288(ra) # 582 <putc>
 6aa:	a019                	j	6b0 <vprintf+0x60>
    } else if(state == '%'){
 6ac:	01498d63          	beq	s3,s4,6c6 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6b0:	0485                	addi	s1,s1,1
 6b2:	fff4c903          	lbu	s2,-1(s1)
 6b6:	14090d63          	beqz	s2,810 <vprintf+0x1c0>
    if(state == 0){
 6ba:	fe0999e3          	bnez	s3,6ac <vprintf+0x5c>
      if(c == '%'){
 6be:	ff4910e3          	bne	s2,s4,69e <vprintf+0x4e>
        state = '%';
 6c2:	89d2                	mv	s3,s4
 6c4:	b7f5                	j	6b0 <vprintf+0x60>
      if(c == 'd'){
 6c6:	11490c63          	beq	s2,s4,7de <vprintf+0x18e>
 6ca:	f9d9079b          	addiw	a5,s2,-99
 6ce:	0ff7f793          	zext.b	a5,a5
 6d2:	10fc6e63          	bltu	s8,a5,7ee <vprintf+0x19e>
 6d6:	f9d9079b          	addiw	a5,s2,-99
 6da:	0ff7f713          	zext.b	a4,a5
 6de:	10ec6863          	bltu	s8,a4,7ee <vprintf+0x19e>
 6e2:	00271793          	slli	a5,a4,0x2
 6e6:	97e6                	add	a5,a5,s9
 6e8:	439c                	lw	a5,0(a5)
 6ea:	97e6                	add	a5,a5,s9
 6ec:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6ee:	008b0913          	addi	s2,s6,8
 6f2:	4685                	li	a3,1
 6f4:	4629                	li	a2,10
 6f6:	000b2583          	lw	a1,0(s6)
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	ea8080e7          	jalr	-344(ra) # 5a4 <printint>
 704:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 706:	4981                	li	s3,0
 708:	b765                	j	6b0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70a:	008b0913          	addi	s2,s6,8
 70e:	4681                	li	a3,0
 710:	4629                	li	a2,10
 712:	000b2583          	lw	a1,0(s6)
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	e8c080e7          	jalr	-372(ra) # 5a4 <printint>
 720:	8b4a                	mv	s6,s2
      state = 0;
 722:	4981                	li	s3,0
 724:	b771                	j	6b0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 726:	008b0913          	addi	s2,s6,8
 72a:	4681                	li	a3,0
 72c:	866a                	mv	a2,s10
 72e:	000b2583          	lw	a1,0(s6)
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	e70080e7          	jalr	-400(ra) # 5a4 <printint>
 73c:	8b4a                	mv	s6,s2
      state = 0;
 73e:	4981                	li	s3,0
 740:	bf85                	j	6b0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 742:	008b0793          	addi	a5,s6,8
 746:	f8f43423          	sd	a5,-120(s0)
 74a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 74e:	03000593          	li	a1,48
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	e2e080e7          	jalr	-466(ra) # 582 <putc>
  putc(fd, 'x');
 75c:	07800593          	li	a1,120
 760:	8556                	mv	a0,s5
 762:	00000097          	auipc	ra,0x0
 766:	e20080e7          	jalr	-480(ra) # 582 <putc>
 76a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76c:	03c9d793          	srli	a5,s3,0x3c
 770:	97de                	add	a5,a5,s7
 772:	0007c583          	lbu	a1,0(a5)
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	e0a080e7          	jalr	-502(ra) # 582 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 780:	0992                	slli	s3,s3,0x4
 782:	397d                	addiw	s2,s2,-1
 784:	fe0914e3          	bnez	s2,76c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 788:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 78c:	4981                	li	s3,0
 78e:	b70d                	j	6b0 <vprintf+0x60>
        s = va_arg(ap, char*);
 790:	008b0913          	addi	s2,s6,8
 794:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 798:	02098163          	beqz	s3,7ba <vprintf+0x16a>
        while(*s != 0){
 79c:	0009c583          	lbu	a1,0(s3)
 7a0:	c5ad                	beqz	a1,80a <vprintf+0x1ba>
          putc(fd, *s);
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	dde080e7          	jalr	-546(ra) # 582 <putc>
          s++;
 7ac:	0985                	addi	s3,s3,1
        while(*s != 0){
 7ae:	0009c583          	lbu	a1,0(s3)
 7b2:	f9e5                	bnez	a1,7a2 <vprintf+0x152>
        s = va_arg(ap, char*);
 7b4:	8b4a                	mv	s6,s2
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	bde5                	j	6b0 <vprintf+0x60>
          s = "(null)";
 7ba:	00000997          	auipc	s3,0x0
 7be:	2c698993          	addi	s3,s3,710 # a80 <malloc+0x16c>
        while(*s != 0){
 7c2:	85ee                	mv	a1,s11
 7c4:	bff9                	j	7a2 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7c6:	008b0913          	addi	s2,s6,8
 7ca:	000b4583          	lbu	a1,0(s6)
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	db2080e7          	jalr	-590(ra) # 582 <putc>
 7d8:	8b4a                	mv	s6,s2
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	bdd1                	j	6b0 <vprintf+0x60>
        putc(fd, c);
 7de:	85d2                	mv	a1,s4
 7e0:	8556                	mv	a0,s5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	da0080e7          	jalr	-608(ra) # 582 <putc>
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	b5d1                	j	6b0 <vprintf+0x60>
        putc(fd, '%');
 7ee:	85d2                	mv	a1,s4
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	d90080e7          	jalr	-624(ra) # 582 <putc>
        putc(fd, c);
 7fa:	85ca                	mv	a1,s2
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	d84080e7          	jalr	-636(ra) # 582 <putc>
      state = 0;
 806:	4981                	li	s3,0
 808:	b565                	j	6b0 <vprintf+0x60>
        s = va_arg(ap, char*);
 80a:	8b4a                	mv	s6,s2
      state = 0;
 80c:	4981                	li	s3,0
 80e:	b54d                	j	6b0 <vprintf+0x60>
    }
  }
}
 810:	70e6                	ld	ra,120(sp)
 812:	7446                	ld	s0,112(sp)
 814:	74a6                	ld	s1,104(sp)
 816:	7906                	ld	s2,96(sp)
 818:	69e6                	ld	s3,88(sp)
 81a:	6a46                	ld	s4,80(sp)
 81c:	6aa6                	ld	s5,72(sp)
 81e:	6b06                	ld	s6,64(sp)
 820:	7be2                	ld	s7,56(sp)
 822:	7c42                	ld	s8,48(sp)
 824:	7ca2                	ld	s9,40(sp)
 826:	7d02                	ld	s10,32(sp)
 828:	6de2                	ld	s11,24(sp)
 82a:	6109                	addi	sp,sp,128
 82c:	8082                	ret

000000000000082e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 82e:	715d                	addi	sp,sp,-80
 830:	ec06                	sd	ra,24(sp)
 832:	e822                	sd	s0,16(sp)
 834:	1000                	addi	s0,sp,32
 836:	e010                	sd	a2,0(s0)
 838:	e414                	sd	a3,8(s0)
 83a:	e818                	sd	a4,16(s0)
 83c:	ec1c                	sd	a5,24(s0)
 83e:	03043023          	sd	a6,32(s0)
 842:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 846:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 84a:	8622                	mv	a2,s0
 84c:	00000097          	auipc	ra,0x0
 850:	e04080e7          	jalr	-508(ra) # 650 <vprintf>
}
 854:	60e2                	ld	ra,24(sp)
 856:	6442                	ld	s0,16(sp)
 858:	6161                	addi	sp,sp,80
 85a:	8082                	ret

000000000000085c <printf>:

void
printf(const char *fmt, ...)
{
 85c:	711d                	addi	sp,sp,-96
 85e:	ec06                	sd	ra,24(sp)
 860:	e822                	sd	s0,16(sp)
 862:	1000                	addi	s0,sp,32
 864:	e40c                	sd	a1,8(s0)
 866:	e810                	sd	a2,16(s0)
 868:	ec14                	sd	a3,24(s0)
 86a:	f018                	sd	a4,32(s0)
 86c:	f41c                	sd	a5,40(s0)
 86e:	03043823          	sd	a6,48(s0)
 872:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 876:	00840613          	addi	a2,s0,8
 87a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 87e:	85aa                	mv	a1,a0
 880:	4505                	li	a0,1
 882:	00000097          	auipc	ra,0x0
 886:	dce080e7          	jalr	-562(ra) # 650 <vprintf>
}
 88a:	60e2                	ld	ra,24(sp)
 88c:	6442                	ld	s0,16(sp)
 88e:	6125                	addi	sp,sp,96
 890:	8082                	ret

0000000000000892 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 892:	1141                	addi	sp,sp,-16
 894:	e422                	sd	s0,8(sp)
 896:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 898:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	00000797          	auipc	a5,0x0
 8a0:	25c7b783          	ld	a5,604(a5) # af8 <freep>
 8a4:	a02d                	j	8ce <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a6:	4618                	lw	a4,8(a2)
 8a8:	9f2d                	addw	a4,a4,a1
 8aa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	6310                	ld	a2,0(a4)
 8b2:	a83d                	j	8f0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b4:	ff852703          	lw	a4,-8(a0)
 8b8:	9f31                	addw	a4,a4,a2
 8ba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8bc:	ff053683          	ld	a3,-16(a0)
 8c0:	a091                	j	904 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c2:	6398                	ld	a4,0(a5)
 8c4:	00e7e463          	bltu	a5,a4,8cc <free+0x3a>
 8c8:	00e6ea63          	bltu	a3,a4,8dc <free+0x4a>
{
 8cc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	fed7fae3          	bgeu	a5,a3,8c2 <free+0x30>
 8d2:	6398                	ld	a4,0(a5)
 8d4:	00e6e463          	bltu	a3,a4,8dc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	fee7eae3          	bltu	a5,a4,8cc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8dc:	ff852583          	lw	a1,-8(a0)
 8e0:	6390                	ld	a2,0(a5)
 8e2:	02059813          	slli	a6,a1,0x20
 8e6:	01c85713          	srli	a4,a6,0x1c
 8ea:	9736                	add	a4,a4,a3
 8ec:	fae60de3          	beq	a2,a4,8a6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f4:	4790                	lw	a2,8(a5)
 8f6:	02061593          	slli	a1,a2,0x20
 8fa:	01c5d713          	srli	a4,a1,0x1c
 8fe:	973e                	add	a4,a4,a5
 900:	fae68ae3          	beq	a3,a4,8b4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 904:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 906:	00000717          	auipc	a4,0x0
 90a:	1ef73923          	sd	a5,498(a4) # af8 <freep>
}
 90e:	6422                	ld	s0,8(sp)
 910:	0141                	addi	sp,sp,16
 912:	8082                	ret

0000000000000914 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 914:	7139                	addi	sp,sp,-64
 916:	fc06                	sd	ra,56(sp)
 918:	f822                	sd	s0,48(sp)
 91a:	f426                	sd	s1,40(sp)
 91c:	f04a                	sd	s2,32(sp)
 91e:	ec4e                	sd	s3,24(sp)
 920:	e852                	sd	s4,16(sp)
 922:	e456                	sd	s5,8(sp)
 924:	e05a                	sd	s6,0(sp)
 926:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 928:	02051493          	slli	s1,a0,0x20
 92c:	9081                	srli	s1,s1,0x20
 92e:	04bd                	addi	s1,s1,15
 930:	8091                	srli	s1,s1,0x4
 932:	0014899b          	addiw	s3,s1,1
 936:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 938:	00000517          	auipc	a0,0x0
 93c:	1c053503          	ld	a0,448(a0) # af8 <freep>
 940:	c515                	beqz	a0,96c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 942:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 944:	4798                	lw	a4,8(a5)
 946:	02977f63          	bgeu	a4,s1,984 <malloc+0x70>
 94a:	8a4e                	mv	s4,s3
 94c:	0009871b          	sext.w	a4,s3
 950:	6685                	lui	a3,0x1
 952:	00d77363          	bgeu	a4,a3,958 <malloc+0x44>
 956:	6a05                	lui	s4,0x1
 958:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 960:	00000917          	auipc	s2,0x0
 964:	19890913          	addi	s2,s2,408 # af8 <freep>
  if(p == (char*)-1)
 968:	5afd                	li	s5,-1
 96a:	a895                	j	9de <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 96c:	00000797          	auipc	a5,0x0
 970:	1a478793          	addi	a5,a5,420 # b10 <base>
 974:	00000717          	auipc	a4,0x0
 978:	18f73223          	sd	a5,388(a4) # af8 <freep>
 97c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 982:	b7e1                	j	94a <malloc+0x36>
      if(p->s.size == nunits)
 984:	02e48c63          	beq	s1,a4,9bc <malloc+0xa8>
        p->s.size -= nunits;
 988:	4137073b          	subw	a4,a4,s3
 98c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 98e:	02071693          	slli	a3,a4,0x20
 992:	01c6d713          	srli	a4,a3,0x1c
 996:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 998:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 99c:	00000717          	auipc	a4,0x0
 9a0:	14a73e23          	sd	a0,348(a4) # af8 <freep>
      return (void*)(p + 1);
 9a4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9a8:	70e2                	ld	ra,56(sp)
 9aa:	7442                	ld	s0,48(sp)
 9ac:	74a2                	ld	s1,40(sp)
 9ae:	7902                	ld	s2,32(sp)
 9b0:	69e2                	ld	s3,24(sp)
 9b2:	6a42                	ld	s4,16(sp)
 9b4:	6aa2                	ld	s5,8(sp)
 9b6:	6b02                	ld	s6,0(sp)
 9b8:	6121                	addi	sp,sp,64
 9ba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9bc:	6398                	ld	a4,0(a5)
 9be:	e118                	sd	a4,0(a0)
 9c0:	bff1                	j	99c <malloc+0x88>
  hp->s.size = nu;
 9c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c6:	0541                	addi	a0,a0,16
 9c8:	00000097          	auipc	ra,0x0
 9cc:	eca080e7          	jalr	-310(ra) # 892 <free>
  return freep;
 9d0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9d4:	d971                	beqz	a0,9a8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d8:	4798                	lw	a4,8(a5)
 9da:	fa9775e3          	bgeu	a4,s1,984 <malloc+0x70>
    if(p == freep)
 9de:	00093703          	ld	a4,0(s2)
 9e2:	853e                	mv	a0,a5
 9e4:	fef719e3          	bne	a4,a5,9d6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9e8:	8552                	mv	a0,s4
 9ea:	00000097          	auipc	ra,0x0
 9ee:	b80080e7          	jalr	-1152(ra) # 56a <sbrk>
  if(p == (char*)-1)
 9f2:	fd5518e3          	bne	a0,s5,9c2 <malloc+0xae>
        return 0;
 9f6:	4501                	li	a0,0
 9f8:	bf45                	j	9a8 <malloc+0x94>
