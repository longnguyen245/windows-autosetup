# ----------------------------
# Auto Setup Script for Windows
# ----------------------------

# Set script paths
$pathRoot = $PSScriptRoot
$parentPath = [System.IO.Directory]::GetParent($pathRoot).FullName
$configPath = Join-Path $parentPath "localConfigs.sh"

# Check config file existence
if (-Not (Test-Path -Path $configPath)) {
    Write-Host "localConfigs.sh not found, you need to run " -NoNewline
    Write-Host "generateConfigs.cmd" -ForegroundColor Yellow -NoNewline
    Write-Host " first"
    Read-Host "Press Enter to exit..."
    exit 1
}

# Install Scoop if not installed
function InstallScoop {
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "Scoop already installed."
    }
    else {
        Write-Host "Installing Scoop..."
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
    }
}

# Step 2: Install Scoop
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "Scoop already installed."
}
else {
    Write-Host "Installing Scoop..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

# Step 3: Install required packages
Invoke-Expression "scoop install git gsudo"

# Step 4: Run bash script
$bashPath = "$env:USERPROFILE\scoop\apps\git\current\bin\bash.exe"
$scriptToRun = ".\bin\windows.sh"

& $bashPath $scriptToRun
