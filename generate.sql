-- Roles Table-- Roles Table
CREATE TABLE Roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Persons Table
CREATE TABLE Persons (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    last_name VARCHAR(50) NOT NULL
);

-- Users Table
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(60) NOT NULL CHECK (LENGTH(password_hash) = 60),
    role_id INT NOT NULL,
    person_id INT NOT NULL UNIQUE,
    FOREIGN KEY (role_id) REFERENCES Roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (person_id) REFERENCES Persons(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Stocks Table
CREATE TABLE Stocks (
    id SERIAL PRIMARY KEY,
    ticket VARCHAR(5) NOT NULL UNIQUE,
    price DOUBLE PRECISION NOT NULL,
    amount INT NOT NULL
);

-- Companies Table
CREATE TABLE Companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Accounts Table
CREATE TABLE Accounts (
    user_id INT NOT NULL PRIMARY KEY,
    account DOUBLE PRECISION CHECK (account >= 0),
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Company_Stock Join Table
CREATE TABLE Company_Stock (
    company_id INT NOT NULL,
    stock_id INT NOT NULL UNIQUE,
    PRIMARY KEY (company_id, stock_id),
    FOREIGN KEY (company_id) REFERENCES Companies(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (stock_id) REFERENCES Stocks(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- User_Stock Join Table
CREATE TABLE User_Stock (
    user_id INT NOT NULL,
    stock_id INT NOT NULL,
    amount INT NOT NULL,
    PRIMARY KEY (user_id, stock_id),
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (stock_id) REFERENCES Stocks(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Insert Roles
INSERT INTO Roles (name) VALUES 
('Admin'), 
('User'),
('Waiting'),
('Blocked');

-- Insert Persons
INSERT INTO Persons (first_name, patronymic, last_name) VALUES
('Иван', 'Дмитриевич', 'Кольчевский'),
('Алексей', 'Валерьевич', 'Еднач'),
('Артём', 'Андреевич', 'Ковальчук');

-- Insert Users
INSERT INTO Users (username, password_hash, role_id, person_id) VALUES
('kalci', '$2a$10$fbbf337d042d1710336f8u3RA00CdolZNl/dBgMuLjyLTqU2KVRyS', 1, (SELECT id FROM Persons WHERE last_name = 'Кольчевский' LIMIT 1)), -- Admin role, password: meowmeowmeow:3
('thomaschar', '$2a$10$eb0f08df4490a93668690uTxouIbEf1lfuvULcoK5iaoUN3GKM7m.', 2, (SELECT id FROM Persons WHERE last_name = 'Еднач' LIMIT 1)), -- User role, password: *******
('moracer', '$2a$10$f2d5cb0c6df9efc95ff3cuAFGKKYHDMAStb.WJGgjs2CQMhBKfv8S', 2, (SELECT id FROM Persons WHERE last_name = 'Ковальчук' LIMIT 1)); -- User role, password: ilovebmw42

-- Insert Stocks
INSERT INTO Stocks (ticket, price, amount) VALUES
('APL', 52.42, 10),
('ALPHA', 1337, 20),
('TSL', 1102, 40);

-- Insert Companies
INSERT INTO Companies (name) VALUES 
('Google'), 
('Apple'), 
('Tesla');

-- Insert Accounts
INSERT INTO Accounts (user_id, account) VALUES
(2, 1213),
(3, 1233.58);

-- Link Companies and Stocks
INSERT INTO Company_Stock (company_id, stock_id) VALUES
((SELECT id FROM Companies WHERE name = 'Google' LIMIT 1), (SELECT id FROM Stocks WHERE ticket = 'ALPHA' LIMIT 1)), -- ALPHA is Google's stock
((SELECT id FROM Companies WHERE name = 'Apple' LIMIT 1), (SELECT id FROM Stocks WHERE ticket = 'APL' LIMIT 1)), -- APL is Apple's stock
((SELECT id FROM Companies WHERE name = 'Tesla' LIMIT 1), (SELECT id FROM Stocks WHERE ticket = 'TSL' LIMIT 1)); -- TSL is Tesla's stocka's stock

-- Link Users and Stocks
INSERT INTO User_Stock (user_id, stock_id, amount) VALUES
(2, (SELECT id FROM Stocks WHERE ticket = 'ALPHA' LIMIT 1), 5),
(2, (SELECT id FROM Stocks WHERE ticket = 'TSL' LIMIT 1), 1),
(3, (SELECT id FROM Stocks WHERE ticket = 'APL' LIMIT 1), 1),
(3, (SELECT id FROM Stocks WHERE ticket = 'TSL' LIMIT 1), 7);