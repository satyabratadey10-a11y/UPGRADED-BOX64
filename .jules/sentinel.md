## $(date +%Y-%m-%d) - [Replace sprintf with snprintf in elfloader.c]
**Vulnerability:** Found multiple instances of `sprintf` being used to write to fixed-size buffers in `src/elfs/elfloader.c`.
**Learning:** `sprintf` does not perform bounds checking, leading to potential buffer overflow vulnerabilities if the formatted string exceeds the buffer size. This is a common pattern that needs remediation across the codebase.
**Prevention:** Always use `snprintf` with `sizeof(buffer)` instead of `sprintf` to ensure that writes are explicitly bounded and prevent overflow into adjacent memory segments.
