#!/usr/bin/env bash

# Adds a meal to the meal_log table in the sqlite3 database nutrition.db.
# Takes three arguments PERSON_NAME, RECIPE_NAME, and DATE. All arguments
# are optional. PERSON_NAME and RECIPE_NAME searches the tables people and
# recipes respectively for a person and recipe with the name in question.
# If only one entry per parameter is found, that entry is used, otherwise
# the user has to explicitly choose one of the possbile matches. DATE
# defaults to today’s date and is otherwise given as yyyy-mm-dd.
# Usage:
# ./add_meal_to_log.sh PERSON_NAME RECIPE_NAME DATE

# Check whether user has passed at least one argument and use the first one as person_name in that case
if [[ $# -gt 0 ]] ; then
    sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
        *
    FROM
        people
    WHERE
        person_name LIKE '%$1%'
    ORDER BY
        person_name;"
    
    number_of_people_matches=$(sqlite3 nutrition.db -cmd "SELECT COUNT(*) FROM people WHERE person_name LIKE '%$1%';" << EOF)
fi

# Check whether user has passed at least two arguments and use the second as recipe_name in that case
if [[ $# -gt 1 ]] ; then
    sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
        *
    FROM
        recipes
    WHERE
        recipe_name LIKE '%$2%'
    ORDER BY
        recipe_name;"
    
    number_of_recipe_matches=$(sqlite3 nutrition.db -cmd "SELECT COUNT(*) FROM recipes WHERE recipe_name LIKE '%$2%';" << EOF)
fi

# Check whether person exists in database and throw an error otherwise
if [[ $number_of_people_matches -eq 0 ]] ; then
    echo 'Person not found in database. Please check spelling, or use script add_person.sh to add person to database.'
    exit 0
fi

# Check whether user has passed at least three arguments and use the third one as meal_date in that case
# otherwise set meal_date to today’s date
if [[ $# -gt 2 ]] ; then
    meal_date=$3
else
    meal_date=$(date +%Y-%m-%d)
fi

# Ask user to clarify what person they want to enter data for, if name matches more than one database entry
if [[ $number_of_people_matches -eq 1 ]] ; then
    person_id=$(sqlite3 nutrition.db -cmd "SELECT id FROM people WHERE person_name LIKE '%$1%';" << EOF)
else
    echo 'Person ID number:'
    read person_id
fi

# Ask user to clarify what recipe they want to enter data for, if name matches more than one database entry
if [[ $number_of_recipe_matches -eq 1 ]] ; then
    recipe_id=$(sqlite3 nutrition.db -cmd "SELECT id FROM recipes WHERE recipe_name LIKE '%$2%';" << EOF)
else
    echo 'Recipe ID number:'
    read recipe_id
fi

# Give the ability for user to comment on their entry, e.g. if it is missing data but they want to note it was a restaurant meal
echo 'Comment:'
read comment

# Make new database entry
sqlite3 nutrition.db "INSERT INTO meal_log (
    meal_date,
    person_id,
    recipe_id,
    comment
)
VALUES
(
    '$meal_date',
    $person_id,
    $recipe_id,
    '$comment'
);"

# Print out last databse entry for confirmation
sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT * FROM meal_log WHERE id = (SELECT MAX(id) FROM meal_log);"
