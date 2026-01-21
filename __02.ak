@echo off
setlocal

REM ==============================
REM CONFIGURATION
REM ==============================
set SEVENZIP="C:\Program Files\7-Zip\7z.exe"

REM Archive Paths (on Dropbox)
set GLOBAL_ARCHIVE="MASTERZ:/Master Z/RDPS/GLOBAL.7z"
set RCLONE_ARCHIVE="MASTERZ:/Master Z/RDPS/RCLONE.7z"
set RDP_ARCHIVE="MASTERZ:/Master Z/RDPS/RDP-02.7z"

REM Temporary download directory
set TEMP_DIR=C:\akbarui\temp

REM Extraction Destinations (Changed to unique folders)
set GLOBAL_DEST=D:/GLOBAL
set RCLONE_DEST=D:/USER
set RDP_DEST=D:/USER

set TC_INI_SRC=D:\GLOBAL\configs\WINCMD.INI
set TC_INI_DST=C:\Users\RDP\AppData\Roaming\GHISLER\WINCMD.INI

mkdir D:\jvipper 2>nul
mkdir D:\jdown 2>nul

mkdir D:\torrent 2>nul
mkdir D:\torrent\Downloading 2>nul
mkdir D:\torrent\Watch 2>nul
mkdir D:\torrent\RawTorrents 2>nul
mkdir D:\TorrentsFinished 2>nul

mkdir D:\DOWNLOAD 2>nul

mkdir D:\UPLOAD 2>nul
mkdir D:\UPLOAD-ENC 2>nul
mkdir D:\UPLOAD\RAR 2>nul
mkdir D:\UPLOAD\downloaded 2>nul
mkdir D:\UPLOAD\jvipper 2>nul

REM ==============================
REM CREATE NECESSARY DIRECTORIES
REM ==============================
echo Creating necessary directories...

mkdir "%TEMP_DIR%" 2>nul
mkdir "%GLOBAL_DEST%" 2>nul
mkdir "%RCLONE_DEST%" 2>nul
mkdir "%RDP_DEST%" 2>nul

REM ==============================
REM DOWNLOAD ARCHIVES TO TEMP DIRECTORY
REM ==============================
echo Downloading archives to "%TEMP_DIR%"...

REM Download GLOBAL.7z
rclone copyto -vv --stats=10s "MASTERZ:/Master Z/RDPS/GLOBAL.7z" "%TEMP_DIR%\GLOBAL.7z"
if not exist "%TEMP_DIR%\GLOBAL.7z" (
    echo ERROR: Download failed for GLOBAL.7z
    exit /b 1
)

REM Download RCLONE.7z
rclone copyto -vv --stats=10s "MASTERZ:/Master Z/RDPS/RCLONE.7z" "%TEMP_DIR%\RCLONE.7z"
if not exist "%TEMP_DIR%\RCLONE.7z" (
    echo ERROR: Download failed for RCLONE.7z
    exit /b 1
)

REM Download RDP-02.7z
rclone copyto -vv --stats=10s "MASTERZ:/Master Z/RDPS/RDP-02.7z" "%TEMP_DIR%\RDP-02.7z"
if not exist "%TEMP_DIR%\RDP-02.7z" (
    echo ERROR: Download failed for RDP-02.7z
    exit /b 1
)

REM ==============================
REM EXTRACT ARCHIVES TO DESTINATIONS
REM ==============================
echo Extracting archives...

REM Extract GLOBAL.7z
echo Extracting GLOBAL.7z...
mkdir "%GLOBAL_DEST%" 2>nul
%SEVENZIP% x "%TEMP_DIR%\GLOBAL.7z" -o"%GLOBAL_DEST%" -y
if errorlevel 1 (
    echo ERROR: Extraction failed for GLOBAL.7z
    exit /b 1
)

REM Extract RDP-02.7z
echo Extracting RDP-02.7z...
mkdir "%RDP_DEST%" 2>nul
%SEVENZIP% x "%TEMP_DIR%\RDP-02.7z" -o"%RDP_DEST%" -y
if errorlevel 1 (
    echo ERROR: Extraction failed for RDP-02.7z
    exit /b 1
)

REM Extract RCLONE.7z
echo Extracting RCLONE.7z...
mkdir "%RCLONE_DEST%" 2>nul
%SEVENZIP% x "%TEMP_DIR%\RCLONE.7z" -o"%RCLONE_DEST%" -y -aoa -bb0
if errorlevel 1 (
    echo ERROR: Extraction failed for RCLONE.7z
    exit /b 1
)

REM ==============================
REM CLEANUP TEMP DIRECTORY
REM ==============================
echo Cleaning up temporary files...
rd /s /q "%TEMP_DIR%"

echo ==============================
echo All archives downloaded and extracted.
echo ==============================


REM ==============================
REM COPY TOTAL COMMANDER CONFIG
REM ==============================
echo Copying WINCMD.INI...

mkdir "C:\Users\RDP\AppData\Roaming\GHISLER" 2>nul

if exist "%TC_INI_SRC%" (
    copy /Y "%TC_INI_SRC%" "%TC_INI_DST%"
) else (
    echo WARNING: WINCMD.INI not found
)


REM ==============================
REM ENABLE DARK THEME
REM ==============================
echo Enabling dark theme...

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" ^
 /v AppsUseLightTheme /t REG_DWORD /d 0 /f

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" ^
 /v SystemUsesLightTheme /t REG_DWORD /d 0 /f

taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

REG ADD "HKCU\Control Panel\Colors" ^
 /v AppsBackground /t REG_SZ /d "32 32 32" /f

REM ==============================
REM SET WALLPAPER
REM ==============================
echo Setting wallpaper...

powershell -NoProfile -ExecutionPolicy Bypass ^
 -Command "$w='D:\USER\background\background_RDP-02.jpg'; Add-Type 'using System.Runtime.InteropServices; public class W{[DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(int a,int b,string c,int d);}'; [W]::SystemParametersInfo(20,0,$w,3)"


REM ==============================
REM COPY SCRIPTS
REM ==============================

echo Copying Rar-sub-jvip.bat...

if exist "D:\GLOBAL\scripts\Rar-sub-jvip.bat" (
    copy /Y "D:\GLOBAL\scripts\Rar-sub-jvip.bat" "D:\jvipper\"
) else (
    echo WARNING: Rar-sub-jvip.bat not found
)


REM ==============================
REM LAUNCH TOTAL COMMANDER
REM ==============================
echo Launching Total Commander...

if exist "D:\USER\portable\Commander\TOTALCMD.EXE" (
    start "" "D:\USER\portable\Commander\TOTALCMD.EXE"
) else (
    echo WARNING: TOTALCMD.EXE not found
)


REM ==============================
REM LAUNCH DOWNLOAD OFFLOAD SCRIPT
REM ==============================
echo Launching Download-OFFLOAD...

if exist "D:\USER\Download-OFFLOAD.bat" (
    start "" cmd.exe /k "D:\USER\Download-OFFLOAD.bat"
) else (
    echo WARNING: Download-OFFLOAD.bat not found
)

echo ==============================
echo Done
echo ==============================
cmd /k
