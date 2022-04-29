SYS_EXIT 	equ 1
SYS_READ 	equ 3
SYS_WRITE	equ 4
STDIN		equ 0
STDOUT		equ 1

section .data
    msg1    db  "Enter string: ", 0xA,0xD
    len1    equ $- msg1

    msg2    db  "String entered is: ", 0xA,0xD
    len2    equ $- msg2

section .bss
    res     resb 32

section .text
	global _start

_start:
    ;Enter string
    mov 	eax, SYS_WRITE
	mov 	ebx, STDOUT
	mov		ecx, msg1
	mov		edx, len1
	int		0x80

    mov 	eax, SYS_READ
	mov		ebx, STDIN
	mov		ecx, res
	mov		edx, 32
	int		0x80

    ;Print string
    mov 	eax, SYS_WRITE
	mov 	ebx, STDOUT
	mov		ecx, msg2
	mov		edx, len2
	int		0x80

    mov		eax, SYS_WRITE
	mov		ebx, STDOUT
	mov 	ecx, res
	mov 	edx, 32
	int		0x80

exit:
	mov		eax, SYS_EXIT
	xor		ebx, ebx 	; Set ebx to 0
	int		0x80     