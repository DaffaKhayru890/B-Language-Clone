section .data 

section .text 
    global _start 

    extern _read_file
    extern _lexer

_start:
    jmp get_token

    print:
        push ebp 
        mov ebp, esp 

        mov rax, 4
        mov rbx, 1
        mov rcx, [ebp+12]
        mov rdx, [ebp+8]
        syscall 

        pop ebp 

        ret 