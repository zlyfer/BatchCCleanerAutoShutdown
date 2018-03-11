@echo off
setlocal enabledelayedexpansion
mode con cols=15 lines=6
set max=0
set /P max=<numofprocesses.ini
if exist "%desktop%\Neues Textdokument.txt" set sd=1
if not exist "%desktop%\Neues Textdokument.txt" set sd=0
del "%desktop%\Neues Textdokument.txt" 2>nul
if %sd%==1 MSG * "Der Computer wird innerhalb von 30 Sekunden neugestartet, sobald Ccleaner beendet wurde."
if %sd%==0 MSG * "Der Computer wird innerhalb von 30 Sekunden heruntergefahren, sobald Ccleaner beendet wurde."
echo Warten...
:loop
ping -n 2 localhost >nul
qprocess *|find "ccleaner">ccleaner_shutdown_temp.dat 2>nul
set "cmd=findstr /R /N "^^" ccleaner_shutdown_temp.dat | find /C ":""
for /F %%a in ('!cmd!') do set count=%%a
if %count% LSS %max%+1 (
if %sd%==1 (
echo Neustart..
shutdown -r -t 30 -c "Der Computer wird in 30 Sekunden neugestartet. Druecke Enter um das Herunterfahren abzubrechen.."
)
if %sd%==0 (
echo Beenden..
shutdown -s -t 30 -c "Der Computer wird in 30 Sekunden heruntergefahren. Druecke Enter um das Herunterfahren abzubrechen.."
)
echo.
echo Enter..
pause >nul
shutdown -a
exit
)
goto loop