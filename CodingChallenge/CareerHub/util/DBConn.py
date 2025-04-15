import pyodbc

def db_connection():
    try:
        conn = pyodbc.connect(
            'DRIVER={ODBC Driver 17 for SQL Server};'
            'SERVER=DESKTOP-2O1DQBE\\SQLEXPRESS;'
            'DATABASE=CareerHubDB;'
            'Trusted_Connection=yes;'
        )
        # print("✅ Database connection established.")
        return conn
    except pyodbc.Error as e:
        print("❌ Error connecting to database:", e)