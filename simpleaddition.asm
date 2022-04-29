SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
STDIN       equ 0
STDOUT      equ 1

section .data
    msg1    db  "Enter first number: ", 0xA,0xD
    len1    equ $- msg1

    msg2    db  "Enter second number: ", 0xA,0xD
    len2    equ $- msg2

    msg3    db  "Sum of two numbers is: ", 0xA,0xD
    len3    equ $- msg3

    errmsg  db  "Invalid number: ", 0xA, 0xD
    lenerr  equ $- errmsg

section .bss
    num1    resb 32
    num2    resb 32
    sum     resb 32

section .text
    global _start

_start:
    ; Enter first number
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num1
    mov edx, 32
    int 0x80

    ; Convert string number to decimal number
    mov ebx, num1           ; Ebx register is input of string_to_decimal 
    call string_to_decimal  ; Store decimal number in eax register
    mov [num1], eax         ; Update value for num1
    
    ; Enter second number
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num2
    mov edx, 32
    int 0x80

    ; Convert string number to decimal number
    mov ebx, num2           ; Ebx register is input of string_to_decimal 
    call string_to_decimal  ; Store decimal number in eax register
    
    ; Add two number in decimal format
    add eax, [num1]         
    
    ; Convert decimal number to string number and store value in sum through ebx pointer
    ; eax register is input of decimal_to_string
    mov ebx, sum
    call decimal_to_string

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, len3
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, sum
    mov edx, 32
    int 0x80

exit:
    mov	eax, SYS_EXIT
	xor	ebx, ebx 
	int	0x80 

; Convert string to decimal number
; Input: ebx register
; Output: eax register
string_to_decimal:
    xor eax, eax    ; eax = 0
    xor ecx, ecx    ; ecx = 0
    xor edx, edx    ; edx = 0

    std_continue:
        mov cl, [ebx]   ; Get digit character
        cmp cl, 0x0     ; Check if null character
        je std_done
        cmp cl, 0xA     ; Check if enter character
        je std_done
        cmp cl, '0'     ; Check if < 0
        jb std_invalid
        cmp cl, '9'     ; Check if > 9
        ja std_invalid
        sub cl, 0x30    ; Convert character to digit in decimal

        ; Check if eax > 2^28 - 1, then if mul 10, it will be higher than 2^31 - 1
        cmp eax, 0x0FFFFFFF
        ja std_invalid

        ; eax = eax * 10 + ecx
        push ecx    ; push ecx value to stack
        mov ecx, 10 
        mul ecx
        pop ecx     ; get value from stack
        add eax, ecx

        ; Check if eax > 2^31 - 1
        cmp eax, 0x7FFFFFFF
        ja std_invalid

        inc ebx
        jmp std_continue

    std_invalid:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, errmsg
        mov edx, lenerr
        int 0x80
        jmp exit

    std_done:
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

