## YYYY-MM-DD - [Buffer Overflow fixes]
**Vulnerability:** Found buffer overflows involving fixed-size buffers with strcpy and sprintf (e.g. char tmpbuff[100]; sprintf(tmpbuff, "%s...", getenv("TMP"));).
**Learning:** This codebase uses standard libc functions where unbounded versions like strcpy and sprintf can lead to stack buffer overflows.
**Prevention:** Always use bounds-checking versions such as snprintf with sizeof(buffer) to ensure buffers cannot be overflowed.
