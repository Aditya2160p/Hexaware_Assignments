from dao.ICarLeaseRepositoryImpl import ICarLeaseRepositoryImpl
from entity.Vehicle import Vehicle
from entity.Customer import Customer
from myexceptions.CarNotFoundException import CarNotFoundException
from myexceptions.CustomerNotFoundException import CustomerNotFoundException
from myexceptions.LeaseNotFoundException import LeaseNotFoundException
from datetime import datetime

def print_menu():
    print("\n==== Car Rental System ====")
    print("1. Add Car")
    print("2. Remove Car")
    print("3. Find Car by ID")
    print("4. List Available Cars")
    print("5. List Rented Cars")
    print("6. Add Customer")
    print("7. Remove Customer")
    print("8. View All Customers")
    print("9. Create Lease")
    print("10. Record Payment")
    print("11. View Active Leases")
    print("12. View Lease History")
    print("13. Return Car")
    print("14. View Customer Payment History")
    print("15. View Total Revenue")
    print("0. Exit")

def get_date_input(prompt):
    while True:
        try:
            return datetime.strptime(input(f"{prompt} (YYYY-MM-DD): "), "%Y-%m-%d").date()
        except ValueError:
            print("❌ Invalid date format. Please enter in YYYY-MM-DD.")

def main():
    repo = ICarLeaseRepositoryImpl()

    while True:
        print_menu()
        choice = input("Enter your choice (0–15): ")

        try:
            if choice == '1':
                print("\n🚗 Add New Car")
                make = input("Make: ")
                model = input("Model: ")
                year = int(input("Year: "))
                rate = float(input("Daily Rate: ₹"))
                status = "available"
                capacity = int(input("Passenger Capacity: "))
                engine = float(input("Engine Capacity (in litres): "))
                car = Vehicle(None, make, model, year, rate, status, capacity, engine)
                repo.addCar(car)
                print("✅ Car added successfully.")

            elif choice == '2':
                carID = int(input("Enter Car ID to remove: "))
                repo.removeCar(carID)
                print("✅ Car removed.")

            elif choice == '3':
                cid = int(input("Enter Car ID: "))
                car = repo.getCarDetails(cid)
                print(vars(car))

            elif choice == '4':
                print("\n🚗 Available Cars:")
                for car in repo.listAvailableCars():
                    print(vars(car))

            elif choice == '5':
                print("\n🚘 Rented Cars:")
                for car in repo.listRentedCars():
                    print(vars(car))

            elif choice == '6':
                print("\n👤 Add New Customer")
                fname = input("First Name: ")
                lname = input("Last Name: ")
                email = input("Email: ")
                phone = input("Phone Number: ")
                customer = Customer(None, fname, lname, email, phone)
                repo.addCustomer(customer)
                print("✅ Customer added successfully.")

            elif choice == '7':
                customerID = int(input("Enter Customer ID to remove: "))
                repo.removeCustomer(customerID)
                print("✅ Customer removed.")

            elif choice == '8':
                print("\n📋 Customer List:")
                for c in repo.listCustomers():
                    print(vars(c))

            elif choice == '9':
                print("\n📝 Create Lease")
                custID = int(input("Customer ID: "))
                carID = int(input("Car ID: "))
                startDate = get_date_input("Start Date")
                endDate = get_date_input("End Date")
                lease = repo.createLease(custID, carID, startDate, endDate)
                cost = repo.calculateLeaseCost(carID, startDate, endDate)
                print("✅ Lease created successfully.")
                print("Total Cost: ₹", cost)
                print(vars(lease))

            elif choice == '10':
                leaseID = int(input("Lease ID: "))
                lease = repo.returnCar(leaseID)  # get lease details for reference
                amount = float(input("Payment Amount: ₹"))
                repo.recordPayment(lease, amount)
                print("✅ Payment recorded successfully.")


            elif choice == '11':
                print("\n📋 Active Leases:")
                for lease in repo.listActiveLeases():
                    print(vars(lease))

            elif choice == '12':
                print("\n📂 Lease History:")
                for lease in repo.listLeaseHistory():
                    print(vars(lease))

            elif choice == '13':
                leaseID = int(input("Enter Lease ID to return car: "))
                lease = repo.returnCar(leaseID)
                print("✅ Car returned successfully.")
                print(vars(lease))

            elif choice == '14':
                cid = int(input("Enter Customer ID: "))
                payments = repo.getPaymentHistory(cid)
                print("\n💳 Payment History:")
                for row in payments:
                    print(f"Payment ID: {row[0]}, Date: {row[1]}, Amount: ₹{row[2]}")

            elif choice == '15':
                total = repo.getTotalRevenue()
                print(f"💰 Total Revenue: ₹{total}")

            elif choice == '0':
                print("👋 Exiting Car Rental System. Goodbye!")
                break

            else:
                print("❌ Invalid option. Please choose a number from 0 to 15.")

        except CarNotFoundException as e:
            print("❌", e)
        except CustomerNotFoundException as e:
            print("❌", e)
        except LeaseNotFoundException as e:
            print("❌", e)
        except Exception as e:
            print("⚠️ Unexpected Error:", str(e))

if __name__ == "__main__":
    main()
