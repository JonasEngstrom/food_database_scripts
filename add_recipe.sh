#!/usr/bin/env bash

# Adds a new recipe to the table recipes in the sqlite3 database nutrition.db.
# Usage:
# ./add_recipe.sh RECIPE_NAME

sqlite3 nutrition.db "INSERT INTO recipes (
    recipe_name
)
VALUES
(
    '$1'
);"

sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT * FROM recipes WHERE id = (SELECT MAX(id) FROM recipescccccbhundefulugkvlvgcklnvgbjvvlubetndlikhfr
);"
