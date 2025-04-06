--Этап 2. Создание представлений и написание аналитических запросов
--Задание 1
--Шаг 1: Создание CTE для расчета среднего чека
--Шаг 2: Использование функции ROW_NUMBER()
--Шаг 3: Фильтрация топ-3 заведений
CREATE OR REPLACE VIEW cafe.top_3_restaurants AS
WITH average_sales AS (
    SELECT
        r.cafe_name,
        r.type,
        ROUND(AVG(s.avg_check), 2) AS average_check
    FROM
        cafe.restaurants r
    JOIN
        cafe.sales s ON r.restaurant_uuid = s.restaurant_uuid
    GROUP BY
        r.cafe_name, r.type
),
ranked_sales AS (
    SELECT
        cafe_name,
        type,
        average_check,
        ROW_NUMBER() OVER (PARTITION BY type ORDER BY average_check DESC) AS rank
    FROM
        average_sales
)
SELECT
    cafe_name,
    type,
    average_check
FROM
    ranked_sales
WHERE
    rank <= 3;