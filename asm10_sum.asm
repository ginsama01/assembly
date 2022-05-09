; Compile with nasm32 and ld linker
; Sample input:
; 74 2881 23 471 8824
; Sample output:
; Sum of old numbers: 
; 3375
; Sum of even numbers: 
; 8898

SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
STDIN       equ 0
STDOUT      equ 1

section .data
    msg1    db  "Sum of old numbers: ", 0xA, 0xD
    len1    equ $ - msg1

    msg2    db  "Sum of even numbers: ", 0xA, 0xD
    len2    equ $ - msg2

    newline db  "", 0xA, 0xD
    lenNL   equ $ - newline

section .bss
    digit   resb 1
    num1    resb 13
    num2    resb 13
    sum     resb 13
    sum1    resb 13
    sum2    resb 13

section .text
    global _start

_start:
    xor eax, eax
    mov [sum1], eax
    mov [sum2], eax
    call read_array
    call print_sum_old
    call print_sum_even

exit:
    mov	eax, SYS_EXIT
	xor	ebx, ebx 
	int	0x80 


read_array:
    xor eax, eax
    mov [num1], eax
    mov [num1 + 4], eax
    mov [num1 + 8], eax
    mov eax, num1

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
        je add_num

        cmp ecx, " "
        je add_num
        
        mov [eax], cl
        inc eax

        jmp read_num

    add_num:
        push ecx
        xor esi, esi
        xor eax, eax
        call find_num1_digit

        mov cl, [num1 + esi - 1]
        cmp cl, '0'
        je add_even
        cmp cl, '2'
        je add_even
        cmp cl, '4'
        je add_even
        cmp cl, '6'
        je add_even
        cmp cl, '8'
        je add_even

    add_old:
        ; move sum1 to num2
        mov edx, sum1
        xor ecx, ecx
        mov [num2], ecx
        mov ecx, num2
        call move
        xor edi, edi
        xor eax, eax
        call find_num2_digit

        xor ebx, ebx
        mov [sum], ebx
        mov [sum + 4], ebx
        mov [sum + 8], ebx
        mov ebx, sum
        call calculate_sum
        ; move sum to sum1
        mov edx, sum
        xor ecx, ecx
        mov [sum1], ecx
        mov ecx, sum1
        call move

        pop ecx
        cmp ecx, 0xA
        je done_read

        jmp read_array

    add_even:
        ; move sum2 to num2
        mov edx, sum2
        xor ecx, ecx
        mov [num2], ecx
        mov ecx, num2
        call move

        xor edi, edi
        xor eax, eax
        call find_num2_digit

        xor ebx, ebx
        mov [sum], ebx
        mov [sum + 4], ebx
        mov [sum + 8], ebx
        mov ebx, sum
        call calculate_sum
        ; move sum to sum2
        mov edx, sum
        xor ecx, ecx
        mov [sum2], ecx
        mov ecx, sum2
        call move

        pop ecx
        cmp ecx, 0xA
        je done_read

        jmp read_array

    done_read:
        ret

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

print_sum_old:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, sum1
    mov edx, 13
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, newline
    mov edx, lenNL
    int 0x80

    ret

print_sum_even:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, sum2
    mov edx, 13
    int 0x80

    ret