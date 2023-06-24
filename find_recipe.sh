#!/usr/bin/env bash

# Displays nutrition facts for entries in the view VIEW_recipe_nutrition in the
# sqlite3 database nutrition.db. The argument RECIPE_NAME is optional. If not
# provided, the entire view is returned.
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
