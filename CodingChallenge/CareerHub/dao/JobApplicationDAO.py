from abc import ABC, abstractmethod
class JobApplicationDAO(ABC):
    @abstractmethod
    def insert_application(self, application): pass
    @abstractmethod
    def get_applications_for_job(self, job_id): pass