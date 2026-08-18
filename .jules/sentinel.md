## 2024-08-09 - [Defense in Depth] Replaced sprintf with snprintf
**Vulnerability:** Found uses of `sprintf` with fixed-size stack buffers (`tmpbuff` and `template`) that format strings containing environment variables (e.g. `TMP` and outputs of `GetTmpDir()`). If an attacker could control these environment variables to be very long strings, it could lead to a stack-based buffer overflow.
**Learning:** Even in seemingly innocent file path construction for temp files or procfs mapping, `sprintf` with environment-controlled variables poses a buffer overflow risk.
**Prevention:** Always use bounded string operations like `snprintf` with the correct `sizeof(buffer)` when formatting paths or strings, especially when incorporating data from external sources like environment variables.
