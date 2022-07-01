; nasm -f elf64 -g -F dwarf -o asm10_sum_x64.o asm10_sum_x64.asm
; ld -o asm10_sum_x64 asm10_sum_x64.o
; Sample input:
; 74 2881 23 471 8824
; Sample output:
; Sum of old numbers: 
; 3375
; Sum of even numbers: 
; 8898

%include 'io_x64.asm'
SYS_EXIT 	equ 0x3c

section .data
    msg1    db  "Sum of old numbers: ", 0xA, 0x0

    msg2    db  "Sum of even numbers: ", 0xA, 0x0

    newline db  "", 0xA, 0x0

section .bss
    digit   resb 1
    sum1    resb 13
    sum2    resb 13

section .text
    global _start

_start:
    call read_array
    
    ; print sum of old numbers
    mov rdi, msg1
    call printStr

    mov rdi, [sum1]
    mov rsi, sum1
    call decimal_to_string
    mov rdi, sum1
    call printStr
    mov rdi, newline
    call printStr

    ; print sum of even numbers
    mov rdi, msg2
    call printStr

    mov rdi, [sum2]
    mov rsi, sum2
    call decimal_to_string
    mov rdi, sum2
    call printStr

exit:
    mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall 


; Read array then calculate sum of old, even
; Input: none
; Output: none
read_array:
    read_init:
        push rbp
        mov rbp, rsp

        mov qword [sum1], 0
        mov qword [sum2], 0

    read_start:
        xor rax, rax
        xor rdx, rdx
        xor r8, r8

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
        je read_check
        cmp rcx, " "    ; if space character
        je read_check
        
        sub cl, 0x30
        push rcx
        mov rcx, 10 
        mul rcx
        pop rcx     
        add rax, rcx

        ; check even or old
        cmp cl, 0
        je even
        cmp cl, 2
        je even
        cmp cl, 4
        je even
        cmp cl, 6
        je even
        cmp cl, 8
        je even
        mov r8, 1 
        jmp read_num

    even:
        mov r8, 0
        jmp read_num

    read_check:
        ; if number is old
        cmp r8, 1
        je add_old

    add_even:
        add qword [sum2], rax
        ; check if enter character
        cmp rcx, 0xA
        je done_read
        jmp read_start

    add_old:
        add qword [sum1], rax
        ; check if enter character
        cmp rcx, 0xA
        je done_read
        jmp read_start

    done_read:
        mov rsp, rbp
        pop rbp
        ret

