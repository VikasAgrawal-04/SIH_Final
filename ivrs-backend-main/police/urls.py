# movies/urls.py
from django.urls import path
from django.contrib import admin
from police import views

urlpatterns = [
  path('admin/', admin.site.urls),
  path('choose_service', views.choose_service, name='choose_service'),
  path('redirecting', views.redirecting, name='redirecting'),
  path('get_recorded_audio', views.get_recorded_audio, name='get_recorded_audio'),
  path('demo', views.demo, name='demo'),

]
