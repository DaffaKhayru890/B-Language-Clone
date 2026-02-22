section .data
    token db 'Token: ',0
    len_token equ $ - token

    type db ', Type: ', 0
    len_type equ $ - type

    newline db '', 10
    let_newline equ $ - newline

    type_name_table:
        dq 'EOF'        ; 0 TOKEN_EOF
        dq 'IDENTIFIER' ; 1 TOKEN_IDENTIFIER


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
        mov rsi, token_count

        call print 

        ; print type: string 
        mov rdi, type
        mov rsi, len_type

        call print 

        ; print token type 
        

        ; print newline 
        mov rdi, newline
        mov rsi, let_newline

        call print  

        jmp exit 

    exit:
        mov rax, 60 
        xor rdi, rdi 
        syscall 
