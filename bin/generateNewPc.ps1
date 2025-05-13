$pathRoot = $PSScriptRoot 
$parentPath = [System.IO.Directory]::GetParent($pathRoot).FullName

$name = Read-Host "Enter your PC name"

while ($name -match "\s") {
    Write-Output "The name cannot contain spaces. Please enter a valid name."
    $name = Read-Host "Enter your PC name"
}

$local = 0
while ($true) {
    $tmp = Read-Host "Do you want to use local? (y/n)"
    
    if ($tmp -match '^[Yy]$') {
        Write-Host "You selected to use local."
        $local = 1
        break
    }
    elseif ($tmp -match '^[Nn]$') {
        Write-Host "You selected not to use local."
        break
    }
    else {
        Write-Host "Please enter 'y' or 'n'."
    }
}


mkdir "$parentPath\pc\$name"
Copy-Item "$pathRoot\default\*" "$parentPath\pc\$name"

if ($local) {
    Write-Output "*" > "$parentPath\pc\$name\.gitignore"
} 

Write-Output "Created new PC"
