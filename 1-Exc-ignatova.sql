CREATE DATABASE `minions`;
USE `minions`;

CREATE TABLE `minions` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `age` INT 
);
CREATE TABLE `towns` (
	`town_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

ALTER TABLE `minions`
ADD COLUMN `town_id` INT,
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY `minions`(`town_id`) 
REFERENCES `towns`(`id`);

INSERT INTO `towns`
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');
INSERT INTO `minions`
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

-- zad4
TRUNCATE `minions`;

-- zad5 
DROP TABLE `minions`;
DROP TABLE `towns`;


-- zad6 ++Populate the table with 5 records 
CREATE TABLE `people` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    `picture` BLOB,
    `height` FLOAT(5, 2),
    `weight` FLOAT(5, 2),
    `gender` CHAR(1) NOT NULL,
    `bithdate` DATE NOT NULL, #format yyyy-mm-dd
    `biography` TEXT
);
INSERT INTO `people`
VALUES
(1, 'Maria', NULL, 156.5, 45.5, 'F', '2002-05-24', 'oaidhoa auhdajbn'),
(2, 'Petia', NULL, 166.5, 55.5, 'F', '2001-05-25', 'ahsdashd  sghajdbuaj'),
(3, 'Nasko', NULL, 90, 15.5, 'M', '2015-07-28', 'hasjdgjasb ajhwdg'),
(4, 'Lili', NULL, 140, 25, 'F', '2010-01-14', 'kaDGU ioefhkdb shakdhjk'),
(5, 'Petar', NULL, 176.5, 45.5, 'M', '1999-03-05', 'ashdk jhwdkhksl dhshj');

-- zad7
CREATE TABLE `users` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL,
    `password` VARCHAR(26) NOT NULL,
    `profile_picture` BLOB,
    `last_login_time` TIMESTAMP,
    `is_deleted` BOOLEAN
);
INSERT INTO `users`
VALUES
(1, 'mimi1', '1234', NULL, '2002-05-24 12:23:53', TRUE),
(2, 'pipi2', 'asdf', NULL, '2001-05-25 15:28:13', FALSE),
(3, 'nasimo_ninja', 'qwerty', NULL, '2015-07-28 11:13:23', FALSE),
(4, 'lilka^pilka', 'zxcv', NULL, '2010-01-14 03:20:50', TRUE),
(5, 'peshito', 'qaz', NULL, '1999-03-05 17:27:50', FALSE);


-- zad8
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY (`id`, `username`);

-- zad9
ALTER TABLE `last_login_timelast_login_timeusers`
CHANGE COLUMN `last_login_time` `last_login_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- ZAD 10
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`),
CHANGE COLUMN `username` `username` VARCHAR(30) NOT NULL UNIQUE;




-- zad 13
CREATE DATABASE `soft_uni`;
USE `soft_uni`;

CREATE TABLE `towns`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);
CREATE TABLE `addresses`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `address_text` VARCHAR(100) NOT NULL,
    `town_id` INT NOT NULL,
    CONSTRAINT fk_addresses_towns
    FOREIGN KEY (`town_id`) REFERENCES `towns`(`id`) #той решава да направи тази колона fk, не го пише в заданието
);
CREATE TABLE `departments`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL
);
CREATE TABLE `employees`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(20) NOT NULL,
    `middle_name` VARCHAR(20) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `job_title` VARCHAR(50),
    `department_id` INT NOT NULL,
    `hire_date` DATE,
    `salary` DECIMAL NOT NULL,
    `address_id` INT,
    CONSTRAINT fk_employees_departments
    FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`),
    CONSTRAINT fk_employees_addresses
    FOREIGN KEY (`address_id`) REFERENCES `addresses`(`id`)
);

INSERT INTO `towns`(`name`)
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO `departments`(`name`)
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

ALTER TABLE `employees`
CHANGE COLUMN `address_id` `address_id` INT;

INSERT INTO `employees`
VALUES
(1, 'Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00, NULL),
(2, 'Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00, NULL),
(3, 'Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25, NULL),
(4, 'Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00, NULL),
(5, 'Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88, NULL);

SELECT * FROM `towns`
ORDER BY `name`;

SELECT * FROM `departments`
ORDER BY `name`;

SELECT * FROM `employees`
ORDER BY `salary` DESC;

-- ZAD16
SELECT `name` FROM `towns`
ORDER BY `name`;

SELECT `name` FROM `departments`
ORDER BY `name`;

SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees`
ORDER BY `salary` DESC;

-- zad 17
UPDATE `employees`
SET `salary` = `salary` * 1.1;
-- WHERE `id` = 1
SELECT `salary` FROM `employees`;

-- zad 18
-- TRUNCATE
/*
DELETE FROM `employees`
WHERE `id` = 5;
*/

-- zad 11
CREATE DATABASE `Movies`;
USE `Movies`;
CREATE TABLE `directors`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `director_name` VARCHAR(50) NOT NULL,
    `notes` TEXT
);
CREATE TABLE `genres`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `genre_name` VARCHAR(50) NOT NULL,
    `notes` TEXT
);
CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `category_name` VARCHAR(50) NOT NULL,
    `notes` TEXT
);
CREATE TABLE `movies`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `director_id` INT,
    `copyright_year` INT,
    `length` INT,
    `genre_id` INT,
    `category_id` INT,
    `rating` INT,
    `notes` TEXT
);
INSERT INTO `directors`(`director_name`, `notes`)
VALUES
('John Smith', 'sth'),
('Caroline Thompson', 'other thing'),
('Michael Moore', 'else'),
('Sam Hocking', 'another'),
('Paul Benson', 'what else');
INSERT INTO `genres`(`genres_name`, `notes`)
VALUES
('romantic', 'sth'),
('animation', 'other thing'),
('psy', 'else'),
('comedy', 'another'),
('action', 'what else');
INSERT INTO `categories`(`categories_name`, `notes`)
VALUES
('with subs', 'sth'),
('hd', 'other thing'),
('with adds', 'else'),
('for kids', 'another'),
('modern', 'what else');
INSERT INTO `movies`(`title`, `director_id`, `length`, `rating`)
VALUES
('Moby Dick', 2, 120, 6),
('Wedding', 4, 100, 4),
('Persey', 1, 90, 6),
('Sparta', 3, 80, 5),
('Greek Weekend', 5, 60, 5);

-- zad 12
CREATE DATABASE `car_rental`;
USE `car_rental`;
CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `daily_rate` DECIMAL,
    `weekly_rate` DECIMAL,
    `monthly_rate` DECIMAL,
    `weekend_rate` DECIMAL
);
CREATE TABLE `cars`(
	`id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `plate_number` VARCHAR(50) NOT NULL,
    `make` VARCHAR(30),
    `model` VARCHAR(30),
    `car_year` INT,
    `category_id` INT,
    `doors` INT,
    `picture` BLOB,
    `car_condition` VARCHAR(30),
    `available` BOOLEAN NOT NULL
);
CREATE TABLE `employees`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(20),
    `last_name` VARCHAR(20) NOT NULL,
    `title` VARCHAR(4),
    `notes` TEXT
    );
CREATE TABLE `customers`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `driver_licence_number` VARCHAR(10),
    `full_name` VARCHAR(20) NOT NULL,
    `address` VARCHAR(100),
    `city` VARCHAR(50),
    `zip_code` INT,
    `notes` TEXT
    );
CREATE TABLE `rental_orders`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `employee_id` INT,
    `customer_id` INT,
    `car_id` INT,
    `car_condition` VARCHAR(40),
    `tank_level` INT,
    `kilometrage_start` INT,
    `kilometrage_end` INT,
    `total_kilometrage` INT,
    `start_date` DATE,
    `end_date` DATE,
    `total_days` INT,
    `rate_applied` DECIMAL,
    `tax_rate` DECIMAL,
    `order_status` VARCHAR(20),
    `notes` TEXT
    );