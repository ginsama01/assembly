SYS_EXIT 	equ 1
SYS_READ 	equ 3
SYS_WRITE	equ 4
STDIN		equ 0
STDOUT		equ 1

section .data
    msg1    db  "Enter string: ", 0xA,0xD
    len1    equ $- msg1

    msg2    db  "Enter substring: ", 0xA,0xD
    len2    equ $- msg2

    res     dd 0

section .bss
    string      resb 100
    substring   resb 10
    trace       resb 100

section .text
	global _start

_start:
    call read_string
    call read_substring    
    ; esi is string pointer
    mov esi, 0
    ; res is pointed by edx register
    mov edx, res
    ; trace is pointed by ecx register
    mov ecx, trace
    call check_substr
    call print
    jmp exit

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
    mov edx, 100
    int 0x80
    ; Return
    ret

read_substring:
    ; Message
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80
    ; Enter substring
    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, substring
    mov edx, 10
    int 0x80
    ; Return
    ret

check_substr:
    push esi
    ; edi is substring pointer
    xor edi, edi
    xor eax, eax
    xor ebx, ebx
    check:
        ; get character of string
        mov al, [string + esi]
        ; get character of substring
        mov bl, [substring + edi]
        ; compare if character of substring is enter or null
        cmp bl, 0x0
        je is_substr
        cmp bl, 0xA
        je is_substr 
        ; compare if character of string is enter or null
        cmp al, 0x0
        je check_done 
        cmp al, 0xA
        je check_done
        cmp al, bl
        jne not_substr
        ; next character
        inc esi
        inc edi
        jmp check
        
    
    is_substr:
        pop esi
        mov [ecx], esi
        inc ecx
        mov al, [edx]
        add al, 1
        mov [edx], al
        inc esi
        jmp check_substr

    not_substr:
        pop esi
        inc esi
        jmp check_substr

    check_done:
        pop esi 
        ret

print:
    mov eax, [res]
    mov esi, [res]
    mov ebx, res
    call decimal_to_string
    mov byte [ebx], 0xA
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, res
    mov edx, 4
    int 0x80

    print_array:
        mov eax, trace
     
        print_loop:
            xor ebx, ebx
            mov bl, [eax]
            push eax
            mov eax, ebx
            xor ebx, ebx
            mov [res], ebx
            mov ebx, res
            call decimal_to_string
            mov byte [ebx], ' '
            mov eax, SYS_WRITE
            mov ebx, STDOUT
            mov ecx, res
            mov edx, 4
            int 0x80
            pop eax
            inc eax
            dec esi
            cmp esi, 0x0
            jne print_loop

    print_done:
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

exit:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80