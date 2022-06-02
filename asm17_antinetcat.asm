O_RDONLY            equ 0
SYS_OPEN            equ 2
SYS_GETDENTS64      equ 0xd9
SYS_WRITE           equ 1
SYS_EXIT            equ 0x3c
STDIN               equ 0
STDOUT              equ 1

section .data
    filename    db  "/home/huynq/Documents", 0x0
    newline     db 0xA, 0x0
section .bss
    fd          resq 1
    nread       resq 1
    dirent      resb 10000000

struc LINUX_DIRENT64
    .d_ino       resq 1
    .d_off       resq 1
    .d_reclen    resw 1
    .d_type      resb 1
    .d_name      resb 32
endstruc

section .text
    global _start



_start:
    push rbp
    mov rbp, rsp

    ; open folder
    mov rdi, filename
    mov rsi, O_RDONLY
    xor rdx, rdx
    mov rax, SYS_OPEN
    syscall
    mov [fd], rax

    ; getdents
    mov rdi, qword [fd]
    mov rsi, dirent
    mov rdx, 10000000
    mov rax, SYS_GETDENTS64
    syscall
    mov qword [nread], rax

    xor rcx, rcx
    
    file_loop:
        lea rsi, [dirent + LINUX_DIRENT64.d_name]
        add rsi, rcx
        push rcx
        call printStr
        mov rsi, newline
        call printStr
        pop rcx
        movzx rax, word [dirent + LINUX_DIRENT64.d_reclen]
        add rcx, rax
        cmp rcx, qword [nread]
        jae loop_done
        jmp file_loop

    loop_done:


    mov rsp, rbp
    pop rbp

exit:
    xor rdi, rdi
    mov rax, SYS_EXIT
    syscall




strlen:
    push rbp
    mov rbp, rsp

    xor rax, rax
    mov rdi, rsi

    strlen_loop:
        cmp byte [rdi], 0
        je strlen_done
        inc rdi
        inc rax
        jmp strlen_loop

    strlen_done:
        mov rsp, rbp 
        pop rbp
        ret

printStr:
    push rbp
    mov rbp, rsp
    call strlen
    mov rdx, rax
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    syscall

    mov rsp, rbp 
    pop rbp
    ret

