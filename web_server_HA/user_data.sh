#!/bin/bash

# Оновлення списку пакетів та встановлення Nginx
sudo apt update
sudo apt install -y nginx

# Запуск Nginx та його автозапуск при старті системи
sudo systemctl start nginx
sudo systemctl enable nginx

# Створення файлу index.html з повідомленням
cat <<EOF | sudo tee /var/www/html/index.html
<h1>Hello from $(hostname)</h1>
EOF

# Перезапуск Nginx, щоб застосувати зміни
sudo systemctl restart nginx
