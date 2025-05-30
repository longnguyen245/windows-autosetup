#!/bin/bash

source ./bin/utils.sh
source ./bin/scoop.sh
source ./bin/external.sh
source ./bin/contextMenu.sh
source ./localConfigs.sh
if [ -z $PC ]; then
    log ERROR "PC name is not defined, you need to define it in localConfigs.sh"
    exit
else
    log INFO "PC is: $PC"
fi
source ./pc/$PC/configs.sh

PWD=$(pwd)
HOME=~
SCOOP_DIR="$HOME/scoop"
SCOOP_APPS="$SCOOP_DIR/apps"
REAL_ASSETS=$PWD/assets
ASSETS=$PWD/tmp
PC_DIR=$PWD/pc/$PC

export SETUP_TMP_DIR=$PWD/setup_tmp
PORTABLE_APPS_DIR=~/portable_apps

if [ ! -d $SETUP_TMP_DIR ]; then
    mkdir $SETUP_TMP_DIR
fi
if [ ! -d $PORTABLE_APPS_DIR ]; then
    mkdir $PORTABLE_APPS_DIR
fi

# copy tmp
rm -rf $ASSETS
cp -r $REAL_ASSETS $ASSETS
cp -r ./pc/$PC/assets/* $ASSETS

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

# log INFO "Disabling aria2 for scoop"
if [ ! -z $SCOOP_ARIA2 ]; then
    scoop config aria2-enabled true
else
    scoop config aria2-enabled false
fi

log INFO "Installing core packages"
scoop_install wget2 aria2 curl

log INFO "Installing packages"
source ./pc/$PC/packages.sh

log INFO "Setup Git"
git config --global credential.helper manager
git config --global init.defaultBranch main
git config --global user.email $EMAIL
git config --global user.name $NAME

# check windows terminal
sed -i "s|START_DIR|$(escape_backslashes $WORKSPACE_PATH)|g" "$ASSETS/configs/windowsTerminal/settings.json"
if [ -d "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe" ]; then
    echo skipped
    if [ ! -f "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" ]; then
        cp $ASSETS/configs/windowsTerminal/settings.json ~/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState
    fi
else
    scoop install extras/windows-terminal
    if [ ! -f "$SCOOP_DIR/persist/windows-terminalt/settings/settings.json" ]; then
        cp $ASSETS/configs/windowsTerminal/settings.json $SCOOP_DIR/persist/windows-terminalt/settings
    fi
fi

log INFO "Importing context menu"
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

if [ ! -z $ENABLE_UTC_TIME ]; then
    log INFO "Enabling UTC time"
    run_powershell_command_with_admin "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' -Name 'RealTimeIsUniversal' -Value 1 -Type DWord"
fi

# install key
if [ ! -z $TYPING_VIETNAMESE_LINK ]; then
    log INFO "Installing EVkey/Unikey"
    aria2c -d $SETUP_TMP_DIR -o key.zip $TYPING_VIETNAMESE_LINK
    rm -rf "$SETUP_TMP_DIR/key"
    unzip "$SETUP_TMP_DIR/key.zip" -d "$SETUP_TMP_DIR/key"
    cp -r "$SETUP_TMP_DIR/key" $PORTABLE_APPS_DIR -f

    if [ -f "$SETUP_TMP_DIR/key/UniKeyNT.exe" ]; then
        "$PORTABLE_APPS_DIR/key/UniKeyNT.exe" & # run exe
        if [ ! -z $AUTOSTART_WITH_WINDOWS ]; then
            create_shortcut \
                "$(convert_to_windows_path "$PORTABLE_APPS_DIR/key/UniKeyNT.exe")" \
                "$(convert_to_windows_path "$PORTABLE_APPS_DIR/key/UniKeyNT.lnk")"
            cp -r $PORTABLE_APPS_DIR/key/UniKeyNT.lnk "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/"
        fi
    fi

    if [ -f "$SETUP_TMP_DIR/key/EVKey64.exe" ]; then
        cp $ASSETS/configs/evkey/setting.ini $PORTABLE_APPS_DIR/key
        "$PORTABLE_APPS_DIR/key/EVKey64.exe" & # run exe
        if [ ! -z $AUTOSTART_WITH_WINDOWS ]; then
            create_shortcut \
                "$(convert_to_windows_path "$PORTABLE_APPS_DIR/key/EVKey64.exe")" \
                "$(convert_to_windows_path "$PORTABLE_APPS_DIR/key/EVKey64.lnk")"
            cp -r $PORTABLE_APPS_DIR/key/EVKey64.lnk "$HOME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/"
        fi
    fi
fi

# Install nodejs
if [ ! -z $INSTALL_NODEJS ]; then
    scoop_install fnm
fi
if [ ! -z $NODEJS_VERSION ]; then
    run_powershell_command "fnm install $NODEJS_VERSION"
    run_powershell_command "fnm default $NODEJS_VERSION"
fi
if [ ! -z "$NODEJS_GLOBAL_PACKAGES" ]; then
    run_powershell_command "npm install -g $NODEJS_GLOBAL_PACKAGES"
fi
# install local fonts
log INFO "Installing local fonts"
if [ ! -d "~/AppData/Local/Microsoft/Windows/Fonts" ]; then
    mkdir ~/AppData/Local/Microsoft/Windows/Fonts
fi
cp $ASSETS/fonts/* ~/AppData/Local/Microsoft/Windows/Fonts

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

# setup config for windows

log INFO "Setup windows"

[ ! -z "$COMBINE_TASKBAR_BUTTONS_IS_FULL" ] && run_powershell_command 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 1'
[ ! -z "$ENABLE_SHOW_HIDDEN_FILES" ] && run_powershell_command 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1'
[ ! -z "$ENABLE_SHOW_HIDDEN_EXTENSIONS" ] && run_powershell_command 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0'
[ ! -z "$DISABLE_SHOW_HIDDEN_SHOW_RECENTLY_FILES" ] && run_powershell_command 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowRecent -Value 0'
[ ! -z "$DISABLE_SHOW_HIDDEN_SHOW_FREQUENTLY_FILES" ] && run_powershell_command 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowFrequent -Value 0'
[ ! -z "$OPEN_EXPLORER_DEFAULT_WITH_THIS_PC" ] && run_powershell_command 'Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name LaunchTo -Value 1'

# Date & time format
[ ! -z "$TIME_ZONE" ] && run_powershell_command "tzutil /s '$TIME_ZONE'"
[ ! -z "$FORMAT_DATE" ] && run_powershell_command "Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sShortDate -Value '$FORMAT_DATE'"
[ ! -z "$FORMAT_TIME" ] && {
    run_powershell_command "Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sShortTime -Value '$FORMAT_TIME'"
    run_powershell_command "Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sTimeFormat -Value '$FORMAT_TIME'"
}

# restart explorer
[ ! -z "$TIME_ZONE" ] || [ ! -z "$FORMAT_DATE" ] || [ ! -z "$FORMAT_TIME" ] || [ ! -z $COMBINE_TASKBAR_BUTTONS_IS_FULL ] && run_powershell_command_with_admin "Stop-Process -Name explorer -Force"

# set default version wsl
[ ! -z $SET_DEFAULT_WSL2 ] && run_powershell_command "wsl --set-default-version 2"

# Enable VirtualMachine
[ ! -z $ENABLE_HYPER_V ] && run_powershell_command_with_admin "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart"

[ ! -z $ENABLE_WSL ] && run_powershell_command_with_admin "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart"
[ ! -z $ENABLE_VIRTUAL_MACHINE ] && {
    run_powershell_command_with_admin "Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart"
    run_powershell_command_with_admin "Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart"
}
# Enable Windows Sandbox
[ ! -z $ENABLE_SANDBOX ] && run_powershell_command_with_admin "Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart"

# Restoring ConsentPromptBehaviorAdmin
run_powershell_command_with_admin "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 5"

# cleanup
log INFO "Cleaning up"
if [ ! -z $CLEAR_SETUP_TMP_DIR ]; then
    rm -rf $SETUP_TMP_DIR
fi
rm -rf $ASSETS
run_powershell_command "scoop cleanup *"
run_powershell_command "scoop cache rm *"
log SUCCESS "DONE"
