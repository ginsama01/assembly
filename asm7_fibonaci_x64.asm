%include 'io_x64.asm'
SYS_EXIT 	equ 0x3c


section .data
    msg1    db  "Enter n ", 0xA, 0x0
    first_fibo  db "0 ", 0x0
    second_fibo db "1", 0x0
    space   db " ", 0x0

section .bss
    n           resb 8

section .text
    global _start

_start:
    ; read n and convert to decimal
    mov rdi, msg1
    call printStr

    mov rdi, n 
    mov rsi, 8
    call readStr

    mov rdi, n 
    call string_to_decimal
    mov [n], rax

    ; print first fibo
    mov rax, [n]
    cmp rax, 1
    jb exit

    mov rdi, first_fibo
    call printStr
    
    ; print second fibo
    mov rax, [n]
    cmp rax, 2
    jb exit

    mov rdi, second_fibo
    call printStr

    ; calculate fibonacci and print
    mov rdi, [n]
    call cal_fibo

exit:
    mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall 


; Calculate fibonacci and print
; Input: 
;   %rdi: int - n-th fibonacci
; Output: none
cal_fibo:
    push rbp
    mov rbp, rsp
    ; for local variable
    sub rsp, 90
    %define num1    rbp - 30
    %define num2    rbp - 60
    %define sum     rbp - 90

    ; compare if n >= 3
    mov r8, rdi
    cmp r8, 3
    jb cal_done

    ; Have printed first and second fibo
    dec r8
    dec r8

    ; init fibo[n-1]
    mov qword [num2], 31h
    ; fibo[n-2]
    mov qword [num1], 30h
    
    
    cal_loop:
        lea rdi, [num1]
        lea rsi, [num2]
        lea rdx, [sum]
        call calculate_sum
       
        ; print fibonacci
        mov rdi, space
        call printStr

        lea rdi, [sum]
        call printStr
        
        ; num1 = num2
        lea rdi, [num2]
        lea rsi, [num1]
        call move

        ; num2 = sum
        lea rdi, [sum]
        lea rsi, [num2]
        call move
        
        ; check how many fibo need to calculate
        dec r8
        cmp r8, 0
        je cal_done
        jmp cal_loop


    cal_done: 
        add rsp, 90
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
    %define num2 rbp + 46
    
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