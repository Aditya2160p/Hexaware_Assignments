class CustomerNotFoundException(Exception):
    def __init__(self, customer_id):
        super().__init__(f"❌ Customer with ID {customer_id} not found in the database.")
