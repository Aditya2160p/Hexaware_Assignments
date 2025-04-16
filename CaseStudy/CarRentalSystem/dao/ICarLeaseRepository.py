from abc import ABC, abstractmethod
from typing import List
from datetime import date
from entity.Vehicle import Vehicle
from entity.Customer import Customer
from entity.Lease import Lease

class ICarLeaseRepository(ABC):

    # Car Management
    @abstractmethod
    def addCar(self, car: Vehicle): pass

    @abstractmethod
    def removeCar(self, carID: int): pass

    @abstractmethod
    def listAvailableCars(self) -> List[Vehicle]: pass

    @abstractmethod
    def listRentedCars(self) -> List[Vehicle]: pass

    @abstractmethod
    def findCarById(self, carID: int) -> Vehicle: pass

    # Customer Management
    @abstractmethod
    def addCustomer(self, customer: Customer): pass

    @abstractmethod
    def removeCustomer(self, customerID: int): pass

    @abstractmethod
    def listCustomers(self) -> List[Customer]: pass

    @abstractmethod
    def findCustomerById(self, customerID: int) -> Customer: pass

    # Lease Management
    @abstractmethod
    def createLease(self, customerID: int, carID: int, startDate: date, endDate: date) -> Lease: pass

    @abstractmethod
    def returnCar(self, leaseID: int) -> Lease: pass

    @abstractmethod
    def listActiveLeases(self) -> List[Lease]: pass

    @abstractmethod
    def listLeaseHistory(self) -> List[Lease]: pass

    # Payment Handling
    @abstractmethod
    def recordPayment(self, lease: Lease, amount: float): pass

    # Additional Methods
    @abstractmethod
    def updateCustomer(self, customer: Customer): pass

    @abstractmethod
    def getCustomerDetails(self, customerID: int) -> Customer: pass

    @abstractmethod
    def updateCarAvailability(self, carID: int, status: str): pass

    @abstractmethod
    def getCarDetails(self, carID: int) -> Vehicle: pass

    @abstractmethod
    def calculateLeaseCost(self, carID: int, startDate: date, endDate: date) -> float: pass

    @abstractmethod
    def getPaymentHistory(self, customerID: int): pass

    @abstractmethod
    def getTotalRevenue(self) -> float: pass
