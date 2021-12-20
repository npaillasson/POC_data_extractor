import re
from getpass import getpass
import mysql.connector
from mysql.connector import errorcode

DATE_FORMAT = re.compile(r'[0-9]{4}$')

print("connexion à mysql,\n")
mysql_user = input("user: ")
mysql_password = getpass()
database_name = input("database_name: ")

print("connexion à la base de données en cours...")

config = {
    'user': mysql_user,
    'password': mysql_password,
    'host': '127.0.0.1',
    'database': database_name,
    'raise_on_warnings': True
}

try:
    connect = mysql.connector.connect(**config)
    print("succes")
except mysql.connector.Error as err:
    print("echec")
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("La connexion à la base de données a échouée...")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("La base de données n'éxiste pas...")
    else:
        print(err)
    exit()

while True:
    extraction_year = input("Année d'extraction: ")
    if extraction_year == "/stop":
        break
    elif not DATE_FORMAT.match(extraction_year):
        print("L'année entrée ne semble pas correcte...")
        continue

    cursor_selector = connect.cursor()

    sql_command = (f"SELECT `member`.`id`, `member`.`name`, `section`.`num`, `section`.`name`, `cost`.`price`, `payment`.`date`, `adress`.`adress` "
                   f"FROM member  "
                   f"JOIN `adress`  "
                   f"ON (`member`.`id`=`adress`.`member_id`)  "
                   f"JOIN `payment`  "
                   f"ON (`member`.`id`=`payment`.`member_id`)  "
                   f"JOIN `section_payment`  "
                   f"ON (`payment`.`id`=`section_payment`.`payment_id`)  "
                   f"JOIN `section`  "
                   f"ON (`section`.`id`=`section_payment`.`section_id`)  "
                   f"JOIN `cost` "
                   f"ON (`cost`.`id`=`section`.`cost_id`) "
                   f"WHERE `payment`.`date`= {extraction_year} "
                   f"AND ((`adress`.`year_of_move_in`<={extraction_year}) "
                   f"AND (`adress`.`moving_year`IS NULL OR `adress`.`moving_year`>={extraction_year}));")

    cursor_selector.execute(sql_command)
    result = cursor_selector.fetchall()

    for i in result:
        print(i[0], i[1], i[2], i[3], i[4], i[5], i[6])
        print(result)

    cursor_selector.close()

connect.close()