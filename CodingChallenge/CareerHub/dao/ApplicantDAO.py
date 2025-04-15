from abc import ABC, abstractmethod

class ApplicantDAO(ABC):
    @abstractmethod
    def insert_applicant(self, applicant): pass

    @abstractmethod
    def get_all_applicants(self): pass




