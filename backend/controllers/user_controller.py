from pymongo import MongoClient
from bson.objectid import ObjectId
from werkzeug.security import generate_password_hash, check_password_hash

client = MongoClient("mongodb+srv://<*******>:<********>@cluster0.tr4crzg.mongodb.net/")
db = client["posted_notes"]
users_collection = db["users"]

def register_user(username, email, password, graduation_date=None, college=None):
    hashed_password = generate_password_hash(password)
    user_data = {
        "username": username,
        "email": email,
        "password": hashed_password,
        "graduation_date": graduation_date,
        "college": college
    }
    result = users_collection.insert_one(user_data)
    return result.inserted_id

def login_user(username, password):
    user = users_collection.find_one({"username": username})
    if user and check_password_hash(user["password"], password):
        return user
    return None

def update_profile(user_id, **kwargs):
    user_query = {"_id": ObjectId(user_id)}
    new_values = {"$set": kwargs}
    result = users_collection.update_one(user_query, new_values)
    if result.modified_count > 0:
        return users_collection.find_one(user_query)
    return None
