from util.DBConn import db_connection
class JobApplicationDAOImpl:
    def insert_application(self, application):
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Applications VALUES (?, ?, ?, ?, ?)", (application.application_id, application.job_id, application.applicant_id, application.application_date, application.cover_letter))
        conn.commit()
        conn.close()

    def get_applications_for_job(self, job_id):
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM Applications WHERE JobID = ?", (job_id,))
        rows = cursor.fetchall()
        conn.close()
        return rows