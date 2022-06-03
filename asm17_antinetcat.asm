; nasm -f elf64 -g -F dwarf -o asm17_antinetcat.o asm17_antinetcat.asm
; ld -o asm17_antinetcat asm17_antinetcat.o
O_RDONLY            equ 0
SYS_OPEN            equ 2
SYS_CLOSE           equ 3
SYS_GETDENTS64      equ 0xd9
SYS_WRITE           equ 1
SYS_READ            equ 0
SYS_EXIT            equ 0x3c
SYS_KILL            equ 0x3e
SYS_NANOSLEEP       equ 0x23
SIGKILL             equ 9
STDIN               equ 0
STDOUT              equ 1


section .data
    filename    db  "/proc", 0x0
    proc        db  "/proc/"
    cmdline     db  "/cmdline"
    newline     db 0xA, 0x0

section .bss
    fd          resq 1
    nread       resq 1
    dirent      resb 10000000
    pid         resq 1
    pidfile     resq 3
    pidcmd      resb 2
    pidfd       resq 1
    num         resq 1
    sleeptime   resq 2

struc LINUX_DIRENT64
    .d_ino       resq 1
    .d_off       resq 1
    .d_reclen    resw 1
    .d_type      resb 1
    .d_name      resb 32
endstruc

struc timespec 
    .tv_sec     resq 1
    .tv_nsec    resq 1
endstruc

section .text
    global _start



_start:
    push rbp
    mov rbp, rsp

after_sleep:
    ; open folder /proc
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
    ; read file in /proc/
    lea rsi, [dirent + rcx + LINUX_DIRENT64.d_name]
    mov al, byte [rsi]
    push rcx
    cmp al, '0'
    jb loop_continue
    cmp al, '9'
    ja loop_continue
    
    call check_pid
    

    loop_continue:
        pop rcx
        ; next DIRENT
        movzx rax, word [dirent + rcx + LINUX_DIRENT64.d_reclen]
        add rcx, rax
        cmp rcx, qword [nread]
        jae sleep
        jmp file_loop

sleep:
    ; sleep for 10 seconds
    mov dword [sleeptime + timespec.tv_sec], 10
    mov dword [sleeptime + timespec.tv_nsec], 0
    mov rdi, sleeptime
    mov rsi, sleeptime
    mov rax, SYS_NANOSLEEP
    syscall

    jmp after_sleep


exit:
    mov rsp, rbp
    pop rbp

    xor rdi, rdi
    mov rax, SYS_EXIT
    syscall

check_pid:
    push rbp
    mov rbp, rsp
    
    ; check file /proc/:pid/cmdline
    mov rcx, qword [rsi]
    mov [pid], rcx
    mov qword [pidfile], 0
    mov qword [pidfile + 8], 0
    mov qword [pidfile + 16], 0
    mov rbx, pidfile
    mov rcx, "/proc/"
    mov [rbx], rcx
    add rbx, 6
    xor rcx, rcx

    string_add:
        mov dl, byte [pid + rcx]
        cmp dl, 0
        je add_done
        mov [rbx], dl 
        inc rbx
        inc rcx
        jmp string_add

    add_done: 
        mov rcx, "/cmdline"
        mov [rbx], rcx
        ; open folder
        mov rdi, pidfile
        mov rsi, O_RDONLY
        xor rdx, rdx
        mov rax, SYS_OPEN
        syscall

        cmp rax, -1
        je check_done
        mov [pidfd], rax

        mov rdi, qword [pidfd]
        mov rsi, pidcmd
        mov rdx, 2
        mov rax, SYS_READ
        syscall

        mov rdi, qword [pidfd]
        mov rax, SYS_CLOSE
        syscall

        ; if it starts with "nc", it's netcat process.
        cmp word [pidcmd], "nc"
        jne check_done
        mov rsi, pid
        call printStr
        mov rsi, newline
        call printStr

        mov rbx, pid
        call stringToDecimal
        mov qword [num], rax

        ; kill process
        mov rdi, qword [num]
        mov rsi, SIGKILL
        mov rax, SYS_KILL
        syscall


    check_done:
        mov rsp, rbp
        pop rbp
        ret


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

stringToDecimal:
    xor rax, rax
    xor rcx, rcx
    xor rdx, rdx

    std_continue:
        mov cl, [rbx]
        cmp cl, 0x0     ; Check if null character
        je std_done
        cmp cl, 0xA     ; Check if enter character
        je std_done

        sub cl, 0x30 
        
        push rcx    ; push ecx value to stack
        mov rcx, 10 
        mul rcx
        pop rcx     ; get value from stack
        add rax, rcx

        inc rbx
        jmp std_continue

    std_done:
        ret 