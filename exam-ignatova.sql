# ex. 1
CREATE DATABASE stc;
USE stc;

CREATE TABLE `drivers`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`age` INT NOT NULL,
`rating` FLOAT DEFAULT 5.5
);
CREATE TABLE `clients`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`full_name` VARCHAR(50) NOT NULL,
`phone_number` VARCHAR(20) NOT NULL
);
CREATE TABLE `addresses`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(100) NOT NULL
);
CREATE TABLE `courses`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`from_address_id` INT NOT NULL,
`start` DATETIME NOT NULL,
`car_id` INT NOT NULL,
`client_id` INT NOT NULL,
`bill` DECIMAL(10,2) DEFAULT 10,
CONSTRAINT `fk_courses_addresses` 
FOREIGN KEY(`from_address_id`)
REFERENCES `addresses`(`id`),
CONSTRAINT `fk_courses_clients` 
FOREIGN KEY(`client_id`)
REFERENCES `clients`(`id`)
);
CREATE TABLE `categories`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(10) NOT NULL
);
CREATE TABLE `cars`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`make` VARCHAR(20) NOT NULL,
`model` VARCHAR(20),
`year` INT NOT NULL DEFAULT 0,
`mileage` INT DEFAULT 0,
`condition` CHAR(1) NOT NULL,
`category_id` INT NOT NULL,
CONSTRAINT `fk_cars_categories` 
FOREIGN KEY(`category_id`)
REFERENCES `categories`(`id`)
);
CREATE TABLE `cars_drivers`(
	car_id INT NOT NULL,
    driver_id INT NOT NULL,
CONSTRAINT pk_cars_drivers PRIMARY KEY (
		car_id, driver_id),
CONSTRAINT `fk_drivers_cars_drivers` 
FOREIGN KEY(`driver_id`)
REFERENCES `drivers`(`id`),
CONSTRAINT `fk_drivers_cars_cars` 
FOREIGN KEY(`car_id`)
REFERENCES `cars`(`id`)
);
ALTER TABLE `courses`
ADD CONSTRAINT fk_courses_cars
FOREIGN KEY (car_id)
REFERENCES cars(id);

# ex. 2
INSERT INTO clients (full_name, phone_number)
SELECT concat(d.first_name, ' ', d.last_name), 
	concat('(088) 9999', d.id*2)
FROM drivers AS d
WHERE d.id BETWEEN 10 AND 20;

# ex. 3
UPDATE cars
SET `condition` = 'C'
WHERE (mileage >= 800000 OR mileage IS NULL) 
	AND `year` <= 2010 
    AND make != 'Mercedes-Benz';

SELECT * FROM cars
WHERE (mileage >= 800000 OR mileage IS NULL) 
	AND `year` >= 2010 
    AND make != 'Mercedes-Benz';

# ex. 4
DELETE clients FROM clients AS cl
LEFT JOIN courses AS cou ON cou.client_id = cl.id
WHERE client_id IS NULL AND char_length(full_name) > 3;

DELETE FROM clients AS cl 
WHERE cl.id NOT IN (
SELECT distinct client_id FROM courses AS cou
)
AND char_length(full_name) > 3;

# ex. 5
SELECT make, model, `condition` FROM cars
ORDER BY id;

# ex. 6
SELECT d.first_name AS first_name, d.last_name AS last_name, c.make, c.model, c.mileage
FROM drivers AS d
JOIN cars_drivers AS cd ON d.id = cd.driver_id
JOIN cars AS c ON c.id = cd.car_id
WHERE c.mileage IS NOT NULL
ORDER BY mileage DESC, first_name;

# ex. 7
SELECT c.id AS car_id, c.make, c.mileage, 
	-- (SELECT count(cou.id) FROM courses WHERE c.id = cou.car_id LIMIT 1) AS count_of_courses,
	 count(cou.id) AS count_of_courses,
    ROUND(AVG(cou.bill), 2) AS avg_bill
FROM cars AS c
LEFT JOIN courses AS cou ON c.id = cou.car_id
GROUP BY c.id
HAVING count_of_courses != 2
ORDER BY count_of_courses DESC, car_id;

# ex. 8
SELECT cl.full_name,
	-- (SELECT count(cou.car_id) FROM courses WHERE c.id = cou.car_id),
    count(cou.car_id) AS count_of_cars,
    sum(cou.bill) AS total_sum
FROM clients AS cl
JOIN courses AS cou ON cou.client_id = cl.id
WHERE cl.full_name LIKE '_a%'
GROUP BY cl.full_name
HAVING count_of_cars > 1
ORDER BY cl.full_name;

# ex. 9
SELECT a.`name`,
	(CASE
        WHEN hour(cou.`start`) BETWEEN 6 AND 20 THEN 'Day'
        ELSE 'Night'
    END) AS `day_time`,
    cou.bill,
    cl.full_name,
    c.make, c.model, cat.`name`
FROM addresses AS a
JOIN courses AS cou ON cou.from_address_id = a.id
JOIN clients AS cl ON cl.id = cou.client_id
JOIN cars AS c ON cou.car_id = c.id
JOIN categories AS cat ON cat.id = c.category_id
ORDER BY cou.id;


# ex. 10
DELIMITER $$
CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR (20)) 
RETURNS INT 
DETERMINISTIC
BEGIN
	DECLARE cou_count INT;
	SET cou_count := (SELECT COUNT(cou.id) 
						FROM courses AS cou
	 JOIN clients AS cl ON cl.id = cou.client_id
	WHERE cl.phone_number = phone_num);
	RETURN cou_count;
END $$

# ex. 11
DELIMITER $$
CREATE PROCEDURE udp_courses_by_address (address_name VARCHAR(100))
BEGIN
	SELECT a.`name`,
	cl.full_name,
	(CASE
        WHEN cou.bill <= 20 THEN 'Low'
        WHEN cou.bill <= 30 THEN 'Medium'
        ELSE 'High'
    END) AS `level_of_bill`,
    c.make, c.`condition`, cat.`name`
	FROM addresses AS a
	JOIN courses AS cou ON cou.from_address_id = a.id
	JOIN clients AS cl ON cl.id = cou.client_id
	JOIN cars AS c ON cou.car_id = c.id
	JOIN categories AS cat ON cat.id = c.category_id
	ORDER BY c.make, cl.full_name;
END $$



