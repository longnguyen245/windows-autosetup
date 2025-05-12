#!/bin/bash

source ./bin/utils.sh

PWD=$(pwd)
HOME=~
SCOOP_DIR="$HOME/scoop"
SCOOP_APPS="$SCOOP_DIR/apps"
ASSETS=$PWD/assets

SETUP_TMP_DIR=./setup_tmp
PORTABLE_APPS_DIR=~/portable_apps
EVKEY_DOWNLOAD_LINK="https://github.com/lamquangminh/EVKey/releases/download/Release/EVKey.zip"

if [ ! -d $SETUP_TMP_DIR ]; then
    mkdir $SETUP_TMP_DIR
fi
if [ ! -d $PORTABLE_APPS_DIR ]; then
    mkdir $PORTABLE_APPS_DIR
fi

# fix CA
log INFO "Installing CA certificates extracted from Mozilla"
DATA_SSL_DIR=/c/ProgramData/ssl
if [ ! -d $DATA_SSL_DIR ]; then
    mkdir $DATA_SSL_DIR
    cp "$ASSETS/ca/ca-bundle.pem" $DATA_SSL_DIR
fi

# disable ConsentPromptBehaviorAdmin temporarily, will re-enable after setup completes
log INFO "Disabling ConsentPromptBehaviorAdmin"
run_powershell_command_with_admin "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0"

# Install chocolatey
log INFO "Installing chocolatey"
if [ -f "/c/ProgramData/chocolatey/bin/choco.exe" ]; then
    sudo choco upgrade chocolatey -y
else
    run_powershell_command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
fi

# log INFO "Disabling aria2 for scoop"
scoop config aria2-enabled false

# log INFO "Installing packages"

scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add java
scoop bucket add main
scoop bucket add versions
scoop update

scoop install wget2 openssl
scoop install innounp-unicode                # Inno Setup Unpacker
scoop install googlechrome brave firefox     # Browser
scoop install dos2unix scrcpy adb gsudo jadx # Tool
scoop install windows-terminal
scoop install vscode vscodium fnm sublime-text postman heidisql sourcetree android-studio android-clt mongodb mongodb-compass warp-terminal # Coding
scoop install python openjdk17                                                                                                              # Runtime lib
scoop install telegram ayugram neatdownloadmanager anydesk bifrost dolphin beyondcompare                                                    # Apps
scoop install Hack-NF firacode Cascadia-Code                                                                                                # Fonts

sudo scoop install vcredist-aio # Windows libs
sudo choco install warp -y      # 1111

log INFO "Setup Git"
git config --global credential.helper manager
git config --global init.defaultBranch main

log INFO "Importing context menu"
reg import $SCOOP_APPS/sublime-text/current/install-context.reg
reg import $SCOOP_APPS/vscodium/current/install-context.reg
reg import $SCOOP_APPS/vscode-insiders/current/install-context.reg
reg import $SCOOP_APPS/vscode/current/install-context.reg
reg import $SCOOP_APPS/7zip/current/install-context.reg

if [ -d "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe" ]; then
    echo skipped
    if [ ! -f "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" ]; then
        cp $ASSETS/configs/windowsTerminal/settings.json ~/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState
    fi
else
    scoop install extras/windows-terminal
    if [ ! -f "$SCOOP_APPS/windows-terminal/current/settings/settings.json" ]; then
        cp $ASSETS/configs/windowsTerminal/settings.json $SCOOP_APPS/windows-terminal/current/settings
    fi
fi

log INFO "Enabling UTC time"
reg import "$ASSETS/regs/WinUTCOn.reg"

# profiles setup
log INFO "Importing profiles settings"
cp $ASSETS/configs/profiles/.bashrc ~/
cp $ASSETS/configs/profiles/.zshrc ~/
mkdir -p ~/Documents/WindowsPowerShell
cp $ASSETS/configs/profiles/Microsoft.PowerShell_profile.ps1 ~/Documents/WindowsPowerShell
# remove fnm env
if [ -d $SCOOP_APPS/fnm ]; then
    echo skipped
else
    sed -i 's|eval "\$(fnm env --use-on-cd)"||' ~/.bashrc
    sed -i 's|eval "\$(fnm env --use-on-cd)"||' ~/.zshrc
    rm ~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1
fi

# install evkey
log INFO "Installing EVkey/Unikey"
wget2 -O "$SETUP_TMP_DIR/evkey.zip" $EVKEY_DOWNLOAD_LINK
rm -rf "$SETUP_TMP_DIR/evkey"
unzip "$SETUP_TMP_DIR/evkey.zip" -d "$SETUP_TMP_DIR/evkey"
cp -r "$SETUP_TMP_DIR/evkey" $PORTABLE_APPS_DIR -f
cp $ASSETS/configs/evkey/setting.ini $PORTABLE_APPS_DIR/evkey
"$PORTABLE_APPS_DIR/evkey/EVKey64.exe" & # run exe
create_shortcut \
    "$(convert_to_windows_path "$PORTABLE_APPS_DIR/evkey/EVKey64.exe")" \
    "$(convert_to_windows_path "$PORTABLE_APPS_DIR/evkey/EVKey64.lnk")"
cp -r $PORTABLE_APPS_DIR/evkey/EVKey64.lnk "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/"

# Install nodejs
run_powershell_command "fnm install 22"
run_powershell_command "fnm default 22"
run_powershell_command "npm install -g yarn pnpm"

# install local fonts
log INFO "Installing local fonts"
cp $ASSETS/fonts/* ~/AppData/Local/Microsoft/Windows/Fonts

# setup config for windows

log INFO "Setup windows"
# Enable show hidden files
run_powershell_command 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1'
# Enable show extension files
run_powershell_command 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0'
# Disable Show recently used files in Quick access
run_powershell_command 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowRecent -Value 0'
# set default version wsl
run_powershell_command "wsl --set-default-version 2"
# Enable VirtualMachine
run_powershell_command_with_admin "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart"
run_powershell_command_with_admin "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart"
run_powershell_command_with_admin "Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart"
run_powershell_command_with_admin "Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart"
# Enable Windows Sandbox
run_powershell_command_with_admin "Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart"
# Restoring ConsentPromptBehaviorAdmin
run_powershell_command_with_admin "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 5"

# cleanup
log INFO "Cleaning up"
rm -rf $SETUP_TMP_DIR
run_powershell_command "scoop cleanup *"
run_powershell_command "scoop cache rm *"
log SUCCESS "DONE"
