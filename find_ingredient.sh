#!/usr/bin/env bash

# Displays nutrtion facts for entries in the view VIEW_ingredients in the sqlite3 database nutrition.db.
# Usage:
# ./find_ingredient.sh INGREDIENT_NAME

sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
    food_name,
    food_number,
    energy_kcal,
    fat_total_g,
    sum_saturated_fatty_acids_g,
    carbohydrates_available_g,
    sugars_total_g,
    protein_g,
    sodium_chloride_g
FROM
    VIEW_ingredients
WHERE
    food_name LIKE '%$1%'
ORDER BY
    energy_kcal,
    protein_g DESC;"
