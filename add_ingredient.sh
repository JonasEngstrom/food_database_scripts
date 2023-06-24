#!/usr/bin/env bash

# Adds a new ingredient to the table own_ingredients in the sqlite3 database nutrition.db. The argument INGREDIENT_NAME is optional.
# Usage:
# ./add_ingredient.sh INGREDIENT_NAME

if [[ $# -eq 0 ]] ; then
    echo 'Produktnamn:'
    read food_name
else
    food_name="$1"
fi

echo 'Energy (kcal):'
read energy_kcal

echo 'Fat (g):'
read fat_total_g

echo '…of which saturated fat (g):'
read sum_saturated_fatty_acids_g

echo 'Carbohydrates (g):'
read carbohydrates_available_g

echo '…of which sugars (g):'
read sugars_total_g

echo 'Protein (g):'
read protein_g

echo 'Sodium chloride (g):'
read sodium_chloride_g

sqlite3 nutrition.db "INSERT INTO own_ingredients (
    food_name,
    energy_kcal,
    fat_total_g,
    sum_saturated_fatty_acids_g,
    carbohydrates_available_g,
    sugars_total_g,
    protein_g,
    sodium_chloride_g
)
VALUES
(
    '$food_name',
    $energy_kcal,
    $fat_total_g,
    $sum_saturated_fatty_acids_g,
    $carbohydrates_available_g,
    $sugars_total_g,
    $protein_g,
    $sodium_chloride_g
);"

echo 'Last added ingredient in database:'

sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT 
    food_name,
    'own' || food_number AS food_number,
    energy_kcal,
    fat_total_g,
    sum_saturated_fatty_acids_g,
    carbohydrates_available_g,
    sugars_total_g,
    protein_g,
    sodium_chloride_g
FROM
    own_ingredients
WHERE
    food_number = (SELECT MAX(food_number) FROM own_ingredients);"
