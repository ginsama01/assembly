%include 'io_x64.asm'
SYS_EXIT 	equ 0x3c

section .data
    msg1    db  "Enter string: ", 0xA, 0x0
    msg2    db  "Reverse string: ", 0xA, 0x0

section .bss
    string      resb 256
    res         resb 256

section .text
    global _start

_start:
    ; enter string
    mov rdi, msg1
    call printStr

    mov rdi, string
    mov rsi, 256
    call readStr

    ; reverse string
    mov rdi, string
    mov rsi, res
    call reverse_string
    
    ; print reverse string
    mov rdi, msg2
    call printStr

    mov rdi, res
    call printStr
    
exit:
    mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall 

; Reverse string
; Input:
;   %rdi: char* - string to reverse
;   %rsi: char* - store string after reverse
; Output: none
reverse_string:
    reverse_init:
        push rbp
        mov rbp, rsp

        xor rax, rax
        xor rcx, rcx    ; for count characters
    
    next_char:
        mov al, [rdi]   ; get character
        ; if character is null or enter
        cmp al, 0x0     
        je reverse
        cmp al, 0xA
        je reverse
        push rax    ; push character to stack
        inc rdi     ; next character
        inc rcx     ; inc count
        jmp next_char
    
    reverse:
        pop rax     ;get charcater from stack
        mov [rsi], rax  ; mov to end string
        inc rsi     ; next position in end string
        loop reverse
    
    reverse_done:
        mov rsp, rbp
        pop rbp
        ret
