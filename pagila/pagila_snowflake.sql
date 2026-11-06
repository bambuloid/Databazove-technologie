-- Pagila dimensional snowflake schema, PostgreSQL 12+
-- DDL only: no source data is loaded.
-- Execute inside an existing PostgreSQL database.
-- Unquoted identifiers are folded to lowercase by PostgreSQL.
CREATE SCHEMA IF NOT EXISTS pagila_dw;
SET search_path TO pagila_dw;

CREATE TABLE dim_country (
  CountryID INT PRIMARY KEY,
  Country VARCHAR(50) NOT NULL
);

CREATE TABLE dim_city (
  CityID INT PRIMARY KEY,
  CountryID INT NOT NULL,
  City VARCHAR(50) NOT NULL,
  CONSTRAINT fk_city_country FOREIGN KEY (CountryID) REFERENCES dim_country(CountryID)
);

CREATE TABLE dim_address (
  AddressID INT PRIMARY KEY,
  CityID INT NOT NULL,
  Address VARCHAR(50) NOT NULL,
  Address2 VARCHAR(50),
  District VARCHAR(50),
  PostalCode VARCHAR(10),
  Phone VARCHAR(20),
  CONSTRAINT fk_address_city FOREIGN KEY (CityID) REFERENCES dim_city(CityID)
);

CREATE TABLE dim_store (
  StoreID INT PRIMARY KEY,
  AddressID INT NOT NULL,
  ManagerStaffID INT,
  CONSTRAINT fk_store_address FOREIGN KEY (AddressID) REFERENCES dim_address(AddressID)
);

CREATE TABLE dim_customer (
  CustomerID INT PRIMARY KEY,
  StoreID INT NOT NULL,
  AddressID INT NOT NULL,
  FirstName VARCHAR(45) NOT NULL,
  LastName VARCHAR(45) NOT NULL,
  Email VARCHAR(50),
  Active SMALLINT,
  CreatedAt DATE,
  CONSTRAINT fk_customer_store FOREIGN KEY (StoreID) REFERENCES dim_store(StoreID),
  CONSTRAINT fk_customer_address FOREIGN KEY (AddressID) REFERENCES dim_address(AddressID)
);

CREATE TABLE dim_staff (
  StaffID INT PRIMARY KEY,
  StoreID INT NOT NULL,
  AddressID INT NOT NULL,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(50),
  Active SMALLINT,
  CONSTRAINT fk_staff_store FOREIGN KEY (StoreID) REFERENCES dim_store(StoreID),
  CONSTRAINT fk_staff_address FOREIGN KEY (AddressID) REFERENCES dim_address(AddressID)
);

CREATE TABLE dim_language (
  LanguageID INT PRIMARY KEY,
  Name VARCHAR(20) NOT NULL
);

CREATE TABLE dim_film (
  FilmID INT PRIMARY KEY,
  LanguageID INT NOT NULL,
  Title VARCHAR(255) NOT NULL,
  Description TEXT,
  ReleaseYear SMALLINT,
  RentalDuration SMALLINT,
  RentalRate DECIMAL(4,2),
  Length SMALLINT,
  ReplacementCost DECIMAL(5,2),
  Rating VARCHAR(10),
  SpecialFeatures TEXT,
  CONSTRAINT fk_film_language FOREIGN KEY (LanguageID) REFERENCES dim_language(LanguageID)
);

CREATE TABLE dim_category (
  CategoryID INT PRIMARY KEY,
  Name VARCHAR(25) NOT NULL
);

CREATE TABLE bridge_film_category (
  FilmID INT NOT NULL,
  CategoryID INT NOT NULL,
  PRIMARY KEY (FilmID, CategoryID),
  CONSTRAINT fk_film_category_film FOREIGN KEY (FilmID) REFERENCES dim_film(FilmID),
  CONSTRAINT fk_film_category_category FOREIGN KEY (CategoryID) REFERENCES dim_category(CategoryID)
);

CREATE TABLE dim_actor (
  ActorID INT PRIMARY KEY,
  FirstName VARCHAR(45) NOT NULL,
  LastName VARCHAR(45) NOT NULL
);

CREATE TABLE bridge_film_actor (
  FilmID INT NOT NULL,
  ActorID INT NOT NULL,
  PRIMARY KEY (FilmID, ActorID),
  CONSTRAINT fk_film_actor_film FOREIGN KEY (FilmID) REFERENCES dim_film(FilmID),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (ActorID) REFERENCES dim_actor(ActorID)
);

CREATE TABLE dim_date (
  DateKey INT PRIMARY KEY, -- YYYYMMDD, e.g. 20261106
  FullDate DATE NOT NULL UNIQUE,
  Year SMALLINT NOT NULL,
  Quarter SMALLINT NOT NULL,
  Month SMALLINT NOT NULL,
  MonthName VARCHAR(9) NOT NULL,
  DayOfMonth SMALLINT NOT NULL,
  DayOfWeek SMALLINT NOT NULL,
  DayName VARCHAR(9) NOT NULL
);

CREATE TABLE fact_rental (
  RentalID INT PRIMARY KEY,
  InventoryID INT NOT NULL, -- source identifier; retained for traceability
  FilmID INT NOT NULL,
  CustomerID INT NOT NULL,
  StaffID INT NOT NULL,
  StoreID INT NOT NULL, -- store of the rented inventory item
  RentalDateKey INT NOT NULL,
  ReturnDateKey INT NULL,
  RentalCount INT NOT NULL DEFAULT 1 CHECK (RentalCount = 1),
  RentalDurationDays DECIMAL(8,2) NULL,
  CONSTRAINT fk_rental_film FOREIGN KEY (FilmID) REFERENCES dim_film(FilmID),
  CONSTRAINT fk_rental_customer FOREIGN KEY (CustomerID) REFERENCES dim_customer(CustomerID),
  CONSTRAINT fk_rental_staff FOREIGN KEY (StaffID) REFERENCES dim_staff(StaffID),
  CONSTRAINT fk_rental_store FOREIGN KEY (StoreID) REFERENCES dim_store(StoreID),
  CONSTRAINT fk_rental_date FOREIGN KEY (RentalDateKey) REFERENCES dim_date(DateKey),
  CONSTRAINT fk_return_date FOREIGN KEY (ReturnDateKey) REFERENCES dim_date(DateKey)
);

-- Optional: actual revenue requires payment data from the source Pagila database.
-- ManagerStaffID is a descriptive source identifier, deliberately not an FK,
-- to avoid a dim_store <-> dim_staff cycle in this educational ERD.
