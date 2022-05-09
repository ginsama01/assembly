; Compile with nasm32 and ld linker
; Sample input
; 6777 7117 6627 12664 8818
; Max number: 
; 12664
; Min number: 
; 6627
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
    digit   resb 11
    min     resb 11
    max     resb 11
section .text
    global _start

_start:
    mov edx, 0
    mov ebx, 0xFFFF
    call read_array
    call print_max
    call print_min

exit:
    mov	eax, SYS_EXIT
	xor	ebx, ebx 
	int	0x80 

read_array:
    push edx
    push ebx
    xor eax, eax

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
        je check_min
        cmp ecx, " "
        je check_min
        sub cl, 0x30
        push ecx
        mov ecx, 10 
        mul ecx
        pop ecx     
        add eax, ecx
        jmp read_num


    
    check_min:
        pop ebx ; min value
        cmp eax, ebx
        jb update_min

    check_max:
        pop edx
        cmp eax, edx
        ja update_max
        cmp ecx, 0xA
        je done_read
        jmp read_array

    update_min:
        mov ebx, eax
        jmp check_max

    update_max:
        mov edx, eax
        cmp ecx, 0xA
        je done_read
        jmp read_array

    done_read:
        ret

print_max:
    mov eax, edx
    push ebx
    
    mov ebx, max
    call decimal_to_string

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, max
    mov edx, 11
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, newline
    mov edx, lenNL
    int 0x80

    pop ebx
    ret

print_min:

    mov eax, ebx
    mov ebx, min
    call decimal_to_string

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, min
    mov edx, 11
    int 0x80

    ret


; Convert decimal number to string
; Input: eax register
; Output: ebx pointer   
decimal_to_string:
    xor ecx, ecx    ; ecx = 0
    
    dts_continue:
        xor edx, edx    ; edx = 0 for divider
       
        ; Divide 10, remainder is digit, push it to stack to reverse. Using ecx for count number of digits.
        push ecx
        mov ecx, 10
        div ecx
        pop ecx
        push edx
        inc ecx
         cmp eax, 0      ; if eax = 0, end
        je dts_done
        jmp dts_continue
    
    dts_done:
        pop edx     ; get digit
        add edx, 0x30   ; convert to ascii
        mov [ebx], edx  ; move digit value in ascii to ebx pointer
        inc ebx         ; increase pointer to next character
        loop dts_done
    
    ret

