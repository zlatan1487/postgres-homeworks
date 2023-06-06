import csv
import psycopg2
from datetime import datetime

"""Скрипт для заполнения данными таблиц в БД Postgres."""


# connect to db
conn = psycopg2.connect(host='localhost', database='north', user='postgres', password='1989')
try:
    with conn:
        with conn.cursor() as cursor:
            # Внесение данных из файла CSV в таблицу "customers"
            with open('north_data/customers_data.csv', 'r') as file:
                reader = csv.reader(file)
                next(reader)  # Пропустить заголовок
                for row in reader:
                    cursor.execute(
                        "INSERT INTO customers (customer_id, company_name, contact_name) VALUES (%s, %s, %s)",
                        row
                    )

            # Внесение данных из файла CSV в таблицу "employees"
            with open('north_data/employees_data.csv', 'r') as file:
                reader = csv.reader(file)
                next(reader)  # Пропустить заголовок
                for row in reader:
                    birth_date = datetime.strptime(row[4], "%Y-%m-%d").date()
                    cursor.execute(
                        "INSERT INTO employees (employee_id, first_name, last_name, title, birth_date, notes) VALUES (%s, %s, %s, %s, %s, %s)",
                        (int(row[0]), row[1], row[2], row[3], birth_date, row[5])
                    )

            # Внесение данных из файла CSV в таблицу "orders"
            with open('north_data/orders_data.csv', 'r') as file:
                reader = csv.reader(file)
                next(reader)  # Пропустить заголовок
                for row in reader:
                    order_date = datetime.strptime(row[3], "%Y-%m-%d").date()
                    cursor.execute(
                        "INSERT INTO orders (order_id, customer_id, employee_id, order_date, ship_city) VALUES (%s, %s, %s, %s, %s)",
                        (int(row[0]), row[1], int(row[2]), order_date, row[4])
                    )
finally:
    # close connection
    conn.close()
