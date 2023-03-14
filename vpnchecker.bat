@echo off

REM BEGIN USER EDITABLE PARAMETERS

set delay=5
set vpnname=Ethernet2
set vpnuser=user
set vpnpass=password
set exelocation=C:\Program Files\Mozilla Firefox
set exefile=firefox.exe
REM set tab1=https://signin.aws.amazon.com/console
REM set tab2=https://learn.acloud.guru
set tab1=https://chat.openai.com/chat

REM END USER EDITABLE PARAMETERS

:start
cls

@echo on
REM netsh interface ipv4 show interfaces | FIND "Ethernet 2" /I /C >var
netsh interface ipv4 show interfaces | FIND "HssStore 1" /I /C >var
@echo off
cls

if "%errorlevel%"=="0" (
 echo was enabled
 goto vpnup
) else (
 echo was disabled
 goto vpndown
)

:vpndown
echo.
echo --------------------------------------------------------------------------------
echo.
echo                                       !
echo                                       !
echo                                       !
echo                                     !!!!!
echo                                      !!!
echo                                       !
echo.
echo                     \/ VPN is DOWN at %time%! \/
echo.

tasklist | find /I "%exefile%" > nul

IF %ERRORLEVEL% EQU 0 (
echo                --== %exefile% Is Running, KILLING NOW ==--
echo.
taskkill /IM "%exefile%" > nul
::wmic process where "commandline like '%script.bat%'" get name
wmic process where "commandline like 'vpnchecker.bat'" call terminate
taskkill /IM "vpnchecker.exe" > nul
)

echo                     --== Checking VPN Again ==--
echo.
echo                  --== Waiting %delay% Seconds Before Next Re-Check ==--



echo --------------------------------------------------------------------------------

set /a pingms=%delay%*1000
ping -n 1 -w %pingms% 123.123.123.123 > nul
)

goto start

:vpnup
echo.
echo --------------------------------------------------------------------------------
echo. 
echo                                       !
echo                                      !!!
echo                                     !!!!!
echo                                       !
echo                                       !
echo                                       !
echo.
echo.
echo                        /\ VPN is UP at %time% /\
echo.

tasklist | find /I "%exefile%" > nul

if errorlevel 1 (
echo                 \/ %exefile% Is Not Running, Restarting \/
start /D "%exelocation%" %exefile% -new-tab -url %tab1%
REM start /D "%exelocation%" %exefile% -new-tab -url %tab1% -new-tab -url %tab2% 
echo.
) else (
echo                   /\ %exefile% Is Running At %time% /\
echo.
)
echo                  --== Rechecking VPN Status in %delay% Seconds ==--
echo %tab1%
echo %tab2%
echo %exelocation%
echo %exefile%
echo.
echo --------------------------------------------------------------------------------
set /a pingms=%delay%*1000
ping -n 1 -w %pingms% 123.123.123.123 > nul
goto start
