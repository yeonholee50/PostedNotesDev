from pymongo import MongoClient
from bson.objectid import ObjectId

client = MongoClient("mongodb+srv://<***********>:<*************>@cluster0.tr4crzg.mongodb.net/")
db = client["posted_notes"]
verification_collection = db["verification"]

def verify_user_identity(user_id, school_id):
    verification_query = {"user_id": ObjectId(user_id), "school_id": school_id}
    verification = verification_collection.find_one(verification_query)
    if verification:
        return True
    return False
