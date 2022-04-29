SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
STDIN       equ 0
STDOUT      equ 1

section .data
    msg1    db  "Enter string: ", 0xA,0xD
    len1    equ $- msg1

    msg2    db  "Uppercase string is: ", 0xA,0xD
    len2    equ $- msg2

section .bss
    inp_str resq 4

section .text
    global _start

_start:
    ; Enter input string
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, inp_str
    mov edx, 32
    int 0x80

    ; Uppercase string
    mov ecx, inp_str    ; move address of inp_str to ecx register
    call upper_string

    ; print uppercase string
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, inp_str    ; move to point to first character of inp_str again
    mov edx, 32
    int 0x80

exit:
    mov		eax, SYS_EXIT
	xor		ebx, ebx 
	int		0x80  

upper_string:
    mov al, [ecx]   ; ecx is the pointer, so [ecx] is the current char
    cmp al, 0x0     ; check if al is null, it means end of string
    je done         
    cmp al, 'a'     ; check if current char >= 'a' character, if no, go next character
    jb next_char
    cmp al, 'z'     ; check if current char <= 'a' character, if no, go next character
    ja next_char
    sub al, 0x20    ; move AL upper case, the distance between 
                    ; uppercase and lowercase letters is 20h in ASCII
    mov [ecx], al   ; write current character back to string, then go to nextChar

next_char:
    inc ecx         ; ecx is pointer to inp_str, so inc ecx means point to next char
    jmp upper_string

done:
    ret             ; return to position that upperString was called

