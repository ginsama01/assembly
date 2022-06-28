%include 'io_x64.asm'
SYS_EXIT 	equ 0x3c


section .data
    msg1    db  "Enter first number: ", 0xA,0x0

    msg2    db  "Enter second number: ", 0xA,0x0

    msg3    db  "Sum of two numbers is: ", 0xA,0x0

    errmsg  db  "Invalid number", 0xA, 0x0

section .bss
    num1    resb 32
    num2    resb 32
    sum     resb 32

section .text
    global _start

_start:
    
    ; Enter first number
    mov rdi, msg1
    call printStr

    mov rdi, num1
    mov rsi, 32
    call readStr

    ; Convert string number to decimal number
    mov rdi, num1           
    call string_to_decimal  
    mov [num1], rax         ; Update value for num1
    
    ; Enter second number
    mov rdi, msg2
    call printStr

    mov rdi, num2
    mov rsi, 32
    call readStr

    ; Convert string number to decimal number
    mov rdi, num2          
    call string_to_decimal 
    
    ; Add two number in decimal format
    add rax, [num1]         
    
    ; Convert decimal number to string number
    mov rdi, rax
    mov rsi, sum
    call decimal_to_string

    ; print string
    mov rdi, msg3
    call printStr

    mov rdi, sum
    call printStr

exit:
    mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall 

; Convert string to decimal number
; Input: 
;   %rdi: char* - string to convert
; Output: 
;   %rax: int - decimal number
string_to_decimal:
    std_init:
        push rbp
        mov rbp, rsp

        xor rax, rax    ; rax = 0
        xor rcx, rcx    ; rcx = 0
        xor rdx, rdx    ; rdx = 0
    
    std_continue:
        mov cl, [rdi]   ; Get digit character
        cmp cl, 0x0     ; Check if null character
        je std_done
        cmp cl, 0xA     ; Check if enter character
        je std_done
        cmp cl, '0'     ; Check if < 0
        jb std_invalid
        cmp cl, '9'     ; Check if > 9
        ja std_invalid
        sub cl, 0x30    ; Convert character to digit in decimal

        ; Check if rax > 2^28 - 1, then if mul 10, it will be higher than 2^31 - 1
        cmp rax, 0x0FFFFFFF
        ja std_invalid

        ; rax = rax * 10 + rcx
        push rcx    ; push rcx value to stack
        mov rcx, 10 
        mul rcx
        pop rcx     ; get value from stack
        add rax, rcx

        ; Check if rax > 2^31 - 1
        cmp rax, 0x7FFFFFFF
        ja std_invalid

        inc rdi
        jmp std_continue

    std_invalid:
        mov rdi, errmsg
        call printStr
        jmp exit

    std_done:
        mov rsp, rbp
        pop rbp
        ret 

; Convert decimal number to string
; Input: 
;   %rdi: int - decimal number 
;   %rsi: char* - string will store value
; Output: none
decimal_to_string:
    dts_init:
        push rbp
        mov rbp, rsp
        mov rax, rdi    ; decimal number
        xor rcx, rcx    ; rcx = 0
    
    dts_continue:
        xor rdx, rdx    ; rdx = 0 for divider
       
        ; Divide 10, remainder is digit, push it to stack to reverse. Using rcx for count number of digits.
        push rcx
        mov rcx, 10
        div rcx
        pop rcx
        push rdx
        inc rcx
        cmp rax, 0      ; if rax = 0, end
        je dts_done
        jmp dts_continue
    
    dts_done:
        pop rdx     ; get digit
        add rdx, 0x30   ; convert to ascii
        mov [rsi], rdx  ; move digit value in ascii to rsi pointer
        inc rsi         ; increase pointer to next character
        loop dts_done
    
    dts_end:
        mov rsp, rbp
        pop rbp
        ret

