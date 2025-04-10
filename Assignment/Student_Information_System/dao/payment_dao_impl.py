from entity.payment import Payment

class PaymentDAOImpl:
    def __init__(self, conn):
        self.conn = conn

    def add_payment(self, payment):
        cursor = self.conn.cursor()
        query = """
        INSERT INTO Payments (student_id, amount, payment_date, course_id)
        VALUES (?, ?, ?, ?)
        """
        cursor.execute(query, (payment.student_id, payment.amount, payment.payment_date,payment.course_id))
        self.conn.commit()
        print("✅ Payment recorded successfully.")

    def get_all_payments(self):
        cursor = self.conn.cursor()
        cursor.execute("SELECT payment_id, student_id, course_id, amount, payment_date FROM Payments")
        rows = cursor.fetchall()
        payments = []
        for row in rows:
            payment = Payment(
                payment_id=row[0],
                student_id=row[1],
                course_id=row[2],
                amount=row[3],
                payment_date=row[4]
            )
            payments.append(payment)
        return payments

    def get_payments_by_student(self, student_id):
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT amount, payment_date FROM Payments WHERE student_id = ?
        """, (student_id,))
        return cursor.fetchall()

    def sum_payments_by_course(self, course_id):
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT SUM(amount) FROM Payments WHERE course_id = ?
        """, (course_id,))
        result = cursor.fetchone()[0]
        return result if result else 0.0


