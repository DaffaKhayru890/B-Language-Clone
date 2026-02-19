#include <stdio.h>

extern void _read_file();
extern int bytes_read;
extern char source_code[];

int main() {
    printf("sebelum read_file\n");
    _read_file();
    printf("setelah read_file\n");
    printf("bytes_read=%d\n", bytes_read);
    return 0;
}