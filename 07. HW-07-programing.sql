# ex.1
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
BEGIN
	SELECT e.first_name, e.last_name
    FROM employees AS e 
    WHERE salary > 35000
    ORDER BY e.first_name, e.last_name, e.employee_id;
END$$
DELIMITER ;
CALL usp_get_employees_salary_above_35000;

# ex.2
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above (salary_level DECIMAL(19,4))
BEGIN
	SELECT e.first_name, e.last_name
    FROM employees AS e
    WHERE e.salary >= salary_level
    ORDER BY e.first_name, e.last_name, e.employee_id;
END$$
DELIMITER ;
CALL usp_get_employees_salary_above (45000);

# ex.3
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with (prefix VARCHAR(20))
BEGIN
	SELECT `name` AS town_name
    FROM towns AS t
    WHERE LOWER(t.`name`) like LOWER(CONCAT(prefix, '%'))
    ORDER BY town_name;
END $$
DELIMITER ;
CALL usp_get_towns_starting_with('b');

# ex.4
DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town (town_name VARCHAR(20))
BEGIN
	SELECT e.first_name, e.last_name 
    FROM towns AS t
    JOIN addresses AS a ON t.town_id = a.town_id
    JOIN employees AS e ON e.address_id = a.address_id
    WHERE t.`name` = town_name
    ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;
CALL usp_get_employees_from_town ('Sofia');

# ex. 5
DELIMITER $$
CREATE FUNCTION ufn_get_salary_level (salary DECIMAL(19,4))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
DECLARE salary_level VARCHAR(10);
    IF (salary < 30000)
		THEN SET salary_level := 'Low';
	ELSEIF (salary <= 50000)
		THEN SET salary_level := 'Average';
	ELSE
		SET salary_level := 'High';
	END IF;
    
RETURN salary_level;

END $$
DELIMITER ;
SELECT ufn_get_salary_level (10000)

# ex.6
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level (salary_level VARCHAR(20))
BEGIN
	SELECT e.first_name, e.last_name 
    FROM employees AS e
    WHERE (SELECT ufn_get_salary_level(e.salary) = salary_level)
    ORDER BY e.first_name DESC, e.last_name DESC;
END $$
CALL usp_get_employees_by_salary_level('High');

# ex.7
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(
set_of_letters varchar(50), word varchar(50)
)
RETURNS BIT
DETERMINISTIC
BEGIN
	
RETURN (SELECT word REGEXP(concat('^[', set_of_letters, ']+$')));
   
END $$

# ex.8


# ex.9
DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than (balance_higher_than DECIMAL(19,4))
BEGIN
	SELECT ah.first_name, ah.last_name FROM account_holders AS ah
	JOIN (SELECT * FROM accounts AS a 
			GROUP BY a.account_holder_id
			HAVING SUM(balance) > balance_higher_than) AS a 
	ON a.account_holder_id = ah.id
	ORDER BY a.account_holder_id;
END $$
CALL usp_get_holders_with_balance_higher_than(7000);

# ex.10
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(
balance DECIMAL(19,4), interest DECIMAL(19,4), years INT)
RETURNS DECIMAL(19,4)
BEGIN

RETURN balance * pow((1+ interest), years);

END $$

# ex. 11
CREATE PROCEDURE usp_calculate_future_value_for_account(
	acc_id INT, interest DECIMAL(19,4))
BEGIN
	SELECT a.id AS account_id, 
			ah.first_name, 
            ah.last_name,
            a.balance AS current_balance,
            (SELECT ufn_calculate_future_value(a.balance, interest, 5)) -- тук хардкодваме years
				AS balance_in_5_years
    FROM account_holders ah
    JOIN `accounts` a ON ah.id = a.account_holder_id
    WHERE a.id = acc_id;
END $$

# ex.12
DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
    IF (money_amount <= 0)
    THEN ROLLBACK;
    ELSE    
		UPDATE accounts a 
		SET a.balance = a.balance + money_amount
        WHERE a.id = account_id;
		
    END IF;
END $$

CALL usp_deposit_money(1, 10);

# ex.13
DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
    IF (money_amount < 0)
		THEN ROLLBACK;
    ELSEIF (money_amount > (SELECT a.balance FROM accounts AS a WHERE account_id like id))
		THEN ROLLBACK;
    ELSE    
		UPDATE accounts a 
		SET a.balance = a.balance - money_amount
        WHERE a.id = account_id;
		
    END IF;
END $$


# ex. 14
DELIMITER $$
CREATE PROCEDURE usp_transfer_money(
	from_account_id INT, to_account_id INT, amount DECIMAL(19,4))
BEGIN
	IF (amount >= 0)
    AND 
    (SELECT a.id FROM accounts AS a WHERE id = from_account_id) IS NOT NULL
    AND
    (SELECT a.id FROM accounts AS a WHERE id = to_account_id) IS NOT NULL
    -- AND
    -- ((SELECT balance FROM accounts a WHERE a.id = from_account_id) >= amount)
    THEN
    START TRANSACTION;
    
    -- withdraw
UPDATE accounts a 
SET 
    balance = balance - amount
WHERE
    a.id = from_account_id;
    
	UPDATE accounts a 
SET 
    balance = balance + amount
WHERE
    a.id = to_account_id;
    
    IF (SELECT balance FROM accounts a WHERE a.id = from_account_id) < 0 
    THEN ROLLBACK;
    ELSE COMMIT;
    END IF;
END IF;
END $$

# ex. 15
CREATE TABLE `logs`(log_id INT PRIMARY KEY AUTO_INCREMENT, account_id INT, old_sum DECIMAL(19,4), new_sum DECIMAL(19,4));
DELIMITER $$
CREATE TRIGGER tr_balance_change
AFTER UPDATE
ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO `logs`(account_id, old_sum, new_sum)
    VALUES(old.id, old.balance, new.balance);
END $$

UPDATE accounts a SET a.balance = a.balance +10 WHERE id = 1;

# ex. 16
CREATE TABLE `logs`(
    log_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    account_id INT(11) NOT NULL,
    old_sum DECIMAL(19,4) NOT NULL,
    new_sum DECIMAL(19,4) NOT NULL,
    CONSTRAINT fk_logs_accounts 
    FOREIGN KEY(account_id) 
    REFERENCES accounts(id)
);
 
CREATE TABLE `notification_emails`(
    `id` INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `recipient` INT(11) NOT NULL,
    `subject` VARCHAR(50) NOT NULL,
    `body` VARCHAR(255) NOT NULL
);
 
CREATE TRIGGER tr_notification_emails
AFTER INSERT 
ON `logs`
FOR EACH ROW
BEGIN
    INSERT INTO `notification_emails`(`recipient`, `subject`, `body`)
    VALUES (NEW.account_id, 
            CONCAT('Balance change for account: ', NEW.account_id), 
            CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'), ' your balance was changed from ', 
                ROUND(NEW.old_sum, 2), ' to ', ROUND(NEW.new_sum, 2), '.'));
END

