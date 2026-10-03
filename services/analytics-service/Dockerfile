FROM php:8.2-cli-alpine
# Install PostgreSQL extension required by the PHP app
RUN apk add --no-cache postgresql-dev && docker-php-ext-install pdo_pgsql
WORKDIR /app
COPY . .
EXPOSE 8087
CMD ["php", "-S", "0.0.0.0:8087", "router.php"]
