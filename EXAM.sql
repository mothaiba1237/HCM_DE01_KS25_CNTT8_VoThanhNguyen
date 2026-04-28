CREATE DATABASE SalesManagement;
USE SalesManagement;

CREATE TABLE IF NOT EXISTS Product(
	product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(256) NOT NULL,
    manufacturer VARCHAR(256) NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Customer(
	customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(256) NOT NULL,
    customer_email VARCHAR(256) NOT NULL UNIQUE,
    customer_phone INT,
    customer_addres VARCHAR(256) NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders(
	order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE ,
    orders_sum DECIMAL(10, 2),
    customer_id VARCHAR(10),
    CONSTRAINT FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE IF NOT EXISTS Order_Detail(
	order_id VARCHAR(10),
    product_id VARCHAR(10),
    quantity INT,
    price_attime DECIMAL(10, 2),
    PRIMARY KEY(order_id, product_id),
    CONSTRAINT FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

ALTER TABLE Orders
ADD COLUMN note TEXT;

ALTER TABLE Product
CHANGE manufacturer NhaSanXuat VARCHAR(256);

DROP TABLE Order_Detail;
DROP TABLE Orders;


INSERT INTO Product VALUES
('P001', 'MacBook Air M2', 'Apple', '20000000', '10'),
('P002', 'Iphone','Apple', '30000000', '100'),
('P003', 'Samsung', 'Samsung', '15000000', '25'),
('P004', 'Xiaomi', 'Xiaomi','7000000', '30'),
('P005', 'Asus', 'Asus', '35000000', '15');

INSERT INTO Customer VALUES
('C001', 'Nguyen Van A', 'a@gmail.com','0123455670', 'HCM'),
('C002', 'Nguyen Van B', 'b@gmail.com', NULL, 'HN'),
('C003', 'Nguyen Van C', 'c@gmail.com', '0234567890', 'HN'),
('C004', 'Nguyen Van D', 'd@gmail.com', '0345678912', 'Da Nang'),
('C005', 'Nguyen Van E', 'e@gmail.com', NULL, 'Hue');

INSERT INTO Orders VALUES
('DH001', '2026-04-28', '30000000', 'C001'),
('DH002', '2026-10-03', '20000000', 'C003'),
('DH003', '2026-10-05', '15000000', 'C004'),
('DH004', '2026-03-20', '17000000', 'C001'),
('DH005', '2026-04-05', '25000000', 'C005');

INSERT INTO Order_Detail VALUES
('DH001', 'P001', '1', '20000000'),
('DH001', 'P003', '1', '15000000'),
('DH002', 'P002', '1', '30000000'),
('DH003', 'P003', '1', '15000000'),
('DH004', 'P004', '1', '7000000');

SET SQL_SAFE_UPDATES = 0;
UPDATE Product 
SET product_price = product_price * 1.1
WHERE NhaSanXuat = 'Apple';

DELETE FROM Customer
WHERE customer_phone IS NULL;

SELECT * FROM Product
WHERE product_price BETWEEN 10000000 AND 20000000;


 
SELECT p.product_name
FROM Product p
JOIN Order_Detail od ON p.product_id = od.product_id
WHERE od.order_id = 'DH001';


SELECT 
CONCAT(customer_id, ' | ', customer_name, ' | ', customer_email) AS customer_info
FROM Customer 
WHERE customer_id IN(
	SELECT customer_id
    FROM Orders
    WHERE order_id IN(
		SELECT order_id
        FROM Order_Detail
        WHERE product_id = (
			SELECT product_id
            FROM Product
            WHERE product_name =  'MacBook Air M2'
        )
    )
)
