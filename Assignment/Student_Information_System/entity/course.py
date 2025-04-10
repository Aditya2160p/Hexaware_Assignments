class Course:
    def __init__(self, course_id, course_name, credits, teacher_id=None):
        self.course_id = course_id
        self.course_name = course_name
        self.credits = credits
        self.teacher_id = teacher_id
