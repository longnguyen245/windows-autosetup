$downloadPath = "$env:USERPROFILE\Downloads\acer\"
$acerCenter = "AcerCenter.zip"
$acerCenterPath = $downloadPath + $acerCenter
$acerQuickAccess = "AcerQuickAccess.zip"
$acerQuickAccessPath = $downloadPath + $acerQuickAccess
$audioDriver = "AudioDriver.zip"
$audioDriverPath = $downloadPath + $audioDriver
$nitroSense = "NitroSense.zip"
$nitroSensePath = $downloadPath + $nitroSense

$linkAcerCenter = "https://global-download.acer.com/GDFiles/Application/Acer%20Care%20Center/Acer%20Care%20Center_Acer_4.00.3046_W11x64_A.zip?acerid=638115973251364975&Step1=&Step2=&Step3=ASPIRE%20A715-42G&OS=ALL&LC=en&BC=ACER&SC=PA_6"
$linkAcerQuickAccess = "https://global-download.acer.com/GDFiles/Application/Quick%20Access/Quick%20Access_Acer_3.00.3044_W11x64_A.zip?acerid=638115974807159857&Step1=&Step2=&Step3=ASPIRE%20A715-42G&OS=ALL&LC=en&BC=ACER&SC=PA_6"
$linkAudioDriver = "https://global-download.acer.com/GDFiles/Driver/Audio/Audio_Realtek_6.0.9208.1_W11x64_A.zip?acerid=637734066224533681&Step1=&Step2=&Step3=ASPIRE%20A715-42G&OS=ALL&LC=en&BC=ACER&SC=PA_6"
$linkNitroSense = "https://global-download.acer.com/GDFiles/Application/Nitro%20Sense/Nitro%20Sense_Acer_3.01.3028_W11x64_A.zip?acerid=637813743040356772&Step1=&Step2=&Step3=NITRO%20AN515-55&OS=ALL&LC=en&BC=ACER&SC=PA_6"

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

RunCommands @(
    "scoop bucket add extras",
    "scoop install aria2",
    "aria2c -o $acerCenter -d $downloadPath '$linkAcerCenter'",
    "aria2c -o $acerQuickAccess -d $downloadPath '$linkAcerQuickAccess'",
    "aria2c -o $audioDriver -d $downloadPath '$linkAudioDriver'",
    "aria2c -o $nitroSense -d $downloadPath '$linkNitroSense'",
    "scoop uninstall aria2"
)

Expand-Archive -Path $acerCenterPath -DestinationPath "$acerCenterPath-extract" -Force
Expand-Archive -Path $acerQuickAccessPath -DestinationPath "$acerQuickAccessPath-extract" -Force
Expand-Archive -Path $audioDriverPath -DestinationPath "$audioDriverPath-extract" -Force
Expand-Archive -Path $nitroSensePath -DestinationPath "$nitroSensePath-extract" -Force

Rename-Item -Path "$nitroSensePath-extract\Nitro Sense_Acer_3.01.3028_W11x64\NitroSense_V3.01.3028_MSFT_SIGNED_20210812\Plugs\Nitro AN515-42" -NewName "Aspire A715-42G"

Start-Process "$acerCenterPath-extract\Acer Care Center_Acer_4.00.3046_W11x64\setup.exe"
Start-Process "$acerQuickAccessPath-extract\Quick Access_Acer_3.00.3044_W11x64\setup.exe"
Start-Process "$audioDriverPath-extract\Audio_Realtek_6.0.9208.1_W11x64\Setup_Driver.cmd"
Start-Process "$nitroSensePath-extract\Nitro Sense_Acer_3.01.3028_W11x64\NitroSense_V3.01.3028_MSFT_SIGNED_20210812\Setup.exe"
