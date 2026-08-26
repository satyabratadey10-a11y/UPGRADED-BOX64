## 2024-05-18 - Prevent Buffer Overflows with Path Variables
**Vulnerability:** Several places in the code used `strcpy()` and `strcat()` to copy user-supplied paths or dynamically constructed strings into fixed-size buffers, particularly those representing paths (e.g., `MAX_PATH` sized arrays). An example was found in `src/steam.c`, where user-controlled program paths were copied directly into a `MAX_PATH` buffer without bounds checking. Other instances were found in `src/tools/dynacache.c`.
**Learning:** Fixed-size buffers are common for path storage in C. However, blindly using `strcpy()` and `strcat()` with these buffers risks a buffer overflow if the source string length is unexpectedly long or manipulated by an attacker.
**Prevention:** Always use bounds-checking string manipulation functions when dealing with fixed-size arrays. Prefer `strncpy(dest, src, sizeof(dest) - 1); dest[sizeof(dest) - 1] = '\0';` over `strcpy()`. Similarly, prefer `strncat(dest, src, sizeof(dest) - strlen(dest) - 1);` over `strcat()`.

## 2024-10-18 - Replacing `sprintf` with `snprintf` for Buffer Overflow Prevention
**Vulnerability:** Found `sprintf` used to format symbol names into a fixed-size character array (`rets[8][1000]`) in `src/elfs/elfloader.c`.
**Learning:** Even if `sprintf` is mostly used with controlled or bounded inputs, unexpected dynamically constructed strings like long symbol names can exceed the array bounds. Relying on implicit bounds is a security vulnerability, and explicit bounds checking is required for a robust codebase.
**Prevention:** Always use bounds-checking functions like `snprintf` when formatting strings into fixed-size buffers, providing the size of the buffer to avoid overruns and ensure defense-in-depth.
