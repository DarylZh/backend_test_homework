
--Шаг 6. Наполнение таблиц данными из дампа
INSERT INTO cafe.managers (manager_name, manager_phone)
SELECT DISTINCT
    manager,
    manager_phone
FROM raw_data.sales;
INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_date, end_date)
SELECT
    r.restaurant_uuid,
    m.manager_uuid,
    MIN(s.report_date) AS start_date,
    MAX(s.report_date) AS end_date
FROM raw_data.sales s
JOIN cafe.restaurants r ON s.cafe_name = r.cafe_name
JOIN cafe.managers m ON s.manager = m.manager_name
GROUP BY r.restaurant_uuid, m.manager_uuid;
INSERT INTO cafe.sales (date, restaurant_uuid, avg_check)
SELECT
    report_date,
    r.restaurant_uuid,
    avg_check
FROM raw_data.sales s
JOIN cafe.restaurants r ON s.cafe_name = r.cafe_name;