# Box64 Bugs and Glitches Report
## Potential Buffer Overflows
Found 310 uses of `sprintf` and 104 uses of `strcpy`. These should be replaced with `snprintf` and `strncpy` to prevent buffer overflows.

### Examples of `sprintf` usage:
1830:                sprintf(buff, "%s%*s\n", line, 74-l, h->name);
1833:                sprintf(buff, "%s%*s\n", line, 74-l, "[stack]");
2149:            sprintf(ret, "%s + 0x%lx + 0x%lx", ElfName(elf), start - (uintptr_t)GetBaseAddress(elf), addr - start);
2151:            sprintf(ret, "%s/%s", ElfName(elf), symbname);
2153:            sprintf(ret, "%s/%s + 0x%lx", ElfName(elf), symbname, addr - start);

### Examples of `strcpy` usage:
31:            strcpy(info->cpuname, getenv("BOX64_SYSINFO_CPUNAME"));
34:            strcpy(info->cpuname, "Unknown CPU");
92:                strcpy(info->cpuname, start);
135:                    strcpy(info->cpuname, start);
159:        strcpy(info->cpuname, "Unknown CPU");

## Compilation Warnings
Found 44 compilation warnings during a build.

Examples include:
- \`warning: ignoring return value of ‘write’ declared with attribute ‘warn_unused_result’ [-Wunused-result]\` in \`src/os/os_linux.c\`
- \`warning: ‘%04lu’ directive output may be truncated writing 4 bytes into a region of size between 3 and 31 [-Wformat-truncation=]\` in \`src/build_info.h\`
- \`warning: argument 1 null where non-null expected [-Wnonnull]\` in \`src/libtools/threads.c\`

These should be addressed to ensure robustness, specifically because SonarCloud enforces strict C reliability ratings and will fail builds on code warnings.
## Thread Attribute Null Warning

There are numerous warnings related to \`pthread_attr\` manipulation in \`src/libtools/threads.c\`:
\`\`\`
/app/src/libtools/threads.c:365:19: warning: argument 1 null where non-null expected [-Wnonnull]
\`\`\`
This suggests that \`PTHREAD_ATTR(attr)\` might be evaluating to NULL or that \`attr\` itself is occasionally passed as NULL without being checked, which could lead to undefined behavior or segmentation faults in a multithreaded environment.
## Unchecked Return Values
In \`src/os/os_linux.c\`, the return values of \`write\` are ignored.
\`\`\`
src/os/os_linux.c:228:9: warning: ignoring return value of ‘write’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
\`\`\`
This should be checked, or the result of \`write\` should be cast to \`(void)\` properly to silence the warning if ignoring it is strictly intended, although handling errors is always preferable for system calls.

## Format Truncation Warnings
In \`src/build_info.h\`, there are several format truncation warnings:
\`\`\`
/app/src/build_info.h:34:19: warning: ‘%04lu’ directive output may be truncated writing 4 bytes into a region of size between 3 and 31 [-Wformat-truncation=]
\`\`\`
These suggest that fixed-size buffers are potentially too small to hold the formatted output string when bounds checking via \`snprintf\` is used. Buffer sizes should be increased or the format string should be validated.
## Thread-Safety Warnings (Lack of TLS)
In \`src/os/os_linux.c\`:
\`\`\`c
static __thread char native_name[500] = { 0 };
\`\`\`
This string buffer is thread-local (\`__thread\`), which is good, but in \`src/os/sysinfo.c\` there are potentially non-thread-safe uses.

## Subprocess Resource Leak
In \`src/os/sysinfo.c\`:
\`\`\`c
    if (!info->read_cpuname || !info->read_ncpu || !info->read_frequency) {
        FILE* f = popen("lscpu", "r");
        if (!f) goto fallback;
        while (fgets(line, sizeof(line), f)) {
            // ...
        }
    }
\`\`\`
The file pointer \`f\` from \`popen\` might not be properly closed with \`pclose(f)\` when \`goto fallback\` or the loop finishes without closing it (need to check the full context but often these leak).

## Summary
These represent the major areas of bugs and glitches identified during the review.
