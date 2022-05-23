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
    space               db  " ", 0x0
    newline             db  0xA, 0x0

    ElfHeaderMsg        db  "ELF Header:", 0xA, 0x0
    ElfMagicMsg         db  "   Magic:  ", 0x0
    
    ElfClassMsg         db  "   Class:                                  ", 0x0
    ElfClass32Msg       db  "ELF32", 0xA, 0x0
    ElfClass64Msg       db  "ELF64", 0xA, 0x0
    ElfClassNone        db  "Invalid class", 0xA, 0x0

    ElfDataMsg          db  "   Data:                                   ", 0x0
    ElfDataLSBMsg       db  "2's complement, little endian", 0xA, 0x0
    ElfDataMSBMsg       db  "2's complement, big endian", 0xA, 0x0
    ElfDataNone         db  "Invalid data encoding", 0xA, 0x0

    ElfVersionMsg       db  "   Version:                                ", 0x0
    ElfVersionCurrentMsg   db  "1 (current)", 0xA, 0x0
    ElfVersionNoneMsg   db  "0 (invalid)", 0xA, 0x0

    OSstr:
        dq 0
        db "UNIX - System V", 0Ah, 0
        dq 1
        db "UNIX - HP-UX", 0Ah, 0
        dq 2
        db "UNIX - NetBSD", 0Ah, 0
        dq 3
        db "UNIX - GNU", 0Ah, 0
        dq 6
        db "UNIX - Solaris", 0Ah, 0
        dq 7
        db "UNIX - AIX", 0Ah, 0
        dq 8
        db "UNIX - IRIX", 0Ah, 0
        dq 9
        db "UNIX - FreeBSD", 0Ah, 0
        dq 19
        db "UNIX - TRU64", 0Ah, 0
        dq 11
        db "Novell - Modesto", 0Ah, 0
        dq 12
        db "UNIX - OpenBSD", 0Ah, 0
        dq 13
        db "VMS - OpenVMS", 0Ah, 0
        dq 14
        db "HP - Non-Stop Kernel", 0Ah, 0
        dq 15
        db "AROS", 0Ah, 0
        dq 16
        db "FenixOS", 0Ah, 0
        dq 17
        db "Nuxi CloudABI", 0Ah, 0
        dq 18
        db "Stratus Technologies OpenVOS", 0Ah, 0
        dq -1

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

struc ELF64_Ehdr
    .e_ident        resb 16
    .e_type         resw 1
    .e_machine      resw 1
    .e_version      resd 1
    .e_entry        resq 1
    .e_phoff        resq 1
    .e_shoff        resq 1
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
    mov ecx, ElfHeaderMsg
    call printStr

    ; print magic
    mov ecx, ElfMagicMsg
    call printStr

    xor ecx, ecx

magicloop:
    xor eax, eax
    mov al, [file + ecx]
    push ecx
    call printHexByte
    mov ecx, space
    call printStr
    pop ecx
    inc ecx
    cmp ecx, 16
    je magicloop_print
    jmp magicloop

    magicloop_print:
        mov ecx, newline
        call printStr

elf_class:
    ; print class
    mov ecx, ElfClassMsg
    call printStr

    cmp byte [file + e_ident.EI_CLASS], 1
    je elf_class_32
    cmp byte [file + e_ident.EI_CLASS], 2
    je elf_class_64
    mov ecx, ElfClassNone
    jmp elf_class_print

    elf_class_32:
        mov ecx, ElfClass32Msg
        jmp elf_class_print

    elf_class_64:
        mov ecx, ElfClass64Msg

    elf_class_print:
        call printStr

elf_data:
    ; print data
    mov ecx, ElfDataMsg
    call printStr

    cmp byte [file + e_ident.EI_DATA], 1
    je elf_data_lsb
    cmp byte [file + e_ident.EI_DATA], 2
    je elf_data_msb
    mov ecx, ElfDataNone
    jmp elf_data_print

    elf_data_lsb:
        mov ecx, ElfDataLSBMsg
        jmp elf_data_print
    
    elf_data_msb:
        mov ecx, ElfDataMSBMsg

    elf_data_print:
        call printStr

elf_version:
    ; print version
    mov ecx, ElfVersionMsg
    call printStr

    cmp byte [file + e_ident.EI_VERSION], 1
    je elf_version_current
    mov ecx, ElfVersionNoneMsg
    jmp elf_version_print

    elf_version_current:
        mov ecx, ElfVersionCurrentMsg
        jmp elf_version_print

    elf_version_print:
        call printStr

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
    mov dl, 16
    div dl
    mov ebx, hex
    add al, 48
    cmp al, 58
    jae addToHexAl

    contAfterAl:
        mov [ebx], al
        inc ebx
        add ah, 0x30
        cmp ah, 58
        jae addToHexAh

    contAfterAh:
        mov [ebx], ah
        ret

    addToHexAl:
        add al, 39
        jmp contAfterAl
    
    addToHexAh:
        add ah, 39
        jmp contAfterAh

printHexByte:
    call decimalToHex
    mov ecx, hex
    call printStr
    ret
        