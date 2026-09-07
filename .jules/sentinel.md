## 2024-05-18 - Prevent Buffer Overflows with Path Variables
**Vulnerability:** Several places in the code used `strcpy()` and `strcat()` to copy user-supplied paths or dynamically constructed strings into fixed-size buffers, particularly those representing paths (e.g., `MAX_PATH` sized arrays). An example was found in `src/steam.c`, where user-controlled program paths were copied directly into a `MAX_PATH` buffer without bounds checking. Other instances were found in `src/tools/dynacache.c`.
**Learning:** Fixed-size buffers are common for path storage in C. However, blindly using `strcpy()` and `strcat()` with these buffers risks a buffer overflow if the source string length is unexpectedly long or manipulated by an attacker.
**Prevention:** Always use bounds-checking string manipulation functions when dealing with fixed-size arrays. Prefer `strncpy(dest, src, sizeof(dest) - 1); dest[sizeof(dest) - 1] = '\0';` over `strcpy()`. Similarly, prefer `strncat(dest, src, sizeof(dest) - strlen(dest) - 1);` over `strcat()`.

## 2024-05-18 - Prevent Buffer Overflows by replacing sprintf with snprintf
**Vulnerability:** Use of `sprintf` can lead to buffer overflows if the resulting formatted string exceeds the buffer size. In `src/elfs/elfloader.c`, `sprintf` was used to write to fixed-size buffers like `buff[1024]` and `rets[8][1000]`. If Elf names or symbol names are excessively long, this could overflow the buffers.
**Learning:** Hardcoded buffer sizes and unconstrained formatting functions (`sprintf`) are a common source of buffer overflow vulnerabilities, especially when dealing with dynamically loaded data like ELF files.
**Prevention:** Always use bounds-checking formatting functions like `snprintf` with the buffer size (`sizeof(buffer)`) to prevent overflows.
