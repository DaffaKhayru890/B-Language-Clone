section .data 
    filename db '../example/example.b', 0

section .note.GNU-stack noalloc noexec nowrite progbits

section .bss 
    global source_code

    source_code resb 4097
    fd resq 1
    bytes_read resq 1

section .text 
    global _read_file

_read_file:
    ; open file 
    mov rax, 2
    mov rdi, filename
    mov rsi, 0
    mov rdx, 0
    syscall

    mov [fd], rax 

    ; read file 
    mov rax, 0
    mov rdi, [fd]
    mov rsi, source_code 
    mov rdx, 4097
    syscall 

    mov [bytes_read], rax
    mov byte [source_code+rax], 0

    ; close file 
    mov rax, 3
    mov rdi, [fd]
    syscall

    ret

section .note.GNU-stack noalloc noexec nowrite progbits