#!/bin/bash
source $PWD/.venv/bin/activate
cd src/
python manage.py runserver 0.0.0.0:8000
