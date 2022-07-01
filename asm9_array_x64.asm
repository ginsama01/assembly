; nasm -f elf64 -g -F dwarf -o asm9_array_x64.o asm9_array_x64.asm
; ld -o asm9_array_x64 asm9_array_x64.o
; Sample input
; 6777 7117 6627 12664 8818
; Max number: 
; 12664
; Min number: 
; 6627
%include 'io_x64.asm'
SYS_EXIT 	equ 0x3c

section .data
    msg1    db  "Max number: ", 0xA, 0x0

    msg2    db  "Min number: ", 0xA, 0x0

    newline db  "", 0xA, 0x0

section .bss
    digit   resb 11
    min     resb 11
    max     resb 11
    
section .text
    global _start

_start:
    ; read array in decimal then find min, max
    call read_array
    
    ; print max
    mov rdi, [max]
    mov rsi, max
    call decimal_to_string

    mov rdi, msg1
    call printStr
    mov rdi, max
    call printStr
    mov rdi, newline
    call printStr

    ; print min
    mov rdi, [min]
    mov rsi, min
    call decimal_to_string
    
    mov rdi, msg2
    call printStr
    mov rdi, min
    call printStr


exit:
    mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall 

; Read array then find min, max
; Input: none
; Output: none
read_array:
    read_init:
        push rbp
        mov rbp, rsp

        mov qword [max], 0
        mov qword [min], 0xffffffffffffffff

    read_start:
        xor rax, rax
        xor rdx, rdx

    read_num:
        ; read array element digit by digit
        push rax
        mov rdi, digit
        mov rsi, 1
        call readStr

        pop rax
        
        xor rcx, rcx
        mov cl, [digit]
        cmp rcx, 0xA    ; if enter character
        je check_min
        cmp rcx, " "    ; if space character
        je check_min
        
        sub cl, 0x30
        push rcx
        mov rcx, 10 
        mul rcx
        pop rcx     
        add rax, rcx
        jmp read_num


    check_min:
        ; if number < min
        cmp rax, qword [min]
        jb update_min

    check_max:
        cmp rax, qword [max]
        ja update_max
        ; check if enter character
        cmp rcx, 0xA
        je done_read
        jmp read_start

    update_min:
        mov qword [min], rax
        jmp check_max

    update_max:
        mov qword [max], rax
        ; check if enter character
        cmp rcx, 0xA
        je done_read
        jmp read_start

    done_read:
        mov rsp, rbp
        pop rbp
        ret





