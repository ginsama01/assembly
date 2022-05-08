SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
STDIN       equ 0
STDOUT      equ 1

section .data
    msg1    db  "Max number: ", 0xA, 0xD
    len1    equ $ - msg1

    msg2    db  "Min number: ", 0xA, 0xD
    len2    equ $ - msg2

    newline db  "", 0xA, 0xD
    lenNL   equ $ - newline

section .bss
    digit   resb 1
    num     resb 13
    sum     resb 13

section .text
    global _start

_start:
    call read_array

read_array:
    xor eax, eax
    mov [num], eax
    mov eax, num

    read_num:
        push eax
        mov eax, SYS_READ
        mov ebx, STDIN
        mov ecx, digit
        mov edx, 1
        int 0x80

        pop eax
        xor ecx, ecx
        mov cl, [digit]
        cmp ecx, 0xA
        je add_num_then_end

        cmp ecx, " "
        je add_num
        
        mov al, cl
        inc eax

        jmp read_num

    add_num:
        push ecx
        xor esi, esi
        xor eax, eax
        call find_num1_digit

        xor edi, edi
        xor eax, eax
        call find_num2_digit

        move ebx, sum
        call calculate_sum

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
