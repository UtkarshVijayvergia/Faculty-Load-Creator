from rest_framework.serializers import ModelSerializer

from .models import course


# Retrieval of complete course information
class courseSerializer(ModelSerializer):
    class Meta:
        model = course
        fields = '__all__'
