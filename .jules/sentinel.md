
## 2024-05-24 - [sprintf() buffer overflow vulnerability pattern]
**Vulnerability:** Unbounded string formatting using `sprintf()`.
**Learning:** Legacy C string manipulation functions were used which do not check bounds. Found heavily utilized throughout `src/elfs/elfloader.c`.
**Prevention:** Always use `snprintf()` and specify the maximum length of the destination buffer to prevent buffer overflows.
