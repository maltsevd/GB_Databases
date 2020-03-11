-- 1. Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).

-- К сожалению, ввиду ограниченного времени, не додумался где можно улучшить. Запросы проанализировал, вопросов нет.

-- 2. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.


SELECT (SELECT first_name FROM users WHERE id = from_user_id) as friend, COUNT(*) as m_count FROM messages
  WHERE to_user_id = 13
    AND from_user_id IN (
    SELECT from_user_id AS id FROM friendship WHERE user_id = to_user_id
    UNION
    SELECT user_id AS id FROM friendship WHERE friend_id = to_user_id)
  GROUP BY from_user_id
  ORDER BY m_count DESC
  LIMIT 1;    


-- 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT SUM(users_likes) AS total FROM (SELECT COUNT(*) AS users_likes FROM likes 
  WHERE target_type_id = 2 AND target_id IN (SELECT * FROM (SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10) AS sorted_profiles) 
    GROUP BY target_id
) AS counted_likes;



-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT CASE(sex)
  WHEN 'm' THEN 'man'
  WHEN 'f' THEN 'woman'
  END AS sex, 
    COUNT(*) as likes_count FROM (SELECT user_id as user, (SELECT sex FROM profiles WHERE user_id = user) as sex FROM likes) as res 
  GROUP BY sex
  ORDER BY likes_count DESC LIMIT 1;

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

SELECT CONCAT(first_name, ' ', last_name) AS user,
  (SELECT COUNT(*) FROM media md WHERE md.user_id = users.id) + 
  (SELECT COUNT(*) FROM likes l WHERE l.user_id = users.id) + 	
  (SELECT COUNT(*) FROM messages ms WHERE ms.from_user_id = users.id) 
	AS activity 
	FROM users
	ORDER BY activity
	LIMIT 10;