from abc import ABC, abstractmethod

class EnrollmentDAO(ABC):
    @abstractmethod
    def enroll_student(self, enrollment):
        pass

    @abstractmethod
    def get_all_enrollments(self):
        pass

    @abstractmethod
    def get_enrollments_by_course(self, course_id):
        pass

    @abstractmethod
    def count_enrollments_by_course(self, course_id):
        pass

    @abstractmethod
    def get_enrollments_by_student(self, student_id):
        pass
