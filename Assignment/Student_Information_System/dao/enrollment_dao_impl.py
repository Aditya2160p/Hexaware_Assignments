from entity.enrollment import Enrollment

class EnrollmentDAOImpl:
    def __init__(self, conn):
        self.conn = conn

    def enroll_student(self, enrollment):
        cursor = self.conn.cursor()
        query = """
        INSERT INTO Enrollments (student_id, course_id, enrollment_date)
        VALUES (?, ?, ?)
        """
        cursor.execute(query, (enrollment.student_id, enrollment.course_id, enrollment.enrollment_date))
        self.conn.commit()
        print("✅ Student enrolled successfully.")

    def get_all_enrollments(self):
        cursor = self.conn.cursor()
        cursor.execute("SELECT enrollment_id, student_id, course_id, enrollment_date FROM Enrollments")
        rows = cursor.fetchall()
        enrollments = []
        for row in rows:
            enrollment = Enrollment(
                enrollment_id=row[0],
                student_id=row[1],
                course_id=row[2],
                enrollment_date=row[3]
            )
            enrollments.append(enrollment)
        return enrollments

    def get_enrollments_by_course(self, course_id):
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT s.student_id, s.first_name, s.last_name, e.enrollment_date
            FROM Enrollments e
            JOIN Students s ON e.student_id = s.student_id
            WHERE e.course_id = ?
        """, (course_id,))
        return cursor.fetchall()

    def count_enrollments_by_course(self, course_id):
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT COUNT(*) FROM Enrollments WHERE course_id = ?
        """, (course_id,))
        return cursor.fetchone()[0]

    def get_enrollments_by_student(self, student_id):
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT e.enrollment_id, e.course_id, e.enrollment_date
            FROM Enrollments e
            WHERE e.student_id = ?
        """, (student_id,))
        return cursor.fetchall()


