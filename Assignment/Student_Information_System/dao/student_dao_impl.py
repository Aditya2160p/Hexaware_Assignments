import pyodbc
from entity.student import Student

class StudentDAOImpl:
    def __init__(self, conn):
        self.conn = conn

    def add_student(self, student):
        cursor = self.conn.cursor()
        query = """
        INSERT INTO Students (first_name, last_name, date_of_birth, email, phone_number)
        VALUES (?, ?, ?, ?, ?)
        """
        cursor.execute(query, (student.first_name, student.last_name, student.date_of_birth,
                               student.email, student.phone_number))
        self.conn.commit()
        print("✅ Student added successfully.")

    def get_all_students(self):
        cursor = self.conn.cursor()
        cursor.execute("SELECT student_id, first_name, last_name, date_of_birth, email, phone_number FROM Students")
        rows = cursor.fetchall()
        students = []
        for row in rows:
            student = Student(
                student_id=row[0],
                first_name=row[1],
                last_name=row[2],
                date_of_birth=row[3],
                email=row[4],
                phone_number=row[5]
            )
            students.append(student)
        return students

