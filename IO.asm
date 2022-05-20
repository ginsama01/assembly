strlen: 
    push rbp
    mov rbp, rsp

    mov rax, rdi
    checkLoop:
    cmp byte [rax], 0
    jz strlenFns
    inc rax
    jmp checkLoop

    strlenFns:
    sub rax, rdi 
    leave
    ret


; convert NULL-terminated string to num
strToNum: 
    ; function prologue: set up the stack then store callee saved registers
    push rbp
    mov rbp, rsp
    push rbx

    xor rax, rax
    xor rcx, rcx
    mov r8, 10
    checkDoneSTN:
    mov rbx, rdi ; load first arg into abx, use rcx as counter to loop through characters
    cmp byte [rbx+rcx], 0 ; comp
    jz doneSTN
    xor rdx, rdx
    mul r8 ; multiply value of rax by 10
    xor rdx, rdx
    mov dl, [rbx+rcx] ; load character in address rbx+rcx to dl
    cmp dl, '9' ; check if char is digit
    jg notValid
    cmp dl, '0'
    jl notValid
    sub dl, '0' ; convert to integer digit 
    add rax, rdx ; then add to rax
    inc rcx ; increase counter
    jmp checkDoneSTN
    
    notValid:
    xor rax, rax ; return 0 if not a valid numeric string

    ; function epilogue: restore saved registers, then return to saved rip
    doneSTN:
    pop rbx
    leave
    ret

 ; void numToStr(dword num, lpvoid* buf)
numToStr:
    push rbp
    mov rbp, rsp

    push rbx
    xor rcx, rcx
    mov rax, rdi ; first arg is passed into rax
    
    divideLoop:
    inc rcx ; use rcx as counter
    xor rdx, rdx
    mov rbx, 10
    div rbx ; divide rdx:rax by 10, remainder is stored in rdx
    add dl, '0' ; convert remainder to character
    push rdx ; push character onto stack
    cmp rax, 0 ; check if cannot divide anymore
    jnz divideLoop

    popChrLoop:
    pop rax ; pop character from stack into rax
    mov byte [rsi], al ; then append output
    inc rsi ; next character location set up

    loop popChrLoop ; loop RCX time to pop char from stack to buffer

    pop rbx
    leave
    ret

strRead: ; Read string from input without 0Ah
    push rbp 
    mov rbp, rsp
    mov rax, SYS_READ
    mov rsi, rdi
    mov rdi, STDIN
    mov rdx, 255
    syscall
    mov byte [rsi+rax-1], 0 ; replace \n with \0
    dec rax
    leave
    ret

uint64Read:
    push rbp
    mov rbp, rsp
    sub rsp, 0x20 ; stack allocation for local string

    mov qword [rsp], 0
    mov qword [rsp+8], 0
    mov qword [rsp+10h], 0
    mov qword [rsp+12h], 0

    lea rdi, [rsp]
    call strRead ; here come the bof
    lea rdi, [rsp]
    call strToNum
    leave ; clean the stack, restore rbp
    ret

int64Read:
    push rbp
    mov rbp, rsp
    sub rsp, 0x20 ; stack allocation for local string

    mov qword [rsp], 0
    mov qword [rsp+8], 0
    mov qword [rsp+10h], 0
    mov qword [rsp+12h], 0

    lea rdi, [rsp]
    call strRead
    lea rdi, [rsp]
    cmp byte [rdi], '-'
    jnz IRLabel1
    inc rdi
    call strToNum
    neg rax
    jmp IRLabel2
IRLabel1:
    call strToNum
IRLabel2:
    leave 
    ret
    

; write NULL-terminated string
strPrint: 
    push rbp
    mov rbp, rsp
    push rbx ; callee saved register

    call strlen ; call strlen value to compute len of string buffer contain in rdi

    mov rdx, rax ; arg for strlen

    mov rax, SYS_WRITE 
    mov rsi, rdi
    mov rdi, STDOUT

    syscall
    pop rbx
    leave
    ret

uint64Print: ; write quadword as string
    push rbp
    mov rbp, rsp

    sub rsp, 0x20 

    mov qword [rsp], 0
    mov qword [rsp+8], 0
    mov qword [rsp+10h], 0
    mov qword [rsp+12h], 0

    lea rsi, [rsp]
    call numToStr
    lea rdi, [rsp]
    call strPrint

    leave
    ret

int64Print:
    push rbp
    mov rbp, rsp

    test rdi, rdi
    jns IPlabel1
    push rdi
    lea rdi, [minus]
    call strPrint
    pop rdi
    neg rdi
IPlabel1:
    call uint64Print
    leave
    ret
