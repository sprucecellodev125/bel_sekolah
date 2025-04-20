from django.db import models
from django.utils.translation import gettext_lazy as _
from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
import os
import signal

# Path to the assets folder
ASSET_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'assets')

def ambilNada():
    nada = []
    for root, dirs, files in os.walk(ASSET_DIR):
        for file in files:
            if file.endswith('.mp3'):
                full_path = os.path.join(root, file)
                relative_path = os.path.relpath(full_path, ASSET_DIR)
                nada.append((relative_path, relative_path))
        for dir in dirs:
            dir_path = os.path.join(root, dir)
            rel_dir = os.path.relpath(dir_path, ASSET_DIR)
            nada.append((rel_dir, f"[Album] {rel_dir}"))
        break
    return list(set(nada))

class jadwalBel(models.Model):
    HARI = [
        ('Monday', _('Monday')),
        ('Tuesday', _('Tuesday')),
        ('Wednesday', _('Wednesday')),
        ('Thursday', _('Thursday')),
        ('Friday', _('Friday')),
        ('Saturday', _('Saturday')),
        ('Sunday', _('Sunday')),
    ]

    day = models.CharField(_('day'), max_length=9, choices=HARI)
    time = models.TimeField(_('time'))
    ringtone = models.CharField(_('ringtone'), max_length=200, choices=ambilNada())

    class Meta:
        verbose_name = _('Bell Schedule')
        verbose_name_plural = _('Bell Schedules')

    def __str__(self):
        return f"{self.get_day_display()} {self.time.strftime('%H:%M')} - {self.ringtone}"

@receiver(post_save, sender=jadwalBel)
def restart_scheduler(sender, instance, created, **kwargs):
    """Trigger scheduler restart when new schedules are added."""
    if created:
        with open("/tmp/restart_scheduler.flag", "w") as flag_file:
            flag_file.write("restart")
