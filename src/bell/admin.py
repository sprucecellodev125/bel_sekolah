from django.contrib import admin

from django.contrib import admin
from .models import jadwalBel

@admin.register(jadwalBel)
class panelJadwalBel(admin.ModelAdmin):
    list_display = ('day', 'time', 'ringtone')
    list_filter = ('day', 'time')
    search_fields = ('day', 'time', 'ringtone')
