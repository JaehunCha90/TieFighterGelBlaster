@echo off
setlocal
rem unzip a opencv dll zip file
tar -xf opencv_world.zip -C %~dp0\

rem mkdir and copy prerequisites
set "X64_BASE_PATH=%~dp0..\LgCannonDemoCodeDist\LgClientDisplay\X64"
set "RELEASE_PATH=%X64_BASE_PATH%\Release"
set "DEBUG_PATH=%X64_BASE_PATH%\Debug"

if not exist "%X64_BASE_PATH%" mkdir "%X64_BASE_PATH%"
if not exist "%RELEASE_PATH%" mkdir "%RELEASE_PATH%"
if not exist "%DEBUG_PATH%" mkdir "%DEBUG_PATH%"
if not exist "%RELEASE_PATH%\openvpn\config" mkdir "%RELEASE_PATH%\openvpn\config"
if not exist "%DEBUG_PATH%\openvpn\config" mkdir "%DEBUG_PATH%\openvpn\config"

copy opencv_world490d.dll "%DEBUG_PATH%"
copy libcrypto-3-x64.dll "%DEBUG_PATH%"
copy openvpn.exe "%DEBUG_PATH%\openvpn"
copy libssl-3-x64.dll "%DEBUG_PATH%\openvpn"
copy libpkcs11-helper-1.dll "%DEBUG_PATH%\openvpn"
copy libcrypto-3-x64.dll "%DEBUG_PATH%\openvpn"
copy libopenvpn_plap.dll "%DEBUG_PATH%\openvpn"
copy public_key.pem "%DEBUG_PATH%\openvpn"
copy openvpn.signature.bin "%DEBUG_PATH%\openvpn"
copy libcrypto-3-x64.signature.bin "%DEBUG_PATH%\openvpn"
copy libopenvpn_plap.signature.bin "%DEBUG_PATH%\openvpn"
copy libpkcs11-helper-1.signature.bin "%DEBUG_PATH%\openvpn"
copy libssl-3-x64.signature.bin "%DEBUG_PATH%\openvpn"
xcopy config "%DEBUG_PATH%\openvpn\config" /s /e /y

copy opencv_world490.dll "%RELEASE_PATH%"
copy libcrypto-3-x64.dll "%RELEASE_PATH%"
copy openvpn.exe "%RELEASE_PATH%\openvpn"
copy libssl-3-x64.dll "%RELEASE_PATH%\openvpn"
copy libpkcs11-helper-1.dll "%RELEASE_PATH%\openvpn"
copy libcrypto-3-x64.dll "%RELEASE_PATH%\openvpn"
copy libopenvpn_plap.dll "%RELEASE_PATH%\openvpn"
copy public_key.pem "%RELEASE_PATH%\openvpn"
copy openvpn.signature.bin "%RELEASE_PATH%\openvpn"
copy libcrypto-3-x64.signature.bin "%RELEASE_PATH%\openvpn"
copy libopenvpn_plap.signature.bin "%RELEASE_PATH%\openvpn"
copy libpkcs11-helper-1.signature.bin "%RELEASE_PATH%\openvpn"
copy libssl-3-x64.signature.bin "%RELEASE_PATH%\openvpn"
xcopy config "%RELEASE_PATH%\openvpn\config" /s /e /y



rem Install driver
set "OEMVISTA_PATH=%~dp0OemVista.inf"
pnputil.exe -i -a "%OEMVISTA_PATH%"



rem Define the path to tapctl.exe (assuming it's in the current directory)
set "TAPCTL_PATH=%~dp0tapctl.exe"

rem Check if the tapctl.exe exists
if not exist "%TAPCTL_PATH%" (
    echo tapctl.exe not found in the current directory.
    exit /b 1
)

rem Initialize a flag to track if a TAP device is found
set "tap_found="

rem Run tapctl.exe with argument "list" and capture the output
for /f "delims=" %%i in ('"%TAPCTL_PATH%" list 2^>nul') do (
    rem If any output is found, set the tap_found flag and exit the loop
    set "tap_found=1"
)

rem Check if TAP device is found
if defined tap_found (
    echo TAP device found.
) else (
    echo No TAP devices found. Creating a new TAP device...
    "%TAPCTL_PATH%" create
    if errorlevel 1 (
        echo Failed to create a TAP device.
        exit /b 1
    ) else (
        echo TAP device created successfully.
    )
)

endlocal
exit /b 0
