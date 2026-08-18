## 2024-05-18 - [Prevent Buffer Overflow in Path Construction]
**Vulnerability:** Uses of `sprintf` into fixed-size buffers instead of `snprintf` in system information extraction (like `src/os/sysinfo.c`).
**Learning:** Even if buffers seem appropriately sized for expected inputs (e.g., `4096` bytes for paths, `64` bytes for integer strings), standard C functions without bounds checking (`sprintf`) violate defense-in-depth principles and are susceptible to buffer overflows if invariants change.
**Prevention:** Strictly enforce the use of `snprintf` over `sprintf` throughout the codebase, making bounded string manipulation the default practice.
