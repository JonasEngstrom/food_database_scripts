#!/usr/bin/env bash

# Adds a new person to the table people in the sqlite3 database nutrition.db.
# Usage:
# ./add_person.sh PERSON_NAME

# Throw an error if user has not specified a name
if [[ $# -eq 0 ]] ; then
    echo 'Please pass a person’s name as an argument to the script, i.e. ./add_person.sh PERSON_NAME'
    exit 0
fi

# Make new database entry
sqlite3 nutrition.db "INSERT INTO people (
    person_name
)
VALUES
(
    '$1'
);"

# Print last database entry for confirmation
echo 'Last added person in database:'

sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT * FROM people WHERE id = (SELECT MAX(id) FROM people);"
