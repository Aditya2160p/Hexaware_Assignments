from dao.ICarLeaseRepository import ICarLeaseRepository
from util.DBConnUtil import DBConnUtil
from entity.Vehicle import Vehicle
from entity.Customer import Customer
from entity.Lease import Lease
from entity.Payment import Payment
from datetime import date
from myexceptions.CarNotFoundException import CarNotFoundException
from myexceptions.CustomerNotFoundException import CustomerNotFoundException
from myexceptions.LeaseNotFoundException import LeaseNotFoundException

class ICarLeaseRepositoryImpl(ICarLeaseRepository):
    def __init__(self):
        self.conn = DBConnUtil.getConnection()
        self.cursor = self.conn.cursor()

    # Car Management
    def addCar(self, car: Vehicle):
        query = """
            INSERT INTO Vehicle (make, model, year, dailyRate, status, passengerCapacity, engineCapacity)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """
        self.cursor.execute(query, (
            car.get_make(), car.get_model(), car.get_year(), car.get_dailyRate(),
            car.get_status(), car.get_passengerCapacity(), car.get_engineCapacity()
        ))
        self.conn.commit()

    def removeCar(self, carID: int):
        self.cursor.execute("DELETE FROM Vehicle WHERE vehicleID = ?", (carID,))
        self.conn.commit()

    def listAvailableCars(self):
        query = """
            SELECT * FROM Vehicle 
            WHERE vehicleID NOT IN (
                SELECT vehicleID 
                FROM Lease 
                WHERE startDate <= endDate  -- Exclude all leased cars
            )
        """
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        return [Vehicle(*row) for row in rows]

    def listRentedCars(self):
        query = """
            SELECT * FROM Vehicle 
            WHERE vehicleID IN (
                SELECT vehicleID 
                FROM Lease 
                WHERE startDate <= endDate
            )
        """
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        return [Vehicle(*row) for row in rows]

    def findCarById(self, carID: int):
        self.cursor.execute("SELECT * FROM Vehicle WHERE vehicleID = ?", (carID,))
        row = self.cursor.fetchone()
        if row:
            return Vehicle(*row)
        else:
            raise CarNotFoundException(carID)

    # Customer Management
    def addCustomer(self, customer: Customer):
        query = """
            INSERT INTO Customer (firstName, lastName, email, phoneNumber)
            VALUES (?, ?, ?, ?)
        """
        self.cursor.execute(query, (
            customer.get_firstName(), customer.get_lastName(),
            customer.get_email(), customer.get_phoneNumber()
        ))
        self.conn.commit()

    def removeCustomer(self, customerID: int):
        self.cursor.execute("DELETE FROM Customer WHERE customerID = ?", (customerID,))
        self.conn.commit()

    def listCustomers(self):
        self.cursor.execute("SELECT * FROM Customer")
        rows = self.cursor.fetchall()
        return [Customer(*row) for row in rows]

    def findCustomerById(self, customerID: int):
        self.cursor.execute("SELECT * FROM Customer WHERE customerID = ?", (customerID,))
        row = self.cursor.fetchone()
        if row:
            return Customer(*row)
        else:
            raise CustomerNotFoundException(customerID)

    # Lease Management
    def createLease(self, customerID: int, carID: int, startDate: date, endDate: date):
        lease_type = "MonthlyLease" if (endDate - startDate).days >= 30 else "DailyLease"

        # 1. Insert the lease
        insert_query = """
            INSERT INTO Lease (vehicleID, customerID, startDate, endDate, type)
            VALUES (?, ?, ?, ?, ?)
        """
        self.cursor.execute(insert_query, (carID, customerID, startDate, endDate, lease_type))

        # 2. Immediately get the last inserted ID
        self.cursor.execute("SELECT SCOPE_IDENTITY()")
        lease_id_row = self.cursor.fetchone()
        lease_id = lease_id_row[0] if lease_id_row else None

        # 3. Update vehicle status
        self.cursor.execute("UPDATE Vehicle SET status = 'notAvailable' WHERE vehicleID = ?", (carID,))
        self.conn.commit()

        return Lease(lease_id, carID, customerID, startDate, endDate, lease_type)

    def returnCar(self, leaseID: int):
        self.cursor.execute("SELECT vehicleID FROM Lease WHERE leaseID = ?", (leaseID,))
        result = self.cursor.fetchone()
        if not result:
            raise LeaseNotFoundException(leaseID)

        vehicleID = result[0]
        self.cursor.execute("UPDATE Vehicle SET status='available' WHERE vehicleID = ?", (vehicleID,))
        self.conn.commit()

        self.cursor.execute("SELECT * FROM Lease WHERE leaseID = ?", (leaseID,))
        row = self.cursor.fetchone()
        return Lease(*row) if row else None

    def listActiveLeases(self):
        self.cursor.execute("SELECT * FROM Lease WHERE endDate >= CAST(GETDATE() AS DATE)")
        rows = self.cursor.fetchall()
        return [Lease(*row) for row in rows]

    def listLeaseHistory(self):
        self.cursor.execute("SELECT * FROM Lease")
        rows = self.cursor.fetchall()
        return [Lease(*row) for row in rows]

    # Payment Handling
    def recordPayment(self, lease: Lease, amount: float):
        query = "INSERT INTO Payment (leaseID, paymentDate, amount) VALUES (?, GETDATE(), ?)"
        self.cursor.execute(query, (lease.get_leaseID(), amount))
        self.conn.commit()

    def updateCustomer(self, customer: Customer):
        query = """
            UPDATE Customer 
            SET firstName = ?, lastName = ?, email = ?, phoneNumber = ?
            WHERE customerID = ?
        """
        self.cursor.execute(query, (
            customer.get_firstName(),
            customer.get_lastName(),
            customer.get_email(),
            customer.get_phoneNumber(),
            customer.get_customerID()
        ))
        self.conn.commit()

    def getCustomerDetails(self, customerID: int) -> Customer:
        return self.findCustomerById(customerID)

    def updateCarAvailability(self, carID: int, status: str):
        self.cursor.execute("UPDATE Vehicle SET status = ? WHERE vehicleID = ?", (status, carID))
        self.conn.commit()

    def getCarDetails(self, carID: int) -> Vehicle:
        return self.findCarById(carID)

    def calculateLeaseCost(self, carID: int, startDate: date, endDate: date) -> float:
        self.cursor.execute("SELECT dailyRate FROM Vehicle WHERE vehicleID = ?", (carID,))
        rate_row = self.cursor.fetchone()
        if not rate_row:
            raise CarNotFoundException(carID)
        rate = rate_row[0]

        total_days = (endDate - startDate).days
        if total_days >= 30:
            months = total_days // 30
            return months * rate * 25  # Monthly package
        else:
            return total_days * rate

    def getPaymentHistory(self, customerID: int):
        query = """
            SELECT p.paymentID, p.paymentDate, p.amount
            FROM Payment p
            JOIN Lease l ON p.leaseID = l.leaseID
            WHERE l.customerID = ?
        """
        self.cursor.execute(query, (customerID,))
        return self.cursor.fetchall()

    def getTotalRevenue(self) -> float:
        self.cursor.execute("SELECT SUM(amount) FROM Payment")
        result = self.cursor.fetchone()
        return result[0] if result and result[0] is not None else 0.0
