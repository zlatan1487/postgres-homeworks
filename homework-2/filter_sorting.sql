-- Напишите запросы, которые выводят следующую информацию:
-- 1. заказы, доставленные в страны France, Germany, Spain (таблица orders, колонка ship_country)
SELECT *
FROM orders
WHERE ship_country IN ( 'France', 'Germany', 'Spain')

-- 2. уникальные города и страны, куда отправлялись заказы, отсортировать по странам и городам (таблица orders, колонки ship_country, ship_city)
SELECT DISTINCT ship_city, ship_country
FROM orders
ORDER BY ship_country, ship_city;

-- 3. сколько дней в среднем уходит на доставку товара в Германию (таблица orders, колонки order_date, shipped_date, ship_country)
SELECT AVG(shipped_date - order_date) AS average_delivery_time
FROM orders
WHERE ship_country = 'Germany';

-- 4. минимальную и максимальную цену среди продуктов, не снятых с продажи (таблица products, колонки unit_price, discontinued не равно 1)
SELECT MIN(unit_price) AS min_price, MAX(unit_price) AS max_price
FROM products
WHERE discontinued <> 1;

-- 5. минимальную и максимальную цену среди продуктов, не снятых с продажи и которых имеется не меньше 20 (таблица products, колонки unit_price, units_in_stock, discontinued не равно 1)
SELECT MIN(unit_price) AS min_price, MAX(unit_price) AS max_price
FROM products
WHERE discontinued <> 1 AND units_in_stock >= 20;