#Docker-Compose
docker-compose -f docker-compose.yml --env-file .env up -d
docker-compose -f docker-compose.yml --env-file .env exec app composer install
docker-compose -f docker-compose.yml --env-file .env exec app php artisan key:generate
docker-compose -f docker-compose.yml --env-file .env exec app php artisan migrate