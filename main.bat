@echo off

echo.
echo Unknown project titled Sistem Bel Sekolah Berbasis Python dan Django
echo (c) 2024 Degenerate Aqua Simp. All rights reserved
echo.

if "%~1"=="" (
    echo No argument supplied. Type -h for help
    exit /b 1
)

:start
if "%~1"=="-h" goto help
if "%~1"=="-r" goto run_server
if "%~1"=="-m" goto editdb
if "%~1"=="-s" goto settings
if "%~1"=="-mg" goto migrate
if "%~1"=="-i" goto init

echo Invalid option. Use -h for help.
exit /b 1

:help
echo Command arguments:
echo -h  : This help page
echo -r  : Run server
echo -m  : Edit models
echo -s  : Edit settings
echo -mg : Migrate models
echo -i  : Initialize system
goto :eof

:run_server
where pm2 >nul 2>&1
if errorlevel 1 (
    where node >nul 2>&1
    if errorlevel 1 (
        echo Cannot continue. Please install Node.js
    ) else (
        npm install -g pm2
    )
)

if errorlevel 1 (
    echo The previous command failed.
    exit /b 1
) else (
    pm2 start scripts/start-web.bat
    pm2 start scripts/start-bell.bat
)
goto :eof

:editdb
echo How to edit the models: 
echo There's 3 columns in the models: Time, Day, Ringtone
echo Read the documentation to edit the models
echo.
pause
notepad bel_sekolah\bell\models.py
goto :eof

:settings
echo You're entering the Django settings file
echo Please read the comments inside the file for instructions
echo.
pause
notepad bel_sekolah\bel_sekolah\settings.py
goto :eof

:migrate
call %CD%\.venv\Scripts\activate
python manage.py makemigrations
python manage.py migrate
goto :eof

:init
cd src
pip install -r .\requirements.txt
python manage.py makemigrations
python manage.py migrate
goto :eof
