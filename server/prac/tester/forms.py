from django import forms  
from tester.models import *
from django.utils.safestring import mark_safe
from django.forms import ModelChoiceField


class courseForm(forms.ModelForm):
    class Meta:  
        model = course
        fields = "__all__"
