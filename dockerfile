FROM nginx:alpine

# Обновляем пакеты и устанавливаем необходимые зависимости
RUN apk update && apk add --no-cache python3 py3-pip nginx

# Устанавливаем Snake.js
RUN pip3 install git+https://github.com/jcubic/snakegame.git

# Копируем index.html в корневую директорию nginx
COPY index.html /usr/share/nginx/html/index.html

# Копируем файл snake.py в /usr/share/nginx/html/
COPY snake.py /usr/share/nginx/html/

# Создаем файл конфигурации Nginx для обработки асинхронных запросов
# Это позволит Nginx запускать snake.py как отдельный процесс.
RUN echo "
events {
    worker_connections 1024;
}

http {
    include mime.types;
    default_type text/plain;

    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            try_files $uri $uri/ =404;
        }
    }
}
" > /etc/nginx/conf.d/snake.conf

# Заменяем файл конфигурации Nginx по умолчанию
RUN rm /etc/nginx/conf.d/default.conf

# Запускаем Nginx в фоновом режиме
CMD ["nginx", "-g", "daemon off;"]
