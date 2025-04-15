from util.DBConn import db_connection
class ApplicantDAOImpl:
    def insert_applicant(self, applicant):
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Applicants VALUES (?, ?, ?, ?, ?, ?)", (applicant.applicant_id, applicant.first_name, applicant.last_name, applicant.email, applicant.phone, applicant.resume))
        conn.commit()
        conn.close()

    def get_all_applicants(self):
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM Applicants")
        rows = cursor.fetchall()
        conn.close()
        return rows
