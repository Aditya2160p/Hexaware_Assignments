from entity.Company import Company
from entity.JobListing import JobListing
from entity.Applicant import Applicant
from entity.JobApplication import JobApplication
from dao.CompanyDAOImpl import CompanyDAOImpl
from dao.JobListingDAOImpl import JobListingDAOImpl
from dao.ApplicantDAOImpl import ApplicantDAOImpl
from dao.JobApplicationDAOImpl import JobApplicationDAOImpl
from datetime import datetime
from util.ResumeUtil import upload_resume
from exception.NegativeSalaryException import NegativeSalaryException
from exception.DatabaseConnectionException import DatabaseConnectionException
from exception.InvalidEmailException import InvalidEmailException
import pyodbc
import re

company_dao = CompanyDAOImpl()
job_dao = JobListingDAOImpl()
applicant_dao = ApplicantDAOImpl()
application_dao = JobApplicationDAOImpl()

def menu():
    print("\n===== CareerHub Menu =====")
    print("1. Register Company")
    print("2. Post Job")
    print("3. Register Applicant")
    print("4. Apply for Job")
    print("5. View All Companies")
    print("6. View All Job Listings")
    print("7. View All Applicants")
    print("8. View Applications for a Job")
    print("9. Search Jobs by Salary Range")
    print("0. Exit")

while True:
    try:
        menu()
        choice = input("Enter your choice: ")

        if choice == '1':
            company = Company(int(input("Company ID: ")), input("Name: "), input("Location: "))
            company_dao.insert_company(company)
            print("✅ Company added.")

        elif choice == '2':
            job_id = int(input("Job ID: "))
            company_id = int(input("Company ID: "))
            title = input("Title: ")
            desc = input("Description: ")
            location = input("Location: ")
            salary = float(input("Salary: "))

            if salary < 0:
                raise NegativeSalaryException("Salary cannot be negative.")

            job_type = input("Type (Full-time/Part-time/Contract): ")
            posted_date = datetime.now()

            job = JobListing(job_id, company_id, title, desc, location, salary, job_type, posted_date)
            job_dao.insert_job(job)
            print("✅ Job posted.")

        elif choice == '3':
            email = input("Email: ")
            if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
                raise InvalidEmailException()

            applicant = Applicant(
                int(input("Applicant ID: ")), input("First Name: "), input("Last Name: "),
                email, input("Phone: "), None)

            resume_path = input("Resume File Path (.pdf or .docx): ")
            validated_path = upload_resume(resume_path)
            if validated_path:
                applicant.resume = validated_path
                applicant_dao.insert_applicant(applicant)
                print("✅ Applicant registered.")

        elif choice == '4':
            application_id = int(input("Application ID: "))
            job_id = int(input("Job ID: "))
            applicant_id = int(input("Applicant ID: "))

            # Get resume path from applicant record
            applicants = applicant_dao.get_all_applicants()
            resume_path = "Resume not found."
            for a in applicants:
                if a[0] == applicant_id:
                    resume_path = a[5]
                    break

            application = JobApplication(application_id, job_id, applicant_id, datetime.now(), resume_path)
            application_dao.insert_application(application)
            print("✅ Application submitted.")

        elif choice == '5':
            companies = company_dao.get_all_companies()
            for c in companies:
                print("ID:", c[0], "| Name:", c[1], "| Location:", c[2])

        elif choice == '6':
            jobs = job_dao.get_all_jobs()
            for j in jobs:
                print("ID:", j[0], "| Title:", j[2], "| Salary:", j[5])

        elif choice == '7':
            applicants = applicant_dao.get_all_applicants()
            for a in applicants:
                print("ID:", a[0], "| Name:", a[1], a[2], "| Email:", a[3])

        elif choice == '8':
            job_id = int(input("Enter Job ID to view applications: "))
            apps = application_dao.get_applications_for_job(job_id)
            for app in apps:
                print("AppID:", app[0], "| ApplicantID:", app[2], "| CoverLetter:", app[4])

        elif choice == '9':
            min_salary = float(input("Enter minimum salary: "))
            max_salary = float(input("Enter maximum salary: "))
            results = job_dao.get_jobs_in_salary_range(min_salary, max_salary)
            for job in results:
                print("Title:", job[0], "| Company:", job[1], "| Salary:", job[2])

        elif choice == '0':
            print("👋 Exiting CareerHub. Goodbye!")
            break
        else:
            print("❌ Invalid choice. Try again.")

    except NegativeSalaryException as e:
        print("❌", e)
    except InvalidEmailException as e:
        print("❌", e)
    except pyodbc.IntegrityError as e:
        print("❌ Database integrity error:", e)
    except pyodbc.OperationalError as e:
        print("❌ Database connection error:", e)
    except Exception as e:
        print("❌ Unexpected error:", e)
