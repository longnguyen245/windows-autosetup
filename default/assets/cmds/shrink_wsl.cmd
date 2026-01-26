@echo off
REM
for /d %%D in ("%LOCALAPPDATA%\Packages\CanonicalGroupLimited.*") do (
    if exist "%%D\LocalState\ext4.vhdx" (
        set "VHDX_PATH=%%D\LocalState\ext4.vhdx"
        goto :found
    )
)

:found
if not defined VHDX_PATH (
    echo ext4.vhdx not found
    pause
    exit /b
)

REM 
echo select vdisk file="%VHDX_PATH%" > "%temp%\diskpart_script.txt"
echo compact vdisk >> "%temp%\diskpart_script.txt"

diskpart /s "%temp%\diskpart_script.txt"

del "%temp%\diskpart_script.txt"

echo Disk compacting complete.
pause