from datetime import datetime
from typing import Any
import phonenumbers
from phonenumbers import geocoder
import opencage
from opencage.geocoder import OpenCageGeocode
from pydub import AudioSegment
import speech_recognition as sr
from pydub.silence import split_on_silence
from urllib.request import urlopen
from twilio.rest import Client
from django.http import HttpRequest, HttpResponse
from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt
from twilio.twiml.voice_response import Dial, VoiceResponse
import os
import firebase_admin
from django.shortcuts import render
import pyrebase
from firebase_admin import firestore
from firebase_admin import credentials
from ivr.settings import BASE_DIR
import socketio
from better_profanity import profanity
import socketio

AudioSegment.converter = "C:\\ffmpeg\\ffmpeg\\bin\\ffmpeg.exe"
AudioSegment.ffmpeg = "C:\\ffmpeg\\ffmpeg\\bin\\ffmpeg.exe"
AudioSegment.ffprobe = "C:\\ffmpeg\\ffmpeg\\bin\\ffprobe.exe"

cred = credentials.Certificate(
    os.path.join(BASE_DIR, "serviceAccountKey.json"))
firebase_admin.initialize_app(cred)
db = firestore.client()

config = {
    "apiKey": "AIzaSyBZ6b-dvDNnlJm344nVodnmWYFoFojbhEY",
    "appId": "1:863025956296:web:3bc7762e817c771ce26cfd",
    "messagingSenderId": "863025956296",
    "projectId": "ivrs-8b2eb",
    "authDomain": "ivrs-8b2eb.firebaseapp.com",
    "storageBucket": "ivrs-8b2eb.appspot.com",
    "measurementId": "G-VL7RK7NDEH",
    "databaseURL": "https://ivrs-8b2eb-default-rtdb.firebaseio.com/"
}

db = firestore.client()
firebase = pyrebase.initialize_app(config)
authe = firebase.auth()
database = firebase.database()

number = None
sio = socketio.Client()

@csrf_exempt
def demo(request: HttpRequest) -> HttpResponse:


    if sio.connected:
        print("hfjre"),
    else:
        sio.connect('http://localhost:5000')

    if sio.connected:
        print("print")
        sio.emit("data", {"phone": number, "action": "incoming"})
    else:
        print("not connected")


    return HttpResponse("done", content_type='text/xml')




@csrf_exempt
def choose_service(request: HttpRequest) -> HttpResponse:
    from phonenumbers import geocoder

    sio.connect('http://localhost:5000')



    vr = VoiceResponse()
    vr.say('Welcome to Dial 100')
    account_sid = os.environ['TWILIO_ACCOUNT_SID']
    auth_token = os.environ['TWILIO_AUTH_TOKEN']
    client = Client(account_sid, auth_token)
    call = client.calls.list(limit=1)
    number = ""
    for record in call:
        number = record
    print(number)

    # location of device
    pepnumber = phonenumbers.parse(number)
    location = geocoder.description_for_number(pepnumber, "en")
    key = '2e73a66124b54bba973f559cd8e45b16'
    geocoder = OpenCageGeocode(key)
    query = str(location)
    results = geocoder.geocode(query)

    lat = (results[0]['geometry']['lat'])
    lng = (results[0]['geometry']['lng'])
    new_dict = {}
    status = []
    doctemp1 = db.collection(u'calls').where(u'status', u'==', 'block').stream()

    for i in doctemp1:
        new_dict[i.id] = i.to_dict()
        status.append(new_dict[i.id]['phone'])

    docs = {}
    all_numbers = []
    doctemp2 = db.collection(u'calls').stream()
    for i in doctemp2:
        docs[i.id] = i.to_dict()
        all_numbers.append(new_dict[i.id]['phone'])

    print("new dict", new_dict),

    if number in status or new_dict[number]['blank_call_count'] > 2:
        vr.say("You have been blocked! GOODBYE!")
        vr.hangup()
    else:

        if sio.connected:
            print("print")
            sio.emit("data", {"phone": number, "action": "incoming"})
        else:
            print("not connected")

    
        if number in all_numbers:
            db.collection(u'calls').document(number).update({
                "date": datetime.today(),
            })

        else:

            db.collection(u'calls').document(number).update({
                "blank_call_count": 0,
                "date": datetime.today(),
                "missed_call_count": 0,
                "phone": f'{number}',
                "status": "valid",
                "type": "",
                "lat": f'{lat}',
                "lng": f'{lng}'
            })

        with vr.gather(
                action=reverse('redirecting'),
                timeout=20,
        ) as gather:
            gather.say("Please press 1 for Police & Fire." +
                       "Press 2 for Ambulance", loop=3)

    vr.say('We did not receive your selection')
    vr.hangup()

    if number in all_numbers:
            db.collection(u'calls').document(number).update({
                "date": datetime.today(),
                 "missed_call_count": firestore.Increment(1),
                "type": "missed",
        })

    else:

        db.collection(u'calls').document(number).set({
            "blank_call_count": 0,
            "date": datetime.today(),
            "phone": f'{number}',
            "status": "valid",
            "lat": f'{lat}',
            "lng": f'{lng}',
            "missed_call_count": firestore.Increment(1),
            "type": "missed",
    })

    

    return HttpResponse(str(vr), content_type='text/xml')


@csrf_exempt
def redirecting(request: HttpRequest) -> HttpResponse:
    vr = VoiceResponse()
    digits = request.POST.get('Digits')

    if digits == '1':
        dial = Dial(
            record='record-from-answer-dual',
            recording_status_callback='https://e026-2405-201-3002-2805-301e-f280-9c58-14db.in.ngrok.io/police/get_recorded_audio'
        )
        dial.number('+917067305935')
        vr.append(dial)

    if digits == '2':
        dial = Dial(
            record='record-from-answer-dual',
            recording_status_callback='https://e026-2405-201-3002-2805-301e-f280-9c58-14db.in.ngrok.io/police/get_recorded_audio'
        )
        dial.number('+918982342434')
        vr.append(dial)

    return HttpResponse(str(vr), content_type='text/xml')


@csrf_exempt
def get_recorded_audio(request: HttpRequest) -> tuple[Any, HttpResponse]:
    recorder_file_url = request.POST.get('RecordingUrl')
    print('recorded file url', recorder_file_url)
    # saving wav file
    url = recorder_file_url
    with urlopen(url) as file:
        content = file.read()
    with open(r'C:\Users\palas\a.wav', 'wb') as download:
        download.write(content)

    # create a speech recognition object
    r = sr.Recognizer()
    path = r'C:\Users\palas\a.wav'

    # a function that splits the audio file into chunks
    # and applies speech recognition
    sound = AudioSegment.from_wav(path)
    # split audio sound where silence is 700 miliseconds or more and get chunks
    chunks = split_on_silence(sound,
                              # experiment with this value for your target audio file
                              min_silence_len=500,
                              # adjust this per requirement
                              silence_thresh=sound.dBFS - 14,
                              # keep the silence for 1 second, adjustable as well
                              keep_silence=500,
                              )
    folder_name = "audio-chunks"
    # create a directory to store the audio chunks
    if not os.path.isdir(folder_name):
        os.mkdir(folder_name)
    whole_text = ""
    # process each chunk
    for i, audio_chunk in enumerate(chunks, start=1):
        # export audio chunk and save it in
        # the `folder_name` directory.
        chunk_filename = os.path.join(folder_name, f"chunk{i}.wav")
        audio_chunk.export(chunk_filename, format="wav")
        # recognize the chunk
        with sr.AudioFile(chunk_filename) as source:

            audio_listened = r.record(source)
            # try converting it to text
            try:
                text = r.recognize_google(audio_listened)
            except sr.UnknownValueError as e:
                pass
            else:
                text = f"{text.capitalize()}. "
                whole_text += text
            calltype = None
            if len(whole_text) == 0 or whole_text == None:

                calltype = 'blank'
                db.collection(u'calls').document(number).update({
                    "type": "blank",
                    "blank"
                    "recorded_file": recorder_file_url,
                    "blank_call_count": firestore.Increment(1),
                    })
            elif bool(checkAbusive(whole_text)):
                calltype = 'abusive'
                db.collection(u'calls').document(number).update({
                    "type": "abusive",
                    "status": "block",
                    "recorded_file": recorder_file_url,
                })
            else:
                pass



    if sio.connected:
        print("print")
        sio.emit("data", {"action": "ended", "call_type": calltype, "phone": number })
    else:
        print("not connected")

    print(whole_text, len(whole_text))

    return HttpResponse(str(whole_text), content_type='text/xml')


def checkAbusive(text):
    cus_badwords = []
    profanity.load_censor_words(cus_badwords)
    cen_text = profanity.censor(text, '-')
    if '--' in cen_text:
        return True
    else:
        return False


# FIREBASE INDEX
def index(request):
    # accessing our firebase data and storing it in a variable
    name = database.child('Data').child('Name').get().val()
    stack = database.child('Data').child('Stack').get().val()
    framework = database.child('Data').child('Framework').get().val()

    context = {
        'name': name,
        'stack': stack,
        'framework': framework
    }
    return render(request, 'index.html', context)
