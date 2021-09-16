SELECT count(*) FROM wizzard_deposits;

#ex.2
SELECT max(magic_wand_size) FROM wizzard_deposits;

# ex.3
SELECT 
    deposit_group, MAX(magic_wand_size) AS `max_size`
FROM
    wizzard_deposits
GROUP BY deposit_group
ORDER BY `max_size` , deposit_group;

# ex.4
SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY avg(magic_wand_size)
LIMIT 1;

# ex.5
SELECT deposit_group, sum(deposit_amount) AS `total_sum`
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY `total_sum`;

# ex.6
SELECT deposit_group, sum(deposit_amount) AS `total_sum`
FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
ORDER BY deposit_group;

# ex.7
SELECT deposit_group, sum(deposit_amount) AS `total_sum`
FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;

# ex.8
SELECT deposit_group, magic_wand_creator, min(deposit_charge) AS `min_charge`
FROM wizzard_deposits
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group;

# ex.9
SELECT 
    (CASE
        WHEN `age` BETWEEN 0 AND 10 THEN '[0-10]'
        WHEN `age` BETWEEN 11 AND 20 THEN '[11-20]'
        WHEN `age` BETWEEN 21 AND 30 THEN '[21-30]'
        WHEN `age` BETWEEN 31 AND 40 THEN '[31-40]'
        WHEN `age` BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN `age` BETWEEN 51 AND 60 THEN '[51-60]'
        ELSE '[61+]'
    END) AS `age_group`,
    COUNT(*) AS `wiz_count`
FROM
    wizzard_deposits
GROUP BY `age_group`
ORDER BY `age_group`;

# ex.10
SELECT DISTINCT
    LEFT(first_name, 1) AS `f_char`
FROM
    wizzard_deposits
WHERE
    deposit_group = 'Troll Chest'
GROUP BY `f_char`
ORDER BY `f_char`;

# ex.11
SELECT deposit_group, is_deposit_expired, 
avg(deposit_interest) AS `avg_interest`
FROM wizzard_deposits
WHERE deposit_start_date > '1985-01-01'
GROUP BY deposit_group, is_deposit_expired
ORDER BY deposit_group DESC, is_deposit_expired;

# ex.12
SELECT department_id, min(salary) AS `min_salary`
FROM employees
WHERE department_id IN (2, 5, 7) AND year(hire_date) >= 2000
GROUP BY department_id
ORDER BY department_id;

# ex.13
CREATE TABLE `hpe` AS
SELECT * FROM employees
WHERE salary > 30000 AND manager_id != 42;

UPDATE `hpe`
SET salary = salary + 5000
WHERE department_id = 1;

SELECT department_id, avg(salary) AS `avg_salary`
FROM `hpe`
GROUP BY department_id
ORDER BY department_id;

# ex.14
SELECT department_id, max(salary) AS `max_salary`
FROM employees
GROUP BY department_id
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY department_id;


# ex.15
SELECT count(salary) FROM employees
WHERE manager_id IS NULL;

# ex.16
SELECT e.department_id, 
(
	SELECT DISTINCT e2.salary FROM employees as e2
    WHERE e2.department_id = e.department_id
    ORDER BY e2.salary DESC
    LIMIT 1 OFFSET 2
) AS `third_highest_sal`
FROM employees AS e
GROUP BY e.department_id
HAVING third_highest_sal IS NOT NULL
ORDER BY e.department_id;

# ex.17
SELECT e.first_name, e.last_name, e.department_id
FROM employees AS e
WHERE salary > 
(
	SELECT avg(e2.salary) 
	from employees AS e2
	WHERE e2.department_id = e.department_id
)
ORDER BY department_id, employee_id
LIMIT 10;

# ex.18
SELECT department_id, sum(salary) AS `total_salary`
FROM employees
GROUP BY department_id
ORDER BY department_id;

