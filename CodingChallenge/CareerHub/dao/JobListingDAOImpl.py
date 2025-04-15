from util.DBConn import db_connection
class JobListingDAOImpl:
    def insert_job(self, job):
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO JobListings VALUES (?, ?, ?, ?, ?, ?, ?, ?)", (job.job_id, job.company_id, job.title, job.description, job.location, job.salary, job.job_type, job.posted_date))
        conn.commit()
        conn.close()

    def get_all_jobs(self):
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM JobListings")
        rows = cursor.fetchall()
        conn.close()
        return rows

    def get_jobs_in_salary_range(self, min_salary, max_salary):
        conn = db_connection()
        cursor = conn.cursor()
        query = """
            SELECT jl.JobTitle, c.CompanyName, jl.Salary
            FROM JobListings jl
            JOIN Companies c ON jl.CompanyID = c.CompanyID
            WHERE jl.Salary BETWEEN ? AND ?
        """
        cursor.execute(query, (min_salary, max_salary))
        results = cursor.fetchall()
        conn.close()
        return results
