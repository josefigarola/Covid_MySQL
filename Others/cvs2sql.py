import csv

def create_table_sql(headers, table_name):
    column_definitions = ', '.join(f"{header} TEXT" for header in headers)
    create_table_sql = f"CREATE TABLE {table_name} ({column_definitions});"
    return create_table_sql

def csv_to_sql_insert(csv_filename, table_name, sql_filename):
    with open(sql_filename, 'w') as sql_file:
        with open(csv_filename, 'r') as csv_file:
            csv_reader = csv.DictReader(csv_file)
            columns = csv_reader.fieldnames

            # Generate CREATE TABLE statement based on CSV headers
            create_table_statement = create_table_sql(columns, table_name)
            sql_file.write(create_table_statement + '\n\n')

            i = 1
            for row in csv_reader:
                # Remove commas from values
                values = [f"'{row[col].replace(',', '')}'" if isinstance(row[col], str) else str(row[col]) for col in columns]
                sql_insert = f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({', '.join(values)});\n"
                sql_file.write(sql_insert)
                print(i)
                i += 1

# Replace these values with your actual CSV file, desired table name, and SQL file path
csv_filename = r"path/table.csv"
table_name = 'table_name'
sql_filename = r"path/table.sql"  # Update with your actual username

csv_to_sql_insert(csv_filename, table_name, sql_filename)
