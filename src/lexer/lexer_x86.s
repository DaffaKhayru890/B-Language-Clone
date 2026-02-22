section .data 
    ; =========== Token value ===========
    kw_extern db 'extern'
    kw_return db 'return'
    kw_auto db 'auto'
    kw_if db 'if'
    kw_while db 'while'

    ; =========== Token type ===========
    TOKEN_EOF equ 0

    TOKEN_IDENTIFIER equ 1

    TOKEN_LPAREN equ 2
    TOKEN_RPAREN equ 3
    TOKEN_LBRACE equ 4
    TOKEN_RBRACE equ 5
    TOKEN_LBRACKETS equ 6
    TOKEN_RBRACKETS equ 7

    TOKEN_KEYWORD_EXTERN equ 8
    TOKEN_KEYWORD_RETURN equ 9
    TOKEN_KEYWORD_AUTO equ 10
    TOKEN_KEYWORD_IF equ 11
    TOKEN_KEYWORD_WHILE equ 12
    TOKEN_KEYWORD_GOTO equ 13

section .bss 
    global token_lexeme
    global token_type 
    global token_count

    lexer_count resq 1
    
    token_lexeme resb 258
    token_type resb 1
    token_count resb 1

section .text 
    global _lexer 

    extern source_code 

    extern char_table
    extern jump_table

    ; global handle_unknown
    global handle_eof
    global handle_whitespace
    ; global handle_single_char
    global handle_alphabet
    ; global handle_digit

    extern char_table
    extern jump_table

_lexer: 
    ; =========== Setup lexer ===========
    xor rbp, rbp
    movzx rcx, byte [lexer_count]
    mov rsi, source_code
    movzx rax, byte [rsi+rcx]
    movzx rdi, byte [token_count]
    
    ; =========== Check if eof ===========
    movzx rbx, byte [char_table+rax]
    jmp [jump_table+rbx*8]

    handle_whitespace:
        ; advanced one char ahead
        inc rcx 
        movzx rax, byte [rsi+rcx]

        ; jump to another handler 
        movzx rbx, byte [char_table+rax]
        jmp [jump_table+rbx*8]

    handle_alphabet:
        ; set current char to token lexeme 
        mov byte [token_lexeme+rbp], al 

        ; advanced one char ahead
        inc rcx 
        inc rbp 
        movzx rax, byte [rsi+rcx]

        ; handle identifier if curent token is single char or whitespace
        cmp al, '('
        je handle_identifier

        jmp handle_alphabet
    
    handle_identifier:
        ; insert current token to lexeme 
        mov byte [token_lexeme+rbp], al 

        ; insert token type
        mov byte [token_type], TOKEN_IDENTIFIER  

        jmp done 

    handle_eof:
        ; insert current token to lexemr 
        mov byte [token_lexeme+rbp], al 
        
        ; insert token type 
        mov byte [token_type], TOKEN_EOF 

        jmp done 

    done:
        mov [lexer_count], rcx 
        ret 