## 2024-05-18 - Buffer Overflow Prevention with snprintf
**Vulnerability:** Found multiple uses of `sprintf` writing to fixed-size buffers in `src/elfs/elfloader.c` (e.g., in `getAddrFunctionName` and `CreateMemorymapFile`).
**Learning:** `sprintf` does not check the bounds of the destination buffer, creating a buffer overflow vulnerability if the input string (such as the ELF name or path) is longer than the fixed size of the buffer.
**Prevention:** Replaced `sprintf` with `snprintf`, which includes a size parameter to restrict the number of characters written, thereby preventing the buffer overflow.
