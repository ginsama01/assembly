SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
STDIN       equ 0
STDOUT      equ 1

section .data
    msg1    db  "Enter first number: ", 0xA, 0xD
    len1    equ $ - msg1

    msg2    db  "Enter second number: ", 0xA, 0xD
    len2    equ $ - msg2

    msg3    db  "Sum of two numbers: ", 0xA, 0xD
    len3    equ $ - msg3

section .bss
    num1        resb 21
    num2        resb 21
    sum         resb 21

section .text
    global _start

_start:
    call read_num1
    call read_num2
    xor esi, esi
    xor eax, eax
    call find_num1_digit
    
    xor edi, edi
    xor eax, eax
    call find_num2_digit
    mov ebx, sum
    call calculate_sum

    call print

    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80


read_num1:
    ; Message
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80
    ; Enter string
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num1
    mov edx, 21
    int 0x80
    ; Return
    ret

read_num2:
    ; Message
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80
    ; Enter string
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num2
    mov edx, 21
    int 0x80
    ; Return
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

print:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, len3
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, sum
    mov edx, 21
    int 0x80

    ret