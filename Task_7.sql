--Задание 7

-- Начинаем транзакцию
BEGIN;

-- Блокируем таблицу managers для изменений
LOCK TABLE cafe.managers IN EXCLUSIVE MODE;

-- Добавляем новое поле для хранения массива номеров телефонов
ALTER TABLE cafe.managers
ADD COLUMN phone_numbers TEXT[];

-- Создаем временную таблицу для хранения новых номеров
WITH updated_numbers AS (
    SELECT 
        manager_uuid,
        ARRAY[
            CONCAT('8-800-2500-', LPAD(ROW_NUMBER() OVER (ORDER BY manager_name), 3, '0')),  -- Новый номер
            manager_phone  -- Старый номер
        ] AS new_phone_numbers
    FROM cafe.managers
    WHERE manager_phone IS NOT NULL  -- Обновляем только тех, у кого есть старый номер
)
-- Обновляем новое поле с массивом номеров
UPDATE cafe.managers
SET phone_numbers = updated_numbers.new_phone_numbers
FROM updated_numbers
WHERE cafe.managers.manager_uuid = updated_numbers.manager_uuid;

-- Удаляем старое поле с телефоном
ALTER TABLE cafe.managers
DROP COLUMN manager_phone;

-- Завершаем транзакцию
COMMIT;
