from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection

from django.views.decorators.csrf import csrf_exempt
import json

@csrf_exempt
def postuser(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    username = json_data['username']
    password = json_data['password']
    location = json_data['location']
    price = ''
    fileurl = ''
    description = ''

    cursor = connection.cursor()
    cursor.execute('INSERT INTO models (username, password, location, price, fileurl, description) VALUES '
                   '(%s, %s, %s, %s, %s, %s);', (username, password, location, price, fileurl, description))
    return JsonResponse({})

def getusers(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    
    cursor = connection.cursor()
    cursor.execute('SELECT DISTINCT username FROM models WHERE public = true ORDER BY username DESC;')
    rows = cursor.fetchall()

    response = {}
    response['users'] = rows
    return JsonResponse(response)
# Create your views here.
