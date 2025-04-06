--Задание 3
--1. Подсчет изменений менеджеров: Мы будем группировать данные по restaurant_uuid и подсчитывать количество уникальных менеджеров для каждого заведения.
--2. Сортировка и ограничение результата: Отсортируем результаты по количеству изменений и выберем топ-3 заведения.
SELECT
    r.cafe_name,
    COUNT(DISTINCT rm.manager_uuid) - 1 AS manager_changes
FROM
    cafe.restaurant_manager_work_dates rm
JOIN
    cafe.restaurants r ON rm.restaurant_uuid = r.restaurant_uuid
GROUP BY
    r.cafe_name
ORDER BY
    manager_changes DESC
LIMIT 3;