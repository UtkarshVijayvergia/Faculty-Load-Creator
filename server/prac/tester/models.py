from django.db import models
from django.utils.timezone import now
from rest_framework import status
# Create your models here.

class course(models.Model):
    course_id = models.CharField(max_length=30, unique=True, primary_key=True)
    credit = models.CharField(max_length=5)
    hours = models.CharField(max_length=5, default=0)
    current_timestamp = models.DateTimeField(null=True, blank=True, editable=False)

    def save(self, *args, **kwargs):
        self.current_timestamp = now()
        super(course, self).save(*args, **kwargs)

    def __str__(self):
        return self.course_id