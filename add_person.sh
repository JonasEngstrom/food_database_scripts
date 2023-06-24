#!/usr/bin/env bash

# Adds a new person to the table people in the sqlite3 database nutrition.db.
# Usage:
# ./add_person.sh PERSON_NAME

sqlite3 nutrition.db "INSERT INTO people (
    person_name
)
VALUES
(
    '$1'
);"

sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT * FROM people WHERE id = (SELECT MAX(id) FROM people);"
