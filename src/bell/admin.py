from django.contrib import admin
from .models import jadwalBel
from django.utils.translation import gettext_lazy as _

@admin.action(description=_("Copy to Monday"))
def copy_to_monday(modeladmin, request, queryset):
    for obj in queryset:
        jadwalBel.objects.create(
            day='Monday',
            time=obj.time,
            ringtone=obj.ringtone
        )
    modeladmin.message_user(request, _("%d schedule(s) copied to Monday.") % queryset.count())

@admin.action(description=_("Copy to Tuesday"))
def copy_to_tuesday(modeladmin, request, queryset):
    for obj in queryset:
        jadwalBel.objects.create(
            day='Tuesday',
            time=obj.time,
            ringtone=obj.ringtone
        )
    modeladmin.message_user(request, _("%d schedule(s) copied to Tuesday.") % queryset.count())

@admin.action(description=_("Copy to Wednesday"))
def copy_to_wednesday(modeladmin, request, queryset):
    for obj in queryset:
        jadwalBel.objects.create(
            day='Wednesday',
            time=obj.time,
            ringtone=obj.ringtone
        )
    modeladmin.message_user(request, _("%d schedule(s) copied to Wednesday.") % queryset.count())

@admin.action(description=_("Copy to Thursday"))
def copy_to_thursday(modeladmin, request, queryset):
    for obj in queryset:
        jadwalBel.objects.create(
            day='Thursday',
            time=obj.time,
            ringtone=obj.ringtone
        )
    modeladmin.message_user(request, _("%d schedule(s) copied to Thursday.") % queryset.count())

@admin.action(description=_("Copy to Friday"))
def copy_to_friday(modeladmin, request, queryset):
    for obj in queryset:
        jadwalBel.objects.create(
            day='Friday',
            time=obj.time,
            ringtone=obj.ringtone
        )
    modeladmin.message_user(request, _("%d schedule(s) copied to Friday.") % queryset.count())

@admin.action(description=_("Copy to Saturday"))
def copy_to_saturday(modeladmin, request, queryset):
    for obj in queryset:
        jadwalBel.objects.create(
            day='Saturday',
            time=obj.time,
            ringtone=obj.ringtone
        )
    modeladmin.message_user(request, _("%d schedule(s) copied to Saturday.") % queryset.count())

@admin.action(description=_("Copy to Sunday"))
def copy_to_sunday(modeladmin, request, queryset):
    for obj in queryset:
        jadwalBel.objects.create(
            day='Sunday',
            time=obj.time,
            ringtone=obj.ringtone
        )
    modeladmin.message_user(request, _("%d schedule(s) copied to Sunday.") % queryset.count())

@admin.register(jadwalBel)
class panelJadwalBel(admin.ModelAdmin):
    list_display = ('day', 'time', 'ringtone')
    list_filter = ('day', 'time')
    search_fields = ('day', 'time', 'ringtone')
    actions = [copy_to_monday, copy_to_tuesday, copy_to_wednesday, copy_to_thursday, copy_to_friday, copy_to_saturday, copy_to_sunday]