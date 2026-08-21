## 2024-05-18 - Prevent Buffer Overflows on MAX_PATH Strings
**Vulnerability:** Unbounded `strcpy` and `strcat` functions were used to write into arrays sized `MAX_PATH` (e.g., `char file[MAX_PATH] = {0};`) in `src/steam.c`, leading to potential buffer overflow if path strings exceed 4096 characters.
**Learning:** This codebase frequently performs string manipulation on file paths where it's assumed lengths won't exceed standard limits, which is risky when dealing with external environments like steam runtime paths.
**Prevention:** Always use bounded string manipulation functions (`strncpy`, `strncat`) and ensure explicit null-termination of the buffer (e.g., `buffer[sizeof(buffer) - 1] = '\0'`) to prevent buffer overflows.
