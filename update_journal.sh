mkdir -p .jules
cat << 'JOURNAL' >> .jules/sentinel.md
## 2024-05-18 - [CRITICAL] Fix buffer overflows in wrappedlibc
**Vulnerability:** Found multiple instances where `sprintf` was used with small, fixed-size buffers (e.g. 64 or 100 bytes) to format strings containing external input (like the `TMP` or `TMPDIR` environment variables). This allowed a malicious user to cause a stack-based buffer overflow by providing excessively long inputs.
**Learning:** Legacy C code often relies on `sprintf` and assumes environment variables or paths will fall within "reasonable" bounds, ignoring edge cases or malicious inputs.
**Prevention:** Always use `snprintf` with properly sized buffers (e.g. `4096` for standard maximum path lengths) when dealing with external inputs to ensure bounds checking and prevent stack corruption.
JOURNAL
