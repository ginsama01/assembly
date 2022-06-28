; nasm -f elf64 -g -F dwarf -o asm3_uppercase_x64.o asm3_uppercase_x64.asm
; ld -o asm3_uppercase_x64 asm3_uppercase_x64.o
%include 'io_x64.asm'
SYS_EXIT 	equ 0x3c

section .data
    msg1    db  "Enter string: ", 0xA,0x0

    msg2    db  "Uppercase string is: ", 0xA,0x0

section .bss
    inp_str resq 4

section .text
    global _start

_start:
    
    ; Enter input string
    mov rdi, msg1
    call printStr

    mov rdi, inp_str
    mov rsi, 32
    call readStr

    ; Uppercase string
    mov rdi, inp_str    ; move address of inp_str to ecx register
    call upper_string

    ; print uppercase string
    mov rdi, msg2
    call printStr

    mov rdi, inp_str
    call printStr

exit:
	mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall

; upper string
; input:
;   %rdi: char* - string to upper
; output:
; none
upper_string:
    upper_init:
        push rbp
        mov rbp, rsp
    
    upper_main:
        mov al, [rdi]   ; rdi is the pointer, so [rdi] is the current char
        cmp al, 0x0     ; check if al is null, it means end of string
        je upper_done         
        cmp al, 'a'     ; check if current char >= 'a' character, if no, go next character
        jb upper_next_char
        cmp al, 'z'     ; check if current char <= 'a' character, if no, go next character
        ja upper_next_char
        sub al, 0x20    ; move AL upper case, the distance between 
                        ; uppercase and lowercase letters is 20h in ASCII
        mov [rdi], al   ; write current character back to string, then go to nextChar

    upper_next_char:
        inc rdi         ; rdi is pointer to inp_str, so inc rdi means point to next char
        jmp upper_main

    upper_done:
        mov rsp, rbp
        pop rbp
        ret             ; return to position that upperString was called

