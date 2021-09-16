CREATE DATABASE fsd;
USE fsd;
CREATE TABLE players (
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    age INT NOT NULL DEFAULT 0,
    position CHAR(1) NOT NULL,
    salary DECIMAL(10,2) NOT NULL DEFAULT 0,
    hire_date DATETIME,
    skills_data_id INT NOT NULL,
    team_id INT
    -- todo fk
);

CREATE TABLE players_coaches(
	player_id INT,
    coach_id INT,
    CONSTRAINT pf_player_coaches PRIMARY KEY (
		player_id, coach_id)
);

CREATE TABLE coaches (
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10,2) NOT NULL DEFAULT 0,
    coach_level INT NOT NULL DEFAULT 0
    -- todo fk
);

CREATE TABLE skills_data (
	id INT AUTO_INCREMENT PRIMARY KEY,
    dribbling INT DEFAULT 0,
    pace INT DEFAULT 0,
    passing INT DEFAULT 0,
    shooting INT DEFAULT 0,
    speed INT DEFAULT 0,
    strength INT DEFAULT 0
    -- todo fk
);

CREATE TABLE countries (
	id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL
);

CREATE TABLE towns (
	id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL,
    country_id INT NOT NULL,
    CONSTRAINT fk_countries_towns
    FOREIGN KEY (country_id)
    REFERENCES countries(id)
);

CREATE TABLE stadiums (
	id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL,
    capacity INT NOT NULL,
    town_id INT NOT NULL,
    CONSTRAINT fk_stadiums_towns
    FOREIGN KEY (town_id)
    REFERENCES towns(id)
);

CREATE TABLE teams (
	id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL,
    established DATE NOT NULL,
    fan_base BIGINT NOT NULL DEFAULT 0,
    stadium_id INT NOT NULL,
    CONSTRAINT fk_stadiums_teams
    FOREIGN KEY (stadium_id)
    REFERENCES stadiums(id)
);

ALTER TABLE players
ADD CONSTRAINT fk_playes_skills
FOREIGN KEY (skills_data_id)
REFERENCES skills_data(id);

ALTER TABLE players
ADD CONSTRAINT fk_playes_teams
FOREIGN KEY (team_id)
REFERENCES teams(id);

ALTER TABLE players_coaches
ADD CONSTRAINT fk_players_coaches_playes
FOREIGN KEY (player_id)
REFERENCES players(id);

ALTER TABLE players_coaches
ADD CONSTRAINT fk_players_coaches_coaches
FOREIGN KEY (coach_id)
REFERENCES coaches(id);

# ex.2 
INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT first_name, last_name, salary*2, char_length(first_name)
FROM players
WHERE age >= 45;

# ex.3
UPDATE coaches AS c
JOIN players_coaches AS pc
ON pc.coach_id = c.id
SET coach_level = coach_level + 1 
WHERE first_name LIKE 'A%';           
-- GROUP BY c.id; -- за да мине само веднъж +1 (но Judge приема и без)

/* 
we could do it with subquery:
*/
UPDATE coaches AS c
SET coach_level = coach_level + 1 
WHERE first_name LIKE 'A%' 
AND id = (SELECT coach_id FROM players_coaches 
			WHERE coach_id = id LIMIT 1);

# ex.4
DELETE FROM players
WHERE age >= 45; -- hmmmmmm...

# EX.5
SELECT first_name, age, salary FROM players
ORDER BY salary DESC;

# ex.6
SELECT p.id, 
concat(first_name, ' ', last_name) AS full_name, 
age, `position`, hire_date
FROM players AS p
JOIN skills_data AS s
ON p.skills_data_id = s.id
WHERE age < 23 AND `position` = 'A' AND hire_date IS NULL
AND s.strength >50
ORDER BY salary, age;

# ex. 7
SELECT t.`name` AS team_name, t.established, t.fan_base, count(p.id) AS cnt
FROM teams AS t
JOIN players AS p -- beware of NULL values if we need RIGHT/LEFT JOIN
ON p.team_id = t.id
GROUP BY t.`name`
ORDER BY cnt DESC, fan_base DESC;

/* we could do it with subquery(защото не ни дава да имаме други селектирани
колонки освен тази в group by - това е mode на Judge):
*/
SELECT t.`name` AS team_name, t.established, t.fan_base, 
(SELECT count(*) FROM players WHERE team_id = t.id) AS cnt
FROM teams AS t
ORDER BY cnt DESC, fan_base DESC;

# ex. 8
SELECT max(sd.speed) AS max_speed, towns.`name` 
FROM players AS p
RIGHT JOIN skills_data AS sd ON p.skills_data_id = sd.id
RIGHT JOIN teams AS t ON p.team_id = t.id
RIGHT JOIN stadiums AS s ON t.stadium_id = s.id
RIGHT JOIN towns ON s.town_id = towns.id
WHERE t.`name` != 'Devify'
GROUP BY towns.`name`
ORDER BY max_speed DESC, towns.`name` ASC;

# ex.9
SELECT c.`name`, 
	count(p.id) AS total_count_of_players,
	sum(salary) AS total_sum_of_salaries
FROM players AS p
RIGHT JOIN teams AS t ON p.team_id = t.id
RIGHT JOIN stadiums AS s ON t.stadium_id = s.id
RIGHT JOIN towns ON s.town_id = towns.id
RIGHT JOIN countries AS c ON towns.country_id = c.id
GROUP BY towns.`name`
ORDER BY total_count_of_players DESC, c.`name`;

-- or we could start from countries: ...hhmmm but we get diff result
SELECT c.`name`, 
	count(p.id) AS total_count_of_players,
	sum(salary) AS total_sum_of_salaries
FROM countries AS c
LEFT JOIN towns AS t ON t.country_id = c.id
LEFT JOIN stadiums AS s ON t.id = s.town_id
LEFT JOIN teams ON teams.stadium_id = s.id
LEFT JOIN players AS p ON p.team_id = t.id
GROUP BY c.`name`
ORDER BY total_count_of_players DESC, c.`name`;


# ex.10
DELIMITER $$
CREATE FUNCTION `udf_stadium_players_count` (stadium_name VARCHAR(30))
RETURNS INTEGER
DETERMINISTIC
BEGIN	
RETURN (SELECT count(p.id) FROM players AS p
	RIGHT JOIN teams AS t ON p.team_id = t.id
	RIGHT JOIN stadiums AS s ON t.stadium_id = s.id
	WHERE s.`name` = stadium_name);
END $$

# ex.11
DELIMITER $$
CREATE PROCEDURE udp_find_playmaker(
	min_dribble_points INT, 
    team_name VARCHAR(45))
BEGIN
	SELECT concat(first_name, ' ', last_name) AS full_name, p.age, p.salary, sd.dribbling, sd.speed, t.`name`
    FROM players AS p
    JOIN skills_data AS sd ON p.skills_data_id = sd.id
    JOIN teams AS t ON p.team_id = t.id
    WHERE t.`name` = team_name
    AND dribbling > min_dribble_points
    AND speed > (SELECT AVG(speed) FROM skills_data)
	ORDER BY speed DESC
    LIMIT 1;
END $$

call udp_find_playmaker (20, 'Skyble');


