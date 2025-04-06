--Задание 5
WITH menu_cte AS (
    SELECT
        r.cafe_name,
        'Пицца' AS dish_type,
        p.pizza_name,
        (p.price::numeric) AS price
    FROM
        cafe.restaurants r,
        jsonb_each_text(r.menu) AS p(pizza_name, price)
    WHERE
        r.type = 'pizzeria'
),
menu_with_rank AS (
    SELECT
        cafe_name,
        dish_type,
        pizza_name,
        price,
        ROW_NUMBER() OVER (PARTITION BY cafe_name ORDER BY price DESC) AS rank
    FROM
        menu_cte
)
SELECT
    cafe_name,
    dish_type,
    pizza_name,
    price
FROM
    menu_with_rank
WHERE
    rank = 1
ORDER BY
    cafe_name;