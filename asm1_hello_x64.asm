; nasm -f elf64 -g -F dwarf -o asm1_hello.o asm1_hello.asm
; ld -o asm1_hello asm1_hello.asm

section	.text	     ;Code Segment
   global _start     ;must be declared for linker (ld)

_start:	             ;tells linker entry point
   mov	rdx, len     ;move message length to rdx register for sys_write
   mov	rsi, msg     ;move message to rcx register for sys_write
   mov	rdi, 1       ;move 1 to rdi register, it means write to stdout
   mov	rax, 1       ;move 1 to rax register, it is system call number, 1 is  sys_write
   syscall            ;call kernel (system call)

   mov	eax, 0x3c    ;move 0x3c to rax register, system call number, 0x3c is sys_exit
   xor   rdi, rdi     ;it means rdi = 0, error code = 0, no error
   syscall            ;call kernel  (system call)

section	.data       ;Data Segment
msg db 'Hello, World!', 0xa  ;string to be printed
len equ $ - msg     ;length of the string, $ means the current location,
		    ;so subtract the location of the msg, we have len of msg
