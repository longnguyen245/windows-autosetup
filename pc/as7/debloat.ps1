Write-Host "Debloating"

Get-AppxPackage *Microsoft.XboxApp* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Xbox.TCUI* | Remove-AppxPackage
Get-AppxPackage *Microsoft.GamingApp* | Remove-AppxPackage
Get-AppxPackage *3dviewer* | Remove-AppxPackage
Get-AppxPackage *onenote* | Remove-AppxPackage
Get-AppxPackage *skypeapp* | Remove-AppxPackage
Get-AppxPackage *bingweather* | Remove-AppxPackage
Get-AppxPackage *bingnews* | Remove-AppxPackage
Get-AppxPackage *bingfinance* | Remove-AppxPackage
Get-AppxPackage *bingsports* | Remove-AppxPackage
Get-AppxPackage *zunevideo* | Remove-AppxPackage
# Get-AppxPackage *zunemusic* | Remove-AppxPackage
Get-AppxPackage *mspaint* | Remove-AppxPackage
Get-AppxPackage *solitairecollection* | Remove-AppxPackage
Get-AppxPackage *yourphone* | Remove-AppxPackage
Get-AppxPackage *stickynotes* | Remove-AppxPackage
Get-AppxPackage *windowsmaps* | Remove-AppxPackage
Get-AppxPackage *windowscamera* | Remove-AppxPackage
Get-AppxPackage *windowsalarms* | Remove-AppxPackage
Get-AppxPackage *soundrecorder* | Remove-AppxPackage
Get-AppxPackage *windowsfeedbackhub* | Remove-AppxPackage
Get-AppxPackage *getstarted* | Remove-AppxPackage
Get-AppxPackage *clipchamp* | Remove-AppxPackage
Get-AppxPackage *todos* | Remove-AppxPackage
Get-AppxPackage *msnweather* | Remove-AppxPackage
Get-AppxPackage *devhome* | Remove-AppxPackage
Get-AppxPackage *powerautomate* | Remove-AppxPackage
# Get-AppxPackage *newoutlook* | Remove-AppxPackage
Get-AppxPackage *quickassist* | Remove-AppxPackage
# Get-AppxPackage *webexperience* | Remove-AppxPackage
Get-AppxPackage *microsoftteams* | Remove-AppxPackage
Get-AppxPackage *Teams* | Remove-AppxPackage # for windows 11
# Get-AppxPackage *xboxgamingoverlay* | Remove-AppxPackage
Get-AppxPackage *linkedin* | Remove-AppxPackage
Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage
Get-AppxPackage *MixedReality.Portal* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Getstarted* | Remove-AppxPackage
Get-AppxPackage *onenote* | Remove-AppxPackage
Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage
Get-AppxPackage *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Wallet* | Remove-AppxPackage
Get-AppxPackage *Microsoft.Edge.GameAssist* | Remove-AppxPackage
Get-AppxPackage *copilot* | Remove-AppxPackage
Get-AppxPackage *BingSearch* | Remove-AppxPackage

$oneDrivePath64 = "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
if (Test-Path $oneDrivePath64) {
    Start-Process $oneDrivePath64 -ArgumentList "/uninstall" -NoNewWindow -Wait
}

Write-Host "Done"