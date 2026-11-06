CREATE DATABASE northwind;

CREATE TABLE dim_employees (
    EmployeeID INT PRIMARY KEY,
    LastName VARCHAR(15),
    FirstName VARCHAR(15),
    BirthDate DATETIME,
    Photo VARCHAR(255),
    Notes VARCHAR(255)
)

CREATE TABLE dim_shippers(
    ShipperID INT PRIMARY KEY,
    ShipperName VARCHAR(25),
    ShipperPhone VARCHAR(15)
)

CREATE TABLE dim_customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    ContactName VARCHAR(50),
    Address VARCHAR(50),
    City VARCHAR(20),
    PostalCode VARCHAR(10),
    Country VARCHAR(15)
)

CREATE TABLE dim_dates(
    DateKey INT PRIMARY KEY,
    FullDate DATETIME,
    Year INT,
    Quarter INT,
    Month INT,
    MonthName VARCHAR(9),
    DayOfMonth INT,
    DayOfWeek INT,
    DayName VARCHAR(9)
)

CREATE TABLE dim_suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(50),
    ContactName VARCHAR(50),
    Address VARCHAR(50),
    City VARCHAR(20),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    Phone VARCHAR(15)
)

CREATE TABLE dim_products (
    ProductID INT PRIMARY KEY,
    SupplierID INT FOREIGN KEY REFERENCES dim_suppliers(SupplierID),
    ProductName VARCHAR(50),
    Unit VARCHAR(25),
    Price DECIMAL(10,2),
    CategoryName VARCHAR(25),
    Description VARCHAR(255)
)

CREATE TABLE fact_orderdetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT FOREIGN KEY REFERENCES dim_products(ProductID),
    Quantity INT,
    CustomerID INT FOREIGN KEY REFERENCES dim_customers(CustomerID),
    EmployeeID INT FOREIGN KEY REFERENCES dim_employees(EmployeeID),
    DateKey INT FOREIGN KEY REFERENCES dim_dates(DateKey),
    ShipperID INT FOREIGN KEY REFERENCES dim_shippers(ShipperID)
);