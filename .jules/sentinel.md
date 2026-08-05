## 2025-02-20 - [Buffer Overflow in BOX64_TRACE_FILE]
**Vulnerability:** Buffer overflow using `strcpy` and `strcat` when expanding `%pid` in `BOX64_TRACE_FILE` environment variable.
**Learning:** Legacy string manipulation functions (`strcpy`, `strcat`, and even `strncpy` without length checks) are used extensively for environment variables. Even minor features like trace logging can be a vector for memory corruption if bounds aren't checked.
**Prevention:** Consistently use bounds-checking string operations like `snprintf` when handling any user-provided data, especially environment variables, to avoid overflows.
