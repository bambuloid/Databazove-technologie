CREATE SCHEMA IF NOT EXISTS `chinook_dw` ;
USE `chinook_dw` ;

-- -----------------------------------------------------
-- Table `chinook_dw`.`dim_customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `chinook_dw`.`dim_customer` (
  `customer_key` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `first_name` VARCHAR(40) NULL DEFAULT NULL,
  `last_name` VARCHAR(20) NULL DEFAULT NULL,
  `company` VARCHAR(80) NULL DEFAULT NULL,
  `address` VARCHAR(70) NULL DEFAULT NULL,
  `city` VARCHAR(40) NULL DEFAULT NULL,
  `state` VARCHAR(40) NULL DEFAULT NULL,
  `country` VARCHAR(40) NULL DEFAULT NULL,
  `postal_code` VARCHAR(10) NULL DEFAULT NULL,
  `phone` VARCHAR(24) NULL DEFAULT NULL,
  `fax` VARCHAR(24) NULL DEFAULT NULL,
  `email` VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (`customer_key`),
  UNIQUE INDEX (`customer_id` ASC));


-- -----------------------------------------------------
-- Table `chinook_dw`.`dim_track`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `chinook_dw`.`dim_track` (
  `track_key` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `track_id` INT NOT NULL,
  `track_name` VARCHAR(200) NULL DEFAULT NULL,
  `album_id` INT NULL DEFAULT NULL,
  `album_title` VARCHAR(160) NULL DEFAULT NULL,
  `artist_id` INT NULL DEFAULT NULL,
  `artist_name` VARCHAR(120) NULL DEFAULT NULL,
  `genre_id` INT NULL DEFAULT NULL,
  `genre_name` VARCHAR(120) NULL DEFAULT NULL,
  `media_type_id` INT NULL DEFAULT NULL,
  `media_type_name` VARCHAR(120) NULL DEFAULT NULL,
  `composer` VARCHAR(220) NULL DEFAULT NULL,
  `milliseconds` INT NULL DEFAULT NULL,
  `bytes` INT NULL DEFAULT NULL,
  `list_unit_price` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`track_key`),
  UNIQUE INDEX (`track_id` ASC));


-- -----------------------------------------------------
-- Table `chinook_dw`.`dim_date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `chinook_dw`.`dim_date` (
  `date_key` INT NULL DEFAULT NULL,
  `full_date` DATE NOT NULL,
  PRIMARY KEY (`date_key`),
  UNIQUE INDEX (`full_date` ASC));


-- -----------------------------------------------------
-- Table `chinook_dw`.`dim_employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `chinook_dw`.`dim_employee` (
  `employee_key` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `employee_id` INT NOT NULL,
  `first_name` VARCHAR(20) NULL DEFAULT NULL,
  `last_name` VARCHAR(20) NULL DEFAULT NULL,
  `title` VARCHAR(30) NULL DEFAULT NULL,
  `birth_date` DATETIME NULL DEFAULT NULL,
  `hire_date` DATETIME NULL DEFAULT NULL,
  `address` VARCHAR(70) NULL DEFAULT NULL,
  `city` VARCHAR(40) NULL DEFAULT NULL,
  `state` VARCHAR(40) NULL DEFAULT NULL,
  `country` VARCHAR(40) NULL DEFAULT NULL,
  `postal_code` VARCHAR(10) NULL DEFAULT NULL,
  `phone` VARCHAR(24) NULL DEFAULT NULL,
  `fax` VARCHAR(24) NULL DEFAULT NULL,
  `email` VARCHAR(60) NULL DEFAULT NULL,
  `reports_to_employee_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`employee_key`),
  UNIQUE INDEX (`employee_id` ASC));


-- -----------------------------------------------------
-- Table `chinook_dw`.`dim_billing_location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `chinook_dw`.`dim_billing_location` (
  `billing_location_key` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `billing_address` VARCHAR(70) NULL DEFAULT NULL,
  `billing_city` VARCHAR(40) NULL DEFAULT NULL,
  `billing_state` VARCHAR(40) NULL DEFAULT NULL,
  `billing_country` VARCHAR(40) NULL DEFAULT NULL,
  `billing_postal_code` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`billing_location_key`));


-- -----------------------------------------------------
-- Table `chinook_dw`.`dim_playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `chinook_dw`.`dim_playlist` (
  `playlist_key` INT NULL DEFAULT NULL AUTO_INCREMENT,
  `playlist_id` INT NOT NULL,
  `playlist_name` VARCHAR(120) NULL DEFAULT NULL,
  PRIMARY KEY (`playlist_key`),
  UNIQUE INDEX (`playlist_id` ASC));


-- -----------------------------------------------------
-- Table `chinook_dw`.`fact_sales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `chinook_dw`.`fact_sales` (
  `sales_key` BIGINT NULL DEFAULT NULL AUTO_INCREMENT,
  `invoice_line_id` INT NOT NULL,
  `invoice_id` INT NOT NULL,
  `customer_key` INT NOT NULL,
  `track_key` INT NOT NULL,
  `date_key` INT NOT NULL,
  `time_key` INT NULL DEFAULT NULL,
  `employee_key` INT NULL DEFAULT NULL,
  `billing_location_key` INT NOT NULL,
  `quantity` INT NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  `revenue` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`sales_key`),
  UNIQUE INDEX (`invoice_line_id` ASC),
  INDEX `idx_sales_customer` (`customer_key` ASC),
  INDEX `idx_sales_track` (`track_key` ASC),
  INDEX `idx_sales_date` (`date_key` ASC),
  INDEX `idx_sales_employee` (`employee_key` ASC),
  INDEX `idx_sales_billing` (`billing_location_key` ASC),
  INDEX `idx_sales_invoice` (`invoice_id` ASC),
  INDEX `fk_sales_customer` (`customer_key` ASC),
  INDEX `fk_sales_track` (`track_key` ASC),
  INDEX `fk_sales_date` (`date_key` ASC),
  INDEX `fk_sales_employee` (`employee_key` ASC),
  INDEX `fk_sales_billing` (`billing_location_key` ASC),
  CONSTRAINT `fk_sales_customer`
    FOREIGN KEY (`customer_key`)
    REFERENCES `chinook_dw`.`dim_customer` (`customer_key`),
  CONSTRAINT `fk_sales_track`
    FOREIGN KEY (`track_key`)
    REFERENCES `chinook_dw`.`dim_track` (`track_key`),
  CONSTRAINT `fk_sales_date`
    FOREIGN KEY (`date_key`)
    REFERENCES `chinook_dw`.`dim_date` (`date_key`),
  CONSTRAINT `fk_sales_employee`
    FOREIGN KEY (`employee_key`)
    REFERENCES `chinook_dw`.`dim_employee` (`employee_key`),
  CONSTRAINT `fk_sales_billing`
    FOREIGN KEY (`billing_location_key`)
    REFERENCES `chinook_dw`.`dim_billing_location` (`billing_location_key`));


-- -----------------------------------------------------
-- Table `chinook_dw`.`bridge_playlist_membership`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `chinook_dw`.`bridge_playlist_membership` (
  `playlist_key` INT NOT NULL,
  `track_key` INT NOT NULL,
  PRIMARY KEY (`playlist_key`, `track_key`),
  INDEX `idx_membership_track` (`track_key` ASC),
  INDEX `fk_membership_track` (`track_key` ASC),
  CONSTRAINT `fk_membership_playlist`
    FOREIGN KEY (`playlist_key`)
    REFERENCES `chinook_dw`.`dim_playlist` (`playlist_key`),
  CONSTRAINT `fk_membership_track`
    FOREIGN KEY (`track_key`)
    REFERENCES `chinook_dw`.`dim_track` (`track_key`));
