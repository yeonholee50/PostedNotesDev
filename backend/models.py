from flask_mongoengine import MongoEngine
from datetime import datetime

db = MongoEngine()

class User(db.Document):
    username = db.StringField(required=True, unique=True)
    email = db.EmailField(required=True, unique=True)
    password = db.StringField(required=True)
    graduation_date = db.DateTimeField()
    college = db.StringField()

class Instructor(db.Document):
    name = db.StringField(required=True)
    university = db.StringField(required=True)

class Course(db.Document):
    name = db.StringField(required=True)
    instructor = db.ReferenceField(Instructor)
    created_at = db.DateTimeField(default=datetime.utcnow)

