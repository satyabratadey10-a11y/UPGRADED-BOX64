## 2024-05-18 - [Insecure File Permissions]
**Vulnerability:** Found `chmod(cpuinfo_file, 0666)` called on files securely created by `mkstemp()`.
**Learning:** `mkstemp()` creates files with secure defaults (`0600`), and explicitly calling `chmod` with `0666` weakens these permissions unnecessarily, exposing temporary files to tampering by unprivileged users.
**Prevention:** Avoid explicit `chmod` calls on temporary files created by `mkstemp()` unless specifically required (and safely configured). Rely on secure defaults.
