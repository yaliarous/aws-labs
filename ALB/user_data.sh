#!/bin/bash
set -e
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "Hello World from $(hostname -f)" > /var/www/html/index.html