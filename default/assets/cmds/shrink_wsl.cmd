@echo off
setlocal enabledelayedexpansion

set "FOUND=0"

for /d %%D in ("%USERPROFILE%\*") do (
    if exist "%%D\ext4.vhdx" (
        set "VHDX_PATH=%%D\ext4.vhdx"
        call :compact
        set "FOUND=1"
    )
)

if "%FOUND%"=="0" (
    echo ext4.vhdx not found.
    pause
    exit /b
)

echo Disk compacting complete.
pause
exit /b

REM ============================
:compact
echo %VHDX_PATH%

(
echo select vdisk file="%VHDX_PATH%"
echo compact vdisk
) > "%temp%\diskpart_script.txt"

diskpart /s "%temp%\diskpart_script.txt"
del "%temp%\diskpart_script.txt"

exit /b