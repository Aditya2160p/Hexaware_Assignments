# Student-related exceptions
class StudentNotFoundException(Exception):
    def __init__(self, message="❌ Student not found."):
        super().__init__(message)

class InvalidStudentDataException(Exception):
    def __init__(self, message="❌ Invalid student data provided."):
        super().__init__(message)

# Course-related exceptions
class CourseNotFoundException(Exception):
    def __init__(self, message="❌ Course not found."):
        super().__init__(message)

class InvalidCourseDataException(Exception):
    def __init__(self, message="❌ Invalid course data provided."):
        super().__init__(message)

# Teacher-related exceptions
class TeacherNotFoundException(Exception):
    def __init__(self, message="❌ Teacher not found."):
        super().__init__(message)

class InvalidTeacherDataException(Exception):
    def __init__(self, message="❌ Invalid teacher data provided."):
        super().__init__(message)

# Enrollment-related
class DuplicateEnrollmentException(Exception):
    def __init__(self, message="❌ Student is already enrolled in this course."):
        super().__init__(message)

# Payment-related
class PaymentValidationException(Exception):
    def __init__(self, message="❌ Invalid payment amount or date."):
        super().__init__(message)


