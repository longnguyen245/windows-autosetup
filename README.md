# Windows Project Setup Guide

Quick guide for setting up and configuring the project on Windows. The project uses gitbash and powershell, all will be installed automatically

---

## 1. Prepare Configuration

### Generate New PC Setup

- Double-click `generateNewPC.cmd` to create `pc/<myPC>/` using defaults from `localConfigs.sh`.
- Double-click `generateConfigs.cmd` to generate `ocalConfigs.sh`.

> Skip this if `pc/<myPC>/` and `localConfigs.sh` already exist.

---

## 2. Run Setup

Double-click `windows.cmd` to set up the environment and install applications based on your config files.

---

## 3. Directory Structure

```
project/
├── assets/*
├── pc/<myPC>/
│   ├── configs.sh
│   ├── packages.sh
│   └── assets/*
├── localConfigs.sh
├── *.cmd
└── README.md
```
don't edit `assets` folder, just edit in `pc/<myPC>/assets` everything will be overwritten

---

## 4. Configuration Details

### `configs.sh`

- Format: `KEY=1`
- Lines without `#` are **enabled**.
- Example:
  ```bash
  ENABLE_SHOW_HIDDEN_FILES=1       # Enabled
  #ENABLE_SHOW_HIDDEN_FILES=1      # Disabled
  ```
- Common options:
  - Read file `bin/default/configs.sh`

### `packages.sh`

- Lists apps to install automatically.
- functions: `scoop_install`, `scoop_install_admin`, `scoop_add_bucket`
  ```sh
  # example
  scoop_add_bucket java
  scoop_install python openjdk17  
  ```

### `localConfigs.sh`

Used when generating new PC folders:

```bash
NAME="Your Name"
EMAIL="you@example.com"
PC="myPC"
WORKSPACE_PATH="D:\\"
```

---

## 5. Update Source Code

Run `updateSource.cmd` to pull the latest changes.

---

## 6. Notes

- Do not edit files inside `assets/`. To override, use matching paths under `pc/<myPC>/assets/`.
- Replace `<myPC>` with your actual machine name (e.g., `as7`).
- Ensure all paths are valid on your system.

---

## Credits

- **Scoop**: Used for app installations – [https://scoop.sh](https://scoop.sh)
- **Grok**, **ChatGPT**: Used to generate parts of this documentation.