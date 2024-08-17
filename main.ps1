#!/usr/bin/env pwsh

Write-Output ""
Write-Output "Unknown project titled Sistem Bel Sekolah Berbasis Python dan Django"
Write-Output "Internal Evaluation use only. DO NOT DISTRIBUTE"
Write-Output "(c) 2024 Degenerate Aqua Simp. All rights reserved"
Write-Output ""

if ($args.Count -eq 0) {
    Write-Output "No argument supplied. Type -h for help"
    exit 1
}

function Show-Help {
    Write-Output "Command arguments:"
    Write-Output "-h  : This help page"
    Write-Output "-r  : Run server"
    Write-Output "-m  : Edit models"
    Write-Output "-s  : Edit settings"
    Write-Output "-mg : Migrate models"
    Write-Output "-i  : Initialize system"
}

function Start-Server {
    if (-not (Get-Command pm2 -ErrorAction SilentlyContinue)) {
        if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
            if (Get-Command winget -ErrorAction SilentlyContinue) {
                winget install Schniz.fnm
                fnm env --use-on-cd | Out-String | Invoke-Expression
                fnm use --install-if-missing 20
                npm install -g pm2
            } else {
                Write-Output "Cannot continue. Please install curl or wget"
                exit 1
            }
        } else {
            npm install -g pm2
        }
    }

    if ($LASTEXITCODE -eq 0) {
        pm2 start scripts/start-web.bat
        pm2 start scripts/start-bell.bat
    } else {
        Write-Output "The previous command failed."
        exit 1
    }
}

function Edit-DB {
    Write-Output "How to edit the models: "
    Write-Output "There's 3 columns in the models: Time, Day, Ringtone"
    Write-Output "Read the documentation to edit the models"
    Write-Output ""
    Read-Host "Press ENTER to continue"
    notepad .\bel_sekolah\bell\models.py
}

function Edit-Settings {
    Write-Output "You're entering the Django settings file"
    Write-Output "Please read the comments inside the file for instructions"
    Write-Output ""
    Read-Host "Press ENTER to continue"
    notepad .\bel_sekolah\bell\models.py
}

function MigrateDB {
    & "$PWD/.venv/Scripts/Activate.ps1"
    python manage.py makemigrations
    python manage.py migrate
}

function Initialize-System {
    Set-Location bel_sekolah
    python -m venv .\.venv
    .\.venv\Scripts\activate
    pip install -r .\requirements.txt
    python manage.py makemigrations
    python manage.py migrate
}

switch ($args[0]) {
    '-h' { Show-Help }
    '-r' { Start-Server }
    '-m' { Edit-DB }
    '-s' { Edit-Settings }
    '-mg' { MigrateDB }
    '-i' { Initialize-System }
    default {
        Write-Output "Invalid option. Use -h for help."
        exit 1
    }
}
