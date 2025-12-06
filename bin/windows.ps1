# ----------------------------
# Auto Setup Script for Windows
# ----------------------------


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
$scriptToRun = ".\bin\main.sh"

& $bashPath $scriptToRun
