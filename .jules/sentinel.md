## 2026-08-18 - [Buffer Overflows from Environment Variables]
**Vulnerability:** Fixed-size buffers being populated by environment variables or functions depending on them using unbounded functions like `strcpy`, `strcat`, and `sprintf`. Specifically found in `src/tools/fileutils.c` (via `GTK2_RC_FILES`) and `src/wrapped/wrappedlibc.c` (via `TMPDIR`).
**Learning:** Even internal utility functions are susceptible to stack overflows when their input traces back to user-controllable environment variables. Fixed-size buffers (e.g., `char buf[100]`) are rarely sufficient for file paths.
**Prevention:** Always use `snprintf` and `strncat` when dealing with external inputs. Ensure buffer sizes for paths are sufficiently large (e.g., using `PATH_MAX` or at least `1024`).
