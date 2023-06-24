## Food Database Scripts

A collection of scripts for mangaing an [SQLite](https://www.sqlite.org/) database based on [The Swedish Food Agency’s food database](https://www.livsmedelsverket.se/en/food-and-content/naringsamnen/livsmedelsdatabasen) which is availble under a [Creative Commons Attribution 4.0 license](http://www.creativecommons.se/wp-content/uploads/2015/01/CreativeCommons-Erkännande-4.0.pdf), to plan and log nutrition intake.

The scripts are written using [zshell](https://www.zsh.org) on [macOS Ventura](https://www.apple.com/macos/ventura/) and should run on [bash](https://www.gnu.org/software/bash/).

Scripts are avialble to:

- Search for nutrition information by food.
- Add missing foods to the database.
- Calculating nutrition information for recipes containing several ingredients.
- Log nutrition intake for one or more people by recipe.

## Setup

1. Download [SQLite](https://www.sqlite.org/download.html).
2. Set up database by running `sqlite3 --init setup_schema.sql nutrition.db`.
3. Optional: Delete `setup_schema.sql` and `edited_database.csv`.

## Included Files

### Shell Scripts

#### `add_ingredient.sh`

Adds a new ingredient to the table `own_ingredients` in `nutrition.db`. The argument `INGREDIENT_NAME` is optional.

##### Usage

```bash
./add_ingredient.sh INGREDIENT_NAME
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

### Other Files

#### `setup_schema.sql`

Sets up the database `nutrtion.db` (this name is optional, but the other scripts assumes this name and will have to be changed if this name is not used).

##### Usage

```bash
sqlite3 --init setup_schema.sql nutrition.db
```

#### `edited_database.csv`

An edited version of [The Swedish Food Agency’s food database](https://www.livsmedelsverket.se/en/food-and-content/naringsamnen/livsmedelsdatabasen) which is availble under a [Creative Commons Attribution 4.0 license](http://www.creativecommons.se/wp-content/uploads/2015/01/CreativeCommons-Erkännande-4.0.pdf) and was published on May 24th 2022. It has been converted and edited to facilitate import by [`setup_schmea.sql`].
