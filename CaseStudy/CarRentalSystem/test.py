import pytest
from dao.ICarLeaseRepositoryImpl import ICarLeaseRepositoryImpl
from entity.Vehicle import Vehicle
from entity.Customer import Customer
from datetime import date, timedelta
from myexceptions.CarNotFoundException import CarNotFoundException
from myexceptions.CustomerNotFoundException import CustomerNotFoundException
from myexceptions.LeaseNotFoundException import LeaseNotFoundException

repo = ICarLeaseRepositoryImpl()

created_car_ids = []
created_customer_ids = []
created_lease_ids = []


def create_sample_car():
    car = Vehicle(None, "Hyundai", "i20", 2022, 2000.0, "available", 5, 1.2)
    repo.addCar(car)
    added_car = repo.listAvailableCars()[-1]
    created_car_ids.append(added_car.get_vehicleID())
    return added_car

def create_sample_customer():
    customer = Customer(None, "Test", "User", "test@example.com", "9999999999")
    repo.addCustomer(customer)
    added_customer = repo.listCustomers()[-1]
    created_customer_ids.append(added_customer.get_customerID())
    return added_customer

def create_sample_lease():
    customer = create_sample_customer()
    car = create_sample_car()
    start = date.today()
    end = start + timedelta(days=5)
    lease = repo.createLease(customer.get_customerID(), car.get_vehicleID(), start, end)

    if lease.get_leaseID() is None:
        leases = repo.listLeaseHistory()
        lease = leases[-1]
    created_lease_ids.append(lease.get_leaseID())
    return lease

# -------------------------------
# ✅ 1. Test Car Creation
# -------------------------------
def test_add_car_success():
    car = create_sample_car()
    result = repo.getCarDetails(car.get_vehicleID())
    assert result.get_model() == "i20"

# -------------------------------
# ✅ 2. Test Lease Creation
# -------------------------------
def test_create_lease_success():
    lease = create_sample_lease()
    print("Lease ID:", lease.get_leaseID())
    assert lease.get_leaseID() is not None

# -------------------------------
# ✅ 3. Test Lease Retrieval
# -------------------------------
def test_return_car_success():
    lease = create_sample_lease()
    returned = repo.returnCar(lease.get_leaseID())
    assert returned.get_vehicleID() == lease.get_vehicleID()

# -------------------------------
# ✅ 4. Test Exception Handling
# -------------------------------
def test_customer_not_found_exception():
    with pytest.raises(CustomerNotFoundException):
        repo.getCustomerDetails(999999)

def test_car_not_found_exception():
    with pytest.raises(CarNotFoundException):
        repo.getCarDetails(999999)

def test_lease_not_found_exception():
    with pytest.raises(LeaseNotFoundException):
        repo.returnCar(999999)

def teardown_module(module):
    print("\n🧹 Cleaning up test data...")

    for lease_id in created_lease_ids:
        repo.cursor.execute("DELETE FROM Payment WHERE leaseID = ?", (lease_id,))
        repo.cursor.execute("DELETE FROM Lease WHERE leaseID = ?", (lease_id,))

    for car_id in created_car_ids:
        repo.cursor.execute("DELETE FROM Vehicle WHERE vehicleID = ?", (car_id,))

    for customer_id in created_customer_ids:
        repo.cursor.execute("DELETE FROM Customer WHERE customerID = ?", (customer_id,))

    repo.conn.commit()
    print("✅ Test data cleanup complete.")
