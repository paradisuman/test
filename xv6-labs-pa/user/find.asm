
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmt_subname>:
#include "kernel/fs.h"

//a little changes,but names are still bad!
char*
fmt_subname(const char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  const char *restrict p;

  // Find first character after last slash.
  for(p = path+strlen(path); p >= path && *p != '/'; p--)
   e:	00000097          	auipc	ra,0x0
  12:	2c2080e7          	jalr	706(ra) # 2d0 <strlen>
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
  3e:	296080e7          	jalr	662(ra) # 2d0 <strlen>
  42:	00001917          	auipc	s2,0x1
  46:	ad690913          	addi	s2,s2,-1322 # b18 <buf.0>
  4a:	0015061b          	addiw	a2,a0,1
  4e:	85a6                	mv	a1,s1
  50:	854a                	mv	a0,s2
  52:	00000097          	auipc	ra,0x0
  56:	3f0080e7          	jalr	1008(ra) # 442 <memmove>
  
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
find(const char *restrict path,const char *restrict tar){
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
  94:	4a4080e7          	jalr	1188(ra) # 534 <open>
  98:	04054c63          	bltz	a0,f0 <find+0x88>
  9c:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    exit(1);
  }

  if(fstat(fd, &st) < 0){
  9e:	d9840593          	addi	a1,s0,-616
  a2:	00000097          	auipc	ra,0x0
  a6:	4aa080e7          	jalr	1194(ra) # 54c <fstat>
  aa:	06054263          	bltz	a0,10e <find+0xa6>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    exit(1);
  }

  if(st.type == T_FILE){
  ae:	da041783          	lh	a5,-608(s0)
  b2:	0007869b          	sext.w	a3,a5
  b6:	4709                	li	a4,2
  b8:	06e68f63          	beq	a3,a4,136 <find+0xce>
    //judge the name
    if(strcmp(fmt_subname(path),tar)==0)
      printf("%s\n",path);
  }
  //recursion to sub_dir
  else if(st.type == T_DIR){
  bc:	2781                	sext.w	a5,a5
  be:	4705                	li	a4,1
  c0:	0ae78063          	beq	a5,a4,160 <find+0xf8>
      memmove(p, de.name, strlen(de.name));
      p[strlen(de.name)] = '\0';
      find(buf, tar);
    }
  }
  close(fd);
  c4:	8526                	mv	a0,s1
  c6:	00000097          	auipc	ra,0x0
  ca:	456080e7          	jalr	1110(ra) # 51c <close>
}
  ce:	26813083          	ld	ra,616(sp)
  d2:	26013403          	ld	s0,608(sp)
  d6:	25813483          	ld	s1,600(sp)
  da:	25013903          	ld	s2,592(sp)
  de:	24813983          	ld	s3,584(sp)
  e2:	24013a03          	ld	s4,576(sp)
  e6:	23813a83          	ld	s5,568(sp)
  ea:	27010113          	addi	sp,sp,624
  ee:	8082                	ret
    fprintf(2, "find: cannot open %s\n", path);
  f0:	864a                	mv	a2,s2
  f2:	00001597          	auipc	a1,0x1
  f6:	92658593          	addi	a1,a1,-1754 # a18 <malloc+0xea>
  fa:	4509                	li	a0,2
  fc:	00000097          	auipc	ra,0x0
 100:	74c080e7          	jalr	1868(ra) # 848 <fprintf>
    exit(1);
 104:	4505                	li	a0,1
 106:	00000097          	auipc	ra,0x0
 10a:	3ee080e7          	jalr	1006(ra) # 4f4 <exit>
    fprintf(2, "find: cannot stat %s\n", path);
 10e:	864a                	mv	a2,s2
 110:	00001597          	auipc	a1,0x1
 114:	92058593          	addi	a1,a1,-1760 # a30 <malloc+0x102>
 118:	4509                	li	a0,2
 11a:	00000097          	auipc	ra,0x0
 11e:	72e080e7          	jalr	1838(ra) # 848 <fprintf>
    close(fd);
 122:	8526                	mv	a0,s1
 124:	00000097          	auipc	ra,0x0
 128:	3f8080e7          	jalr	1016(ra) # 51c <close>
    exit(1);
 12c:	4505                	li	a0,1
 12e:	00000097          	auipc	ra,0x0
 132:	3c6080e7          	jalr	966(ra) # 4f4 <exit>
    if(strcmp(fmt_subname(path),tar)==0)
 136:	854a                	mv	a0,s2
 138:	00000097          	auipc	ra,0x0
 13c:	ec8080e7          	jalr	-312(ra) # 0 <fmt_subname>
 140:	85ce                	mv	a1,s3
 142:	00000097          	auipc	ra,0x0
 146:	162080e7          	jalr	354(ra) # 2a4 <strcmp>
 14a:	fd2d                	bnez	a0,c4 <find+0x5c>
      printf("%s\n",path);
 14c:	85ca                	mv	a1,s2
 14e:	00001517          	auipc	a0,0x1
 152:	8fa50513          	addi	a0,a0,-1798 # a48 <malloc+0x11a>
 156:	00000097          	auipc	ra,0x0
 15a:	720080e7          	jalr	1824(ra) # 876 <printf>
 15e:	b79d                	j	c4 <find+0x5c>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 160:	854a                	mv	a0,s2
 162:	00000097          	auipc	ra,0x0
 166:	16e080e7          	jalr	366(ra) # 2d0 <strlen>
 16a:	2541                	addiw	a0,a0,16
 16c:	20000793          	li	a5,512
 170:	0ca7e363          	bltu	a5,a0,236 <find+0x1ce>
    strcpy(buf, path);
 174:	85ca                	mv	a1,s2
 176:	dc040513          	addi	a0,s0,-576
 17a:	00000097          	auipc	ra,0x0
 17e:	10e080e7          	jalr	270(ra) # 288 <strcpy>
    p = buf+strlen(buf);
 182:	dc040513          	addi	a0,s0,-576
 186:	00000097          	auipc	ra,0x0
 18a:	14a080e7          	jalr	330(ra) # 2d0 <strlen>
 18e:	1502                	slli	a0,a0,0x20
 190:	9101                	srli	a0,a0,0x20
 192:	dc040793          	addi	a5,s0,-576
 196:	97aa                	add	a5,a5,a0
    *p++ = '/';
 198:	00178a13          	addi	s4,a5,1
 19c:	02f00713          	li	a4,47
 1a0:	00e78023          	sb	a4,0(a5)
      if(de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 1a4:	00001917          	auipc	s2,0x1
 1a8:	8c490913          	addi	s2,s2,-1852 # a68 <malloc+0x13a>
 1ac:	00001a97          	auipc	s5,0x1
 1b0:	8c4a8a93          	addi	s5,s5,-1852 # a70 <malloc+0x142>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b4:	4641                	li	a2,16
 1b6:	db040593          	addi	a1,s0,-592
 1ba:	8526                	mv	a0,s1
 1bc:	00000097          	auipc	ra,0x0
 1c0:	350080e7          	jalr	848(ra) # 50c <read>
 1c4:	47c1                	li	a5,16
 1c6:	eef51fe3          	bne	a0,a5,c4 <find+0x5c>
      if(de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 1ca:	db045783          	lhu	a5,-592(s0)
 1ce:	d3fd                	beqz	a5,1b4 <find+0x14c>
 1d0:	85ca                	mv	a1,s2
 1d2:	db240513          	addi	a0,s0,-590
 1d6:	00000097          	auipc	ra,0x0
 1da:	0ce080e7          	jalr	206(ra) # 2a4 <strcmp>
 1de:	d979                	beqz	a0,1b4 <find+0x14c>
 1e0:	85d6                	mv	a1,s5
 1e2:	db240513          	addi	a0,s0,-590
 1e6:	00000097          	auipc	ra,0x0
 1ea:	0be080e7          	jalr	190(ra) # 2a4 <strcmp>
 1ee:	d179                	beqz	a0,1b4 <find+0x14c>
      memmove(p, de.name, strlen(de.name));
 1f0:	db240513          	addi	a0,s0,-590
 1f4:	00000097          	auipc	ra,0x0
 1f8:	0dc080e7          	jalr	220(ra) # 2d0 <strlen>
 1fc:	0005061b          	sext.w	a2,a0
 200:	db240593          	addi	a1,s0,-590
 204:	8552                	mv	a0,s4
 206:	00000097          	auipc	ra,0x0
 20a:	23c080e7          	jalr	572(ra) # 442 <memmove>
      p[strlen(de.name)] = '\0';
 20e:	db240513          	addi	a0,s0,-590
 212:	00000097          	auipc	ra,0x0
 216:	0be080e7          	jalr	190(ra) # 2d0 <strlen>
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
      printf("ls: path too long\n");
 236:	00001517          	auipc	a0,0x1
 23a:	81a50513          	addi	a0,a0,-2022 # a50 <malloc+0x122>
 23e:	00000097          	auipc	ra,0x0
 242:	638080e7          	jalr	1592(ra) # 876 <printf>
      return;
 246:	b561                	j	ce <find+0x66>

0000000000000248 <main>:

int main(int argc,char *argv[]){
 248:	1141                	addi	sp,sp,-16
 24a:	e406                	sd	ra,8(sp)
 24c:	e022                	sd	s0,0(sp)
 24e:	0800                	addi	s0,sp,16
  if(argc != 3){
 250:	470d                	li	a4,3
 252:	00e50f63          	beq	a0,a4,270 <main+0x28>
    printf("Usage:find [dir] [name]\n");
 256:	00001517          	auipc	a0,0x1
 25a:	82250513          	addi	a0,a0,-2014 # a78 <malloc+0x14a>
 25e:	00000097          	auipc	ra,0x0
 262:	618080e7          	jalr	1560(ra) # 876 <printf>
    exit(1);
 266:	4505                	li	a0,1
 268:	00000097          	auipc	ra,0x0
 26c:	28c080e7          	jalr	652(ra) # 4f4 <exit>
 270:	87ae                	mv	a5,a1
  }
  
  find(argv[1], argv[2]);
 272:	698c                	ld	a1,16(a1)
 274:	6788                	ld	a0,8(a5)
 276:	00000097          	auipc	ra,0x0
 27a:	df2080e7          	jalr	-526(ra) # 68 <find>
  exit(0);
 27e:	4501                	li	a0,0
 280:	00000097          	auipc	ra,0x0
 284:	274080e7          	jalr	628(ra) # 4f4 <exit>

0000000000000288 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 28e:	87aa                	mv	a5,a0
 290:	0585                	addi	a1,a1,1
 292:	0785                	addi	a5,a5,1
 294:	fff5c703          	lbu	a4,-1(a1)
 298:	fee78fa3          	sb	a4,-1(a5)
 29c:	fb75                	bnez	a4,290 <strcpy+0x8>
    ;
  return os;
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	cb91                	beqz	a5,2c2 <strcmp+0x1e>
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00f71763          	bne	a4,a5,2c2 <strcmp+0x1e>
    p++, q++;
 2b8:	0505                	addi	a0,a0,1
 2ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	fbe5                	bnez	a5,2b0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2c2:	0005c503          	lbu	a0,0(a1)
}
 2c6:	40a7853b          	subw	a0,a5,a0
 2ca:	6422                	ld	s0,8(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <strlen>:

uint
strlen(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	cf91                	beqz	a5,2f6 <strlen+0x26>
 2dc:	0505                	addi	a0,a0,1
 2de:	87aa                	mv	a5,a0
 2e0:	4685                	li	a3,1
 2e2:	9e89                	subw	a3,a3,a0
 2e4:	00f6853b          	addw	a0,a3,a5
 2e8:	0785                	addi	a5,a5,1
 2ea:	fff7c703          	lbu	a4,-1(a5)
 2ee:	fb7d                	bnez	a4,2e4 <strlen+0x14>
    ;
  return n;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  for(n = 0; s[n]; n++)
 2f6:	4501                	li	a0,0
 2f8:	bfe5                	j	2f0 <strlen+0x20>

00000000000002fa <memset>:

void*
memset(void *dst, int c, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 300:	ca19                	beqz	a2,316 <memset+0x1c>
 302:	87aa                	mv	a5,a0
 304:	1602                	slli	a2,a2,0x20
 306:	9201                	srli	a2,a2,0x20
 308:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 30c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 310:	0785                	addi	a5,a5,1
 312:	fee79de3          	bne	a5,a4,30c <memset+0x12>
  }
  return dst;
}
 316:	6422                	ld	s0,8(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <strchr>:

char*
strchr(const char *s, char c)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  for(; *s; s++)
 322:	00054783          	lbu	a5,0(a0)
 326:	cb99                	beqz	a5,33c <strchr+0x20>
    if(*s == c)
 328:	00f58763          	beq	a1,a5,336 <strchr+0x1a>
  for(; *s; s++)
 32c:	0505                	addi	a0,a0,1
 32e:	00054783          	lbu	a5,0(a0)
 332:	fbfd                	bnez	a5,328 <strchr+0xc>
      return (char*)s;
  return 0;
 334:	4501                	li	a0,0
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
  return 0;
 33c:	4501                	li	a0,0
 33e:	bfe5                	j	336 <strchr+0x1a>

0000000000000340 <gets>:

char*
gets(char *buf, int max)
{
 340:	711d                	addi	sp,sp,-96
 342:	ec86                	sd	ra,88(sp)
 344:	e8a2                	sd	s0,80(sp)
 346:	e4a6                	sd	s1,72(sp)
 348:	e0ca                	sd	s2,64(sp)
 34a:	fc4e                	sd	s3,56(sp)
 34c:	f852                	sd	s4,48(sp)
 34e:	f456                	sd	s5,40(sp)
 350:	f05a                	sd	s6,32(sp)
 352:	ec5e                	sd	s7,24(sp)
 354:	1080                	addi	s0,sp,96
 356:	8baa                	mv	s7,a0
 358:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 35a:	892a                	mv	s2,a0
 35c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 35e:	4aa9                	li	s5,10
 360:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 362:	89a6                	mv	s3,s1
 364:	2485                	addiw	s1,s1,1
 366:	0344d863          	bge	s1,s4,396 <gets+0x56>
    cc = read(0, &c, 1);
 36a:	4605                	li	a2,1
 36c:	faf40593          	addi	a1,s0,-81
 370:	4501                	li	a0,0
 372:	00000097          	auipc	ra,0x0
 376:	19a080e7          	jalr	410(ra) # 50c <read>
    if(cc < 1)
 37a:	00a05e63          	blez	a0,396 <gets+0x56>
    buf[i++] = c;
 37e:	faf44783          	lbu	a5,-81(s0)
 382:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 386:	01578763          	beq	a5,s5,394 <gets+0x54>
 38a:	0905                	addi	s2,s2,1
 38c:	fd679be3          	bne	a5,s6,362 <gets+0x22>
  for(i=0; i+1 < max; ){
 390:	89a6                	mv	s3,s1
 392:	a011                	j	396 <gets+0x56>
 394:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 396:	99de                	add	s3,s3,s7
 398:	00098023          	sb	zero,0(s3)
  return buf;
}
 39c:	855e                	mv	a0,s7
 39e:	60e6                	ld	ra,88(sp)
 3a0:	6446                	ld	s0,80(sp)
 3a2:	64a6                	ld	s1,72(sp)
 3a4:	6906                	ld	s2,64(sp)
 3a6:	79e2                	ld	s3,56(sp)
 3a8:	7a42                	ld	s4,48(sp)
 3aa:	7aa2                	ld	s5,40(sp)
 3ac:	7b02                	ld	s6,32(sp)
 3ae:	6be2                	ld	s7,24(sp)
 3b0:	6125                	addi	sp,sp,96
 3b2:	8082                	ret

00000000000003b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b4:	1101                	addi	sp,sp,-32
 3b6:	ec06                	sd	ra,24(sp)
 3b8:	e822                	sd	s0,16(sp)
 3ba:	e426                	sd	s1,8(sp)
 3bc:	e04a                	sd	s2,0(sp)
 3be:	1000                	addi	s0,sp,32
 3c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c2:	4581                	li	a1,0
 3c4:	00000097          	auipc	ra,0x0
 3c8:	170080e7          	jalr	368(ra) # 534 <open>
  if(fd < 0)
 3cc:	02054563          	bltz	a0,3f6 <stat+0x42>
 3d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3d2:	85ca                	mv	a1,s2
 3d4:	00000097          	auipc	ra,0x0
 3d8:	178080e7          	jalr	376(ra) # 54c <fstat>
 3dc:	892a                	mv	s2,a0
  close(fd);
 3de:	8526                	mv	a0,s1
 3e0:	00000097          	auipc	ra,0x0
 3e4:	13c080e7          	jalr	316(ra) # 51c <close>
  return r;
}
 3e8:	854a                	mv	a0,s2
 3ea:	60e2                	ld	ra,24(sp)
 3ec:	6442                	ld	s0,16(sp)
 3ee:	64a2                	ld	s1,8(sp)
 3f0:	6902                	ld	s2,0(sp)
 3f2:	6105                	addi	sp,sp,32
 3f4:	8082                	ret
    return -1;
 3f6:	597d                	li	s2,-1
 3f8:	bfc5                	j	3e8 <stat+0x34>

00000000000003fa <atoi>:

int
atoi(const char *s)
{
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e422                	sd	s0,8(sp)
 3fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 400:	00054683          	lbu	a3,0(a0)
 404:	fd06879b          	addiw	a5,a3,-48
 408:	0ff7f793          	zext.b	a5,a5
 40c:	4625                	li	a2,9
 40e:	02f66863          	bltu	a2,a5,43e <atoi+0x44>
 412:	872a                	mv	a4,a0
  n = 0;
 414:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 416:	0705                	addi	a4,a4,1
 418:	0025179b          	slliw	a5,a0,0x2
 41c:	9fa9                	addw	a5,a5,a0
 41e:	0017979b          	slliw	a5,a5,0x1
 422:	9fb5                	addw	a5,a5,a3
 424:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 428:	00074683          	lbu	a3,0(a4)
 42c:	fd06879b          	addiw	a5,a3,-48
 430:	0ff7f793          	zext.b	a5,a5
 434:	fef671e3          	bgeu	a2,a5,416 <atoi+0x1c>
  return n;
}
 438:	6422                	ld	s0,8(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret
  n = 0;
 43e:	4501                	li	a0,0
 440:	bfe5                	j	438 <atoi+0x3e>

0000000000000442 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 442:	1141                	addi	sp,sp,-16
 444:	e422                	sd	s0,8(sp)
 446:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 448:	02b57463          	bgeu	a0,a1,470 <memmove+0x2e>
    while(n-- > 0)
 44c:	00c05f63          	blez	a2,46a <memmove+0x28>
 450:	1602                	slli	a2,a2,0x20
 452:	9201                	srli	a2,a2,0x20
 454:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 458:	872a                	mv	a4,a0
      *dst++ = *src++;
 45a:	0585                	addi	a1,a1,1
 45c:	0705                	addi	a4,a4,1
 45e:	fff5c683          	lbu	a3,-1(a1)
 462:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 466:	fee79ae3          	bne	a5,a4,45a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 46a:	6422                	ld	s0,8(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret
    dst += n;
 470:	00c50733          	add	a4,a0,a2
    src += n;
 474:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 476:	fec05ae3          	blez	a2,46a <memmove+0x28>
 47a:	fff6079b          	addiw	a5,a2,-1
 47e:	1782                	slli	a5,a5,0x20
 480:	9381                	srli	a5,a5,0x20
 482:	fff7c793          	not	a5,a5
 486:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 488:	15fd                	addi	a1,a1,-1
 48a:	177d                	addi	a4,a4,-1
 48c:	0005c683          	lbu	a3,0(a1)
 490:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 494:	fee79ae3          	bne	a5,a4,488 <memmove+0x46>
 498:	bfc9                	j	46a <memmove+0x28>

000000000000049a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 49a:	1141                	addi	sp,sp,-16
 49c:	e422                	sd	s0,8(sp)
 49e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4a0:	ca05                	beqz	a2,4d0 <memcmp+0x36>
 4a2:	fff6069b          	addiw	a3,a2,-1
 4a6:	1682                	slli	a3,a3,0x20
 4a8:	9281                	srli	a3,a3,0x20
 4aa:	0685                	addi	a3,a3,1
 4ac:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ae:	00054783          	lbu	a5,0(a0)
 4b2:	0005c703          	lbu	a4,0(a1)
 4b6:	00e79863          	bne	a5,a4,4c6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4ba:	0505                	addi	a0,a0,1
    p2++;
 4bc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4be:	fed518e3          	bne	a0,a3,4ae <memcmp+0x14>
  }
  return 0;
 4c2:	4501                	li	a0,0
 4c4:	a019                	j	4ca <memcmp+0x30>
      return *p1 - *p2;
 4c6:	40e7853b          	subw	a0,a5,a4
}
 4ca:	6422                	ld	s0,8(sp)
 4cc:	0141                	addi	sp,sp,16
 4ce:	8082                	ret
  return 0;
 4d0:	4501                	li	a0,0
 4d2:	bfe5                	j	4ca <memcmp+0x30>

00000000000004d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4d4:	1141                	addi	sp,sp,-16
 4d6:	e406                	sd	ra,8(sp)
 4d8:	e022                	sd	s0,0(sp)
 4da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4dc:	00000097          	auipc	ra,0x0
 4e0:	f66080e7          	jalr	-154(ra) # 442 <memmove>
}
 4e4:	60a2                	ld	ra,8(sp)
 4e6:	6402                	ld	s0,0(sp)
 4e8:	0141                	addi	sp,sp,16
 4ea:	8082                	ret

00000000000004ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ec:	4885                	li	a7,1
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4f4:	4889                	li	a7,2
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 4fc:	488d                	li	a7,3
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 504:	4891                	li	a7,4
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <read>:
.global read
read:
 li a7, SYS_read
 50c:	4895                	li	a7,5
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <write>:
.global write
write:
 li a7, SYS_write
 514:	48c1                	li	a7,16
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <close>:
.global close
close:
 li a7, SYS_close
 51c:	48d5                	li	a7,21
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <kill>:
.global kill
kill:
 li a7, SYS_kill
 524:	4899                	li	a7,6
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <exec>:
.global exec
exec:
 li a7, SYS_exec
 52c:	489d                	li	a7,7
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <open>:
.global open
open:
 li a7, SYS_open
 534:	48bd                	li	a7,15
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 53c:	48c5                	li	a7,17
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 544:	48c9                	li	a7,18
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 54c:	48a1                	li	a7,8
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <link>:
.global link
link:
 li a7, SYS_link
 554:	48cd                	li	a7,19
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 55c:	48d1                	li	a7,20
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 564:	48a5                	li	a7,9
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <dup>:
.global dup
dup:
 li a7, SYS_dup
 56c:	48a9                	li	a7,10
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 574:	48ad                	li	a7,11
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 57c:	48b1                	li	a7,12
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 584:	48b5                	li	a7,13
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 58c:	48b9                	li	a7,14
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <trace>:
.global trace
trace:
 li a7, SYS_trace
 594:	48d9                	li	a7,22
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 59c:	1101                	addi	sp,sp,-32
 59e:	ec06                	sd	ra,24(sp)
 5a0:	e822                	sd	s0,16(sp)
 5a2:	1000                	addi	s0,sp,32
 5a4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5a8:	4605                	li	a2,1
 5aa:	fef40593          	addi	a1,s0,-17
 5ae:	00000097          	auipc	ra,0x0
 5b2:	f66080e7          	jalr	-154(ra) # 514 <write>
}
 5b6:	60e2                	ld	ra,24(sp)
 5b8:	6442                	ld	s0,16(sp)
 5ba:	6105                	addi	sp,sp,32
 5bc:	8082                	ret

00000000000005be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5be:	7139                	addi	sp,sp,-64
 5c0:	fc06                	sd	ra,56(sp)
 5c2:	f822                	sd	s0,48(sp)
 5c4:	f426                	sd	s1,40(sp)
 5c6:	f04a                	sd	s2,32(sp)
 5c8:	ec4e                	sd	s3,24(sp)
 5ca:	0080                	addi	s0,sp,64
 5cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ce:	c299                	beqz	a3,5d4 <printint+0x16>
 5d0:	0805c963          	bltz	a1,662 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5d4:	2581                	sext.w	a1,a1
  neg = 0;
 5d6:	4881                	li	a7,0
 5d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5de:	2601                	sext.w	a2,a2
 5e0:	00000517          	auipc	a0,0x0
 5e4:	51850513          	addi	a0,a0,1304 # af8 <digits>
 5e8:	883a                	mv	a6,a4
 5ea:	2705                	addiw	a4,a4,1
 5ec:	02c5f7bb          	remuw	a5,a1,a2
 5f0:	1782                	slli	a5,a5,0x20
 5f2:	9381                	srli	a5,a5,0x20
 5f4:	97aa                	add	a5,a5,a0
 5f6:	0007c783          	lbu	a5,0(a5)
 5fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5fe:	0005879b          	sext.w	a5,a1
 602:	02c5d5bb          	divuw	a1,a1,a2
 606:	0685                	addi	a3,a3,1
 608:	fec7f0e3          	bgeu	a5,a2,5e8 <printint+0x2a>
  if(neg)
 60c:	00088c63          	beqz	a7,624 <printint+0x66>
    buf[i++] = '-';
 610:	fd070793          	addi	a5,a4,-48
 614:	00878733          	add	a4,a5,s0
 618:	02d00793          	li	a5,45
 61c:	fef70823          	sb	a5,-16(a4)
 620:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 624:	02e05863          	blez	a4,654 <printint+0x96>
 628:	fc040793          	addi	a5,s0,-64
 62c:	00e78933          	add	s2,a5,a4
 630:	fff78993          	addi	s3,a5,-1
 634:	99ba                	add	s3,s3,a4
 636:	377d                	addiw	a4,a4,-1
 638:	1702                	slli	a4,a4,0x20
 63a:	9301                	srli	a4,a4,0x20
 63c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 640:	fff94583          	lbu	a1,-1(s2)
 644:	8526                	mv	a0,s1
 646:	00000097          	auipc	ra,0x0
 64a:	f56080e7          	jalr	-170(ra) # 59c <putc>
  while(--i >= 0)
 64e:	197d                	addi	s2,s2,-1
 650:	ff3918e3          	bne	s2,s3,640 <printint+0x82>
}
 654:	70e2                	ld	ra,56(sp)
 656:	7442                	ld	s0,48(sp)
 658:	74a2                	ld	s1,40(sp)
 65a:	7902                	ld	s2,32(sp)
 65c:	69e2                	ld	s3,24(sp)
 65e:	6121                	addi	sp,sp,64
 660:	8082                	ret
    x = -xx;
 662:	40b005bb          	negw	a1,a1
    neg = 1;
 666:	4885                	li	a7,1
    x = -xx;
 668:	bf85                	j	5d8 <printint+0x1a>

000000000000066a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66a:	7119                	addi	sp,sp,-128
 66c:	fc86                	sd	ra,120(sp)
 66e:	f8a2                	sd	s0,112(sp)
 670:	f4a6                	sd	s1,104(sp)
 672:	f0ca                	sd	s2,96(sp)
 674:	ecce                	sd	s3,88(sp)
 676:	e8d2                	sd	s4,80(sp)
 678:	e4d6                	sd	s5,72(sp)
 67a:	e0da                	sd	s6,64(sp)
 67c:	fc5e                	sd	s7,56(sp)
 67e:	f862                	sd	s8,48(sp)
 680:	f466                	sd	s9,40(sp)
 682:	f06a                	sd	s10,32(sp)
 684:	ec6e                	sd	s11,24(sp)
 686:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 688:	0005c903          	lbu	s2,0(a1)
 68c:	18090f63          	beqz	s2,82a <vprintf+0x1c0>
 690:	8aaa                	mv	s5,a0
 692:	8b32                	mv	s6,a2
 694:	00158493          	addi	s1,a1,1
  state = 0;
 698:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 69a:	02500a13          	li	s4,37
 69e:	4c55                	li	s8,21
 6a0:	00000c97          	auipc	s9,0x0
 6a4:	400c8c93          	addi	s9,s9,1024 # aa0 <malloc+0x172>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6a8:	02800d93          	li	s11,40
  putc(fd, 'x');
 6ac:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ae:	00000b97          	auipc	s7,0x0
 6b2:	44ab8b93          	addi	s7,s7,1098 # af8 <digits>
 6b6:	a839                	j	6d4 <vprintf+0x6a>
        putc(fd, c);
 6b8:	85ca                	mv	a1,s2
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	ee0080e7          	jalr	-288(ra) # 59c <putc>
 6c4:	a019                	j	6ca <vprintf+0x60>
    } else if(state == '%'){
 6c6:	01498d63          	beq	s3,s4,6e0 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6ca:	0485                	addi	s1,s1,1
 6cc:	fff4c903          	lbu	s2,-1(s1)
 6d0:	14090d63          	beqz	s2,82a <vprintf+0x1c0>
    if(state == 0){
 6d4:	fe0999e3          	bnez	s3,6c6 <vprintf+0x5c>
      if(c == '%'){
 6d8:	ff4910e3          	bne	s2,s4,6b8 <vprintf+0x4e>
        state = '%';
 6dc:	89d2                	mv	s3,s4
 6de:	b7f5                	j	6ca <vprintf+0x60>
      if(c == 'd'){
 6e0:	11490c63          	beq	s2,s4,7f8 <vprintf+0x18e>
 6e4:	f9d9079b          	addiw	a5,s2,-99
 6e8:	0ff7f793          	zext.b	a5,a5
 6ec:	10fc6e63          	bltu	s8,a5,808 <vprintf+0x19e>
 6f0:	f9d9079b          	addiw	a5,s2,-99
 6f4:	0ff7f713          	zext.b	a4,a5
 6f8:	10ec6863          	bltu	s8,a4,808 <vprintf+0x19e>
 6fc:	00271793          	slli	a5,a4,0x2
 700:	97e6                	add	a5,a5,s9
 702:	439c                	lw	a5,0(a5)
 704:	97e6                	add	a5,a5,s9
 706:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 708:	008b0913          	addi	s2,s6,8
 70c:	4685                	li	a3,1
 70e:	4629                	li	a2,10
 710:	000b2583          	lw	a1,0(s6)
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	ea8080e7          	jalr	-344(ra) # 5be <printint>
 71e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 720:	4981                	li	s3,0
 722:	b765                	j	6ca <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 724:	008b0913          	addi	s2,s6,8
 728:	4681                	li	a3,0
 72a:	4629                	li	a2,10
 72c:	000b2583          	lw	a1,0(s6)
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	e8c080e7          	jalr	-372(ra) # 5be <printint>
 73a:	8b4a                	mv	s6,s2
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b771                	j	6ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 740:	008b0913          	addi	s2,s6,8
 744:	4681                	li	a3,0
 746:	866a                	mv	a2,s10
 748:	000b2583          	lw	a1,0(s6)
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	e70080e7          	jalr	-400(ra) # 5be <printint>
 756:	8b4a                	mv	s6,s2
      state = 0;
 758:	4981                	li	s3,0
 75a:	bf85                	j	6ca <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 75c:	008b0793          	addi	a5,s6,8
 760:	f8f43423          	sd	a5,-120(s0)
 764:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 768:	03000593          	li	a1,48
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	e2e080e7          	jalr	-466(ra) # 59c <putc>
  putc(fd, 'x');
 776:	07800593          	li	a1,120
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	e20080e7          	jalr	-480(ra) # 59c <putc>
 784:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 786:	03c9d793          	srli	a5,s3,0x3c
 78a:	97de                	add	a5,a5,s7
 78c:	0007c583          	lbu	a1,0(a5)
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	e0a080e7          	jalr	-502(ra) # 59c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 79a:	0992                	slli	s3,s3,0x4
 79c:	397d                	addiw	s2,s2,-1
 79e:	fe0914e3          	bnez	s2,786 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7a2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	b70d                	j	6ca <vprintf+0x60>
        s = va_arg(ap, char*);
 7aa:	008b0913          	addi	s2,s6,8
 7ae:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7b2:	02098163          	beqz	s3,7d4 <vprintf+0x16a>
        while(*s != 0){
 7b6:	0009c583          	lbu	a1,0(s3)
 7ba:	c5ad                	beqz	a1,824 <vprintf+0x1ba>
          putc(fd, *s);
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	dde080e7          	jalr	-546(ra) # 59c <putc>
          s++;
 7c6:	0985                	addi	s3,s3,1
        while(*s != 0){
 7c8:	0009c583          	lbu	a1,0(s3)
 7cc:	f9e5                	bnez	a1,7bc <vprintf+0x152>
        s = va_arg(ap, char*);
 7ce:	8b4a                	mv	s6,s2
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	bde5                	j	6ca <vprintf+0x60>
          s = "(null)";
 7d4:	00000997          	auipc	s3,0x0
 7d8:	2c498993          	addi	s3,s3,708 # a98 <malloc+0x16a>
        while(*s != 0){
 7dc:	85ee                	mv	a1,s11
 7de:	bff9                	j	7bc <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7e0:	008b0913          	addi	s2,s6,8
 7e4:	000b4583          	lbu	a1,0(s6)
 7e8:	8556                	mv	a0,s5
 7ea:	00000097          	auipc	ra,0x0
 7ee:	db2080e7          	jalr	-590(ra) # 59c <putc>
 7f2:	8b4a                	mv	s6,s2
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	bdd1                	j	6ca <vprintf+0x60>
        putc(fd, c);
 7f8:	85d2                	mv	a1,s4
 7fa:	8556                	mv	a0,s5
 7fc:	00000097          	auipc	ra,0x0
 800:	da0080e7          	jalr	-608(ra) # 59c <putc>
      state = 0;
 804:	4981                	li	s3,0
 806:	b5d1                	j	6ca <vprintf+0x60>
        putc(fd, '%');
 808:	85d2                	mv	a1,s4
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	d90080e7          	jalr	-624(ra) # 59c <putc>
        putc(fd, c);
 814:	85ca                	mv	a1,s2
 816:	8556                	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	d84080e7          	jalr	-636(ra) # 59c <putc>
      state = 0;
 820:	4981                	li	s3,0
 822:	b565                	j	6ca <vprintf+0x60>
        s = va_arg(ap, char*);
 824:	8b4a                	mv	s6,s2
      state = 0;
 826:	4981                	li	s3,0
 828:	b54d                	j	6ca <vprintf+0x60>
    }
  }
}
 82a:	70e6                	ld	ra,120(sp)
 82c:	7446                	ld	s0,112(sp)
 82e:	74a6                	ld	s1,104(sp)
 830:	7906                	ld	s2,96(sp)
 832:	69e6                	ld	s3,88(sp)
 834:	6a46                	ld	s4,80(sp)
 836:	6aa6                	ld	s5,72(sp)
 838:	6b06                	ld	s6,64(sp)
 83a:	7be2                	ld	s7,56(sp)
 83c:	7c42                	ld	s8,48(sp)
 83e:	7ca2                	ld	s9,40(sp)
 840:	7d02                	ld	s10,32(sp)
 842:	6de2                	ld	s11,24(sp)
 844:	6109                	addi	sp,sp,128
 846:	8082                	ret

0000000000000848 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 848:	715d                	addi	sp,sp,-80
 84a:	ec06                	sd	ra,24(sp)
 84c:	e822                	sd	s0,16(sp)
 84e:	1000                	addi	s0,sp,32
 850:	e010                	sd	a2,0(s0)
 852:	e414                	sd	a3,8(s0)
 854:	e818                	sd	a4,16(s0)
 856:	ec1c                	sd	a5,24(s0)
 858:	03043023          	sd	a6,32(s0)
 85c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 860:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 864:	8622                	mv	a2,s0
 866:	00000097          	auipc	ra,0x0
 86a:	e04080e7          	jalr	-508(ra) # 66a <vprintf>
}
 86e:	60e2                	ld	ra,24(sp)
 870:	6442                	ld	s0,16(sp)
 872:	6161                	addi	sp,sp,80
 874:	8082                	ret

0000000000000876 <printf>:

void
printf(const char *fmt, ...)
{
 876:	711d                	addi	sp,sp,-96
 878:	ec06                	sd	ra,24(sp)
 87a:	e822                	sd	s0,16(sp)
 87c:	1000                	addi	s0,sp,32
 87e:	e40c                	sd	a1,8(s0)
 880:	e810                	sd	a2,16(s0)
 882:	ec14                	sd	a3,24(s0)
 884:	f018                	sd	a4,32(s0)
 886:	f41c                	sd	a5,40(s0)
 888:	03043823          	sd	a6,48(s0)
 88c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 890:	00840613          	addi	a2,s0,8
 894:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 898:	85aa                	mv	a1,a0
 89a:	4505                	li	a0,1
 89c:	00000097          	auipc	ra,0x0
 8a0:	dce080e7          	jalr	-562(ra) # 66a <vprintf>
}
 8a4:	60e2                	ld	ra,24(sp)
 8a6:	6442                	ld	s0,16(sp)
 8a8:	6125                	addi	sp,sp,96
 8aa:	8082                	ret

00000000000008ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ac:	1141                	addi	sp,sp,-16
 8ae:	e422                	sd	s0,8(sp)
 8b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b6:	00000797          	auipc	a5,0x0
 8ba:	25a7b783          	ld	a5,602(a5) # b10 <freep>
 8be:	a02d                	j	8e8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c0:	4618                	lw	a4,8(a2)
 8c2:	9f2d                	addw	a4,a4,a1
 8c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c8:	6398                	ld	a4,0(a5)
 8ca:	6310                	ld	a2,0(a4)
 8cc:	a83d                	j	90a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ce:	ff852703          	lw	a4,-8(a0)
 8d2:	9f31                	addw	a4,a4,a2
 8d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8d6:	ff053683          	ld	a3,-16(a0)
 8da:	a091                	j	91e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8dc:	6398                	ld	a4,0(a5)
 8de:	00e7e463          	bltu	a5,a4,8e6 <free+0x3a>
 8e2:	00e6ea63          	bltu	a3,a4,8f6 <free+0x4a>
{
 8e6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e8:	fed7fae3          	bgeu	a5,a3,8dc <free+0x30>
 8ec:	6398                	ld	a4,0(a5)
 8ee:	00e6e463          	bltu	a3,a4,8f6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f2:	fee7eae3          	bltu	a5,a4,8e6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8f6:	ff852583          	lw	a1,-8(a0)
 8fa:	6390                	ld	a2,0(a5)
 8fc:	02059813          	slli	a6,a1,0x20
 900:	01c85713          	srli	a4,a6,0x1c
 904:	9736                	add	a4,a4,a3
 906:	fae60de3          	beq	a2,a4,8c0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 90a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 90e:	4790                	lw	a2,8(a5)
 910:	02061593          	slli	a1,a2,0x20
 914:	01c5d713          	srli	a4,a1,0x1c
 918:	973e                	add	a4,a4,a5
 91a:	fae68ae3          	beq	a3,a4,8ce <free+0x22>
    p->s.ptr = bp->s.ptr;
 91e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 920:	00000717          	auipc	a4,0x0
 924:	1ef73823          	sd	a5,496(a4) # b10 <freep>
}
 928:	6422                	ld	s0,8(sp)
 92a:	0141                	addi	sp,sp,16
 92c:	8082                	ret

000000000000092e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 92e:	7139                	addi	sp,sp,-64
 930:	fc06                	sd	ra,56(sp)
 932:	f822                	sd	s0,48(sp)
 934:	f426                	sd	s1,40(sp)
 936:	f04a                	sd	s2,32(sp)
 938:	ec4e                	sd	s3,24(sp)
 93a:	e852                	sd	s4,16(sp)
 93c:	e456                	sd	s5,8(sp)
 93e:	e05a                	sd	s6,0(sp)
 940:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 942:	02051493          	slli	s1,a0,0x20
 946:	9081                	srli	s1,s1,0x20
 948:	04bd                	addi	s1,s1,15
 94a:	8091                	srli	s1,s1,0x4
 94c:	0014899b          	addiw	s3,s1,1
 950:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 952:	00000517          	auipc	a0,0x0
 956:	1be53503          	ld	a0,446(a0) # b10 <freep>
 95a:	c515                	beqz	a0,986 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95e:	4798                	lw	a4,8(a5)
 960:	02977f63          	bgeu	a4,s1,99e <malloc+0x70>
 964:	8a4e                	mv	s4,s3
 966:	0009871b          	sext.w	a4,s3
 96a:	6685                	lui	a3,0x1
 96c:	00d77363          	bgeu	a4,a3,972 <malloc+0x44>
 970:	6a05                	lui	s4,0x1
 972:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 976:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 97a:	00000917          	auipc	s2,0x0
 97e:	19690913          	addi	s2,s2,406 # b10 <freep>
  if(p == (char*)-1)
 982:	5afd                	li	s5,-1
 984:	a895                	j	9f8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 986:	00000797          	auipc	a5,0x0
 98a:	1a278793          	addi	a5,a5,418 # b28 <base>
 98e:	00000717          	auipc	a4,0x0
 992:	18f73123          	sd	a5,386(a4) # b10 <freep>
 996:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 998:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 99c:	b7e1                	j	964 <malloc+0x36>
      if(p->s.size == nunits)
 99e:	02e48c63          	beq	s1,a4,9d6 <malloc+0xa8>
        p->s.size -= nunits;
 9a2:	4137073b          	subw	a4,a4,s3
 9a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a8:	02071693          	slli	a3,a4,0x20
 9ac:	01c6d713          	srli	a4,a3,0x1c
 9b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b6:	00000717          	auipc	a4,0x0
 9ba:	14a73d23          	sd	a0,346(a4) # b10 <freep>
      return (void*)(p + 1);
 9be:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9c2:	70e2                	ld	ra,56(sp)
 9c4:	7442                	ld	s0,48(sp)
 9c6:	74a2                	ld	s1,40(sp)
 9c8:	7902                	ld	s2,32(sp)
 9ca:	69e2                	ld	s3,24(sp)
 9cc:	6a42                	ld	s4,16(sp)
 9ce:	6aa2                	ld	s5,8(sp)
 9d0:	6b02                	ld	s6,0(sp)
 9d2:	6121                	addi	sp,sp,64
 9d4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9d6:	6398                	ld	a4,0(a5)
 9d8:	e118                	sd	a4,0(a0)
 9da:	bff1                	j	9b6 <malloc+0x88>
  hp->s.size = nu;
 9dc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e0:	0541                	addi	a0,a0,16
 9e2:	00000097          	auipc	ra,0x0
 9e6:	eca080e7          	jalr	-310(ra) # 8ac <free>
  return freep;
 9ea:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ee:	d971                	beqz	a0,9c2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f2:	4798                	lw	a4,8(a5)
 9f4:	fa9775e3          	bgeu	a4,s1,99e <malloc+0x70>
    if(p == freep)
 9f8:	00093703          	ld	a4,0(s2)
 9fc:	853e                	mv	a0,a5
 9fe:	fef719e3          	bne	a4,a5,9f0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a02:	8552                	mv	a0,s4
 a04:	00000097          	auipc	ra,0x0
 a08:	b78080e7          	jalr	-1160(ra) # 57c <sbrk>
  if(p == (char*)-1)
 a0c:	fd5518e3          	bne	a0,s5,9dc <malloc+0xae>
        return 0;
 a10:	4501                	li	a0,0
 a12:	bf45                	j	9c2 <malloc+0x94>
