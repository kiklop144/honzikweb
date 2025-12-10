@echo off
chcp 65001 >nul

:: ============================================
::  VYBER LOKACE
:: ============================================
:select_location
echo.
echo je toto tvůj repozitář
echo [a] ano
echo [n] ne
set /p LOC=Zadej volbu: 

if /i "%LOC%"=="a" (
    goto show_changes
)

if /i "%LOC%"=="n" (
    set /p CUSTOM=Zadej cestu k repozitari: 
    cd /d "%CUSTOM%"
    goto show_changes
)

echo Neplatna volba, zkus to znovu.
goto select_location

:: ============================================
::  ZOBRAZENI ZMENENYCH SOUBORU
:: ============================================
:show_changes
echo.
echo Zmenene soubory:
echo ----------------------------------------------------

setlocal enabledelayedexpansion
set COUNT=0

for /f "tokens=1,2,*" %%a in ('git status --porcelain') do (
    set /a COUNT+=1
    set TYPE=Neznamy

    if "%%a"=="M" set TYPE=Upraveno
    if "%%a"=="A" set TYPE=Pridano
    if "%%a"=="D" set TYPE=Odstraneno

    if "%%b"=="M" set TYPE=Upraveno
    if "%%b"=="A" set TYPE=Pridano
    if "%%b"=="D" set TYPE=Odstraneno

    echo !COUNT!: %%c  (!TYPE!)
    set "FILE_!COUNT!=%%c"
)

echo ----------------------------------------------------
echo Pokud chces commitnout vse, nech prazdne.
set /p INPUT=Zadej cisla souboru (oddeleni mezerou): 

:: ============================================
::  COMMIT VSECH
:: ============================================
if "%INPUT%"=="" (
    git add -A
    goto commit_message
)

:: ============================================
::  COMMIT VYBRANYCH SOUBORU
:: ============================================
for %%n in (%INPUT%) do (
    git add "!FILE_%%n!"
)

:: ============================================
::  COMMIT ZPRAVA — NESMI BYT PRAZDNA
:: ============================================
:commit_message
set /p MSG=Napis commit zpravu: 

if "%MSG%"=="" (
    echo Commit zprava nesmi byt prazdna!
    goto commit_message
)

git commit -m "%MSG%"
git push

echo.
echo ==========================================
echo   HOTOVO — zmeny jsou na GitHubu
echo ==========================================
pause