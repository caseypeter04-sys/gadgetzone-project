#!/bin/bash
# Web Server Provisioning Script - GadgetZone

set -e

echo "=== Starting Web Server Setup ==="

# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
if ! command -v nginx &> /dev/null; then
    echo "Installing Nginx..."
    sudo apt install nginx -y
fi

# Install UFW
sudo apt install ufw -y

# Configure UFW - allow only essential ports
echo "Configuring firewall..."
sudo ufw --force disable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

# Create self-signed SSL certificate
echo "Creating SSL certificate..."
sudo mkdir -p /etc/ssl/gadgetzone
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/gadgetzone/private.key \
    -out /etc/ssl/gadgetzone/certificate.crt \
    -subj "/C=UK/ST=London/L=London/O=GadgetZone/CN=gadgetzone.local"

# Configure Nginx with HTTPS
echo "Configuring Nginx..."
sudo tee /etc/nginx/sites-available/default > /dev/null << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;
    
    ssl_certificate /etc/ssl/gadgetzone/certificate.crt;
    ssl_certificate_key /etc/ssl/gadgetzone/private.key;
    
    root /var/www/html;
    index index.html index.htm;
    
    server_name _;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

echo "=== Web Server Setup Complete ==="