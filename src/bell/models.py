from django.db import models
from django.utils.translation import gettext_lazy as _
from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
import os
import signal

ASSET = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'assets')

def ambilNada():
    return [(file, file) for file in os.listdir(ASSET) if file.endswith('.mp3')]

class jadwalBel(models.Model):
    WAKTU = [
            ('07:15',),
            ('07:55',),
            ('08:35',),
            ('09:15',),
            ('09:55',),
            ('10:10',),
            ('10:50',),
            ('11:30',),
            ('12:10',),
            ('12:40',),
            ('12:50',),
            ('13:15',),
            ('13:50',),
            ('13:55',),
            ('14:25',),
            ('14:30',),
            ('15:00',),
            ('15:05',),
            ('15:40',),
            ]

    HARI = [
            ('Monday', _('Monday')),
            ('Tuesday', _('Tuesday')),
            ('Wednesday', _('Wednesday')),
            ('Thursday', _('Thursday')),
            ('Friday', _('Friday')),
            ]


    day = models.CharField(_('day'), max_length=9, choices=HARI)
    time = models.CharField(_('time'), max_length=5, choices=[(choice[0], choice[0]) for choice in WAKTU])
    ringtone = models.CharField(_('ringtone'), max_length=100, choices=ambilNada())

    class Meta:
        verbose_name = _('Bell Schedule')
        verbose_name_plural = _('Bell Schedules')

    def __str__(self):
        return f"{self.get_day_display()} {self.time} - {self.ringtone}"
    
@receiver(post_save, sender=jadwalBel)
def restart_scheduler(sender, **kwargs):
    with open("/tmp/restart_scheduler.flag", "w") as flag_file:
        flag_file.write("restart")
