from abc import ABC, abstractmethod

class CourseDAO(ABC):
    @abstractmethod
    def add_course(self, course):
        pass

    @abstractmethod
    def get_all_courses(self):
        pass

    @abstractmethod
    def get_courses_by_teacher(self, teacher_id):
        pass

    @abstractmethod
    def update_course(self, course):
        pass