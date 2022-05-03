SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
STDIN       equ 0
STDOUT      equ 1

section .data
    msg1    db  "Enter n ", 0xA, 0xD
    len1    equ $ - msg1

    first_fibo  db "1 "
    len_first   equ $ - first_fibo

    space   db " "

section .bss
    n           resb 4
    num1        resb 100
    num2        resb 100
    sum         resb 100

section .text
    global _start

_start:
    call read_n 
    call print_fibo1
    call print_fibo2
    call cal_fibo

    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80

read_n:
    ; Message
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80
    ; Enter string
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, n
    mov edx, 4
    int 0x80

    mov ebx, n
    call string_to_decimal
    mov [n], eax
    ; Return
    ret

; Convert string to decimal number
; Input: ebx register
; Output: eax register
string_to_decimal:
    xor eax, eax    ; eax = 0
    xor ecx, ecx    ; ecx = 0
    xor edx, edx    ; edx = 0

    std_continue:
        mov cl, [ebx]   ; Get digit character
        cmp cl, 0x0     ; Check if null character
        je std_done
        cmp cl, 0xA     ; Check if enter character
        je std_done

        sub cl, 0x30    ; Convert character to digit in decimal


        ; eax = eax * 10 + ecx
        push ecx    ; push ecx value to stack
        mov ecx, 10 
        mul ecx
        pop ecx     ; get value from stack
        add eax, ecx

        inc ebx
        jmp std_continue

    std_done:
        ret 

print_fibo1:
    mov eax, [n]
    cmp eax, 1
    jb done_print_fibo1

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, first_fibo
    mov edx, len_first
    int 0x80

    done_print_fibo1:
        ret

print_fibo2:
    mov eax, [n]
    cmp eax, 2
    jb done_print_fibo2

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, first_fibo
    mov edx, len_first
    int 0x80

    done_print_fibo2:
        ret

cal_fibo:
    mov edx, [n]
    cmp edx, 3
    jb cal_done
    dec edx
    dec edx
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

find_num1_digit:
    mov al, [num1 + esi]
    cmp al, 0x0
    je find_done
    cmp al, 0xA
    je find_done
    inc esi
    jmp find_num1_digit

find_num2_digit:
    mov al, [num2 + edi]
    cmp al, 0x0
    je find_done
    cmp al, 0xA
    je find_done
    inc edi
    jmp find_num2_digit

find_done:
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