#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(){
  int p2c[2],c2p[2];
  pipe(p2c);
  pipe(c2p);
  
  if(fork() == 0){
    close(p2c[1]);
    close(c2p[0]);
    
    char buff[8];
    if(read(p2c[0], buff, 1) == 1){
      printf("%d: received ping\n", getpid());
    }
    write(c2p[1], "1", 1);
    
    exit(0);
  }
  else{
    close(c2p[1]);
    close(p2c[0]);
    
    char buff[8];
    write(p2c[1], "2", 1);
    if(read(c2p[0], buff, 1) == 1){
      printf("%d: received pong\n", getpid());
    }
  }
  
  exit(0);
}

