#!/usr/bin/env bash

# Displays nutrition facts for entries in the view VIEW_recipe_nutrition in the sqlite3 database nutrition.db.
# Usage:
# ./find_recipe.sh RECIPE_NAME

sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
    *
FROM
    VIEW_recipe_nutrition
WHERE
    recipe_name LIKE '%$1%'
ORDER BY
    recipe_name;"
