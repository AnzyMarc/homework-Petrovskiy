-- 1.3. Список всех пользователей 
SELECT user, host, plugin FROM mysql.user;

-- 1.5. Список прав для пользователя sys_temp 
SHOW GRANTS FOR 'sys_temp'@'%';

-- 1.8. Список всех таблиц базы данных Sakila 
USE sakila;
SHOW TABLES;