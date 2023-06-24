#!/usr/bin/env bash

# Shows the view VIEW_nutrition_intake_by_date from the sqlite3 database
# nutrition.db. If the optional argument PERSON_NAME is given, it shows
# the date log only for that person.
# Usage:
# ./view_date_log.sh PERSON_NAME

if [[ $# -gt 0 ]] ; then
    number_of_people_matches=$(sqlite3 nutrition.db -cmd "SELECT COUNT(*) FROM people WHERE person_name LIKE '%$1%';" << EOF)

    if [[ $number_of_people_matches -eq 0 ]] ; then
        echo 'No person by that name found in database.'
        exit 0
    fi

    if [[ $number_of_people_matches -gt 1 ]] ; then
        sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
            *
        FROM
            people
        WHERE
            person_name LIKE '%$1%'
        ORDER BY
            person_name,
            id;"
        
        echo 'Several matches by that name, please pick a person ID number:'
        read person_id
    else
        person_id=$(sqlite3 nutrition.db -cmd "SELECT
            id
        FROM
            people
        WHERE
            person_name LIKE '%$1%';" << EOF)
    fi

    sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
            *
        FROM
            VIEW_nutrition_intake_by_date
        WHERE
            person_id IS $person_id
        ORDER BY
            meal_date;"
else
    sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
        *
    FROM
        VIEW_nutrition_intake_by_date
    ORDER BY
        meal_date,
        person_name,
        person_id;"
fi
