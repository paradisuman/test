#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

//a little changes,but names are still bad!
char*
fmt_subname(const char *path)
{
  static char buf[DIRSIZ+1];
  const char *restrict p;

  // Find first character after last slash.
  for(p = path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;
  
  memmove(buf, p, strlen(p)+1);
  
  //memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  //printf("%s\n",buf);
  return buf;
}

void
find(const char *restrict path,const char *restrict tar){
  char buf[512];
  char *p;
  int fd;
  struct dirent de;
  struct stat st;
	
  if((fd = open(path, 0)) < 0){
    fprintf(2, "find: cannot open %s\n", path);
    exit(1);
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    exit(1);
  }

  if(st.type == T_FILE){
    //judge the name
    if(strcmp(fmt_subname(path),tar)==0)
      printf("%s\n",path);
  }
  //recursion to sub_dir
  else if(st.type == T_DIR){
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("ls: path too long\n");
      return;
    }
    
    //refer buf to path
    strcpy(buf, path);
    p = buf+strlen(buf);
    
    //path to: tem/
    *p++ = '/';
    
    //find all sub_dir
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
        continue;
     
      //path to: tem/[de_name]
      memmove(p, de.name, strlen(de.name));
      p[strlen(de.name)] = '\0';
      find(buf, tar);
    }
  }
  close(fd);
}

int main(int argc,char *argv[]){
  if(argc != 3){
    printf("Usage:find [dir] [name]\n");
    exit(1);
  }
  
  find(argv[1], argv[2]);
  exit(0);
}
