@echo off
title ALFA VALVES MRP System
color 0E
cd /d "%~dp0"

echo ==============================================
echo   PT. ALFA VALVES INDONESIA - MRP System
echo ==============================================
echo.

REM ---- Cari Node.js: PATH dulu, lalu folder portable ----
set "NODE_EXE="
where node >nul 2>nul
if not errorlevel 1 set "NODE_EXE=node"

if not defined NODE_EXE (
  if exist "%~dp0nodejs\node.exe" (
    set "PATH=%~dp0nodejs;%PATH%"
    set "NODE_EXE=%~dp0nodejs\node.exe"
    echo [INFO] Memakai Node.js portable dari folder nodejs\
  )
)

if not defined NODE_EXE (
  color 0C
  echo [ERROR] Node.js tidak ditemukan.
  echo.
  echo TIDAK PUNYA HAK ADMINISTRATOR? Tetap bisa!
  echo.
  echo   1. Buka  https://nodejs.org/en/download/prebuilt-binaries
  echo   2. Pilih Windows / x64 / format ZIP
  echo   3. Ekstrak isinya ke folder:  %~dp0nodejs\
  echo      sehingga file  %~dp0nodejs\node.exe  ada.
  echo   4. Jalankan file ini lagi.
  echo.
  echo   Cara ZIP tidak butuh hak Administrator sama sekali.
  echo.
  pause
  exit /b 1
)

for /f "delims=" %%v in ('%NODE_EXE% -v 2^>nul') do set NODEVER=%%v
echo [OK] Node.js %NODEVER% terdeteksi.
echo.

if not exist "node_modules\" (
  echo [SETUP] Memasang dependensi untuk pertama kali...
  echo         Perlu internet, 1-3 menit. Hanya sekali.
  echo.
  call npm install --no-audit --no-fund
  if not exist "node_modules\express" (
    color 0C
    echo.
    echo [ERROR] Instalasi gagal. Pastikan terhubung internet.
    echo         Jika jaringan kantor memakai proxy, hubungi IT.
    pause
    exit /b 1
  )
  echo.
  echo [OK] Dependensi terpasang.
  echo.
)

echo [INFO] Menjalankan server...
echo.
echo   Komputer ini : http://localhost:3000
echo.
echo   Akses dari HP / PC lain di WiFi yang sama, pakai IP di bawah:
echo.
ipconfig | findstr /C:"IPv4"
echo.
echo   Contoh: http://192.168.1.10:3000
echo.
echo   JANGAN TUTUP JENDELA INI selama aplikasi dipakai.
echo   Tekan Ctrl+C untuk berhenti.
echo ==============================================
echo.

start "" http://localhost:3000
%NODE_EXE% server/index.js

echo.
echo Server berhenti.
pause
