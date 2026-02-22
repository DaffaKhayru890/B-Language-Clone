section .data
    token db 'Token: ',0
    len_token equ $ - token

    type db ', Type: ', 0
    len_type equ $ - type

    newline db '', 10
    let_newline equ $ - newline

    str_eof        db 'EOF', 0
    len_eof        equ $ - str_eof

    str_identifier db 'IDENTIFIER', 0
    len_identifier equ $ - str_identifier

    str_lparen     db 'LPAREN', 0
    len_lparen     equ $ - str_lparen

    type_name_table:
        dq str_eof
        dq str_identifier
        dq str_lparen

    type_len_table:
        dq len_eof
        dq len_identifier
        dq len_lparen

section .text 
    global _start 

    extern _read_file

    extern _lexer
    extern token_lexeme 
    extern token_type 
    extern token_count 

_start:
    ; read file content
    call _read_file

    jmp get_token

    print:
        mov rdx, rsi 
        mov rsi, rdi 
        mov rax, 1
        mov rdi, 1
        syscall  

        ret 

    get_token:
        ; get token
        call _lexer

        ; print token: string 
        mov rdi, token
        mov rsi, len_token

        call print

        ; print token lexeme string 
        mov rdi, token_lexeme
        movzx rsi, byte [token_count]

        call print 

        ; print type: string 
        mov rdi, type
        mov rsi, len_type

        call print 

        ; print token type 
        movzx rax, byte [token_type]
        mov rdi, [type_name_table+rax*8]
        mov rsi, [type_len_table+rax*8]

        call print 

        ; print newline 
        mov rdi, newline
        mov rsi, let_newline

        call print  

        jmp exit 

    exit:
        mov rax, 60 
        xor rdi, rdi 
        syscall 

section .note.GNU-stack noalloc noexec nowrite progbits