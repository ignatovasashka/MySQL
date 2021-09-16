# ex.1
SELECT `first_name`, `last_name`
FROM `employees`
# WHERE substring(`first_name`, 1, 2) = 'Sa'
# WHERE left(`first_name`, 2) = 'Sa'
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id;

# ex.2
SELECT `first_name`, `last_name`
FROM `employees`
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;

# ex.3
SELECT `first_name`
FROM `employees`
WHERE `department_id` IN (3, 10) 
AND YEAR(`hire_date`) BETWEEN 1995 AND 2005
ORDER BY `employee_id`;

# ex.4
SELECT `first_name`, `last_name`
FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%'
ORDER BY `employee_id`;

# ex. 5
SELECT `name`FROM `towns`
WHERE char_length(`name`) IN (5, 6)
ORDER BY `name`;

# ex. 6
SELECT `town_id`, `name`FROM `towns`
WHERE left(`name`, 1) IN ('m', 'k', 'b', 'e')
ORDER BY `name`;

# ex. 7
SELECT `town_id`, `name`FROM `towns`
WHERE left(`name`, 1) NOT IN ('r', 'b', 'd')
ORDER BY `name`;

# ex. 8
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name`
FROM `employees`
WHERE year(`hire_date`) > '2000';
SELECT * FROM `v_employees_hired_after_2000`;

# ex. 9
SELECT `first_name`, `last_name`
FROM `employees`
WHERE char_length(`last_name`) = 5;

# ex. 10
SELECT `country_name`, `iso_code`
FROM `countries`
WHERE `country_name` LIKE '%A%A%A%'
ORDER BY `iso_code`;

# ex. 11
# така не се join-ват таблици, но с досегашните ни знания,
# можем толкова
SELECT 
    `peak_name`,
    `river_name`,
    LOWER(CONCAT(`peak_name`, SUBSTRING(`river_name`, 2))) AS 'mix'
FROM
    `peaks`,
    `rivers`
WHERE
    RIGHT(`peak_name`, 1) = LEFT(`river_name`, 1)
ORDER BY `mix`;

# ex. 12
SELECT `name`, DATE_FORMAT(`start`, '%Y-%m-%d') AS 'start'
FROM `games`
WHERE YEAR(`start`) IN (2011, 2012)
ORDER BY `start`, `name`
LIMIT 50;

# ex. 13
SELECT 
    `user_name`,
    SUBSTRING(`email`,
        LOCATE('@', `email`) + 1) AS 'email_provider'
FROM
    `users`
ORDER BY `email_provider` , `user_name`;

# ex. 14
SELECT `user_name`, `ip_address`
FROM `users`
WHERE `ip_address` LIKE "___.1%.%.___"
ORDER BY `user_name`;

# ex. 15
SELECT 
    `name`,
    (CASE
        WHEN HOUR(`start`) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN HOUR(`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END) AS 'Part of the Day',
    (CASE
        WHEN `duration` < 4 THEN 'Extra Short'
        WHEN `duration` < 7 THEN 'Short'
        WHEN `duration` < 11 THEN 'Long'
        ELSE 'Extra Long'
    END) AS `Duration`
FROM
    `games`;

# ex.16
SELECT 
	`product_name`, 
	`order_date`, 
	DATE_ADD(`order_date`, INTERVAL 3 DAY) AS 'pay_due',
	DATE_ADD(`order_date`, INTERVAL 1 MONTH) AS 'deliver_due'
FROM orders;

