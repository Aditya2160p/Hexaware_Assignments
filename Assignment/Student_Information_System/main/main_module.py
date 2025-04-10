from util.db_conn_util import db_connection
from entity.student import Student
from entity.teacher import Teacher
from entity.course import Course
from entity.enrollment import Enrollment
from entity.payment import Payment

from dao.student_dao_impl import StudentDAOImpl
from dao.teacher_dao_impl import TeacherDAOImpl
from dao.course_dao_impl import CourseDAOImpl
from dao.enrollment_dao_impl import EnrollmentDAOImpl
from dao.payment_dao_impl import PaymentDAOImpl

from exceptions.custom_exceptions import (
    StudentNotFoundException,
    InvalidStudentDataException,
    CourseNotFoundException,
    InvalidCourseDataException,
    TeacherNotFoundException,
    InvalidTeacherDataException,
    DuplicateEnrollmentException,
    PaymentValidationException,

)

def main_menu():
    conn = db_connection()
    if conn is None:
        print("❌ DB connection failed.")
        return

    student_dao = StudentDAOImpl(conn)
    teacher_dao = TeacherDAOImpl(conn)
    course_dao = CourseDAOImpl(conn)
    enrollment_dao = EnrollmentDAOImpl(conn)
    payment_dao = PaymentDAOImpl(conn)

    while True:
        print("\n========== STUDENT INFORMATION SYSTEM ==========")
        print("1. Add Student")
        print("2. Add Teacher")
        print("3. Add Course")
        print("4. Enroll Student in Course")
        print("5. Record Payment")
        print("6. View All Students")
        print("7. View All Courses")
        print("8. View All Teachers")
        print("9. View All Enrollments")
        print("10. View All Payments")
        print("11. Enrollment Report by Course")
        print("12. Payment Report by Student")
        print("13. Course Statistics")
        print("14. Get Enrollments For Student")
        print("15. Get Courses For Teacher")
        print("16. Update Course Information")
        print("0. Exit")

        choice = input("Enter choice: ")

        if choice == '1':
            try:
                student = Student(
                    None,
                    input("First name: "),
                    input("Last name: "),
                    input("DOB (YYYY-MM-DD): "),
                    input("Email: "),
                    input("Phone: ")
                )
                student_dao.add_student(student)
            except Exception:
                raise InvalidStudentDataException()

        elif choice == '2':
            try:
                teacher = Teacher(
                    None,
                    input("First name: "),
                    input("Last name: "),
                    input("Email: ")
                )
                teacher_dao.add_teacher(teacher)
            except Exception:
                raise InvalidTeacherDataException()

        elif choice == '3':
            try:
                course_name = input("Course name: ")
                credits = int(input("Credits: "))
                teacher_id = input("Assigned Teacher ID (optional): ")
                teacher_id = int(teacher_id) if teacher_id.strip() else None

                if teacher_id:
                    cursor = conn.cursor()
                    cursor.execute("SELECT * FROM Teachers WHERE teacher_id = ?", (teacher_id,))
                    if not cursor.fetchone():
                        raise TeacherNotFoundException()

                course = Course(None, course_name, credits, teacher_id)
                course_dao.add_course(course)
            except TeacherNotFoundException as e:
                print(e)
            except Exception:
                raise InvalidCourseDataException()

        elif choice == '4':
            try:
                student_id = int(input("Student ID: "))
                course_id = int(input("Course ID: "))
                date = input("Enrollment Date (YYYY-MM-DD): ")

                cursor = conn.cursor()
                cursor.execute("SELECT * FROM Students WHERE student_id = ?", (student_id,))
                if not cursor.fetchone():
                    raise StudentNotFoundException()

                cursor.execute("SELECT * FROM Courses WHERE course_id = ?", (course_id,))
                if not cursor.fetchone():
                    raise CourseNotFoundException()

                enrollment = Enrollment(None, student_id, course_id, date)
                enrollment_dao.enroll_student(enrollment)

            except StudentNotFoundException as e:
                print(e)
            except CourseNotFoundException as e:
                print(e)
            except Exception:
                raise DuplicateEnrollmentException()

        elif choice == '5':
            try:
                student_id = int(input("Student ID: "))
                course_id = int(input("Course ID: "))
                amount = float(input("Amount: "))
                date = input("Payment Date (YYYY-MM-DD): ")

                cursor = conn.cursor()
                cursor.execute("SELECT * FROM Students WHERE student_id = ?", (student_id,))
                if not cursor.fetchone():
                    raise StudentNotFoundException()

                cursor.execute("SELECT * FROM Courses WHERE course_id = ?", (course_id,))
                if not cursor.fetchone():
                    raise CourseNotFoundException()

                if amount <= 0:
                    raise PaymentValidationException()

                payment = Payment(None, student_id, course_id, amount, date)
                payment_dao.add_payment(payment)

            except StudentNotFoundException as e:
                print(e)
            except CourseNotFoundException as e:
                print(e)
            except PaymentValidationException as e:
                print(e)


        elif choice == '6':
            for s in student_dao.get_all_students():
                print(
                    f"Student ID: {s.student_id}, Name: {s.first_name} {s.last_name}, DOB: {s.date_of_birth}, Email: {s.email}, Phone: {s.phone_number}")

        elif choice == '7':
            for c in course_dao.get_all_courses():
                print(
                    f"Course ID: {c.course_id}, Name: {c.course_name}, Credits: {c.credits}, Teacher ID: {c.teacher_id}")

        elif choice == '8':
            for t in teacher_dao.get_all_teachers():
                print(f"Teacher ID: {t.teacher_id}, Name: {t.first_name} {t.last_name}, Email: {t.email}")

        elif choice == '9':
            for e in enrollment_dao.get_all_enrollments():
                print(
                    f"Enrollment ID: {e.enrollment_id}, Student ID: {e.student_id}, Course ID: {e.course_id}, Date: {e.enrollment_date}")

        elif choice == '10':
            for p in payment_dao.get_all_payments():
                print(
                    f"Payment ID: {p.payment_id}, Student ID: {p.student_id}, Course ID: {p.course_id}, Amount: ₹{p.amount}, Date: {p.payment_date}")

        elif choice == '11':
            course_id = int(input("Enter Course ID: "))
            rows = enrollment_dao.get_enrollments_by_course(course_id)
            print(f"\n📘 Enrollment Report for Course {course_id}")
            if rows:
                for row in rows:
                    print(f"Student ID: {row[0]}, Name: {row[1]} {row[2]}, Date: {row[3]}")
            else:
                print("No enrollments found.")

        elif choice == '12':
            student_id = int(input("Enter Student ID: "))
            rows = payment_dao.get_payments_by_student(student_id)
            print(f"\n💵 Payment Report for Student {student_id}")
            if rows:
                for row in rows:
                    print(f"Amount: {row[0]} | Date: {row[1]}")
            else:
                print("No payments found.")

        elif choice == '13':
            course_id = int(input("Enter Course ID: "))
            cursor = conn.cursor()
            cursor.execute("SELECT course_name FROM Courses WHERE course_id = ?", (course_id,))
            result = cursor.fetchone()

            if not result:
                print("❌ Course not found.")
            else:
                total_enrolled = enrollment_dao.count_enrollments_by_course(course_id)
                total_paid = payment_dao.sum_payments_by_course(course_id)

                print(f"\n📊 Statistics for Course {course_id}")
                print(f"Total Enrollments: {total_enrolled}")
                print(f"Total Payments: ₹{total_paid:.2f}")

        elif choice == '14':
            student_id = int(input("Enter Student ID: "))
            enrollments = enrollment_dao.get_enrollments_by_student(student_id)
            print(f"📘 Enrollments for Student ID {student_id}:")
            for e in enrollments:
                print(f"Enrollment ID: {e[0]}, Course ID: {e[1]}, Date: {e[2]}")

        elif choice == '15':
            teacher_id = int(input("Enter Teacher ID: "))
            courses = course_dao.get_courses_by_teacher(teacher_id)
            print(f"📚 Courses assigned to Teacher ID {teacher_id}:")
            for c in courses:
                print(f"Course ID: {c.course_id} | Name: {c.course_name} | Credits: {c.credits}")

        elif choice == '16':
            try:
                course_id = int(input("Enter Course ID to update: "))
                cursor = conn.cursor()
                cursor.execute("SELECT * FROM Courses WHERE course_id = ?", (course_id,))
                row = cursor.fetchone()

                if not row:
                    raise CourseNotFoundException()

                print(f"Current values: Name = {row[1]}, Credits = {row[2]}, Teacher ID = {row[3]}")
                new_name = input("New Course Name: ") or row[1]
                new_credits = input("New Credits: ")
                new_credits = int(new_credits) if new_credits.strip() else row[2]
                new_teacher_id = input("New Teacher ID (blank to keep same): ")
                new_teacher_id = int(new_teacher_id) if new_teacher_id.strip() else row[3]

                # Validate teacher ID if provided
                if new_teacher_id:
                    cursor.execute("SELECT * FROM Teachers WHERE teacher_id = ?", (new_teacher_id,))
                    if not cursor.fetchone():
                        raise TeacherNotFoundException()

                from entity.course import Course
                updated_course = Course(course_id, new_name, new_credits, new_teacher_id)
                course_dao.update_course(updated_course)
                print("✅ Course updated successfully.")

            except CourseNotFoundException as e:
                print(e)
            except TeacherNotFoundException as e:
                print(e)
            except Exception:
                raise InvalidCourseDataException()

        elif choice == '0':
            print("👋 Exiting. Bye!")
            break

        else:
            print("❌ Invalid choice!")

if __name__ == "__main__":
    main_menu()
