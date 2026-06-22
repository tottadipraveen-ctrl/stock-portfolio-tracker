CREATE DATABASE stock_tracker;

USE stock_tracker;

CREATE TABLE users
(
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE portfolios
(
    portfolio_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    portfolio_name VARCHAR(100),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
);

CREATE TABLE stocks
(
    stock_id INT AUTO_INCREMENT PRIMARY KEY,

    symbol VARCHAR(20) UNIQUE NOT NULL,
    company_name VARCHAR(150) NOT NULL,

    sector VARCHAR(100),

    exchange VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transactions
(
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,


    portfolio_id INT,
    stock_id INT,


    transaction_type 
    ENUM('BUY','SELL') NOT NULL,


    quantity INT NOT NULL,


    price DECIMAL(10,2) NOT NULL,


    transaction_date DATE NOT NULL,


    FOREIGN KEY(portfolio_id)
    REFERENCES portfolios(portfolio_id)
    ON DELETE CASCADE,


    FOREIGN KEY(stock_id)
    REFERENCES stocks(stock_id)
);

CREATE TABLE stock_prices
(
    price_id INT AUTO_INCREMENT PRIMARY KEY,


    stock_id INT,


    price_date DATE,


    open_price DECIMAL(10,2),
    high_price DECIMAL(10,2),
    low_price DECIMAL(10,2),
    close_price DECIMAL(10,2),


    volume BIGINT,


    FOREIGN KEY(stock_id)
    REFERENCES stocks(stock_id)
    ON DELETE CASCADE
);

CREATE TABLE watchlist
(
    watchlist_id INT AUTO_INCREMENT PRIMARY KEY,


    user_id INT,
    stock_id INT,


    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,


    FOREIGN KEY(user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,


    FOREIGN KEY(stock_id)
    REFERENCES stocks(stock_id)
);

CREATE INDEX idx_stock_symbol
ON stocks(symbol);


CREATE INDEX idx_transaction_date
ON transactions(transaction_date);


CREATE INDEX idx_stock_price_date
ON stock_prices(price_date);