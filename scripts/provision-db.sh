#!/bin/bash
# Database Server Provisioning Script - GadgetZone

set -e

echo "=== Starting Database Server Setup ==="

sudo apt update && sudo apt upgrade -y

if ! command -v mysql &> /dev/null; then
    echo "Installing MariaDB..."
    sudo apt install mariadb-server -y
fi

# Secure MariaDB
sudo mysql << EOF
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

# Create database and user
echo "Creating database..."
sudo mysql << EOF
CREATE DATABASE IF NOT EXISTS gadgetzone;
CREATE USER IF NOT EXISTS 'gadgetuser'@'%' IDENTIFIED BY 'GadgetZone2026!';
GRANT ALL PRIVILEGES ON gadgetzone.* TO 'gadgetuser'@'%';
FLUSH PRIVILEGES;
EOF

# Configure bind address
sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Create sample tables
sudo mysql gadgetzone << EOF
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0
);

INSERT INTO products (name, price, stock_quantity) VALUES
('Laptop Pro', 1299.99, 50),
('Wireless Mouse', 29.99, 200),
('Mechanical Keyboard', 89.99, 100);
EOF

sudo systemctl restart mariadb
sudo systemctl enable mariadb

echo "=== Database Server Setup Complete ==="