import os
import django
import time
import datetime
import pygame
import sys

RPATH = os.path.join(os.path.dirname(__file__))
sys.path.append(RPATH)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'bel_sekolah.settings')
django.setup()

from bell.models import jadwalBel

# Initialize pygame mixer
pygame.mixer.init()

def play_bell(ringtone):
    path = os.path.join('assets', ringtone)

    if os.path.isdir(path):
        # It's an album (a folder), so play all MP3s inside
        mp3_files = sorted([
            os.path.join(path, f) for f in os.listdir(path)
            if f.lower().endswith('.mp3')
        ])
        for file in mp3_files:
            print(f"Playing {file}...")
            pygame.mixer.music.load(file)
            pygame.mixer.music.play()
            while pygame.mixer.music.get_busy():
                time.sleep(1)
    else:
        # It's a single MP3 file
        print(f"Playing {path}...")
        pygame.mixer.music.load(path)
        pygame.mixer.music.play()
        while pygame.mixer.music.get_busy():
            time.sleep(1)

def fetch_and_list_schedules():
    schedules = jadwalBel.objects.all()
    print("Listing all bell schedules:")
    for schedule in schedules:
        print(f"Day: {schedule.get_day_display()}, Time: {schedule.time}, Ringtone: {schedule.get_ringtone_display()}")

def main():
    fetch_and_list_schedules()
    while True:
        now = datetime.datetime.now()
        current_day = now.strftime('%A')
        current_time = now.strftime('%H:%M')
        
        schedules = jadwalBel.objects.filter(day=current_day, time=current_time)
        
        for schedule in schedules:
            print(f"Playing bell for {schedule.get_day_display()} at {schedule.time} with ringtone {schedule.get_ringtone_display()}")
            play_bell(schedule.ringtone)
        
        if os.path.exists("/tmp/restart_scheduler.flag"):
            print("Restart flag detected. Restarting scheduler...")
            os.remove("/tmp/restart_scheduler.flag")
            os.execv(sys.executable, ['python'] + sys.argv)
        
        # Sleep for 60 seconds before checking again
        time.sleep(60)

if __name__ == "__main__":
    main()
