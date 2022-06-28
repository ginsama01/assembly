SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
STDIN       equ 0
STDOUT      equ 1

section .data
    msg1    db  "Enter n ", 0xA, 0xD
    first_fibo  db "0 ", 0x0
    second_fibo db "1 ", 0x0
    space   db " "

section .bss
    n           resb 8
    num1        resb 100
    num2        resb 100
    sum         resb 100

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
    call cal_fibo

exit:
    mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall 


; Calculate fibonacci and print
cal_fibo:
    mov rdx, [n]
    cmp rdx, 3
    jb cal_done

    ; Have printed first and second fibo
    dec rdx
    dec rdx
    ; fibo[n-1]
    mov eax, 31h
    mov [num1], eax
    ; fibo[n-2]
    mov [num2], eax
    
    
    cal_loop:
        
        xor esi, esi
        xor eax, eax
        call find_num1_digit
        
        xor edi, edi
        xor eax, eax
        call find_num2_digit

        mov ebx, 0
        mov [sum], ebx
        mov ebx, sum
        call calculate_sum
       
        push edx
        ; move num1 to num2
        mov edx, num1
        xor ecx, ecx
        mov [num2], ecx
        mov ecx, num2
        call move

        ; move num2 to sum
        mov edx, sum
        xor ecx, ecx
        mov [num1], ecx
        mov ecx, num1
        call move

        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, space
        mov edx, 1
        int 0x80

        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, sum
        mov edx, 100
        int 0x80
        pop edx
        
        dec edx
        cmp edx, 0
        je cal_done
        jmp cal_loop


    cal_done: 
        ret

; ecx = edx
move:
    loop_move:
        xor eax, eax
        mov al, [edx]
        cmp al, 0x0
        je done_move
        cmp al, 0xA
        je done_move
        mov [ecx], al
        inc ecx
        inc edx
        jmp loop_move

    done_move:
        ret


calculate_sum:
    xor eax, eax
    xor ecx, ecx
    clc

    add_loop:
        pushf
        cmp esi, 0
        je add_case1
        cmp edi, 0
        je add_case2
        popf
        dec esi
        dec edi
        mov al, [num1 + esi]
        adc al, [num2 + edi]
        aaa
        pushf
        or al, 30h
        popf
        push eax
        inc ecx
        jmp add_loop

    add_case1:
        popf
        case1:
            pushf
            cmp edi, 0
            je check_carry
            popf
            dec edi
            mov al, [num2 + edi]
            adc al, 30h
            aaa
            or al, 30h
            push eax
            inc ecx
            jmp case1

    add_case2:
        popf
        case2:
            pushf
            cmp esi, 0
            je check_carry
            popf
            dec esi
            mov al, [num1 + esi]
            adc al, 30h
            aaa
            pushf
            or al, 30h
            popf
            push eax
            inc ecx
            jmp case2

    check_carry:
        popf
        jc add_carry
        jmp create_sum

    add_carry:
        mov al, 31h
        push eax
        inc ecx

    create_sum:
        pop eax
        mov [ebx], al
        inc ebx
        loop create_sum

    ret    