-- Database Schema Initialization Script
-- This script creates all necessary tables for the Restaurant Management application

USE restaurantmanagement;

-- User table
CREATE TABLE IF NOT EXISTS `user` (
    `user_id` INT NOT NULL AUTO_INCREMENT,
    `user_id_card` VARCHAR(12) NOT NULL,
    `user_phone_number` VARCHAR(10) NOT NULL,
    `user_sex` BOOLEAN,
    `user_last_name` VARCHAR(50) NOT NULL,
    `user_first_name` VARCHAR(20) NOT NULL,
    `user_date_of_birth` DATE NOT NULL,
    `user_joined_date` DATE,
    `user_username` VARCHAR(20) NOT NULL,
    `user_password` VARCHAR(255) NOT NULL,
    `user_is_active` BOOLEAN,
    `user_role` VARCHAR(20),
    `user_email` VARCHAR(255),
    `user_address` VARCHAR(255),
    `user_image` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Coefficient table
CREATE TABLE IF NOT EXISTS `coefficient` (
    `coef_id` INT NOT NULL AUTO_INCREMENT,
    `coef_type_date` VARCHAR(100),
    `coef_type_lesson` VARCHAR(100),
    `coef_value` DOUBLE,
    PRIMARY KEY (`coef_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Lobby table
CREATE TABLE IF NOT EXISTS `lobby` (
    `lob_id` INT NOT NULL AUTO_INCREMENT,
    `lob_name` VARCHAR(255),
    `lob_address` VARCHAR(255),
    `lob_price` DECIMAL(12,2),
    `lob_is_active` BOOLEAN,
    `lob_total_table` INT,
    `lob_image` VARCHAR(255),
    `lob_description` VARCHAR(500),
    PRIMARY KEY (`lob_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Lobby Image table
CREATE TABLE IF NOT EXISTS `lobby_image` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `lob_id` INT,
    `image` VARCHAR(500),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`lob_id`) REFERENCES `lobby`(`lob_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dish table
CREATE TABLE IF NOT EXISTS `dish` (
    `dish_id` INT NOT NULL AUTO_INCREMENT,
    `dish_name` VARCHAR(255) NOT NULL,
    `dish_image` VARCHAR(255),
    `dish_is_active` BOOLEAN,
    `dish_description` TEXT,
    PRIMARY KEY (`dish_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Menu table
CREATE TABLE IF NOT EXISTS `menu` (
    `menu_id` INT NOT NULL AUTO_INCREMENT,
    `menu_name` VARCHAR(45) NOT NULL,
    `menu_price` DECIMAL(12,2),
    `menu_is_active` BOOLEAN,
    `menu_image` VARCHAR(300),
    PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Menu Dish table (many-to-many relationship)
CREATE TABLE IF NOT EXISTS `menu_dish` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `menu_id` INT NOT NULL,
    `dish_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`menu_id`) REFERENCES `menu`(`menu_id`) ON DELETE CASCADE,
    FOREIGN KEY (`dish_id`) REFERENCES `dish`(`dish_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Service table
CREATE TABLE IF NOT EXISTS `service` (
    `ser_id` INT NOT NULL AUTO_INCREMENT,
    `ser_name` VARCHAR(255),
    `ser_price` DECIMAL(10,2),
    `ser_is_active` BOOLEAN,
    `ser_description` TEXT,
    `ser_image` VARCHAR(255),
    PRIMARY KEY (`ser_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Order table (using backticks because 'order' is a MySQL reserved word)
CREATE TABLE IF NOT EXISTS `order` (
    `ord_id` INT NOT NULL AUTO_INCREMENT,
    `ord_created_date` DATE,
    `ord_booking_date` DATE,
    `ord_booking_lesson` VARCHAR(45),
    `user_id` INT,
    `coef_id` INT,
    `lob_id` INT,
    `ord_is_payment` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (`ord_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`coef_id`) REFERENCES `coefficient`(`coef_id`) ON DELETE SET NULL,
    FOREIGN KEY (`lob_id`) REFERENCES `lobby`(`lob_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Order Menu table
CREATE TABLE IF NOT EXISTS `order_menu` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `ord_id` INT NOT NULL,
    `menu_id` INT NOT NULL,
    `amount_table` INT,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`ord_id`) REFERENCES `order`(`ord_id`) ON DELETE CASCADE,
    FOREIGN KEY (`menu_id`) REFERENCES `menu`(`menu_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Order Service table
CREATE TABLE IF NOT EXISTS `order_service` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `ord_id` INT NOT NULL,
    `ser_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`ord_id`) REFERENCES `order`(`ord_id`) ON DELETE CASCADE,
    FOREIGN KEY (`ser_id`) REFERENCES `service`(`ser_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Comment table
CREATE TABLE IF NOT EXISTS `comment` (
    `cmt_id` INT NOT NULL AUTO_INCREMENT,
    `cmt_content` VARCHAR(500),
    `user_id` INT,
    `cmt_star` INT,
    `created_day` DATETIME,
    `lobby_id` INT,
    PRIMARY KEY (`cmt_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`lobby_id`) REFERENCES `lobby`(`lob_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Feedback table
CREATE TABLE IF NOT EXISTS `feedback` (
    `feed_id` INT NOT NULL AUTO_INCREMENT,
    `feed_content` TEXT,
    `feed_created_date` DATE,
    `user_id` INT,
    `feed_is_read` BOOLEAN,
    PRIMARY KEY (`feed_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bill table
CREATE TABLE IF NOT EXISTS `bill` (
    `bill_id` INT NOT NULL,
    `bill_created_date` DATE,
    `user_id` INT,
    `bill_total_money` DECIMAL(12,2),
    PRIMARY KEY (`bill_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Note: Run seeder.sql separately to populate initial data
