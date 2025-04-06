--Задание 2
--Шаг 1: Подзапрос для расчета среднего чека
--Шаг 2: Присоединение к таблице ресторанов
--Шаг 3: Использование функции LAG для получения предыдущего года
CREATE MATERIALIZED VIEW cafe.yearly_average_check AS
WITH yearly_sales AS (
    SELECT
        EXTRACT(YEAR FROM s.date) AS year,
        r.cafe_name,
        r.type,
        ROUND(AVG(s.avg_check), 2) AS average_check
    FROM
        cafe.sales s
    JOIN
        cafe.restaurants r ON s.restaurant_uuid = r.restaurant_uuid
    WHERE
        EXTRACT(YEAR FROM s.date) <> 2023
    GROUP BY
        year, r.cafe_name, r.type
)
SELECT
    year,
    cafe_name,
    type,
    average_check,
    LAG(average_check) OVER (PARTITION BY cafe_name ORDER BY year) AS previous_year_check,
    CASE 
        WHEN LAG(average_check) OVER (PARTITION BY cafe_name ORDER BY year) IS NULL THEN NULL
        ELSE ROUND((average_check - LAG(average_check) OVER (PARTITION BY cafe_name ORDER BY year)) / LAG(average_check) OVER (PARTITION BY cafe_name ORDER BY year) * 100, 2)
    END AS percentage_change
FROM
    yearly_sales
ORDER BY
    cafe_name, year;