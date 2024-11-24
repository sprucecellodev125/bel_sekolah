#!/bin/bash

echo ""
echo "Unknown project titled Sistem Bel Sekolah Berbasis Python dan Django"
echo "(c) 2024 Degenerate Aqua Simp. All rights reserved"
echo ""

if [ $# -eq 0 ]; then
    echo "No argument supplied. Type -h for help"
    exit 1
fi

help() {
    echo "Command arguments:"
    echo "-h  : This help page"
    echo "-r  : Run server"
    echo "-s  : Stop server"
    echo "-m  : Edit models"
    echo "-st : Edit settings"
    echo "-mg : Migrate models"
    echo "-i  : Initialize system"
}

start() {
    if ! command -v pm2 &> /dev/null; then
        if ! command -v node &> /dev/null; then
            if command -v wget &> /dev/null; then
                wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
                export NVM_DIR="$HOME/.nvm"
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
                [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
                nvm install node
                npm i -g pm2
            elif command -v curl &> /dev/null; then
                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
                export NVM_DIR="$HOME/.nvm"
                [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
                [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
                nvm install node
                npm i -g pm2
            else
                echo "Cannot continue. Please install curl or wget"
                exit 1
            fi
        else
            npm i -g pm2
        fi
    fi

    if [ $? -eq 0 ]; then
        pm2 start scripts/start-web.sh
        pm2 start scripts/start-bell.sh
    else
        echo "The previous command failed."
        exit 1
    fi
}

stop () {
    if command -v pm2 &> /dev/null; then
        pm2 stop start-bell
        pm2 start start-web
    else
        echo "There's no pm2 installed. Did you mean: -r"
        exit 1
    fi
}

detect_editor() {
    if command -v nano --version &> /dev/null; then
	export EDITOR=nano
    elif command -v vim --version &> /dev/null; then
	export EDITOR=vim
    elif command -v nvim --version &> /dev/null; then
	export EDITOR=nvim
    fi
}

editdb() {
    echo "How to edit the models: "
    echo "There's 3 column in the models: Time, Day, Ringtone"
    echo "Read the documentation to edit the models"
    echo ""
    echo "Press ENTER to continue "
    read
    detect_editor
    if [[ -z "${EDITOR}" ]]; then
	echo "No EDITOR detected on this system. Please install nano or vim"
    else
    	$EDITOR src/bell/models.py
    fi
}

settings() {
    echo "You're entering Django settings file"
    echo "Please read the comment inside the file for instructions"
    echo ""
    echo "Press ENTER to continue"
    read
    detect_editor
    if [[ -z "${EDITOR}" ]]; then
	echo "No EDITOR detected on this system. Please install nano or vim"
    else
	$EDITOR src/bel_sekolah/settings.py
    fi
}

migrate() {
    source $PWD/.venv/bin/activate
    python manage.py makemigrations
    python manage.py migrate
}

init() {
    # Check if Python3 is installed
    if ! command -v python3 > /dev/null 2>&1; then
        echo "Python3 is not found. Installing ...."
        if grep -qE "Ubuntu|Debian" /etc/os-release 2>/dev/null; then
            if command -v sudo > /dev/null 2>&1; then
                sudo apt update && sudo apt install -y build-essential gettext libsdl2-dev python3 python3-pip python3-venv nodejs npm
            else
                apt update && apt install -y build-essential gettext libsdl2-dev python3 python3-pip python3-venv nodejs npm
            fi
        elif grep -q "Fedora" /etc/os-release 2>/dev/null; then
            if command -v sudo > /dev/null 2>&1; then
                sudo dnf groupinstall --setopt fastestmirror=1 -y "Development Tools"
                sudo dnf install -y SDL2
            else
                dnf groupinstall --setopt fastestmirror=1 -y "Development Tools"
                dnf install -y SDL2
            fi
        elif grep -q "Arch Linux" /etc/os-release 2>/dev/null; then
            if command -v sudo > /dev/null 2>&1; then
                sudo pacman -S --needed base-devel python3
            else
                pacman -S --needed base-devel python3
            fi
        else
            echo "Unable to determine your Linux distribution. Please open an issue."
            exit 1
        fi
    fi

    # Create and activate virtual environment
    python3 -m venv .venv
    if [ $? -ne 0 ]; then
        echo "Failed to create virtual environment"
        exit 1
    fi

    source .venv/bin/activate
    if [ $? -ne 0 ]; then
        echo "Failed to activate virtual environment"
        exit 1
    fi

    # Install dependencies
    if [ ! -f requirements.txt ]; then
        echo "requirements.txt is missing"
        exit 1
    fi

    pip install -r requirements.txt
    if [ $? -ne 0 ]; then
        echo "Failed to install dependencies"
        exit 1
    fi

    # Django setup
    cd src
    mkdir -p assets
    python manage.py makemigrations
    if [ $? -ne 0 ]; then
        echo "Failed to make migrations"
        exit 1
    fi

    python manage.py migrate
    if [ $? -ne 0 ]; then
        echo "Failed to apply database migrations"
        exit 1
    fi

    python manage.py compilemessages
    if [ $? -ne 0 ]; then
        echo "Failed to compile locale"
        exit 1
    fi

    echo "All commands ran successfully!"
}

case $1 in
    -h)
        help
        ;;
    -r)
        start
        ;;
    -s)
        stop
        ;;
    -m)
	editdb
	;;
    -mg)
	migrate
	;;
    -st)
	settings
	;;
    -i)
	init
	;;
    *)
        echo "Invalid option. Use -h for help."
        exit 1
        ;;
esac

