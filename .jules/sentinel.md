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

## 2024-05-18 - [Prevent Buffer Overflow in Path Construction]
**Vulnerability:** Uses of `sprintf` into fixed-size buffers instead of `snprintf` in system information extraction (like `src/os/sysinfo.c`).
**Learning:** Even if buffers seem appropriately sized for expected inputs (e.g., `4096` bytes for paths, `64` bytes for integer strings), standard C functions without bounds checking (`sprintf`) violate defense-in-depth principles and are susceptible to buffer overflows if invariants change.
**Prevention:** Strictly enforce the use of `snprintf` over `sprintf` throughout the codebase, making bounded string manipulation the default practice.

## 2024-08-16 - [Security] Prevent buffer overflow vulnerabilities
**Vulnerability:** Use of unbounded string functions `strcpy`, `strcat`, `sprintf`, `vsprintf` creating buffer overflow risks when formatting file paths and traces.
**Learning:** Legacy C code often relies on unbounded string operations. In `src/os/os_linux.c` and `src/os/os_wine.c`, local arrays were written to without bounds checking.
**Prevention:** Always use safe bounded equivalents: `snprintf` and `vsnprintf`. When concatenating, carefully track lengths to avoid over-calculating remaining space: `size_t len = strlen(buf); snprintf(buf + len, sizeof(buf) - len, ...);`.

## 2025-02-20 - [Buffer Overflow in BOX64_TRACE_FILE]
**Vulnerability:** Buffer overflow using `strcpy` and `strcat` when expanding `%pid` in `BOX64_TRACE_FILE` environment variable.
**Learning:** Legacy string manipulation functions (`strcpy`, `strcat`, and even `strncpy` without length checks) are used extensively for environment variables. Even minor features like trace logging can be a vector for memory corruption if bounds aren't checked.
**Prevention:** Consistently use bounds-checking string operations like `snprintf` when handling any user-provided data, especially environment variables, to avoid overflows.

## 2024-05-18 - Prevent Buffer Overflows on MAX_PATH Strings
**Vulnerability:** Unbounded `strcpy` and `strcat` functions were used to write into arrays sized `MAX_PATH` (e.g., `char file[MAX_PATH] = {0};`) in `src/steam.c`, leading to potential buffer overflow if path strings exceed 4096 characters.
**Learning:** This codebase frequently performs string manipulation on file paths where it's assumed lengths won't exceed standard limits, which is risky when dealing with external environments like steam runtime paths.
**Prevention:** Always use bounded string manipulation functions (`strncpy`, `strncat`) and ensure explicit null-termination of the buffer (e.g., `buffer[sizeof(buffer) - 1] = '\0'`) to prevent buffer overflows.
