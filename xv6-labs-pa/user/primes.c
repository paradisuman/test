#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void _exe(int *in, int n, int *p){
  if(!n)return;
  pipe(p);
  
  //write process
  if(fork() == 0){
    close(p[0]);
    printf("prime %d\n",in[0]);
    
    for(int i=1;i<n;i++){
        p[0]=in[i];
        if(p[0]%in[0] != 0){
            write(p[1], (void*)p, 4);
        }
    }
    
    exit(0);
  }
  
  //read process
  close(p[1]);
  if(fork() == 0){
    n=0;
    while(read(p[0], (void*)(p+1), 4) != 0){
      in[n++]=p[1];
    }
    close(p[0]);
    
    _exe(in,n,p);
    exit(0);
  }
  close(p[0]);

  wait(0);
  wait(0);
}

int main(){
  int nums[34];
  int pipe[2];
  for(int i=2;i<=35;i++){
    nums[i-2]=i;
  }
  _exe(nums, 34, pipe);
  exit(0);
}
