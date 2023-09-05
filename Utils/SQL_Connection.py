import mysql.connector as sql

class SQL_Connect():
    def __init__(self):
        # Configure the connection to your MySQL database
        print('Connecting to the database...')
        
    def connect(self):
        self.db_config = {
            'user': 'root',
            'password': '12345',
            'host': 'localhost',  # Or the database server address
            'database': 'covid',
        }
        
        # Connect to the MySQL database
        try:
            self.conn = sql.connect(**self.db_config)
        except sql.Error as e:
            print(f"Error connecting to the database: {e}")
        return self.conn
    
    def cursor(self,conn):
        # Create a cursor object to interact with the database
        self.cursor = conn.cursor()
        return self.cursor
    
    def fetch(self,cursor,query):
        # Execute a SQL query to fetch data from your database
        try:
            self.cursor.execute(query)
            self.data = self.cursor.fetchall()
            print('Data fetched successfully')
        except sql.Error as e:
            print(f"Error executing SQL query: {e}")
        return self.data
    
    def close(self,conn,cursor):
        # Close the cursor and connection
        self.cursor.close()
        self.conn.close()