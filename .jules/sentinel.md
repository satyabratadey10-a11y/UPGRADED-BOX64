## 2024-05-24 - Buffer overflow risks with vsprintf
**Vulnerability:** Use of `vsprintf` in `PrintfFtrace` (src/os/os_linux.c) and in `src/os/os_wine.c` without bounds checking.
**Learning:** Unbounded string formatting can easily lead to buffer overflow if the formatted string length exceeds the allocated buffer. In this case, `tmp` (8192 bytes) and `buf` (1024 bytes) are used.
**Prevention:** Use `vsnprintf` instead of `vsprintf` and ensure the buffer size is passed correctly.
