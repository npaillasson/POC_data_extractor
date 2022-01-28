DROP TABLE IF EXISTS `section_payment`;
DROP TABLE IF EXISTS `payment`;
DROP TABLE IF EXISTS `section`;
DROP TABLE IF EXISTS `cost`;
DROP TABLE IF EXISTS `adress`;
DROP TABLE IF EXISTS `member`;
DROP TABLE IF EXISTS `cost`;
DROP TABLE IF EXISTS `section`;

CREATE TABLE `member` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL
);

CREATE TABLE `cost` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`price`INT NOT NULL
);

CREATE TABLE `adress`(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`adress` VARCHAR(200),
	`member_id` INT,
	`year_of_move_in`INT NOT NULL,
	`moving_year`INT,
	KEY `member_id` (`member_id`),
  	CONSTRAINT `adress_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE
);

CREATE TABLE `section` (
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`num` INT NOT NULL,
	`name` VARCHAR(100) NOT NULL,
	`cost_id` INT,
	KEY `cost_id` (`cost_id`),
  	CONSTRAINT `section_ibfk_1` FOREIGN KEY (`cost_id`) REFERENCES `cost` (`id`) ON DELETE SET NULL 
);

CREATE TABLE `payment`(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`section_id` INT,
	`member_id` INT,
	`date` INT NOT NULL,
	KEY `member_id` (`member_id`),
  	CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`) ON DELETE CASCADE,
  	KEY `section_id` (`section_id`),
  	CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `section` (`id`) ON DELETE SET NULL 
);

CREATE TABLE `section_payment` (
	`section_id` INT NOT NULL,
	`payment_id` INT NOT NULL,
	PRIMARY KEY (`section_id`,`payment_id`),
	KEY `section_id` (`section_id`),
  	CONSTRAINT `section_payment_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `section` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE, 
  	KEY `payment_id` (`payment_id`),
  	CONSTRAINT `section_payment_ibfk_2` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
);

INSERT INTO `member` (`name`) VALUES ("michel"), ("jean-luc"), ("Thomas");

INSERT INTO `cost` (`price`) VALUES (50), (100), (150);

INSERT INTO `section` (`num`, `name`, `cost_id`) VALUES (01, "nord", 1), (02, "sud", 1), (03, "paris", 2);

INSERT INTO `adress` (`adress`, `member_id`, `year_of_move_in`, `moving_year`) VALUES ("29 rue du havres, Lille", 1, 2019, 2020), ("35 rue du petit bourg, Taverny", 1, 2021, NULL), ("102 bis, Avenue mirosmenil, Arceuil", 3, 2019, NULL), ("7 chemin de l'arène, Nimes", 2, 2019, NULL);

INSERT INTO `payment` (`section_id`, `member_id`, `date`) VALUES (1, 1, 2019), (1, 1, 2020), (3, 1, 2021), (2, 2, 2019), (2, 2, 2020), (2, 2, 2021), (3, 3, 2019), (3, 3, 2020), (3, 3, 2021);

INSERT INTO `section_payment` (`section_id`, `payment_id`) VALUES (1,1), (1,2), (2,3), (2,4), (2,5), (2,6), (3,7), (3,8), (3,9); 
