from abc import ABC, abstractmethod
class CompanyDAO(ABC):
    @abstractmethod
    def insert_company(self, company): pass
    @abstractmethod
    def get_all_companies(self): pass
