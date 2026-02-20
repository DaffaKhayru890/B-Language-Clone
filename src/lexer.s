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

    lexer_count resd 1
    
    token_lexeme resb 258
    token_type resd 1
    token_count resd 1

section .text 
    global _lexer 

    extern source_code 

    extern char_table
    extern jump_table

_lexer: 
    ; =========== Setup lexer ===========
    xor rdx, rdx
    xor rbp, rbp
    mov rcx, [lexer_count]
    mov rsi, source_code
    mov rax, [rsi+rcx]
    mov rdi, [token_count]
    
    ; =========== Check if eof ===========
    mov rbx, [char_table+rax]
    jmp [jump_table+rbx*8]

    handle_whitespace:
        ; advanced one char ahead
        inc rcx 
        mov rax, [rsi+rcx]

        ; jump to another handler 
        mov rbx, [char_table+rax]
        jmp [jump_table+rbx*8]

    handle_alphabet:
        ; set current char to token lexeme 
        mov [token_lexeme+rbp], al 

        ; advanced one char ahead
        inc rcx 
        inc rbp 
        mov rax, [rsi+rcx]

        ; check if it's whitespace or eof 
        mov rbx, [char_table+rax]
        jmp [jump_table+rbx*8]

        jmp handle_alphabet

    handle_eof:
        ; insert current token to 
        mov [token_lexeme+rbp], al 
        
        ; insert token type 
        mov rdx, TOKEN_EOF
        mov [token_type], rdx 

        jmp done 

    done:
        mov [lexer_count], rcx 
        ret 