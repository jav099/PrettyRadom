from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection

from django.views.decorators.csrf import csrf_exempt
import json
import os, time
from django.conf import settings
from django.core.files.storage import FileSystemStorage

@csrf_exempt
def postuser(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    username = json_data['username']
    password = json_data['password']
    location = json_data['location']
    public = json_data['public']
    price = ''
    fileurl = ''
    description = ''

    cursor = connection.cursor()
    cursor.execute('INSERT INTO models (username, password, public, location, price, fileurl, description) VALUES '
                   '(%s, %s, %s, %s, %s, %s, %s);', (username, password, public, location, price, fileurl, description))
    return JsonResponse({})

def getusers(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
    
    cursor = connection.cursor()
    cursor.execute('SELECT DISTINCT username, location FROM models WHERE public = true ORDER BY username DESC;')
    rows = cursor.fetchall()

    response = {}
    response['users'] = rows
    return JsonResponse(response)
# Create your views here.

@csrf_exempt
def postmodel(request):
    if request.method != 'POST':
        return HttpResponse(status=400)

    # loading form-encoded data
    username = request.POST.get("username")
    description = request.POST.get("description")
    price = request.POST.get("price")
    cursor = connection.cursor()
    s = 'SELECT password, public, location FROM models WHERE(username=(%s));'
    cursor.execute(s, [username])
    rows = cursor.fetchone()
    password = rows[0]
    public = rows[1]
    location = rows[2]
    modelName = request.POST.get('modelName')


    

    if request.FILES.get("model"):
        content = request.FILES['model']
        filename = modelName+username+".usdz"
        fs = FileSystemStorage()
        filename = fs.save(filename, content)
        fileurl = fs.url(filename)
    else:
        fileurl = None

    cursor.execute('INSERT INTO models (username, description, price, password, public, location, modelName, fileurl) VALUES '
                   '(%s, %s, %s, %s, %s, %s, %s, %s);', (username, description, price, password, public, location, modelName, fileurl))

    return JsonResponse({})

def getmodels(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    username = json_data['username']

    cursor = connection.cursor()
    s = 'SELECT description, price, modelName, fileurl FROM models WHERE(username=(%s) AND public = true);'
    cursor.execute(s, [username])
    rows = cursor.fetchall()

    response = {}
    response['models'] = rows
    return JsonResponse(response)

def login(request):
    if request.method != 'GET':
        return HttpResponse(status=404)
   
    json_data = json.loads(request.body)
    username = json_data['username']
    password = json_data['password']

    cursor = connection.cursor()
    s = 'SELECT password FROM models WHERE(username=(%s));'
    cursor.execute(s, [username])

    correctPassword = cursor.fetchone()

    if correctPassword[0] == password:
        return JsonResponse({"status": "success"})
    else:
        return JsonResponse({"status": "failure"})


