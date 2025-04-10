from abc import ABC, abstractmethod

class StudentDAO(ABC):
    @abstractmethod
    def add_student(self, student):
        pass

    @abstractmethod
    def get_all_students(self):
        pass
