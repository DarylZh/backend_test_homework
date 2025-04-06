--Задание 6
-- Gastro Hub решили проверить новую продуктовую гипотезу и поднять цены на капучино. 
ROLLBACK;

BEGIN;
CREATE TABLE some_table (
    id SERIAL PRIMARY KEY,
    some_column VARCHAR(255)
);
COMMIT;
-- Rollback any existing transaction if it's in an error state
ROLLBACK;

-- Start a new transaction
BEGIN;

-- Drop the existing table if it exists
DROP TABLE IF EXISTS some_table;

-- Try creating the table again
CREATE TABLE some_table (
    id SERIAL PRIMARY KEY,
    some_column VARCHAR(255)
);

-- Commit the transaction
COMMIT;
-- Начинаем транзакцию
BEGIN;

-- Блокируем строки с капучино для обновления
WITH updated_prices AS (
    SELECT cafe_name, 
           menu, 
           jsonb_set(menu, '{Капучино, price}', 
                     ((menu->'Капучино'->>'price')::numeric * 1.2)::text::jsonb)
           AS new_menu
    FROM raw_data.menu
    WHERE menu ? 'Капучино'  -- Проверяем, есть ли капучино в меню
    FOR UPDATE  -- Блокируем строки для обновления
)
-- Обновляем меню с новыми ценами
UPDATE raw_data.menu
SET menu = updated_prices.new_menu
FROM updated_prices
WHERE raw_data.menu.cafe_name = updated_prices.cafe_name;

-- Завершаем транзакцию
COMMIT;