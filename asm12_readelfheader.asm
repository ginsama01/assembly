; Compile with nasm32 and ld linker

SYS_EXIT    equ 1
SYS_READ    equ 3
SYS_WRITE   equ 4
SYS_OPEN    equ 5
SYS_CLOSE   equ 6
SYS_STAT    equ 0x6a
STDIN       equ 0
STDOUT      equ 1

section .data
    ELFHeaderMsg    db  "ELF Header:", 0xA, 0xD
    MagicMsg        db  "   Magic:  "

section .bss
    filename        resb 32
    f_input         resb 32
    stat            resb 92
    file            resb 1000000
    hex             resb 2

struc STAT
    .st_dev         resb 8
    .st_ino         resb 8
    .st_mode        resb 4
    .st_nlink       resb 8
    .st_uid         resb 4
    .st_gid         resb 4
    .st_rdev        resb 8
    .st_size        resb 8
    .st_blksize     resb 8
    .st_blocks      resb 8
    .st_atime       resb 8
    .st_mtime       resb 8
    .st_ctime       resb 8
endstruc
    
struc e_ident
	.EI_MAG		resb 4	; ELF "magic number" (0x7f, 'ELF')
	.EI_CLASS	resb 1	; file's class, or capacity
	.EI_DATA	resb 1	; data encoding of the cpu-specific data
	.EI_VERSION	resb 1	; ELF header version number (set to EV_CURRENT)
	.EI_PAD		resb 1	; marks the beginning of the unused bytes
	.EI_NIDENT	resb 8	; unused bytes in e_ident
endstruc

struc ELF32_Ehdr
    .e_ident        resb 16
    .e_type         resw 1
    .e_machine      resw 1
    .e_version      resd 1
    .e_entry        resd 1
    .e_phoff        resd 1
    .e_shoff        resd 1
    .e_flags        resd 1
    .e_ehsize       resw 1
    .e_phentsize    resw 1
    .e_phnum        resw 1
    .e_shentsize    resw 1
    .e_shnum        resw 1
    .e_shstrndx     resw 1
endstruc


section .text
    global _start

_start:
    pop ecx ; Return address
    pop ecx ; argc
    pop ecx ; argv 
    mov ecx, [ecx]

    ; open file
    mov [filename], ecx
    mov eax, SYS_OPEN
    mov ebx, filename
    mov ecx, 2
    xor edx, edx
    int 0x80

    mov [f_input], eax

    ; use sys_stat to get file_size
    mov eax, SYS_STAT
    mov ebx, filename
    mov ecx, stat
    int 0x80

    ; read file 
    mov eax, SYS_READ
    mov ebx, [f_input]
    mov ecx, file
    mov edx, [stat + STAT.st_size]
    int 0x80

    ; mov eax, SYS_WRITE
    ; mov ebx, STDOUT
    ; mov ecx, file
    ; mov edx, [stat + STAT.st_size]
    ; int 0x80

    ; check elf file
    mov eax, [file]
    cmp eax, 0x464c457f
    jne exit

    ; print elf header
    mov ecx, ELFHeaderMsg
    call printStr

    mov ecx, MagicMsg
    call printStr

    xor eax, eax
    mov al, [file]
    call printHexByte


exit:
    mov eax, SYS_EXIT
    xor ebx, ebx
    int 0x80


strlen:
    xor eax, eax
    mov edi, ecx
    strlen_loop:
        cmp byte [edi], 0
        je strlen_done
        inc edi
        inc eax
        jmp strlen_loop

    strlen_done:
        ret

printStr:
    call strlen
    mov edx, eax
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    int 0x80
    ret

decimalToHex:
    cmp al, 0
    je decimalToHex_done
    push eax
    div ax, 16
    cmp ah, 10
    
    decimalToHex_done:
        ret

printHexByte:
    
        