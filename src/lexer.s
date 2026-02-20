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
    
    ; =========== Set char type value ===========
    CHAR_OTHERS equ 0
    CHAR_WHITESPACE equ 1
    CHAR_OPERATOR equ 2
    CHAR_DELIMITER equ 3
    CHAR_QUOTE equ 4
    CHAR_QUESTION equ 5
    CHAR_ALPHABET equ 6
    CHAR_DIGIT equ 7
    CHAR_UNDERSCORE equ 8

section .bss 
    global token_lexeme
    global token_type 
    global token_count
    global lexer_count

    lexer_count resd 1
    
    token_lexeme resb 258
    token_type resd 1
    token_count resd 1

section .text 
    global _lexer 

    extern source_code 
    extern bytes_read 

_lexer: 
    ; =========== Setup lexer ===========
    xor rdx, rdx
    xor rbp, rbp
    mov rcx, [lexer_count]
    mov rsi, source_code
    mov rax, [rsi+rcx]
    mov rdi, [token_count]
    
    ; =========== Check if eof ===========
    cmp rcx, [bytes_read]
    jae create_eof

    skip_whitespace:
        ; convert char value to table char value
        mov rbx, [char_table+rax]

        ; compare if it's whitespace 
        cmp rbx, CHAR_WHITESPACE
        je advanced

        jmp check_alphabet

    advanced:
        ; advanced one char ahead 
        inc rcx 
        mov rax, [rsi+rcx]
        mov [lexer_count], ecx

        ; check if eof 
        cmp ecx, [bytes_read]
        jae create_eof 

        jmp skip_whitespace

    check_alphabet:
        ; convert char value to table char value
        movzx eax, al 
        movzx ebx, byte [char_table+eax]

        ; check if it's delimiter
        cmp ebx, CHAR_DELIMITER
        je compare_delimiter

        ; compare if it's alphabet
        cmp ebx, CHAR_ALPHABET
        je collect_alphabet 

        jmp check_digit

    check_digit:
        ; compare if it's digit 
        cmp ebx, CHAR_DIGIT
        je collect_alphabet

        jmp done 

    collect_alphabet:
        ; insert char to token lexeme 
        mov [token_lexeme+ebp], al 

        ; advanced char one step ahead 
        inc ecx 
        inc ebp
        mov al, [esi+ecx]

        ; set current new char position
        mov [lexer_count], ecx 

        ; check if it's eof 
        cmp ecx, [bytes_read]
        jae compare_alphabet
 
        ; convert char value to table char value
        movzx eax, al 
        movzx ebx, byte [char_table+eax]

        ; check if it's delimiter 
        cmp ebx, CHAR_DELIMITER
        je compare_alphabet

        ; compare if it's whitespace 
        cmp ebx, CHAR_WHITESPACE
        je compare_alphabet

        jmp check_alphabet

    compare_alphabet:
        jmp set_identifier

    compare_delimiter:
        ; set current token and advanced to next token
        mov [token_lexeme], al
        inc ecx 
        mov [lexer_count], ecx

        ; check if it's lparen 
        cmp al, '('
        je set_lparen

        ; check if it's rparen 
        cmp al, ')'
        je set_rparen

        ; check if it's lbrace 
        cmp al, '{'
        je set_lbrace

        ; check if it's rbrace 
        cmp al, '}'
        je set_rbrace

    create_eof:
        ; set lexeme value 
        mov byte [token_lexeme], 0

        jmp set_eof

    set_identifier:
        ; set identifier 
        mov dl, TOKEN_IDENTIFIER
        mov [token_type], dl 

        ; set token count 
        inc ebp
        mov [token_count], ebp 

        jmp done 

    set_lparen:
        ; set token type to lparen 
        mov dl, TOKEN_LPAREN
        mov [token_type], dl 
        mov dword [token_count], 1

        jmp done 

    set_rparen:
        ; set token type to rparen
        mov dl, TOKEN_RPAREN
        mov [token_type], dl 
        mov dword [token_count], 1

        jmp done 

    set_lbrace:
        ; set token type to lbrace
        mov dl, TOKEN_LBRACE
        mov [token_type], dl 
        mov dword [token_count], 1

        jmp done 

    set_rbrace:
        ; set token type to rbrace 
        mov dl, TOKEN_RBRACE
        mov [token_type], dl 
        mov dword [token_count], 1

        jmp done 

    set_eof:
        mov dl, TOKEN_EOF
        mov [token_type], dl 
        mov dword [token_count], 1

        jmp done 

    done:
        ret 