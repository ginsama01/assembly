

section .text
    global _start

_start:
    pop ecx
    pop ecx
    pop ecx
    mov ecx, [ecx + 4]
    mov eax, 1
    mov ebx, 1
    mov ecx, 18
