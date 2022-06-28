%include 'io_x64.asm'
SYS_EXIT 	equ 0x3c

section .data
    msg1    db  "Enter string: ", 0xA,0x0

    msg2    db  "Enter substring: ", 0xA,0x0

    newline db  0xA, 0x0
    
    space   db  " ", 0x0

section .bss
    string      resb 100
    substring   resb 10
    trace       resb 100
    res         resb 8

section .text
	global _start

_start:
    ; read string
    mov rdi, msg1
    call printStr

    mov rdi, string
    mov rsi, 100
    call readStr

    ; read substring
    mov rdi, msg2
    call printStr

    mov rdi, substring
    mov rsi, 10
    call readStr

    ; check substring
    mov rdi, string
    mov rsi, substring
    mov rdx, trace
    call check_substr
    mov [res], rax

    ; print value
    call print

exit:
    mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall 

; Check substring in string
; Input:
;   %rdi: char* - string
;   %rsi: char* - substring
;   %rdx: char* - store array of position where substring in string
; Output:
;   %rax: int - number of substring in string
check_substr:
    check_init:
        push rbp
        mov rbp, rsp

        xor rax, rax    ; number of substring in string
        xor r8, r8  ; index of string

    check_start:
        push r8     ; push to stack to store position if need later
        xor r9, r9  ; index of sub string
        xor rcx, rcx
        xor rbx, rbx

    check_main:
        ; get character of string
        mov cl, [rdi + r8]
        ; get character of substring
        mov bl, [rsi + r9]
        ; compare if character of substring is enter or null
        cmp bl, 0x0
        je is_substr
        cmp bl, 0xA
        je is_substr 
        ; compare if character of string is enter or null
        cmp cl, 0x0
        je check_done 
        cmp cl, 0xA
        je check_done
        cmp cl, bl
        jne not_substr
        ; next character
        inc r8
        inc r9
        jmp check_main
        
    
    is_substr:
        inc rax ; inc number of substring in string
        
        ; store position of substring
        pop r8
        mov [rdx], r8
        inc rdx

        inc r8 ; next character
        jmp check_start

    not_substr:
        pop r8
        inc r8 ; next character
        jmp check_start

    check_done:
        pop r8 
        mov rsp, rbp
        pop rbp
        ret

; Print result and trace position
; Input: none
; Output: none
print:
    push rbp
    mov rbp, rsp

    mov r8, [res]
    ; convert total time substring in string from decimal to string to print
    mov rdi, [res]
    mov rsi, res
    call decimal_to_string

    mov rdi, res
    call printStr

    mov rdi, newline
    call printStr
    
    ; print position trace
    print_array:
        mov rax, trace
        
        cmp r8, 0
        je print_done

        print_loop:
            ; get position
            xor rbx, rbx
            mov bl, [rax]
            push rax    ; push rax to stack

            ; convert to string to print
            mov qword [res], 0
            mov rdi, rbx
            mov rsi, res
            call decimal_to_string

            mov rdi, res
            call printStr

            mov rdi, space
            call printStr

            pop rax ;get rax from stack
            inc rax ; next element in trace array
            
            dec r8  ; number of position need to print
            cmp r8, 0
            jne print_loop

    print_done:
        mov rsp, rbp
        pop rbp
        ret
