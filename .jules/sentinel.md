## 2024-08-16 - [Security] Prevent buffer overflow vulnerabilities
**Vulnerability:** Use of unbounded string functions `strcpy`, `strcat`, `sprintf`, `vsprintf` creating buffer overflow risks when formatting file paths and traces.
**Learning:** Legacy C code often relies on unbounded string operations. In `src/os/os_linux.c` and `src/os/os_wine.c`, local arrays were written to without bounds checking.
**Prevention:** Always use safe bounded equivalents: `snprintf` and `vsnprintf`. When concatenating, carefully track lengths to avoid over-calculating remaining space: `size_t len = strlen(buf); snprintf(buf + len, sizeof(buf) - len, ...);`.
