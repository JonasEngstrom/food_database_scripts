#!/usr/bin/env bash

# Adds a new recipe to the table recipes in the sqlite3 database nutrition.db.
# Usage:
# ./add_recipe.sh RECIPE_NAME

# Throw an error if user has not specified a recipe name
if [[ $# -eq 0 ]] ; then
    echo 'Please pass a recipe’s name as an argument to the script, i.e. ./add_recipe.sh RECIPE_NAME'
    exit 0
fi

# Insert new database entry
sqlite3 nutrition.db "INSERT INTO recipes (
    recipe_name
)
VALUES
(
    '$1'
);"

# Print last database entry for confirmation
echo 'Last added recipe in database:'

sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT * FROM recipes WHERE id = (SELECT MAX(id) FROM recipes);"
