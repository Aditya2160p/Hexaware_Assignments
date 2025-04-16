import pyodbc
from util.DBPropertyUtil import DBPropertyUtil

class DBConnUtil:
    connection = None

    @staticmethod
    def getConnection():
        if DBConnUtil.connection is None:
            try:
                conn_str = DBPropertyUtil.getPropertyString("db.properties")
                DBConnUtil.connection = pyodbc.connect(conn_str)
                print("✅ Database connected successfully!")
            except Exception as e:
                print("❌ Failed to connect to database:", str(e))
                raise
        return DBConnUtil.connection
