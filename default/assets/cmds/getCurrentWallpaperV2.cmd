@echo off
setlocal enabledelayedexpansion

set "tmp=%time::=%"
set "tmp=%tmp:.=%"
set "tmp=%tmp: =%"
set "tmp=%tmp:~0,12%"

@echo off
setlocal enabledelayedexpansion

for /f "tokens=2,*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop 2^>nul') do set "desktopPath=%%B"

if not defined desktopPath (
    echo [Error] Not found
    pause
    exit /b
)

for /f "delims=" %%A in ('echo "!desktopPath!"') do set "desktopPath=%%A"

echo Desktop Path: "!desktopPath!"


@echo off
for /f "tokens=2,*" %%A in ('reg query "HKCU\Control Panel\Desktop" /v Wallpaper') do set "wallpaper=%%B"
copy "%wallpaper%" "%desktopPath%\%tmp%.jpg"
start "" "%desktopPath%\%tmp%.jpg"
exit /b 0