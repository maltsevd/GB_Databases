-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
UPDATE users SET
  created_at = NOW(),
  updated_at = NOW();

-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

-- Честно говоря, не нашел более изящного решения, нежели создать еще пару полей типа DATETIME и закинуть туда значения с помощью STR_TO_DATE.
-- Если есть более "прямой" способ - прошу поделиться))

CREATE TABLE test (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,  
  created_at VARCHAR(100),
  updated_at VARCHAR(100)
 );
INSERT INTO test (created_at,updated_at) VALUES ('22.10.2017 8:10','27.10.2017 8:10');
INSERT INTO test (created_at,updated_at) VALUES ('23.10.2017 8:10','20.10.2017 9:10');
INSERT INTO test (created_at,updated_at) VALUES ('24.10.2017 8:10','20.10.2017 11:10');
ALTER TABLE test ADD (created_at_dt DATETIME, updated_at_dt DATETIME);
UPDATE test 
  SET created_at_dt = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i'),
  updated_at_dt = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');
ALTER TABLE test 
  DROP created_at, DROP updated_at, 
  RENAME COLUMN created_at_dt TO created_at, RENAME COLUMN updated_at_dt TO updated_at;

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

INSERT INTO storehouses_products (value) VALUES (0),(2500),(0),(30),(500),(1);
SELECT * from storehouses_products ORDER BY value=0, value;

-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')

SELECT * FROM users where MONTHNAME(birthday_at) IN ('may', 'august');

-- 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
SELECT * FROM catalogs WHERE id IN (5,1,2) ORDER BY FIELD(id,5,1,2);

-- Практическое задание теме “Агрегация данных”

-- 1. Подсчитайте средний возраст пользователей в таблице users
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) FROM users;

-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

-- К сожалению не додумался до решения самостоятельно(()

-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы
-- Решение придумал не сам, формулу нашел в гугле
SELECT ROUND(EXP(SUM(LN(id)))) FROM catalogs;