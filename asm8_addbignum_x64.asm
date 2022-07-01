; nasm -f elf64 -g -F dwarf -o asm8_addbignum_x64.o asm8_addbignum_x64.asm
; ld -o asm8_addbignum_x64 asm8_addbignum_x64.o
%include 'io_x64.asm'
SYS_EXIT 	equ 0x3c

section .data
    msg1    db  "Enter first number: ", 0xA, 0x0
    msg2    db  "Enter second number: ", 0xA, 0x0
    msg3    db  "Sum of two numbers: ", 0xA, 0x0

section .bss
    num1    resb 100
    num2    resb 100
    sum     resb 100

section .text
    global _start

_start:
    ; read first number
    mov rdi, msg1
    call printStr

    mov rdi, num1
    mov rsi, 100
    call readStr
    ; read second number
    mov rdi, msg2
    call printStr
    
    mov rdi, num2
    call readStr

    ; cal sum
    mov rdi, num1 
    mov rsi, num2
    mov rdx, sum
    call calculate_sum

    mov rdi, sum
    call printStr

exit:
    mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall 



; Calculate sum of two string number
; Input:
;   %rdi: char* - first number
;   %rsi: char* - second number
;   %rdx: char* - will store sum
; Output:
;   none
calculate_sum:
    push rbp
    mov rbp, rsp
    ; parameter
    %define num1 rbp + 16
    %define num2 rbp + 116
    
    ; num1 = rdi
    mov r9, rsi
    lea rsi, [num1]
    call move

    ; num2 = r9
    mov rdi, r9
    lea rsi, [num2]
    call move

    ; calculate length of two string number
    lea rdi, [num1]
    call strlen
    mov rsi, rax    ; store length of first number to rsi

    lea rdi, [num2]
    call strlen
    mov rdi, rax    ; store length of second number to rdi

    xor rax, rax
    xor rcx, rcx
    xor r9, r9      ; r9 for carry

    add_loop:
        ; if length of first number = 0
        cmp rsi, 0
        je add_case1
        ; if length of second number = 0
        cmp rdi, 0
        je add_case2

        ; get digit
        dec rsi
        dec rdi
        mov al, [num1 + rsi]
        sub al, 0x30
        mov bl, [num2 + rdi]
        sub bl, 0x30
        add al, bl
        add rax, r9  ; add carry
        cmp al, 10
        jae add_loop_carry
        xor r9, r9  ; set carry = 0
        jmp add_loop_continue

    add_loop_carry:
        mov r9, 1   ; set carry = 1
        sub al, 10

    add_loop_continue:
        add al, 0x30
        push rax
        inc rcx
        jmp add_loop

    add_case1:
        cmp rdi, 0
        je check_carry
        dec rdi
        mov al, [num2 + rdi]
        sub al, 0x30
        add rax, r9  ; add carry
        cmp al, 10
        jae add_case1_carry
        xor r9, r9  ; set carry = 0
        jmp add_case1_continue

    add_case1_carry:
        mov r9, 1   ; set carry = 1
        sub al, 10

    add_case1_continue:
        add al, 0x30
        push rax
        inc rcx
        jmp add_case1

    add_case2:
        cmp rsi, 0
        je check_carry
        dec rsi
        mov al, [num1 + rsi]
        sub al, 0x30
        add rax, r9  ; add carry
        cmp al, 10
        jae add_case2_carry
        xor r9, r9  ; set carry = 0
        jmp add_case2_continue

    add_case2_carry:
        mov r9, 1   ; set carry = 1
        sub al, 10

    add_case2_continue:
        add al, 0x30
        push rax
        inc rcx
        jmp add_case2

    check_carry:
        cmp r9, 1   ; if carry = 1
        jb create_sum

    add_carry:
        mov al, 31h
        push rax
        inc rcx

    create_sum:
        pop rax
        mov [rdx], al
        inc rdx
        loop create_sum

    mov rsp, rbp
    pop rbp
    ret    

; Move from offset to offset
; Input:
;   %rdi: first offset
;   %rsi: second offset = first offset
; Output: none
move:
    push rbp
    mov rbp, rsp
    
    loop_move:
        xor rax, rax
        mov al, [rdi]
        cmp al, 0x0
        je done_move
        cmp al, 0xA
        je done_move
        mov [rsi], al
        inc rdi
        inc rsi
        jmp loop_move

    done_move:
        mov byte [rsi], 0x0
        mov rsp, rbp
        pop rbp
        ret