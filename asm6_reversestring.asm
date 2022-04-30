SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
STDIN       equ 0
STDOUT      equ 1

section .data
    msg1    db  "Enter string: ", 0xA, 0xD
    len1    equ $ - msg1

    msg2    db  "Reverse string: ", 0xA, 0xD
    len2    equ $ - msg2

section .bss
    string      resb 256
    res         resb 256

section .text
    global _start

_start:
    call read_string
    call reverse_string
    call print_string
    
exit:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80

read_string:
    ; Message
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80
    ; Enter string
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, string
    mov edx, 256
    int 0x80
    ; Return
    ret

reverse_string:
    xor esi, esi
    xor eax, eax
    xor ecx, ecx
    mov ebx, res
    next_char:
        mov al, [string + esi]
        cmp al, 0x0
        je reverse
        cmp al, 0xA
        je reverse
        push eax
        inc esi
        inc ecx
        jmp next_char
    
    reverse:
        pop eax
        mov [ebx], eax
        inc ebx
        loop reverse
    
    reverse_done:
        ret

print_string:
    ; Message
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80
    ; Enter string
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, res
    mov edx, 256
    int 0x80
    ; Return
    ret