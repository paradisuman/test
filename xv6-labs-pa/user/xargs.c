#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]){
  char block[32];
  char *tem_in[32];
  char buf[32];
  char *p = buf;
  int tem_end=0, str_len = 0, block_len, in_inter;
  
  for(int i = 1; i < argc; i++){
    tem_in[tem_end++] = argv[i];
  }
  in_inter = tem_end;
  
  while( (block_len = read(0, block, sizeof(block))) > 0){
    //in_inter = tem_end;
    //str_len = 0;
    //p=buf;
    for(int i=0; i < block_len; i++){
      if(block[i] == '\n'){
        buf[str_len++] = '\0';
        tem_in[in_inter++]=p;
        
        tem_in[in_inter] = 0;
        in_inter = tem_end;
        str_len = 0;
        p=buf;
  	
        if(fork() == 0){
          if(exec(argv[1], tem_in) < 0){
            printf("xargs exec error!");
            exit(1);
          } 
          exit(0);
        }
        wait(0);
      }
      else if(block[i] == ' '){
        buf[str_len++] = '\0';
        tem_in[in_inter++]=p;
        p=&buf[str_len];
      }
      else {
        buf[str_len++] = block[i];
      }
    }
  }
  
  exit(0);
}
