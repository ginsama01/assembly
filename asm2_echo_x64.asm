; nasm -f elf64 -g -F dwarf -o asm2_echo_x64.o asm2_echo_x64.asm
; ld -o asm2_echo_x64 asm2_echo_x64.o

%include 'io_x64.asm'

SYS_EXIT 	equ 0x3c


section .data
    msg1    db  "Enter string: ", 0xA,0x0
    msg2    db  "String entered is: ", 0xA,0x0

section .bss
    res     resb 32

section .text
	global _start

_start:

    ; enter string
    mov rdi, msg1
    call printStr

    mov rdi, res
    mov rsi, 32
    call readStr

    ;Print string
    mov rdi, msg2
    call printStr

    mov rdi, res
    call printStr

exit:
	mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall