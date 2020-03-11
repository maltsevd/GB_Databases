-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT
  u.id, u.name, u.birthday_at
FROM
  users AS u
JOIN
  orders AS o
ON
  u.id = o.user_id;
  
 
-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
 
SELECT p.id, p.name, p.price, c.name AS catalog
FROM
  products AS p
LEFT JOIN
  catalogs AS c
ON
  p.catalog_id = c.id;