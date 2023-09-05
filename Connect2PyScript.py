import mysql.connector as sql
from Utils.Graph import Graph
from Utils.SQL_Connection import SQL_Connect

# Connect to the data base
Connection = SQL_Connect()
conn = Connection.connect()
cursor = Connection.cursor(conn)

# Execute a SQL query to fetch data from your database
# Define the location
location = 'Mexico'
columns = 'date, new_deaths'
# Construct the SQL query with single quotes around 'location'
query = f"SELECT {columns} FROM deaths WHERE location LIKE '{location}' ORDER BY 1, 2"

data = Connection.fetch(cursor,query)
Connection.close(conn,cursor)

# Separate the data into date and value lists
dates = [row[0] for row in data]
values = [row[1] for row in data]

# Create our Graph object
graph_instance = Graph(dates, values, location)

# Graph the data
title = 'New Deaths in Mexico'
name = 'New_Deaths_in_' + location
x = 'Date'
y = 'New Deaths'
graph_instance.create_graph(name,title,x,y)