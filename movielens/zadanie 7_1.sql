
CREATE SCHEMA IF NOT EXISTS `movieLens` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

CREATE TABLE IF NOT EXISTS `mydb`.`dim_movies` (
  `movie_key` INT NOT NULL AUTO_INCREMENT,
  `movie_id` INT NOT NULL,
  `title` VARCHAR(125) NOT NULL,
  `year` INT NULL,
  PRIMARY KEY (`movie_key`),
  UNIQUE INDEX `movie_id_UNIQUE` (`movie_id` ASC),
  UNIQUE INDEX `title_UNIQUE` (`title` ASC),
  UNIQUE INDEX `movie_key_UNIQUE` (`movie_key` ASC))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`dim_users` (
  `user_key` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `gender` CHAR(1) NOT NULL,
  `age_group` VARCHAR(45) NOT NULL,
  `occupation` VARCHAR(100) NOT NULL,
  `zip_code` VARCHAR(45) NOT NULL,
  `dim_userscol` VARCHAR(45) NULL,
  PRIMARY KEY (`user_key`),
  UNIQUE INDEX `user_key_UNIQUE` (`user_key` ASC),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`dim_date` (
  `date_key` INT NOT NULL AUTO_INCREMENT,
  `full_date` DATE NOT NULL,
  PRIMARY KEY (`date_key`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`fact_ratings` (
  `rating_key` INT NOT NULL AUTO_INCREMENT,
  `date_key` INT NOT NULL,
  `user_key` INT NOT NULL,
  `movie_key` INT NOT NULL,
  `rating` DECIMAL(3,1) NOT NULL,
  `rated_at` DATETIME NULL,
  PRIMARY KEY (`rating_key`),
  INDEX `fk_fact_ratings_dim_date_idx` (`date_key` ASC),
  INDEX `fk_fact_ratings_dim_users1_idx` (`user_key` ASC),
  INDEX `fk_fact_ratings_dim_movies1_idx` (`movie_key` ASC),
  CONSTRAINT `fk_fact_ratings_dim_date`
    FOREIGN KEY (`date_key`)
    REFERENCES `mydb`.`dim_date` (`date_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_ratings_dim_users1`
    FOREIGN KEY (`user_key`)
    REFERENCES `mydb`.`dim_users` (`user_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_ratings_dim_movies1`
    FOREIGN KEY (`movie_key`)
    REFERENCES `mydb`.`dim_movies` (`movie_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

CREATE TABLE IF NOT EXISTS `mydb`.`dim_genres` (
  `genres_key` INT NOT NULL,
  `genres_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`genres_key`))

CREATE TABLE IF NOT EXISTS `mydb`.`bridge_movies_genres` (
  `dim_movies_movie_key` INT NOT NULL,
  `dim_genres_genres_key` INT NOT NULL,
  PRIMARY KEY (`dim_movies_movie_key`, `dim_genres_genres_key`),
  INDEX `fk_dim_movies_has_dim_genres_dim_genres1_idx` (`dim_genres_genres_key` ASC),
  INDEX `fk_dim_movies_has_dim_genres_dim_movies1_idx` (`dim_movies_movie_key` ASC),
  CONSTRAINT `fk_dim_movies_has_dim_genres_dim_movies1`
    FOREIGN KEY (`dim_movies_movie_key`)
    REFERENCES `mydb`.`dim_movies` (`movie_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dim_movies_has_dim_genres_dim_genres1`
    FOREIGN KEY (`dim_genres_genres_key`)
    REFERENCES `mydb`.`dim_genres` (`genres_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)

