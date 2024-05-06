from pymongo import MongoClient
from bson.objectid import ObjectId

client = MongoClient("mongodb+srv://<*******>:<*************>@cluster0.tr4crzg.mongodb.net/")
db = client["posted_notes"]
courses_collection = db["courses"]

def get_courses():
    courses = courses_collection.find()
    return list(courses)

def get_course_notes(course_id, user_id):
    course_query = {"_id": ObjectId(course_id)}
    course = courses_collection.find_one(course_query)
    if course:
        # Check if the user is authorized to view notes for the course
        if user_id in course["authorized_users"]:
            return course["notes"]
    return None
