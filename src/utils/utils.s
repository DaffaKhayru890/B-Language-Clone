section .data 
    filename db '../example/example.b', 0

section .note.GNU-stack noalloc noexec nowrite progbits

section .bss 
    global source_code
    global fd
    global bytes_read

    source_code resb 4096
    fd resd 1
    bytes_read resd 1

section .text 
    global _read_file

_read_file:
    ; open file 
    mov eax, 5
    mov ebx, filename
    mov ecx, 0
    mov edx, 0
    int 0x80

    mov [fd], eax 

    ; read file 
    mov eax, 3
    mov ebx, [fd]
    mov ecx, source_code 
    mov edx, 4096
    int 0x80

    mov [bytes_read], eax

    ; close file 
    mov eax, 6
    mov ebx, [fd]
    int 0x80

    ret