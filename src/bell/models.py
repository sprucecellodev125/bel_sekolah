from django.db import models
from django.utils.translation import gettext_lazy as _
from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
import os
import signal

# Path to the assets folder
ASSET_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'assets')

def ambilNada():
    if not os.path.exists(ASSET_DIR):
        return []
    return [(file, file) for file in os.listdir(ASSET_DIR) if file.endswith('.mp3')]

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
    ringtone = models.CharField(_('ringtone'), max_length=100, choices=ambilNada)

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
