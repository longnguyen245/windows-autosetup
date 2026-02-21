#!/bin/bash

. bin/utils.sh
. bin/contextMenu.sh

shopt -s nullglob

PWD=$(pwd)
ASSETS=$PWD/default/assets
DEBLOAT_LIST=
DEFAULT=$PWD/default
HOME=~
LIST_PC=(pc/*/)
PC=
PORTABLE_APPS_DIR=$HOME/portable_apps
SCOOP_DIR=$HOME/scoop
SCOOP_APPS=$SCOOP_DIR/apps
SCOOP_BUCKETS=$SCOOP_DIR/buckets
TMP=$PWD/tmp
WINDIR_64=/c/Windows/System32
WINDIR_32=/c/Windows/SysWOW64
WIN_EDITION=$(powershell -NoProfile -Command "(Get-ItemProperty 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion').EditionID" | tr -d '\r')
IS_WINDOWS_HOME=false

if [ "$WIN_EDITION" = "CoreSingleLanguage" ]; then
    IS_WINDOWS_HOME=true
else
    IS_WINDOWS_HOME=false
fi

if [ ${#LIST_PC[@]} -eq 0 ]; then
    mkdir -p "pc/my_pc"
    LIST_PC=(pc/*/)
fi

echo "Select a pc:"
i=1
for f in "${LIST_PC[@]}"; do
    echo "$i) $f"
    i=$((i+1))
done

read -p "Enter number: " choice
PC="${LIST_PC[$((choice-1))]}"
echo "You selected: $PC"

if [ -z "$PC" ] || [ ! -d "$PC" ]; then
    echo "Invalid selection. Exiting."
    exit
fi

reg_set true "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "ConsentPromptBehaviorAdmin" 0

# Setup
pc_files=("bucket.txt" "scoop.txt" "debloat.txt" "config.env")

for file in "${pc_files[@]}"; do
    if [ ! -f "${PC}${file}" ]; then
        touch "${PC}${file}"
        echo $DEFAULT/$file > "${PC}${file}"
    fi
done

if [ ! -f "${PC}config.local.env" ]; then
    touch "${PC}config.local.env"
    echo "NAME=" >> "${PC}config.local.env"
    echo "EMAIL=" >> "${PC}config.local.env"
    echo "WORKSPACES_DEFAULT=~" >> "${PC}config.local.env"
fi

if [ ! -f "${PC}custom.sh" ]; then
    touch "${PC}custom.sh"
    echo "#!/bin/bash" >> "${PC}custom.sh"
fi

if [ ! -d "${PC}assets" ]; then
    mkdir "${PC}assets"
    # touch "${PC}assets/placeholder"
fi
if [ ! -d $TMP ]; then
    mkdir $TMP
fi
if [ ! -d $PORTABLE_APPS_DIR ]; then
    mkdir $PORTABLE_APPS_DIR
fi

. $DEFAULT/config.env
. "${PC}config.env"
. "${PC}config.local.env"

cp -r $ASSETS $TMP
cp -r "${PC}"* $TMP

declare -a tmp_list
read_file_to_array $TMP/bucket.txt tmp_list

for bucket in "${tmp_list[@]}"; do
    if [ -n "$bucket" ]; then
        echo "Adding bucket: $bucket"
        scoop bucket add "$bucket"
    fi
done

# fix CA
echo "Installing CA certificates extracted from Mozilla"
DATA_SSL_DIR=/c/ProgramData/ssl
if [ ! -d $DATA_SSL_DIR ]; then
    mkdir $DATA_SSL_DIR
    cp "$ASSETS/ca/ca-bundle.pem" $DATA_SSL_DIR
fi

echo "scoop setup"
scoop config aria2-enabled false
scoop config aria2-options '--aria2-async-dns-enabled=true --some-other=param'
echo "Installing core packages"z
scoop install wget2 aria2 curl

echo "Git setup"
git config --global credential.helper manager
git config --global init.defaultBranch main
git config --global user.email $EMAIL
git config --global user.name $NAME
git config --global core.autocrlf true
git config --global core.autocrlf input

is_true $COMBINE_TASKBAR_BUTTONS_IS_FULL &&
reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarGlomLevel" 1

is_true $ENABLE_SHOW_HIDDEN_FILES &&
reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

is_true $ENABLE_SHOW_HIDDEN_EXTENSIONS &&
reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

is_true $DISABLE_SHOW_HIDDEN_SHOW_RECENTLY_FILES &&
reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowRecent" 0

is_true $DISABLE_SHOW_HIDDEN_SHOW_FREQUENTLY_FILES &&
reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowFrequent" 0

is_true $OPEN_EXPLORER_DEFAULT_WITH_THIS_PC &&
reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1

is_true $ENABLE_CLIPBOARD_HISTORY &&
reg_set false "HKCU:\Software\Microsoft\Clipboard" "EnableClipboardHistory" 1

if is_true $W11_USE_W10_CONTEXT_MENU; then
    powershell -Command 'New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force | Out-Null'
    powershell -Command 'Set-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(default)" -Value ""'
fi

[ -n "$TIME_ZONE" ] && powershell -Command "tzutil /s '$TIME_ZONE'"

is_true $ENABLE_UTC_TIME &&
reg_set true "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" "RealTimeIsUniversal" 1 "DWord"


if is_true $ENABLE_FORMAT_DATE; then
    reg_set false "HKCU:\Control Panel\International" "sShortDate" "'$FORMAT_DATE'" "String"
    reg_set false "HKCU:\Control Panel\International" "sShortTime" "'$FORMAT_TIME'" "String"
    reg_set false "HKCU:\Control Panel\International" "sTimeFormat" "'$FORMAT_TIME'" "String"
fi

if [ -n "$TIME_ZONE" ] || [ -n "$FORMAT_DATE" ] || [ -n "$FORMAT_TIME" ]; then
    powershell -Command "gsudo w32tm /resync"
fi

if is_true $COMBINE_TASKBAR_BUTTONS_IS_FULL ||
[ -n "$TIME_ZONE" ] || is_true $ENABLE_FORMAT_DATE; then
    powershell -Command "gsudo Stop-Process -Name explorer -Force"
fi

if is_true $SET_DEFAULT_WSL2; then
    powershell -Command "wsl --set-default-version 2"
else
    powershell -Command "wsl --set-default-version 1"
fi

if is_true $ENABLE_HYPER_V; then
    if is_true $IS_WINDOWS_HOME; then
        echo "Hyper-V is not available on Windows Home edition. Skipping Hyper-V enablement."
    else
        powershell -Command "gsudo Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart"
    fi
fi

is_true $ENABLE_WSL &&
powershell -Command "gsudo Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart"

if is_true $ENABLE_VIRTUAL_MACHINE; then
    powershell -Command "gsudo Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart"
    if is_true $IS_WINDOWS_HOME; then
        echo "Containers is limited on Windows Home edition. Some features may not be available."
    else
        powershell -Command "gsudo Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart"
    fi
fi

if is_true $ENABLE_SANDBOX; then
    if is_true $IS_WINDOWS_HOME; then
        echo "Windows Sandbox is not available on Windows Home edition. Skipping Sandbox enablement."
    else
        powershell -Command "gsudo Enable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -All -Online -NoRestart"
    fi
fi

if is_true $DISABLE_ADS; then
    reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" 0 DWord
    reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338387Enabled" 0 DWord
    reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338389Enabled" 0 DWord
    reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "RotatingLockScreenEnabled" 0 DWord
    reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "RotatingLockScreenOverlayEnabled" 0 DWord
    reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0 DWord
    reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" 0 DWord
    reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-314559Enabled" 0 DWord
    reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SoftLandingEnabled" 0 DWord
    reg_set true  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" "EnableFeeds" 0 DWord
    reg_set false "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDaEnabled" 0 DWord
    
    powershell -Command 'gsudo reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v LockScreenOverlaysDisabled /t REG_DWORD /d 1 /f'
    powershell -Command 'gsudo reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreenContent /t REG_DWORD /d 1 /f'
fi

if [ -f "$HOME/.bashrc" ]; then
    echo "File existed"
else
    echo "Creating $HOME/.bashrc"
    touch "$HOME/.bashrc"
    
    echo "export ASSETS=$ASSETS" >> $HOME/.bashrc
    echo "export WORKSPACES_DEFAULT=$WORKSPACES_DEFAULT" >> $HOME/.bashrc
    
    cat << 'EOF' >> "$HOME/.bashrc"
PROMPT_COMMAND='history -a'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

alias si='scoop install'
alias sui='scoop uninstall'
alias supdate='$ASSETS/cmds/scoopUpdate.cmd'
alias getwallpaper='$ASSETS/cmds/getCurrentWallpaperV2.cmd'
alias shrinkwsl='$ASSETS/cmds/shrink_wsl.cmd'

reboot() {
    /c/Windows/System32/shutdown.exe -r -t 0
}
restart() {
    reboot
}
shutdown() {
    /c/Windows/System32/shutdown.exe -s -t 0
}
cleantemp() {
    rm -rf /c/Users/$USER/AppData/Local/Temp/* 2>/dev/null
    rm -rf /c/Windows/Temp/* 2>/dev/null
    echo "Done"
}

CUR=$(realpath "$PWD")
WT1=$(realpath "$HOME/scoop/apps/windows-terminal/current")
WT2=$(realpath "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe")

if [ "$CUR" = "$WT1" ] || [ "$CUR" = "$WT2" ]; then
    cd $WORKSPACES_DEFAULT
fi

# ===== Helper Section =====
if [ ! -f "$HOME/.nohelper" ]; then
    echo "
si <app>           - Install an app with Scoop
sui <app>          - Uninstall an app with Scoop
supdate            - Update Scoop and installed apps
getwallpaper       - Get the current Windows wallpaper
shrinkwsl          - Shrink wsl2 disk
shutdown           - Shutdown
reboot/restart     - Restart
cleantemp          - Clean temp
------------------------------------------------------
disablehelper      - Disable this help section
"
fi

alias disablehelper='touch ~/.nohelper && echo "Helper disabled."'
alias enablehelper='rm -f ~/.nohelper && echo "Helper enabled."'
EOF
    
    echo "Applied bashrc settings"
fi

echo "Installing local fonts"
if [ ! -d "~/AppData/Local/Microsoft/Windows/Fonts" ]; then
    mkdir ~/AppData/Local/Microsoft/Windows/Fonts
fi
cp $TMP/assets/fonts/* ~/AppData/Local/Microsoft/Windows/Fonts

echo "Installing Windows Terminal"
if [ -d "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe" ]; then
    echo skipped
    if [ ! -f "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" ]; then
        cp $TMP/assets/configs/windowsTerminal/settings.json ~/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState
    fi
else
    scoop install windows-terminal
    if [ ! -f "$SCOOP_DIR/persist/windows-terminalt/settings/settings.json" ]; then
        cp $TMP/assets/configs/windowsTerminal/settings.json $SCOOP_DIR/persist/windows-terminal/settings
    fi
fi

# install key
if is_true $USE_VIETNAM_TYPING; then
    echo "Installing EVkey/Unikey"
    cp $TMP/assets/typing/$TYPING $TMP/key.zip
    rm -rf "$TMP/key"
    unzip "$TMP/key.zip" -d "$TMP/key"
    cp -r "$TMP/key" $PORTABLE_APPS_DIR -f
    EXE_DIR=
    
    [ -f "$TMP/key/UniKeyNT.exe" ] && EXE_DIR="$PORTABLE_APPS_DIR/key/UniKeyNT.exe"
    [ -f "$TMP/key/EVKey64.exe" ] && EXE_DIR="$PORTABLE_APPS_DIR/key/EVKey64.exe"
    
    # Use the shortcut name EVKey64 for Unikey, because if a shortcut named EVKey64 does not exist, it will create a new one. For Unikey, the shortcut name is not critical.
    create_shortcut \
    "$(convert_to_windows_path $EXE_DIR)" \
    "$(convert_to_windows_path "$PORTABLE_APPS_DIR/key/EVKey64.lnk")"
    cp -r $PORTABLE_APPS_DIR/key/EVKey64.lnk "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/"
    
    if [ ! -f "$PORTABLE_APPS_DIR/key/setting.ini" ]; then
        cp $TMP/assets/configs/evkey/setting.ini $PORTABLE_APPS_DIR/key
        echo "Copied $TMP/assets/configs/evkey/setting.ini"
    fi
    
    $EXE_DIR &
fi

# Scoop
declare -a tmp_list
read_file_to_array $TMP/scoop.txt tmp_list
for pkg in "${tmp_list[@]}"; do
    echo "Installing $pkg"
    gsudo scoop install "$pkg"
done

echo "Importing context menu"
find "$SCOOP_APPS" -type f -name "install-context.reg" | while read -r reg_file; do
    if [ -f "$reg_file" ]; then
        echo "Importing $reg_file..."
        reg import "$reg_file"
        if [ $? -eq 0 ]; then
            echo "Successfully imported $reg_file"
        else
            echo "Failed to import $reg_file"
        fi
    fi
done

# Debloat
declare -a tmp_list
read_file_to_array $TMP/debloat.txt tmp_list
for pkg in "${tmp_list[@]}"; do
    echo "Removing $pkg"
    if [ "$pkg" = "OneDrive" ]; then
        ONE_DRIVE_PATH="$WINDIR_64/OneDriveSetup.exe"
        if [ -f "$ONE_DRIVE_PATH" ]; then
            powershell.exe -NoProfile -Command "& {Start-Process '$(convert_to_windows_path $ONE_DRIVE_PATH)' -ArgumentList '/uninstall' -NoNewWindow -Wait}"
        fi
        ONE_DRIVE_PATH="$WINDIR_32/OneDriveSetup.exe"
        if [ -f "$ONE_DRIVE_PATH" ]; then
            powershell.exe -NoProfile -Command "& {Start-Process '$(convert_to_windows_path $ONE_DRIVE_PATH)' -ArgumentList '/uninstall' -NoNewWindow -Wait}"
        fi
    else
        gsudo powershell -Command "Get-AppxPackage *$pkg* | Remove-AppxPackage"
    fi
done

if is_true $CLEAR_SETUP_TMP_DIR; then
    rm -rf $TMP
fi

powershell -Command "gsudo scoop cleanup *"
powershell -Command "gsudo scoop cache rm *"

. "${PC}custom.sh"

reg_set true "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "ConsentPromptBehaviorAdmin" 5