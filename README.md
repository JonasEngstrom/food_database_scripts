## Food Database Scripts

A collection of scripts for mangaing an [SQLite](https://www.sqlite.org/) database based on [The Swedish Food Agency’s food database](https://www.livsmedelsverket.se/en/food-and-content/naringsamnen/livsmedelsdatabasen) which is availble under a [Creative Commons Attribution 4.0 license](http://www.creativecommons.se/wp-content/uploads/2015/01/CreativeCommons-Erkännande-4.0.pdf), to plan and log nutrition intake.

The scripts are written using [zshell](https://www.zsh.org) on [macOS Ventura](https://www.apple.com/macos/ventura/) and should run on [bash](https://www.gnu.org/software/bash/).

Note that in the database creation process ingredient and recipe tables are set up that both use the id number 1 to indicate missing data, as it is very probable that missing data would be present in any real-world dataset, and that this offers a consistent and easy to use method for logging missing data.

Scripts are avialble to:

- Search for nutrition information by food.
- Add missing foods to the database.
- Calculating nutrition information for recipes containing several ingredients.
- Log nutrition intake for one or more people by recipe.

## Setup

1. Download [SQLite](https://www.sqlite.org/download.html).
2. Set up database by running `sqlite3 --init setup_schema.sql nutrition.db`.
3. Run `chmod +x *.sh` (or do it by individual script).
4. Optional: Delete `setup_schema.sql` and `edited_database.csv`.

## Included Files

### Shell Scripts

#### `add_ingredient.sh`

Adds a new ingredient to the table `own_ingredients` in `nutrition.db`. The argument `INGREDIENT_NAME` is optional.

##### Usage

```bash
./add_ingredient.sh INGREDIENT_NAME
```

#### `add_ingredient_to_recipe.sh`

Links an ingredient from the view `VIEW_ingredients` to the table `recipes` and specifies the weight of that ingredient in the recipe by using the table `recipe_ingredients` in `nutrition.db`. If arguments `INGREDIENT_NAME` and/or `RECIPE_NAME` are passed, the script searches the database for records matching the names. If there is only one match that match is used for creating the new entry, otherwise the user has to explicitly state what ingredient and recipe to use. Both arguments are optional.

##### Usage

```bash
./add_ingredient_to_recipe.sh INGREDIENT_NAME RECIPE_NAME
```
#### `add_meal_to_log.sh`

Adds a meal to the `meal_log` table in `nutrition.db`. Takes three arguments `PERSON_NAME`, `RECIPE_NAME`, and `DATE`. All arguments are optional. `PERSON_NAME` and `RECIPE_NAME` searches the tables people and recipes respectively for a person and recipe with the name in question. If only one entry per parameter is found, that entry is used, otherwise the user has to explicitly choose one of the possbile matches. `DATE` defaults to today’s date and is otherwise given as yyyy-mm-dd.

##### Usage

```bash
./add_meal_to_log.sh PERSON_NAME RECIPE_NAME DATE
```

#### `add_person.sh`

Adds a new person to the table `people` in `nutrition.db`.

##### Usage

```bash
./add_person.sh PERSON_NAME
```

#### `add_recipe.sh`

Adds a new recipe to the table `recipes` in nutrition.db.

##### Usage

```bash
./add_recipe.sh RECIPE_NAME
```

#### `find_ingredient.sh`

Displays nutrition facts for entries in the view `VIEW_ingredients` in nutrition.db. If the argument `INGREDIENT_NAME` is left empty, the enitre view is output.

##### Usage

```bash
./find_ingredient.sh INGREDIENT_NAME
```

#### `find_recipes.sh`

Displays nutrition facts for entries in the view `VIEW_recipe_nutrition` in `nutrition.db`. The argument `RECIPE_NAME` is optional. If not provided, the entire view is returned.

##### Usage

```bash
./find_recipe.sh RECIPE_NAME
```

#### `list_recipe_ingredients.sh`

Lists ingredients and their nutrition facts for entries in the view `VIEW_list_recipe_ingredients` in `nutrition.db`. The argument `RECIPE_NAME` is optional. If not provided, the entire view is returned.

##### Usage

```bash
./list_recipe_ingredients.sh RECIPE_NAME
```

#### `view_meal_log.sh`

Shows the view `VIEW_nutrition_intake_by_meal` in `nutrition.db`. If the optional argument `PERSON_NAME` is given, it shows the meal log only for that person.

##### Usage

```bash
./view_meal_log.sh PERSON_NAME
```

#### `view_todays_meals.sh`

Shows a summary of one day’s intake for a person in the view `VIEW_nutrition_intake_per_meal` in `nutrition.db`. The second argument `DATE` is optional and defaults to today’s date if no date is specified, dates should be given in the format yyyy-mm-dd.

##### Usage

```bash
./view_todays_meal.sh PERSON_NAME DATE
```

### Other Files

#### `setup_schema.sql`

Sets up the database `nutrtion.db` (this name is optional, but the other scripts assumes this name and will have to be changed if this name is not used).

##### Usage

```bash
sqlite3 --init setup_schema.sql nutrition.db
```

#### `edited_database.csv`

An edited version of [The Swedish Food Agency’s food database](https://www.livsmedelsverket.se/en/food-and-content/naringsamnen/livsmedelsdatabasen) which is availble under a [Creative Commons Attribution 4.0 license](http://www.creativecommons.se/wp-content/uploads/2015/01/CreativeCommons-Erkännande-4.0.pdf) and was published on May 24th 2022. It has been converted and edited to facilitate import by [`setup_schmea.sql`].
