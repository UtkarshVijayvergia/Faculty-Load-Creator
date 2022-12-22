from django.urls import path
from . import views


urlpatterns = [
    # path('', views.home, name="home"),
    # path('about.html', views.about, name="about"),
    # path('add_post.html', views.add_post, name="add_post"),
    # path('delete/<post_id>', views.delete, name="delete"),
    # path('delete_post.html', views.delete_post, name="delete_post"),
    path('course/', views.get_courses, name='course'),  # Retrieving all Active Courses Information
    path('courses/', views.post_courses, name='course'),  # Retrieving all Active Courses Information
    # path('course_data/', views.get_course_data),  # Retrieving all Active Courses Information
]