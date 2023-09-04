import mysql.connector as sql
from Utils.Graph import Graph

# Configure the connection to your MySQL database
db_config = {
    'user': 'root',
    'password': '12345',
    'host': 'localhost',  # Or the database server address
    'database': 'covid',
}

# Connect to the MySQL database
try:
    conn = sql.connect(**db_config)
except sql.Error as e:
    print(f"Error connecting to the database: {e}")

# Create a cursor object to interact with the database
cursor = conn.cursor()

# Execute a SQL query to fetch data from your database
# Define the location
location = 'Mexico'
# Construct the SQL query with single quotes around 'location'
query = f"SELECT date, total_deaths FROM deaths WHERE location LIKE '{location}' ORDER BY 1, 2"

# Fetch all the data
try:
    cursor.execute(query)
    data = cursor.fetchall()
    print('Data fetched successfully')
except sql.Error as e:
    print(f"Error executing SQL query: {e}")

# Close the cursor and connection
cursor.close()
conn.close()

# Separate the data into date and value lists
dates = [row[0] for row in data]
values = [row[1] for row in data]

# Create our Graph object
graph_instance = Graph(dates, values, location)
graph_instance.create_graph()