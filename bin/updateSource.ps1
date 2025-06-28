# Variables
$UserPath = $env:USERPROFILE
$repoUrl = "https://github.com/longnguyen245/windows-autosetup"
$zipUrl = "$repoUrl/archive/refs/heads/master.zip"
$tempDir = "tmp"
$zipPath = "$tempDir.zip"

# Download ZIP
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

# Extract ZIP
Expand-Archive -Path $zipPath -DestinationPath $tempDir

# Actual folder inside ZIP is usually like windows-autosetup-main
$extractedFolder = Get-ChildItem $tempDir | Where-Object { $_.PSIsContainer } | Select-Object -First 1
$srcPath = Join-Path $tempDir $extractedFolder.Name

# Copy necessary folders and files
Copy-Item -Recurse -Force "$srcPath\bin" .\
Copy-Item -Recurse -Force "$srcPath\assets" .\
Copy-Item "$srcPath\*.cmd" .\
Copy-Item "$srcPath\*.md" .\

# Clean up
Remove-Item -Recurse -Force $tempDir
Remove-Item -Force $zipPath

& "$env:USERPROFILE\scoop\apps\git\current\bin\bash.exe" ".\bin\afterUpdateSource.sh"
