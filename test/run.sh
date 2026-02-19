if [ $# -eq 0 ]; then
    echo "Tidak ada argumen. Gunakan: ./my_script.sh <argumen>"
    exit 1
fi

arg=$1

if [ "$arg" = "lexer" ]; then
    nasm -f elf32 ../src/utils/utils.s -o utils.o
    nasm -f elf32 ../src/lexer/lexer.s -o lexer.o
    gcc -m32 ./test_lexer.c utils.o -o test_lexer -no-pie
    ./test_lexer
    rm ./test_lexer ./utils.o ./lexer.o
fi