$pathRoot = $PSScriptRoot 
$parentPath = [System.IO.Directory]::GetParent($pathRoot).FullName
$homeDirectory = $HOME -replace '\\', '\\'
$username = $env:USERNAME
$email = "$username@local"
$text = ''
$configPath = "$parentPath\localConfigs.sh"

if (Test-Path -Path $configPath) {
    Write-Output ""
}
else {
    $text += "NAME=$username`n"
    $text += "EMAIL=$email`n"
    $text += "PC=`n"
    $text += "WORKSPACE_PATH='$homeDirectory'`n"
    $text | Set-Content -Path $configPath
}