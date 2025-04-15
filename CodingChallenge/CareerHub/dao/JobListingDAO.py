from abc import ABC, abstractmethod
class JobListingDAO(ABC):
    @abstractmethod
    def insert_job(self, job): pass
    @abstractmethod
    def get_all_jobs(self): pass
    @abstractmethod
    def get_jobs_in_salary_range(self, min_salary: float, max_salary: float): pass
