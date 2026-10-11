#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <limits.h>

/* Returns 1 if directory has a valid ELF libc.so, 0 if it has a
   GNU ld script or invalid file (which would crash Android linker) */
static int dir_has_valid_libc(const char *dir) {
    char path[PATH_MAX];
    snprintf(path, sizeof(path), "%s/libc.so", dir);
    int fd = open(path, O_RDONLY);
    if (fd < 0) return 1; /* no libc.so here — safe to keep */
    unsigned char magic[4] = {0};
    ssize_t r = read(fd, magic, 4);
    close(fd);
    if (r < 4) return 0; /* too small — not a real ELF */
    return (magic[0]==0x7f && magic[1]=='E' &&
            magic[2]=='L'  && magic[3]=='F');
}

int main(int argc, char *argv[]) {
    /* Step 1: build clean LD_LIBRARY_PATH */
    char clean[32768];
    strncpy(clean, "/system/lib64:/vendor/lib64", sizeof(clean)-1);
    clean[sizeof(clean)-1] = '\0';

    const char *orig = getenv("LD_LIBRARY_PATH");
    if (orig) {
        char tmp[32768];
        strncpy(tmp, orig, sizeof(tmp)-1);
        tmp[sizeof(tmp)-1] = '\0';
        char *tok = strtok(tmp, ":");
        while (tok) {
            if (strcmp(tok,"/system/lib64") != 0 &&
                strcmp(tok,"/vendor/lib64") != 0 &&
                dir_has_valid_libc(tok)) {
                strncat(clean, ":", sizeof(clean)-strlen(clean)-1);
                strncat(clean, tok,  sizeof(clean)-strlen(clean)-1);
            }
            tok = strtok(NULL, ":");
        }
    }
    setenv("LD_LIBRARY_PATH", clean, 1);

    /* Step 2: find box64.real next to this launcher */
    char self[PATH_MAX] = {0};
    char real[PATH_MAX] = {0};
    ssize_t len = readlink("/proc/self/exe", self, sizeof(self)-1);
    if (len > 0) {
        self[len] = '\0';
        char *slash = strrchr(self, '/');
        if (slash) {
            *slash = '\0';
            snprintf(real, sizeof(real), "%s/box64.real", self);
        }
    }
    if (real[0]) execv(real, argv);

    /* Fallback: Winlator default path */
    execv("/data/data/com.winlator/files/rootfs/usr/local/bin/box64.real",
          argv);
    perror("box64 launcher: exec failed");
    return 1;
}
