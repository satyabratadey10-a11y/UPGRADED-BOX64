## 2024-05-18 - Prevent Buffer Overflows with Path Variables
**Vulnerability:** Several places in the code used `strcpy()` and `strcat()` to copy user-supplied paths or dynamically constructed strings into fixed-size buffers, particularly those representing paths (e.g., `MAX_PATH` sized arrays). An example was found in `src/steam.c`, where user-controlled program paths were copied directly into a `MAX_PATH` buffer without bounds checking. Other instances were found in `src/tools/dynacache.c`.
**Learning:** Fixed-size buffers are common for path storage in C. However, blindly using `strcpy()` and `strcat()` with these buffers risks a buffer overflow if the source string length is unexpectedly long or manipulated by an attacker.
**Prevention:** Always use bounds-checking string manipulation functions when dealing with fixed-size arrays. Prefer `strncpy(dest, src, sizeof(dest) - 1); dest[sizeof(dest) - 1] = '\0';` over `strcpy()`. Similarly, prefer `strncat(dest, src, sizeof(dest) - strlen(dest) - 1);` over `strcat()`.

## 2025-02-23 - Widespread Buffer Overflow Vulnerabilities
**Vulnerability:** Extensive use of unbounded string manipulation functions like `sprintf` and `strcpy` throughout the C codebase (over 400 instances).
**Learning:** Legacy C habits or prioritizing speed/convenience over safety often leads to unchecked string operations, making the code susceptible to buffer overflows.
**Prevention:** Strictly enforce the use of bounds-checking equivalents (`snprintf`, `strncpy`) during code review and utilize static analysis tools (like SonarCloud or compiler warnings like `-Wformat-truncation`) to catch unbounded operations before they are merged.

## 2024-05-18 - [Fix sprintf Buffer Overflow Risk]
 **Vulnerability:** [Use of bounded string formatting (sprintf) risking buffer overflow]
 **Learning:** [Legacy C code commonly uses sprintf which can write past buffer bounds if inputs are unexpectedly large]
 **Prevention:** [Strictly use snprintf with sizeof(buffer) or dynamically calculated lengths rather than hardcoded numerical bounds]

## 2024-05-18 - Prevent Buffer Overflow with bounded string manipulation
**Vulnerability:** Unbounded string manipulation using `sprintf`.
**Learning:** `sprintf` writes data to a buffer without checking its length, which can lead to buffer overflow if the source string is longer than expected.
**Prevention:** Strictly use `snprintf` instead of `sprintf` throughout the codebase, providing the correct size of the destination buffer to prevent overflow and ensure robust defense-in-depth security practices.

## 2024-05-18 - [Insecure File Permissions]
**Vulnerability:** Found `chmod(cpuinfo_file, 0666)` called on files securely created by `mkstemp()`.
**Learning:** `mkstemp()` creates files with secure defaults (`0600`), and explicitly calling `chmod` with `0666` weakens these permissions unnecessarily, exposing temporary files to tampering by unprivileged users.
**Prevention:** Avoid explicit `chmod` calls on temporary files created by `mkstemp()` unless specifically required (and safely configured). Rely on secure defaults.
