#!/usr/bin/env bash

# Links an ingredient from the view VIEW_ingredients to the table recipes and
# specifies the weight of that ingredient in the recipe by using the table
# recipe_ingredients in the sqlite3 database nutrition.db. If arguments
# INGREDIENT_NAME and/or RECIPE_NAME are passed, the script searches the
# database for records matching the names. If there is only one match that
# match is used for creating the new entry, otherwise the user has to
# explicitly state what ingredient and recipe to use. Both arguments are optional.
# Usage:
# ./add_ingredient_to_recipe.sh INGREDIENT_NAME RECIPE_NAME

# Check whether user has passed at least one argument
if [[ $# -gt 0 ]] ; then
    sqlite3 nutrition.db -cmd ".headers on" ".mode columns" "SELECT
        food_name,
        food_number
    FROM
        VIEW_ingredients
    WHERE
        food_name LIKE '%$1%'
    ORDER BY
        food_name;"
    
    number_of_ingredient_matches=$(sqlite3 nutrition.db -cmd "SELECT COUNT(*) FROM VIEW_ingredients WHERE food_name LIKE '%$1%';" << EOF)
fi

# Check whether user has passed at least two arguments
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

# If first argument matches more than one entry, ask user to clarify
if [[ $number_of_ingredient_matches -eq 1 ]] ; then
    ingredient_id=$(sqlite3 nutrition.db -cmd "SELECT food_number FROM VIEW_ingredients WHERE food_name LIKE '%$1%';" << EOF)
else
    echo 'Ingredient ID number:'
    read ingredient_id
fi

# If second argument matches more than one entry, ask user to clarify
if [[ $number_of_recipe_matches -eq 1 ]] ; then
    recipe_id=$(sqlite3 nutrition.db -cmd "SELECT id FROM recipes WHERE recipe_name LIKE '%$2%';" << EOF)
else
    echo 'Recipe ID number:'
    read recipe_id
fi

# Ask user for the rest of the data needed
echo 'Number of grams of ingredient in recipe:'
read grams

# Make new database entry
sqlite3 nutrition.db "INSERT INTO recipe_ingredients (
    recipe_id,
    ingredient_id,
    grams
)
VALUES
(
    $recipe_id,
    '$ingredient_id',
    $grams
);"

# Print last database entry for confirmation

sqlite3 nutrition.db -cmd ".separator ''" "SELECT
    'Added ',
    grams,
    ' grams of ',
    LOWER(VIEW_ingredients.food_name),
    ' to the recipe for ',
    LOWER(recipes.recipe_name),
    '.'
FROM
    recipe_ingredients
JOIN VIEW_ingredients
    ON recipe_ingredients.ingredient_id = VIEW_ingredients.food_number
JOIN recipes
    ON recipe_ingredients.recipe_id = recipes.id
WHERE
    recipe_ingredients.recipe_id IS $recipe_id AND
    recipe_ingredients.ingredient_id IS '$ingredient_id' AND
    recipe_ingredients.grams IS $grams
LIMIT 1
;"
