if [ $# -eq 0 ]; then
    echo "Tidak ada argumen. Gunakan: ./my_script.sh <argumen>"
    exit 1
fi

arg=$1

if [ "$arg" = "lexer" ]; then
    nasm -f elf64 ../src/lexer/lexer_x86.s -o lexer.o
    nasm -f elf64 ../src/lookup/lookup_x86.s -o lookup.o
    nasm -f elf64 ../src/utils/read_file_x86.s -o read_file.o
    nasm -f elf64 ./test_lexer_x86.s -o test_lexer.o

    ld lexer.o lookup.o read_file.o test_lexer.o -o B 
    ./B 
    rm lexer.o lookup.o read_file.o test_lexer.o B
fi