# Run this command first and then run the ps1 file in powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Variables
$pathRoot = $PSScriptRoot 
$evkeyLinkDownload = "https://github.com/lamquangminh/EVKey/releases/download/Release/EVKey.zip"
$evkeyPathFile = "$HOME\Desktop\evkey.zip"
$evkeyPathFolder = "$HOME\PortableApps\evkey"
$evkeyConfigFile = $pathRoot + "\config\evkey\setting.ini"
$evKeyexeFile = $evkeyPathFolder + "\EVKey64.exe"
$powershellFnmEnv = "fnm env --use-on-cd | Out-String | Invoke-Expression"
$bashAndZshFnmEnv = 'eval "$(fnm env --use-on-cd)"'
$pathConfigWindowTerminal = "$HOME\scoop\apps\windows-terminal\current\settings"
$pathFileConfigWindowTerminal = $pathRoot + "\config\windowsTerminal\settings.json"

# Functions
function Write-Start {
    param (
        $msg
    )
    Write-Host $msg -ForegroundColor Green; Write-Host
}
function Write-Done {
    Write-Host "DONE" -ForegroundColor Green; Write-Host
}

Function setEnvFnm {
    param (
        $shell
    )
    
    switch ($shell) {
        "ps1" { SetEnvToShell -name 'Powershell' -shellPath $PROFILE -envCode $powershellFnmEnv }
        "bash" { 
            SetEnvToShell -name 'Bash' -shellPath "$HOME\.bashrc" -envCode $bashAndZshFnmEnv 
            dos2unix.exe -r -v -f -D utf8 "$HOME\.bashrc" 
        }
        "zsh" {
            SetEnvToShell -name 'Zsh' -shellPath "$HOME\.zshrc" -envCode $bashAndZshFnmEnv
            dos2unix.exe -r -v -f -D utf8 "$HOME\.bashrc"  
        }
        Default {}
    }
}

Function SetEnvToShell {
    param (
        $name, $shellPath, $envCode
    )

    If (test-path $shellPath) {
        $fileContent = Get-Content -Path $shellPath
        $result = $fileContent -like $envCode

        If ($result -ne $null) {
            Write-Host "$name FnmEnv existed" 
        }
        Else {
            "`n$envCode" >> $shellPath
            Write-Host "$name FnmEnv created" 
        }
    }
    Else {
        Write-Host "$name FnmEnv created" 
        New-Item -Path $shellPath -Type File -Force
        "`n$envCode" >> $shellPath
    }
}

# Start
Start-Process -Wait powershell -verb runas -ArgumentList "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0"
                                        
#
Write-Start -msg "Installing Scoop"

if (Get-Command scoop -errorAction SilentlyContinue) {
    Write-Warning "Scoop already installed"
}
else {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
}
Write-Done

Write-Start -msg "Initializing Scoop..."
scoop install git
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add java
scoop bucket add main
scoop bucket add versions
scoop update
Write-Done

Write-Start -msg "Installing Scoop's packages"
scoop install firefox googlechrome <# Web browser #> 
scoop install extras/windows-terminal main/dos2unix <# Tool #>
scoop install vscode versions/vscode-insiders extras/vscodium main/fnm extras/sublime-text postman extras/heidisql <# Coding #>
scoop install vcredist-aio python <# Runtime lib #> 
# Start-Process -Wait powershell -verb runas -ArgumentList "scoop install vcredist-aio"
scoop install extras/telegram extras/neatdownloadmanager <# Apps #> 
Write-Done

Write-Start -msg "Installing Fonts"
scoop install nerd-fonts/FiraCode-NF
Start-Process -Wait powershell -verb runas -ArgumentList "$pathRoot\psfiles\installFonts.ps1" 
Write-Done

Write-Start -msg "Set Env shell"
setEnvFnm -shell "ps1"
setEnvFnm -shell "bash"
setEnvFnm -shell "zsh"
Write-Done

Write-Start -msg "Set Git Credential Manager Core"
Start-Process -Wait powershell -verb runas -ArgumentList "git config --global credential.helper manager"
Write-Done

Write-Start -msg "Installing NodeJS in fnm"
Start-Process -Wait powershell -verb runas -ArgumentList "fnm install 18"
Start-Process -Wait powershell -verb runas -ArgumentList "fnm use 18"
Write-Done

Write-Start -msg "Installing Modules global Nodejs"
Start-Process -Wait powershell -verb runas -ArgumentList "npm install --verbose;npm install -g yarn pnpm"
Write-Done

Write-Start -msg "Setup fnm env"
fnm env --use-on-cd | Out-String | Invoke-Expression
Write-Done

Write-Start -msg "Add Windows Terminal as a context menu option"
reg import "$HOME\scoop\apps\windows-terminal\current\install-context.reg"
Write-Done

Write-Start -msg "Add Sublime Text as a context menu option"
reg import "$HOME\scoop\apps\sublime-text\current\install-context.reg"
Write-Done

Write-Start -msg "Add VSCodium as a context menu option, For file associations"
reg import "$HOME\scoop\apps\vscodium\current\install-context.reg"
reg import "$HOME\scoop\apps\vscodium\current\install-associations.reg"
Write-Done

Write-Start -msg "Add VSCode Insiders as a context menu option, For file associations"
reg import "$HOME\scoop\apps\vscode-insiders\current\install-context.reg"
reg import "$HOME\scoop\apps\vscode-insiders\current\install-associations.reg"
Write-Done

Write-Start -msg "Add VSCode as a context menu option, For file associations"
reg import "$HOME\scoop\apps\vscode\current\install-context.reg"
reg import "$HOME\scoop\apps\vscode\current\install-associations.reg"
Write-Done

Write-Start -msg "Add 7zip as a context menu option"
reg import "$HOME\scoop\apps\7zip\current\install-context.reg"
Write-Done

Write-Start -msg "Installing Evkey"
If (Test-Path -Path $evKeyexeFile -PathType Leaf) {
    Write-Warning "Evkey installed"
    Start-Process $evKeyexeFile
}
Else {
    # if (Test-Path -Path $evkeyPathFolder) {
    #     Remove-Item -Path $evkeyPathFolder -Recurse -Include *.*
    # } 
    Write-Host "Downloading evkey"
    Invoke-WebRequest $evkeyLinkDownload -OutFile $evkeyPathFile
    Write-Host "Extracting evkey"
    Expand-Archive -Path $evkeyPathFile -DestinationPath $evkeyPathFolder -Force

    Write-Host "Setup config evkey"
    If (Test-Path -Path $evkeyPathFolder) {
        Copy-Item $evkeyConfigFile -Destination $evkeyPathFolder -Force
        Start-Process $evKeyexeFile
    }

    Write-Host "Delete evkey.zip"
    If (Test-Path -Path $evkeyPathFile -PathType Leaf) {
        Remove-Item -Path $evkeyPathFile 
    } 
}
Write-Done

Write-Start -msg "Setup config Windows terminal"
If (test-path "$pathConfigWindowTerminal\settings.json") {
}
else {
    Copy-Item $pathFileConfigWindowTerminal -Destination $pathConfigWindowTerminal -Force
}
Write-Done

Write-Start -msg "Enable Virtualization"
Start-Process -Wait powershell -verb runas -ArgumentList @"
echo y | Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -
All -Norestart
echo y | Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-
Subsystem-Linux -All -Norestart
echo y | Enable-WindowsOptionalFeature -Online -FeatureName
VirtualMachinePlatform -All
echo y | Enable-WindowsOptionalFeature -Online -FeatureName Containers -All
"@
Write-Done

Write-Start -msg "Installing WSL..."
wsl --set-default-version 2
If (!(wsl -l -v)) {
    wsl --install
    wsl --update
    wsl --install --no-launch --web-download -d Ubuntu
    Write-Warning "WSL installed"
}
Else {
    Write-Warning "WSL installed"
}

Write-Done

