section .data 
    filename db '../example/example.b', 0

section .note.GNU-stack noalloc noexec nowrite progbits

section .bss 
    global source_code

    source_code resb 4097
    fd resd 1
    bytes_read resd 1

section .text 
    global _read_file

_read_file:
    ; open file 
    mov rax, 5
    mov rbx, filename
    mov rcx, 0
    mov rdx, 0
    int 0x80

    mov [fd], eax 

    ; read file 
    mov rax, 3
    mov rbx, [fd]
    mov rcx, source_code 
    mov rdx, 4096
    int 0x80

    mov [bytes_read], rax
    mov byte [source_code+rax], 0

    ; close file 
    mov rax, 6
    mov rbx, [fd]
    int 0x80

    ret