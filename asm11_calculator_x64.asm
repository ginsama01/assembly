%include 'io_x64.asm'
SYS_EXIT 	equ 0x3c

section .data
    msg1    db  "Chon 1 trong 4 tuy chon: ", 0xA, 0x0

    msg2    db  "1. Cong ", 0xA, 0x0

    msg3    db  "2. Tru ", 0xA, 0x0

    msg4    db  "3. Nhan ", 0xA, 0x0

    msg5    db  "4. Chia ", 0xA, 0x0

    msg6    db  "Nhap hai toan hang, moi toan hang tren mot dong ", 0xA, 0x0

    msg7    db  "So chia khong hop le ", 0xA, 0x0

    msg8    db  "Ket qua la: ", 0xA, 0x0

    newline db  "", 0xA, 0x0

section .bss
    ope     resb 2
    num1    resb 11
    num2    resb 11
    res     resb 11

section .text
    global _start

_start:

    ; print message
    mov rdi, msg1
    call printStr
    mov rdi, msg2
    call printStr
    mov rdi, msg3
    call printStr
    mov rdi, msg4
    call printStr
    mov rdi, msg5
    call printStr
   
    ; read operation
    mov rdi, ope
    mov rsi, 2
    call readStr

    ; read number and convert to decimal
    mov rdi, msg6
    call printStr
    mov rdi, num1
    mov rsi, 11
    call readStr
    mov rdi, num2
    mov rsi, 11
    call readStr

    ; convert num1 string to decimal number
    mov rdi, num1
    call string_to_decimal
    mov [num1], rax

    ; convert num2 string to decimal number
    mov rdi, num2
    call string_to_decimal
    mov [num2], rax

    ; case for operation
    mov al, [ope]
    cmp al, '1'
    je add_ope 

    cmp al, '2'
    je sub_ope

    cmp al, '3'
    je mul_ope

    cmp al, '4'
    je div_ope

print:
    ; print result
    mov rdi, msg8
    call printStr

    mov rdi, res
    call printStr

exit:
    mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall 


add_ope:
    mov rax, [num1]
    add rax, [num2]
    mov rdi, rax
    mov rsi, res
    call decimal_to_string
    jmp print

sub_ope:
    mov rax, [num1]
    sub rax, [num2]
    mov rdi, rax
    mov rsi, res
    call decimal_to_string
    jmp print

mul_ope:
    xor rdx, rdx
    mov rax, [num1]
    mov rbx, [num2]
    mul rbx
    mov rdi, rax
    mov rsi, res
    call decimal_to_string
    jmp print

div_ope:
    xor rdx, rdx
    mov rax, [num1]
    mov rbx, [num2]
    cmp rbx, 0
    je invalid
    div rbx
    mov rdi, rax
    mov rsi, res
    call decimal_to_string
    jmp print


    invalid:
        mov rdi, msg7
        call printStr
        jmp exit

