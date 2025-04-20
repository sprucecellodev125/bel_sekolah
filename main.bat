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
if "%~1"=="-s" goto stop_server
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
echo -s  : Stop server
echo -m  : Edit models
echo -st : Edit settings
echo -mg : Migrate models
echo -i  : Initialize system
echo -u  : Create admin user
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

:stop_server
where pm2 >nul 2>&1
if errorlevel 0 (
    pm2 stop start-bell
    pm2 start start-web
) else (
    echo There's no pm2 installed. Did you mean: -r
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
@echo off

python -m venv .venv
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to create virtual environment
    exit /b 1
)

call .\.venv\Scripts\activate
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to activate virtual environment
    exit /b 1
)

pip install -r requirements.txt
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to install dependencies
    exit /b 1
)

cd src
mkdir assets
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to create assets directory
    exit /b 1
)

python manage.py makemigrations
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to make migrations
    exit /b 1
)

python manage.py migrate
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to migrate
    exit /b 1
)

REM Step 7: Compile messages
python manage.py compilemessages
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to compile locale
    exit /b 1
)

echo All commands ran successfully!
goto :eof

:create_user
python manage.py createsuperuser
goto :eof