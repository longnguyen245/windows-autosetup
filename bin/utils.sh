is_true() {
    case "$1" in
        true|TRUE|True|1|yes|YES|Yes|on|ON)
        return 0 ;;   # true
        *)
        return 1 ;;   # false
    esac
}

escape_backslashes() {
    local input="$1"
    echo "${input//\\/\\\\}"
}

reg_set() {
    local need_admin="$1"   # true / false
    local path="$2"         # EX: HKCU:\Software\Microsoft\Windows...
    local name="$3"         # Value name
    local value="$4"        # Value
    local type="${5:-DWord}" # DWord default
    
    # Escape backslashes cho PowerShell
    path=$(escape_backslashes "$path")
    
    # PowerShell inline script
    local ps_script="
    if (!(Test-Path '$path')) {
        New-Item -Path '$path' -Force | Out-Null
    }
    New-ItemProperty -Path '$path' -Name '$name' -Value $value -PropertyType $type -Force | Out-Null
    "

    if [ "$need_admin" = "true" ]; then
        gsudo powershell -NoLogo -NoProfile -Command "$ps_script"
    else
        powershell -NoLogo -NoProfile -Command "$ps_script"
    fi
}

convert_to_windows_path() {
    local unix_path="$1"
    echo "$unix_path" | sed 's|^/c/|C:/|; s|/|\\|g'
}

create_shortcut() {
    local target="$1"
    local shortcut="$2"

    powershell.exe -NoProfile -Command "& {
        \$s=(New-Object -ComObject WScript.Shell).CreateShortcut('$shortcut');
        \$s.TargetPath='$target';
        \$s.Save()
    }"
}

read_file_to_array() {
    local file="$1"
    local -n arr_ref=$2
    arr_ref=()
    
    while IFS= read -r line || [ -n "$line" ]; do
        line=$(echo "$line" | tr -d '\r' | xargs)
        [ -n "$line" ] && arr_ref+=("$line")
    done < "$file"
}