-- Подключиться к БД Northwind и сделать следующие изменения:
-- 1. Добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
ALTER TABLE products
ADD CONSTRAINT check_unit_price_positive
CHECK (unit_price > 0);

-- 2. Добавить ограничение, что поле discontinued таблицы products может содержать только значения 0 или 1
ALTER TABLE products
ADD CONSTRAINT check_discontinued_value CHECK (discontinued IN (0, 1));


-- 3. Создать новую таблицу, содержащую все продукты, снятые с продажи (discontinued = 1)
CREATE TABLE discontinued_products AS
SELECT *
FROM products
WHERE discontinued = 1;

-- 4. Удалить из products товары, снятые с продажи (discontinued = 1)
-- Для 4-го пункта может потребоваться удаление ограничения, связанного с foreign_key. Подумайте, как это можно решить, чтобы связь с таблицей order_details все же осталась.
-- создание временной таблицы

CREATE TABLE temp_products (
    product_id INT PRIMARY KEY,
    product_name character varying(40) NOT NULL,
    supplier_id smallint,
    category_id smallint,
    quantity_per_unit character varying(20),
    unit_price real,
    units_in_stock smallint,
    units_on_order smallint,
    reorder_level smallint,
    discontinued integer NOT NULL
);

-- бекап таблицы с discontinued = 0
INSERT INTO temp_products (product_id, product_name, supplier_id,
category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued)
SELECT product_id, product_name, supplier_id,
category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued
FROM products
WHERE discontinued = 0;

-- Удаление ограничения внешнего ключа "fk_order_details_products"
ALTER TABLE order_details DROP CONSTRAINT fk_order_details_products;

-- Удаление таблицы "products"
DROP TABLE products;

-- переименование таблицы в products
ALTER TABLE temp_products RENAME TO products;

SELECT * FROM products

-- тестим связь между табл., products и order_details
SELECT *
FROM products
JOIN order_details ON products.product_id = order_details.product_id;