from models import db, Instructor, Course

def create_instructor(name, university):
    new_instructor = Instructor(name=name, university=university)
    db.session.add(new_instructor)
    db.session.commit()
    return new_instructor

def create_course(name, instructor_id):
    new_course = Course(name=name, instructor_id=instructor_id)
    db.session.add(new_course)
    db.session.commit()
    return new_course