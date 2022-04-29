section	.text	     ;Code Segment
   global _start     ;must be declared for linker (ld)

_start:	            ;tells linker entry point
   mov	edx,len     ;move message length to edx register for sys_write
   mov	ecx,msg     ;move message to ecx register for sys_write
   mov	ebx,1       ;move 1 to ebx register, it means write to stdout
   mov	eax,4       ;move 1 to eax register, it is system call number, 4 is  sys_write
   int	0x80        ;call kernel (system call)

   mov	eax,1       ;move 4 to eax register, system call number, 1 is sys_exit
   int	0x80        ;call kernel  (system call)

section	.data       ;Data Segment
msg db 'Hello, World!', 0xa  ;string to be printed
len equ $ - msg     ;length of the string, $ means the current location,
		    ;so subtract the location of the msg, we have len of msg
