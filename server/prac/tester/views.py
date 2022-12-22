from django.shortcuts import render
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from prac import settings
from .models import course
from .forms import *
from .serializers import courseSerializer
# Create your views here.

@api_view(['GET'])
def get_courses(request):
    try:
        if request.method == 'GET':
            res = course.objects.all()
            serializer = courseSerializer(res, many=True)
            return Response(serializer.data)
    except Exception as e:
        return Response(e, status=status.HTTP_500_INTERNAL_SERVER_ERROR)




@api_view(['POST'])
def post_courses(request):
    try:
        if request.method == 'POST':
            data = request.data
            for i in range(len(data)):
                schedular_all = course.objects.get(course_id=data[i]["course_id"])
                schedular_all.hours=data[i]['newhours']
                schedular_all.save()
        return Response(status=status.HTTP_200_OK)
    except Exception as e:
        return Response(e, status=status.HTTP_500_INTERNAL_SERVER_ERROR)