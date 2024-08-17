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
            ('10:18',),
            ('10:25',),
            ('10:30',),
            ('10:35',),
            ('10:40',),
            ('10:45',),
            ('10:50',),
            ('10:55',),
            ('11:00',),
            ('11:05',),
            ('11:10',),
            ('11:15',),
            ('11:20',),
            ('11:25',),
            ('11:30',),
            ('11:40',),
            ('11:45',),
            ('11:50',),
            ('11:55',),
            ('12:00',),
            ('12:05',),
            ('12:10',),
            ('12:15',),
            ('12:20',),
            ('12:25',),
            ('12:30',),
            ('12:35',),
            ('12:40',),
            ('12:50',),
            ('13:10',),
            ('13:15',),
            ('13:20',),
            ('13:25',),
            ('13:30',),
            ('13:35',),
            ('13:50',),
            ('13:55',),
            ('14:02',),
            ('14:06',),
            ('14:10',),
            ('14:15',),
            ('14:20',),
            ('14:25',),
            ('14:30',),
            ('14:35',),
            ('14:40',),
            ('14:45',),
            ('14:50',),
            ('14:55',),
            ('15:00',),
            ('15:05',),
            ('15:10',),
            ('15:15',),
            ('15:20',),
            ('15:25',),
            ('15:30',),
            ('15:35',),
            ('15:40',),
            ('15:45',),
            ('15:50',),
            ('15:55',),
            ('16:00',),
            ('16:05',),
            ('16:10',),
            ('16:15',),
            ('16:20',),
            ('16:25',),
            ('16:30',),
            ('21:25',),
            ('21:40',),
            ('22:00',),
            ('22:05',),
            ('22:10',),
            ('22:15',),
            ('22:20',),
            ('22:25',),
            ('22:30',),
            ('22:35',),
            ('22:40',),
            ('22:45',),
            ]

    HARI = [
            ('Monday', _('Monday')),
            ('Tuesday', _('Tuesday')),
            ('Wednesday', _('Wednesday')),
            ('Thursday', _('Thursday')),
            ('Friday', _('Friday')),
            ('Saturday', _('Saturday')),
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
