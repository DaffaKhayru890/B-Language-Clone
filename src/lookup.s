section .data 
    global char_table
    global jump_table

    ; =========== Table lookup for ASCII ===========
    align 256
    char_table:
        db 1                ; 0 null terminator
        times 8 db 0        ; 8 others char 
        db 2                ; 9 \t 
        db 2                ; 10 \n 
        times 2 db 0        ; 12 others char 
        db 2                ; 13 \r 
        times 18 db 0       ; 31 others char 
        db 2                ; 32 space 
        db 3                ; 33 !
        db 5                ; 34 "
        times 2 db 0        ; 36 others char 
        db 3                ; 37 % 
        db 3                ; 38 &
        db 5                ; 39 '
        db 4                ; 40 (
        db 4                ; 41 )
        db 3                ; 42 *
        db 3                ; 43 +
        times 1 db 0        ; 44 others char 
        db 3                ; 45 -
        times 1 db 0        ; 46 others char 
        db 3                ; 47 /
        times 10 db 7       ; 57 digit 
        db 4                ; 58 :
        db 4                ; 59 ; 
        db 3                ; 60 <
        db 3                ; 61 =
        db 3                ; 62 >
        db 6                ; 63 ?
        db 0                ; 64 others char
        times 26 db 6       ; 90 alphabet uppercase 
        db 4                ; 91 [
        db 3                ; 92 \
        db 4                ; 93 ]
        db 3                ; 94 ^
        db 9                ; 95 _
        db 0                ; 96 others char 
        times 26 db 6       ; 122 alphabet lowercase 
        db 4                ; 123 {
        db 0                ; 124 others char 
        db 4                ; 125 }
        times 130 db 0      ; 255 others char 

    ; =========== Table lookup for jump ===========
    align 256
    jump_table:
        dq handle_unknown       ; 0 handle uknown char 
        dq handle_eof           ; 1 handle eof or null terminator char 
        dq handle_whitespace    ; 2 handle whiespace 
        dq handle_operator      ; 3 handle operator char 
        dq handle_delimiter     ; 4 handle delimiter char 
        dq 

