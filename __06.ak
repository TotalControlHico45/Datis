@echo off
setlocal

REM ==============================
REM CONFIGURATION
REM ==============================
set DOWNLOAD_DEST=C:\runi\soft-RDP-06.7z
set EXTRACT_DEST=D:\SOFT
set EXTRACT_PASSWORD=protocol

set TC_INI_SRC=D:\SOFT\configs\WINCMD.INI
set TC_INI_DST=C:\Users\RDP\AppData\Roaming\GHISLER\WINCMD.INI

set SEVENZIP="C:\Program Files\7-Zip\7z.exe"

echo Creating directory structure...

mkdir D:\SOFT 2>nul
mkdir D:\DOWNLOAD 2>nul

mkdir D:\UPLOAD 2>nul
mkdir D:\UPLOAD-ENC 2>nul
mkdir D:\UPLOAD\RAR 2>nul
mkdir D:\UPLOAD\downloaded 2>nul
mkdir D:\UPLOAD\jvipper 2>nul

mkdir D:\jvipper 2>nul
mkdir D:\jdown 2>nul

mkdir D:\torrent-06 2>nul
mkdir D:\torrent-06\Downloading 2>nul
mkdir D:\torrent-06\Watch 2>nul
mkdir D:\torrent-06\RawTorrents 2>nul
mkdir D:\TorrentsFinished-06 2>nul

REM ==============================
REM DOWNLOAD soft.7z
REM ==============================
echo Downloading soft.7z...

mkdir C:\runi 2>nul

rclone copyto -vv --stats=10s ^
"MASTERZ:/Master Z/SOFT/soft-RDP-06.7z" "%DOWNLOAD_DEST%"

if errorlevel 1 (
    echo ERROR: Download failed
    cmd /k
    exit /b 1
)

REM ==============================
REM EXTRACT TO D:\SOFT
REM ==============================
echo Extracting archive...

mkdir "%EXTRACT_DEST%" 2>nul

%SEVENZIP% x "%DOWNLOAD_DEST%" -o"%EXTRACT_DEST%" -p%EXTRACT_PASSWORD% -y
if errorlevel 1 (
    echo ERROR: Extraction failed
    cmd /k
    exit /b 1
)

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
REM COPY WINRAR & JVIPP BAT
REM ==============================
echo Installing WinRAR (portable copy)...

if exist "D:\SOFT\install\WinRAR" (
    mkdir "C:\Program Files\WinRAR" 2>nul
    xcopy /E /I /Y "D:\SOFT\install\WinRAR" "C:\Program Files\WinRAR"
) else (
    echo WARNING: WinRAR source folder not found
)

echo Copying Rar-sub-jvip.bat...

if exist "D:\SOFT\bat\Rar-sub-jvip.bat" (
    copy /Y "D:\SOFT\bat\Rar-sub-jvip.bat" "D:\jvipper\"
) else (
    echo WARNING: Rar-sub-jvip.bat not found
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
 -Command "$w='D:\SOFT\background\background_RDP-06.jpg'; Add-Type 'using System.Runtime.InteropServices; public class W{[DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(int a,int b,string c,int d);}'; [W]::SystemParametersInfo(20,0,$w,3)"

REM ==============================
REM LAUNCH TOTAL COMMANDER
REM ==============================
echo Launching Total Commander...

if exist "D:\SOFT\portable\Commander\TOTALCMD.EXE" (
    start "" "D:\SOFT\portable\Commander\TOTALCMD.EXE"
) else (
    echo WARNING: TOTALCMD.EXE not found
)



REM ==============================
REM LAUNCH DOWNLOAD OFFLOAD SCRIPT
REM ==============================
echo Launching Download-OFFLOAD...

if exist "D:\SOFT\Download-OFFLOAD.bat" (
    start "" cmd.exe /k "D:\SOFT\Download-OFFLOAD.bat"
) else (
    echo WARNING: Download-OFFLOAD.bat not found
)


echo ==============================
echo Done
echo ==============================
cmd /k
