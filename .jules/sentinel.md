## 2024-05-15 - Unbounded string copies (sprintf)
**Vulnerability:** Found uses of `sprintf` without bounds checking when manipulating paths and PIDs.
**Learning:** These exist likely due to convenience, but `sprintf` can overflow buffers.
**Prevention:** Strictly use bounded string manipulation functions like `snprintf` with explicit size arguments in this C codebase to prevent buffer overflows.
