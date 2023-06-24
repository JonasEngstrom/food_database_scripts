#!/usr/bin/env bash

# Lists ingredients and their nutrition facts for entries in the view
# VIEW_list_recipe_ingredients in the sqlite3 database nutrition.db.
# The argument RECIPE_NAME is optional. If not provided, the entire
# view is returned.
# Usage:
# ./list_recipe_ingredients.sh RECIPE_NAME

# Print output
sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
    *
FROM
    VIEW_list_recipe_ingredients
WHERE
    recipe_name LIKE '%$1%';"
