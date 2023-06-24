#!/usr/bin/env bash

# Shows the view VIEW_nutrition_intake_by_meal from the sqlite3 database
# nutrition.db. If the optional argument PERSON_NAME is given, it shows
# the meal log only for that person.
# Usage:
# ./view_meal_log.sh PERSON_NAME

if [[ $# -gt 0 ]] ; then
    number_of_people_matches=$(sqlite3 nutrition.db -cmd "SELECT COUNT(*) FROM people WHERE person_name LIKE '%$1%';" << EOF)

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
            VIEW_nutrition_intake_by_meal
        WHERE
            person_id IS $person_id
        ORDER BY
            meal_date;"
else
    sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
        *
    FROM
        VIEW_nutrition_intake_by_meal
    ORDER BY
        meal_date,
        person_name,
        person_id;"
fi
