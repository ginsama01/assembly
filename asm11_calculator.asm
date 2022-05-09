; Compile with nasm32 and ld linker

SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
STDIN       equ 0
STDOUT      equ 1

section .data
    msg1    db  "Chon 1 trong 4 tuy chon: ", 0xA, 0xD
    len1    equ $ - msg1

    msg2    db  "1. Cong ", 0xA, 0xD
    len2    equ $ - msg2

    msg3    db  "2. Tru ", 0xA, 0xD
    len3    equ $ - msg3

    msg4    db  "3. Nhan ", 0xA, 0xD
    len4    equ $ - msg4

    msg5    db  "4. Chia ", 0xA, 0xD
    len5    equ $ - msg5

    msg6    db  "Nhap hai toan hang, moi toan hang tren mot dong ", 0xA, 0xD
    len6    equ $ - msg6

    msg7    db  "So chia khong hop le ", 0xA, 0xD
    len7    equ $ - msg7

    msg8    db  "Ket qua la: ", 0xA, 0xD
    len8    equ $ - msg8

    newline db  "", 0xA, 0xD
    lenNL   equ $ - newline

section .bss
    ope     resb 2
    num1    resb 11
    num2    resb 11
    res     resb 11

section .text
    global _start

_start:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, len3
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg4
    mov edx, len4
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg5
    mov edx, len5
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, ope
    mov edx, 2
    int 0x80


    call read_number
    ; convert num1 string to decimal number
    mov ebx, num1
    call string_to_decimal
    mov [num1], eax

    ; convert num2 string to decimal number
    mov ebx, num2
    call string_to_decimal
    mov [num2], eax

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
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg8
    mov edx, len8
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, res
    mov edx, 11
    int 0x80

exit:
    mov	eax, SYS_EXIT
	xor	ebx, ebx 
	int	0x80 

read_number:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg6
    mov edx, len6
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num1
    mov edx, 11
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num2
    mov edx, 11
    int 0x80
    ret


add_ope:
    mov eax, [num1]
    add eax, [num2]
    mov ebx, res
    call decimal_to_string
    jmp print

sub_ope:
    mov eax, [num1]
    sub eax, [num2]
    mov ebx, res
    call decimal_to_string
    jmp print

mul_ope:
    xor edx, edx
    mov eax, [num1]
    mov ebx, [num2]
    mul ebx
    cmp edx, 0
    mov ebx, res
    call decimal_to_string
    jmp print

div_ope:
    xor edx, edx
    mov eax, [num1]
    mov ebx, [num2]
    cmp ebx, 0
    je invalid
    div ebx
    mov ebx, res
    call decimal_to_string
    jmp print


    invalid:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, msg7
        mov edx, len7
        int 0x80
        jmp exit

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

        ; eax = eax * 10 + ecx
        push ecx    ; push ecx value to stack
        mov ecx, 10 
        mul ecx
        pop ecx     ; get value from stack
        add eax, ecx


        inc ebx
        jmp std_continue

    std_invalid:
        
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