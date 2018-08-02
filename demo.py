import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import random,time
import json

cred = credentials.Certificate('lino2018-ad380-firebase-adminsdk-0kxy6-12a589b7ea.json')

firebase_admin.initialize_app(cred, {
    'databaseURL' : 'https://lino2018-ad380.firebaseio.com'
})

random.seed()

root = db.reference()

data = {}

with open('lino2018-ad380-Crowd-export.json', 'r') as f:
    data = json.load(f)

while True:
    time.sleep(3)
    for i in range(500):
        lat =  21.40 + round(random.uniform(0, 0.02), 6)
        lng = 39.88 + round(random.uniform(0, 0.02), 6)
        status = 'Active'
        if i % 2 == 1:
            status = 'inActive'
        data[str(i) + "-tmp"]['location']['lat'] += round(random.uniform(0, 0.02), 6)
        data[str(i) + "-tmp"]['location']['lng'] += round(random.uniform(0, 0.02), 6)
    new_user = root.child('Crowd').update(data)


# Add a new user under /users.
    # time.sleep(3)
    # for i in range(500):
    #     lat =  21.40 + round(random.uniform(0, 0.02), 6)
    #     lng = 39.88 + round(random.uniform(0, 0.02), 6)
    #     status = 'Active'
    #     if i % 2 == 1:
    #         status = 'inActive'
    #     template = {
    #         'campaign_id' : 'campaign_id',
    #         'location' : {
    #             "heading" : random.randint(0,360),
    #              "lat": lat,
    #              "lng": lng,
    #              "timestamp": 123456789
    #         },
    #         'status' : status,
    #         'numberOfPeople' : random.randint(10,300)
    #     }
    #     newData = {str(i) + "-tmp" : template}
    #     data.update(newData)
    # new_user = root.child('Crowd').update(data)
