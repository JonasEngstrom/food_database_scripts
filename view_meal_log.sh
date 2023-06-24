#!/usr/bin/env bash

# Shows the view VIEW_nutrition_intake_by_meal from the sqlite3 database
# nutrition.db. If the optional argument PERSON_NAME is given, it shows
# the meal log only for that person.
# Usage:
# ./view_meal_log.sh PERSON_NAME

# Check whether user has specified a name
if [[ $# -gt 0 ]] ; then
    number_of_people_matches=$(sqlite3 nutrition.db -cmd "SELECT COUNT(*) FROM people WHERE person_name LIKE '%$1%';" << EOF)

    # Throw error if specified person does not exist in database
    if [[ $number_of_people_matches -eq 0 ]] ; then
        echo 'No person by that name found in database.'
        exit 0
    fi

    # Ask user to clarify if serveral people with the same name exist in database
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

    # Print output (if user has specified a name)
    sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
            *
        FROM
            VIEW_nutrition_intake_by_meal
        WHERE
            person_id IS $person_id
        ORDER BY
            meal_date;"
else
    # Print output (if user has not specified a name)
    sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
        *
    FROM
        VIEW_nutrition_intake_by_meal
    ORDER BY
        meal_date,
        person_name,
        person_id;"
fi
