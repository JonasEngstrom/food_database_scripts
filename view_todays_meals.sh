#!/usr/bin/env bash

# Shows a summary of one day’s intake for a person in the view
# VIEW_nutrition_intake_per_meal in the sqlite3 database nutrition.db.
# The second argument DATE is optional and defaults to today’s date if no
# date is specified, dates should be given in the format yyyy-mm-dd.
# Usage:
# ./view_todays_meal.sh PERSON_NAME DATE

# Check that name is passed as argument
if [[ $# -eq 0 ]] ; then
    echo 'You need to specify a name as an argument to the script, i.e. ./view_todays_meals.sh'
    exit 0
fi

# Check how many entries in the database that match the name given
number_of_people_matches=$(sqlite3 nutrition.db -cmd "SELECT COUNT(*) FROM people WHERE person_name LIKE '%$1%';" << EOF)

# Throw an error if person does not exist in database
if [[ $number_of_people_matches -eq 0 ]] ; then
    echo 'No person by that name found in database.'
    exit 0
fi

# Ask user to clarify which person they mean if the name matches more than one database entry
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

# Set date to today’s date unless user has specified other date
if [[ $# -gt 1 ]] ; then
    meal_date=$2
else
    meal_date=$(date +%Y-%m-%d)
fi

# Get person’s full name from database
person_name=$(sqlite3 nutrition.db -cmd "SELECT person_name FROM people WHERE id IS '$person_id';" << EOF)

# Print a header for output
echo 'Nutrition intake summary for' $person_name 'on' $meal_date':'

# Print output table
sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "WITH summary_table AS
(
    SELECT
        recipe_name,
        energy_kcal,
        fat_total_g,
        sum_saturated_fatty_acids_g,
        carbohydrates_available_g,
        sugars_total_g,
        protein_g,
        sodium_chloride_g
    FROM
        VIEW_nutrition_intake_by_meal
    WHERE
        person_id IS $person_id AND
        meal_date IS '$meal_date'
)
SELECT
    recipe_name AS 'Recipe Name',
    energy_kcal AS 'Energy (kcal)',
    fat_total_g AS 'Fat (g)',
    sum_saturated_fatty_acids_g AS 'Saturated Fat (g)',
    carbohydrates_available_g AS 'Carbohydrates (g)',
    sugars_total_g AS 'Sugars (g)',
    protein_g AS 'Protein (g)',
    sodium_chloride_g AS 'NaCl (g)'
FROM
    summary_table
UNION ALL
SELECT
    '',
    '-------------',
    '-------',
    '-----------------',
    '-----------------',
    '----------',
    '-----------',
    '--------'
UNION ALL
SELECT
    'Daily Totals:',
    SUM(energy_kcal),
    SUM(fat_total_g),
    SUM(sum_saturated_fatty_acids_g),
    SUM(carbohydrates_available_g),
    SUM(sugars_total_g),
    SUM(protein_g),
    SUM(sodium_chloride_g)
FROM
    summary_table
;"
