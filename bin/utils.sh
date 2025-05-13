#!/bin/bash

create_shortcut() {
    local target_path="$1"
    local shortcut_path="$2"

    powershell.exe -Command "
    \$wshShell = New-Object -ComObject WScript.Shell
    \$shortcut = \$wshShell.CreateShortcut('$shortcut_path')
    \$shortcut.TargetPath = '$target_path'
    \$shortcut.Save()
    Write-Host 'Shortcut created at: $shortcut_path'
    "
}

convert_to_windows_path() {
    local unix_path="$1"
    local win_path
    win_path=$(echo "$unix_path" | sed 's|^/c/|C:/|; s|/|\\|g')
    echo "$win_path"
}

escape_backslashes() {
    local input="$1"
    local escaped="${input//\\/\\\\}"
    echo "$escaped"
}

run_powershell_command() {
    powershell.exe -Command "$1"
}

run_powershell_command_with_admin() {
    gsudo powershell.exe -Command "$1"
}

log() {
    local level=$1
    local message=$2

    case "$level" in
    INFO)
        echo -e "\033[1;32m[INFO] $message\033[0m"
        ;;
    WARNING)
        echo -e "\033[1;33m[WARNING] $message\033[0m"
        ;;
    ERROR)
        echo -e "\033[1;31m[ERROR] $message\033[0m"
        ;;
    DEBUG)
        echo -e "\033[1;34m[DEBUG] $message\033[0m"
        ;;
    SUCCESS)
        echo -e "\033[1;36m[SUCCESS] $message\033[0m"
        ;;
    *)
        echo -e "\033[0m[LOG] $message\033[0m"
        ;;
    esac
}
