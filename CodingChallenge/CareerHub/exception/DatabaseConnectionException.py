class DatabaseConnectionException(Exception):
    def __init__(self, message="Database connection failed"):
        super().__init__(message)
