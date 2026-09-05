## 2024-05-18 - Prevent Buffer Overflows with Path Variables
**Vulnerability:** Several places in the code used `strcpy()` and `strcat()` to copy user-supplied paths or dynamically constructed strings into fixed-size buffers, particularly those representing paths (e.g., `MAX_PATH` sized arrays). An example was found in `src/steam.c`, where user-controlled program paths were copied directly into a `MAX_PATH` buffer without bounds checking. Other instances were found in `src/tools/dynacache.c`.
**Learning:** Fixed-size buffers are common for path storage in C. However, blindly using `strcpy()` and `strcat()` with these buffers risks a buffer overflow if the source string length is unexpectedly long or manipulated by an attacker.
**Prevention:** Always use bounds-checking string manipulation functions when dealing with fixed-size arrays. Prefer `strncpy(dest, src, sizeof(dest) - 1); dest[sizeof(dest) - 1] = '\0';` over `strcpy()`. Similarly, prefer `strncat(dest, src, sizeof(dest) - strlen(dest) - 1);` over `strcat()`.
## 2024-05-24 - Buffer Overflow Prevention in ELF Loader
 **Vulnerability:** Unbounded `sprintf` used with fixed-size string buffers (`buff` and `ret`) in `elfloader.c`, risking potential buffer overflows.
 **Learning:** Hardcoded fixed-size buffers were manipulated with `sprintf` which assumes the input length will never exceed the limit.
 **Prevention:** Strictly use `snprintf` with `sizeof(buffer)` instead of `sprintf` throughout the C codebase to ensure safety constraints stay synchronized.
