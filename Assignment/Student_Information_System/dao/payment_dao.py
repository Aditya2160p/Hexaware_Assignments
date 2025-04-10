from abc import ABC, abstractmethod

class PaymentDAO(ABC):
    @abstractmethod
    def add_payment(self, payment):
        pass

    @abstractmethod
    def get_all_payments(self):
        pass

    @abstractmethod
    def get_payments_by_student(self, student_id):
        pass

    @abstractmethod
    def sum_payments_by_course(self, course_id):
        pass