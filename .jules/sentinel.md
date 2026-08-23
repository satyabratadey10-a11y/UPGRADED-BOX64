## 2024-05-18 - Replace sprintf with snprintf to prevent buffer overflow
**Vulnerability:** Use of `sprintf` can lead to buffer overflows if the resulting string exceeds the allocated buffer size.
**Learning:** `sprintf` was used for formatting strings without bounding the output length to the buffer size, leading to potential buffer overflows if input data like symbol names are larger than expected.
**Prevention:** Always use bounded functions like `snprintf` when formatting strings, passing the buffer size to ensure memory safety.
