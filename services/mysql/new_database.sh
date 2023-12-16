#!/bin/bash
#
# This script will create a new database

NEW_DB_NAME="$1"
mysql -u root -p "${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS $NEW_DB_NAME"
