class Lease:
    def __init__(self, leaseID=None, vehicleID=None, customerID=None, startDate=None, endDate=None, type=None):
        self.__leaseID = leaseID
        self.__vehicleID = vehicleID
        self.__customerID = customerID
        self.__startDate = startDate
        self.__endDate = endDate
        self.__type = type

    def get_leaseID(self): return self.__leaseID
    def set_leaseID(self, leaseID): self.__leaseID = leaseID

    def get_vehicleID(self): return self.__vehicleID
    def set_vehicleID(self, vehicleID): self.__vehicleID = vehicleID

    def get_customerID(self): return self.__customerID
    def set_customerID(self, customerID): self.__customerID = customerID

    def get_startDate(self): return self.__startDate
    def set_startDate(self, startDate): self.__startDate = startDate

    def get_endDate(self): return self.__endDate
    def set_endDate(self, endDate): self.__endDate = endDate

    def get_type(self): return self.__type
    def set_type(self, type): self.__type = type
