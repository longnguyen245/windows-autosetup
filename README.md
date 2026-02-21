# Windows Project Setup Guide

Quick guide for setting up and configuring the project on Windows. The project uses Git Bash and PowerShell; all required tools will be installed automatically.

---

## 📁 Configuration Behavior

The project supports **user customization via the `pc` directory**.

- The `default` directory contains the base (fallback) configuration.
- The `pc` directory is intended for **local user overrides**.
- **Do not modify files inside `default`.**

### 🔄 How it works

1. At runtime, the project checks for the presence of the `pc` directory.
2. If the `pc` directory does not exist, it will be **created automatically** with the required structure.
3. When the project runs:
   - Files inside `pc` will **override** corresponding files in `default`.
   - If a file is not present in `pc`, the version in `default` will be used.

### ✅ Recommended workflow

- Put all your custom configurations inside `pc`.
- Leave `default` untouched to avoid conflicts during updates.
- The system will automatically merge and prioritize `pc` over `default`.

### 📌 Priority order

```
pc/        (highest priority — user overrides)
default/   (fallback configuration)
```

This ensures your local changes are preserved while keeping the default configuration clean and update-safe.
