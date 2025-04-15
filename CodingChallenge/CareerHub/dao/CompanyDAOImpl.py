from util.DBConn import db_connection
class CompanyDAOImpl:
    def insert_company(self, company):
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Companies VALUES (?, ?, ?)", (company.company_id, company.company_name, company.location))
        conn.commit()
        conn.close()

    def get_all_companies(self):
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM Companies")
        rows = cursor.fetchall()
        conn.close()
        return rows
