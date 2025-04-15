import pytest
from datetime import datetime
from entity.Company import Company
from entity.JobListing import JobListing
from entity.Applicant import Applicant
from entity.JobApplication import JobApplication
from dao.CompanyDAOImpl import CompanyDAOImpl
from dao.JobListingDAOImpl import JobListingDAOImpl
from dao.ApplicantDAOImpl import ApplicantDAOImpl
from dao.JobApplicationDAOImpl import JobApplicationDAOImpl
from util.DBConn import db_connection

company_dao = CompanyDAOImpl()
job_dao = JobListingDAOImpl()
applicant_dao = ApplicantDAOImpl()
application_dao = JobApplicationDAOImpl()

def setup_module(module):
    conn = db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Applications WHERE ApplicationID = 99")
    cursor.execute("DELETE FROM JobListings WHERE JobID = 99")
    cursor.execute("DELETE FROM Applicants WHERE ApplicantID = 99")
    cursor.execute("DELETE FROM Companies WHERE CompanyID = 99")
    conn.commit()
    conn.close()


# Sample test data
sample_company = Company(99, "TestCorp", "Testville")
sample_job = JobListing(99, 99, "QA Engineer", "Test job for QA", "Remote", 60000, "Full-time", datetime.now())
sample_applicant = Applicant(99, "Test", "User", "test@example.com", "9999999999", "resume.pdf")
sample_application = JobApplication(99, 99, 99, datetime.now(), "resume.pdf")


def test_insert_company():
    company_dao.insert_company(sample_company)
    result = company_dao.get_all_companies()
    assert any(c[0] == 99 for c in result)

def test_insert_job():
    job_dao.insert_job(sample_job)
    result = job_dao.get_all_jobs()
    assert any(j[0] == 99 for j in result)

def test_insert_applicant():
    applicant_dao.insert_applicant(sample_applicant)
    result = applicant_dao.get_all_applicants()
    assert any(a[0] == 99 for a in result)

def test_insert_application():
    application_dao.insert_application(sample_application)
    result = application_dao.get_applications_for_job(99)
    assert any(a[0] == 99 for a in result)

def test_salary_range_query():
    result = job_dao.get_jobs_in_salary_range(50000, 70000)
    assert all(50000 <= job[2] <= 70000 for job in result)
