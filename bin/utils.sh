#!/bin/bash

# Create a Windows shortcut using PowerShell
create_shortcut() {
    local target_path="$1"
    local shortcut_path="$2"

    local ps_script="
    \$wshShell = New-Object -ComObject WScript.Shell
    \$shortcut = \$wshShell.CreateShortcut('$shortcut_path')
    \$shortcut.TargetPath = '$target_path'
    \$shortcut.Save()
    Write-Host 'Shortcut created at: $shortcut_path'
    "
    powershell.exe -NoProfile -Command "$ps_script"
}

# Convert /c/Users/... to C:\Users\...
convert_to_windows_path() {
    local unix_path="$1"
    echo "$unix_path" | sed 's|^/c/|C:/|; s|/|\\|g'
}

# Escape backslashes for PowerShell strings
escape_backslashes() {
    local input="$1"
    echo "${input//\\/\\\\}"
}

# Run PowerShell command (non-admin)
run_powershell_command() {
    powershell.exe -NoProfile -Command "$1"
}

# Run PowerShell command as Administrator
run_powershell_command_with_admin() {
    gsudo powershell.exe -NoProfile -Command "$1"
}

# Colored logging
log() {
    local level="$1"
    local message="$2"

    case "$level" in
    INFO) echo -e "\033[1;32m[INFO] $message\033[0m" ;;
    WARNING) echo -e "\033[1;33m[WARNING] $message\033[0m" ;;
    ERROR) echo -e "\033[1;31m[ERROR] $message\033[0m" ;;
    DEBUG) echo -e "\033[1;34m[DEBUG] $message\033[0m" ;;
    SUCCESS) echo -e "\033[1;36m[SUCCESS] $message\033[0m" ;;
    *) echo -e "\033[0m[LOG] $message\033[0m" ;;
    esac
}
