# Set execution policy
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
$pathRoot = $PSScriptRoot 
$parentPath = [System.IO.Directory]::GetParent($pathRoot).FullName
$configPath = "$parentPath\localConfigs.sh"

if (Test-Path -Path $configPath) {
    Write-Output ""
}
else {
    Write-Host "localConfigs.sh not found, you need to run " -NoNewline
    Write-Host "generateConfigs.cmd" -ForegroundColor Yellow -NoNewline
    Write-Host " first"
    exit
}

function RunCommands {
    param (
        [string[]]$commands
    )
    foreach ($command in $commands) {
        Invoke-Expression $command
    }
}

function RunCommandsWithAdmin {
    param (
        [string[]]$commands
    )
    foreach ($command in $commands) {
        Start-Process -Wait powershell -Verb runas -ArgumentList $command
    }
}

function InstallScoop {
    if (Get-Command scoop -errorAction SilentlyContinue) {
    }
    else {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
    }
}

RunCommandsWithAdmin @(
    "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0"
)

InstallScoop

RunCommands @(
    "scoop install git"
)

& "$env:USERPROFILE\scoop\apps\git\current\bin\bash.exe" ".\bin\windows.sh"