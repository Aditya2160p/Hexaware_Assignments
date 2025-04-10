from entity.teacher import Teacher

class TeacherDAOImpl:
    def __init__(self, conn):
        self.conn = conn

    def add_teacher(self, teacher):
        cursor = self.conn.cursor()
        query = """
        INSERT INTO Teachers (first_name, last_name, email)
        VALUES (?, ?, ?)
        """
        cursor.execute(query, (teacher.first_name, teacher.last_name, teacher.email))
        self.conn.commit()
        print("✅ Teacher added successfully.")

    def get_all_teachers(self):
        cursor = self.conn.cursor()
        cursor.execute("SELECT teacher_id, first_name, last_name, email FROM Teachers")
        rows = cursor.fetchall()
        teachers = []
        for row in rows:
            teacher = Teacher(
                teacher_id=row[0],
                first_name=row[1],
                last_name=row[2],
                email=row[3]
            )
            teachers.append(teacher)
        return teachers

