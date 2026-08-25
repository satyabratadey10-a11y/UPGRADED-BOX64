## 2024-05-18 - Prevent Buffer Overflows with Path Variables
**Vulnerability:** Several places in the code used `strcpy()` and `strcat()` to copy user-supplied paths or dynamically constructed strings into fixed-size buffers, particularly those representing paths (e.g., `MAX_PATH` sized arrays). An example was found in `src/steam.c`, where user-controlled program paths were copied directly into a `MAX_PATH` buffer without bounds checking. Other instances were found in `src/tools/dynacache.c`.
**Learning:** Fixed-size buffers are common for path storage in C. However, blindly using `strcpy()` and `strcat()` with these buffers risks a buffer overflow if the source string length is unexpectedly long or manipulated by an attacker.
**Prevention:** Always use bounds-checking string manipulation functions when dealing with fixed-size arrays. Prefer `strncpy(dest, src, sizeof(dest) - 1); dest[sizeof(dest) - 1] = '\0';` over `strcpy()`. Similarly, prefer `strncat(dest, src, sizeof(dest) - strlen(dest) - 1);` over `strcat()`.

## 2024-05-18 - Replacing sprintf with snprintf
**Vulnerability:** Use of unbounded string generation functions, such as `sprintf`, poses risks of buffer overflows, which can allow an attacker to overwrite memory buffers and cause unexpected crashes or even remote code execution.
**Learning:** `sprintf` was used in `src/tools/env.c`, `src/libtools/box32_inputevent.c`, and `src/libtools/signals.c` to format dynamic path variables and PIDs without bounds checking.
**Prevention:** Strictly use `snprintf` instead of `sprintf` throughout the C codebase to guard against buffer overflows and ensure robust defense-in-depth security practices.
