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
    cursor.execute('SELECT DISTINCT username FROM models WHERE public = true ORDER BY username DESC;')
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
    cursor.execute('SELECT password, public, location FROM models WHERE username=(username) VALUES ''(%s);', (username) )
    rows = cursor.fetchone()
    password = rows['password']
    public = rows['public']
    location = rows['location']
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

    cursor = connection.cursor()
    cursor.execute('SELECT description, price, modelName, fileurl FROM models WHERE public = true ORDER BY username DESC;')
    rows = cursor.fetchall()

    response = {}
    response['models'] = rows
    return JsonResponse(response)
