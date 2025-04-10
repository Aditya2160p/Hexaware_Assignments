from abc import ABC, abstractmethod

class TeacherDAO(ABC):
    @abstractmethod
    def add_teacher(self, teacher):
        pass

    @abstractmethod
    def get_all_teachers(self):
        pass
