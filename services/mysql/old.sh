#!/bin/bash

# This script will setup a mysql database

# MySQL user and database details
DB_USER="your_user"
DB_PASSWORD="your_password"
DB_NAME="your_database"

# Install MySQL Server
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

# Set MySQL root password non-interactively
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

# Install MySQL server
sudo apt-get -y install mysql-server

# Create a new MySQL user and database
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

# Create a table and insert data (adjust as needed)
mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" <<MYSQL_SCRIPT
CREATE TABLE IF NOT EXISTS your_table (
   id INT AUTO_INCREMENT PRIMARY KEY,
   name VARCHAR(255),
   age INT
);
INSERT INTO your_table (name, age) VALUES ('John Doe', 30);
INSERT INTO your_table (name, age) VALUES ('Jane Doe', 25);
MYSQL_SCRIPT
