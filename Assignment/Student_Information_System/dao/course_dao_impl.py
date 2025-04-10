from entity.course import Course

class CourseDAOImpl:
    def __init__(self, conn):
        self.conn = conn

    def add_course(self, course):
        cursor = self.conn.cursor()
        query = """
        INSERT INTO Courses (course_name, credits, teacher_id)
        VALUES (?, ?, ?)
        """
        cursor.execute(query, (course.course_name, course.credits, course.teacher_id))
        self.conn.commit()
        print("✅ Course added successfully.")

    def get_all_courses(self):
        cursor = self.conn.cursor()
        cursor.execute("SELECT course_id, course_name, credits, teacher_id FROM Courses")
        rows = cursor.fetchall()
        courses = []
        for row in rows:
            course = Course(
                course_id=row[0],
                course_name=row[1],
                credits=row[2],
                teacher_id=row[3]
            )
            courses.append(course)
        return courses

    def get_courses_by_teacher(self, teacher_id):
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT course_id, course_name, credits, teacher_id
            FROM Courses WHERE teacher_id = ?
        """, (teacher_id,))
        rows = cursor.fetchall()
        courses = []
        for row in rows:
            course = Course(
                course_id=row[0],
                course_name=row[1],
                credits=row[2],
                teacher_id=row[3]
            )
            courses.append(course)
        return courses

    def update_course(self, course):
        cursor = self.conn.cursor()
        query = "UPDATE Courses SET course_name = ?, credits = ?, teacher_id = ? WHERE course_id = ?"
        cursor.execute(query, (course.course_name, course.credits, course.teacher_id, course.course_id))
        self.conn.commit()


