CREATE TABLE IF NOT EXISTS sfa_ingredients (
    food_name TEXT NOT NULL,
    food_number INTEGER PRIMARY KEY,
    energy_kcal INTEGER NOT NULL,
    fat_total_g NUMERIC NOT NULL,
    sum_saturated_fatty_acids_g NUMERIC NOT NULL,
    carbohydrates_available_g NUMERIC NOT NULL,
    sugars_total_g NUMERIC NOT NULL,
    protein_g NUMERIC NOT NULL,
    sodium_chloride_g NUMERIC NOT NULL
);

.mode csv
.separator ';'
.import edited_database.csv sfa_ingredients
.separator '|'
.mode columns
.headers on

CREATE TABLE IF NOT EXISTS own_ingredients (
    food_name TEXT NOT NULL,
    food_number INTEGER PRIMARY KEY AUTOINCREMENT,
    energy_kcal INTEGER NOT NULL,
    fat_total_g NUMERIC NOT NULL,
    sum_saturated_fatty_acids_g NUMERIC NOT NULL,
    carbohydrates_available_g NUMERIC NOT NULL,
    sugars_total_g NUMERIC NOT NULL,
    protein_g NUMERIC NOT NULL,
    sodium_chloride_g NUMERIC NOT NULL
);

INSERT OR IGNORE INTO own_ingredients
VALUES ('MISSING DATA',1,0,0,0,0,0,0,0);

CREATE VIEW IF NOT EXISTS VIEW_ingredients AS
SELECT
    food_name,
    'sfa' || food_number AS food_number,
    energy_kcal,
    fat_total_g,
    sum_saturated_fatty_acids_g,
    carbohydrates_available_g,
    sugars_total_g,
    protein_g,
    sodium_chloride_g
FROM
    sfa_ingredients
UNION ALL
SELECT
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
;

CREATE TABLE IF NOT EXISTS recipes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    recipe_name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS recipe_ingredients (
    recipe_id INTEGER NOT NULL,
    ingredient_id TEXT NOT NULL,
    grams NUMERIC NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (ingredient_id) REFERENCES VIEW_ingredients (food_number) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS people (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    person_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS meal_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    meal_date TEXT NOT NULL CHECK (meal_date IS DATE(meal_date)),
    person_id INTEGER NOT NULL,
    recipe_id INTEGER NOT NULL,
    comment TEXT,
    FOREIGN KEY (person_id) REFERENCES people (id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE VIEW IF NOT EXISTS VIEW_recipe_nutrition AS
SELECT
    recipe_id,
    recipe_name,
    SUM(energy_kcal) AS energy_kcal,
    SUM(fat_total_g) AS fat_total_g,
    SUM(sum_saturated_fatty_acids_g) AS sum_saturated_fatty_acids_g,
    SUM(carbohydrates_available_g) AS carbohydrates_available_g,
    SUM(sugars_total_g) AS sugars_total_g,
    SUM(protein_g) AS protein_g,
    SUM(sodium_chloride_g) AS sodium_chloride_g
FROM
(SELECT
    recipe_id,
    recipe_name,
    ingredient_id,
    grams,
    food_name,
    food_number,
    CAST(grams AS REAL) / 100 * CAST(energy_kcal AS REAL) AS energy_kcal,
    CAST(grams AS REAL) / 100 * CAST(fat_total_g AS REAL) AS fat_total_g,
    CAST(grams AS REAL) / 100 * CAST(sum_saturated_fatty_acids_g AS REAL) AS sum_saturated_fatty_acids_g,
    CAST(grams AS REAL) / 100 * CAST(carbohydrates_available_g AS REAL) AS carbohydrates_available_g,
    CAST(grams AS REAL) / 100 * CAST(sugars_total_g AS REAL) AS sugars_total_g,
    CAST(grams AS REAL) / 100 * CAST(protein_g AS REAL) AS protein_g,
    CAST(grams AS REAL) / 100 * CAST(sodium_chloride_g AS REAL) AS sodium_chloride_g
FROM
    recipe_ingredients
JOIN
    VIEW_ingredients
ON
    ingredient_id = food_number
JOIN
    recipes
ON
    recipe_id = recipes.id)
GROUP BY
    recipe_id
;

CREATE VIEW IF NOT EXISTS VIEW_nutrition_intake_by_meal AS
SELECT
    meal_date,
    person_id,
    person_name,
    energy_kcal,
    fat_total_g,
    sum_saturated_fatty_acids_g,
    carbohydrates_available_g,
    sugars_total_g,
    protein_g,
    sodium_chloride_g
FROM
    meal_log
JOIN
    people
ON
    person_id = people.id
JOIN
    VIEW_recipe_nutrition
ON
    meal_log.recipe_id = VIEW_recipe_nutrition.recipe_id
ORDER BY
    meal_date,
    person_name,
    person_id
;

CREATE VIEW IF NOT EXISTS VIEW_nutrition_intake_by_date AS
SELECT
    meal_date,
    person_id,
    person_name,
    SUM(energy_kcal) AS energy_kcal,
    SUM(fat_total_g) AS fat_total_g,
    SUM(sum_saturated_fatty_acids_g) AS sum_saturated_fatty_acids_g,
    SUM(carbohydrates_available_g) AS carbohydrates_available_g,
    SUM(sugars_total_g) AS sugars_total_g,
    SUM(protein_g) AS protein_g,
    SUM(sodium_chloride_g) AS sodium_chloride_g
FROM
    VIEW_nutrition_intake_by_meal
GROUP BY
    person_id,
    meal_date
ORDER BY
    meal_date,
    person_name,
    person_id
;
