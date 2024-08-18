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
                source ~/.bashrc
                nvm install node
                npm i -g pm2
            elif command -v curl &> /dev/null; then
                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
                source ~/.bashrc
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
    python -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    cd src
    mkdir assets
    python manage.py makemigrations
    python manage.py migrate
    python manage.py compilemessages
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

