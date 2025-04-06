--Задание 4
--1. Извлечь данные из таблицы cafe.menu, которая хранит меню в формате JSONB.
--2. Подсчитать количество пицц для каждой пиццерии.
--3. Найти максимальное количество пицц и вывести все пиццерии с этим количеством.
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'cafe';
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'restaurants';
WITH pizza_counts AS (
    SELECT
        r.cafe_name,
        jsonb_array_length(r.menu -> 'pizzas') AS pizza_count
    FROM
        cafe.restaurants r
    WHERE
        r.type = 'pizzeria'
)
SELECT
    cafe_name,
    pizza_count
FROM
    pizza_counts
WHERE
    pizza_count = (SELECT MAX(pizza_count) FROM pizza_counts);