#include <stdio.h>
#include <string.h>
#include <stdarg.h>

void myprintf(int prefix, const char* fmt, ...) {
    char tmp[8192];
    tmp[0] = '\0';
    if (prefix) {
        snprintf(tmp, sizeof(tmp), "[test] ");
    }
    va_list args;
    va_start(args, fmt);
    vsnprintf(tmp + strlen(tmp), sizeof(tmp) - strlen(tmp), fmt, args);
    va_end(args);
    printf("tmp=%s\n", tmp);
}

int main() {
    myprintf(1, "hello %s", "world");
    return 0;
}
