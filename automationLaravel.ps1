echo "This is a script automation Laravel"
echo "Have fun !!!"
docker --version

# Clone Source Code Laravel 5.8
git clone -b 5.8 https://github.com/laravel/laravel.git src
Remove-Item -Path ./src/.git -Force
New-Item -Path ./src -ItemType directory -Name ".docker"
New-Item -Path ./src/.docker -ItemType directory -Name "db"
New-Item -Path ./src/.docker -ItemType directory -Name "nginx"
New-Item -Path ./src/.docker/nginx -ItemType file -Name "nginx.conf"
New-Item -Path ./src/.docker -ItemType directory -Name "phpmyadmin"
New-Item -Path ./src -ItemType file -Name ".env"

New-Item -Path . -ItemType file -Name "Dockerfile"
New-Item -Path . -ItemType file -Name "docker-compose.yml"
New-Item -Path . -ItemType file -Name "docker-compose.dev.yml"
New-Item -Path . -ItemType file -Name ".dockerignore"
New-Item -Path . -ItemType file -Name ".env"
New-Item -Path . -ItemType file -Name ".gitignore"
New-Item -Path . -ItemType directory -Name "deloy"
New-Item -Path . -ItemType directory -Name "script"
New-Item -Path . -ItemType directory -Name "env"
New-Item -Path . -ItemType directory -Name ".circleci"
New-Item -Path ./env -ItemType file -Name ".nginx.env"
New-Item -Path ./env -ItemType file -Name ".mariadb.env"
New-Item -Path ./env -ItemType file -Name ".phpmyadmin.env"
New-Item -Path ./env -ItemType file -Name ".env.development.local"
New-Item -Path ./.circleci -ItemType file -Name "config.yml"

# Remove gitignore
Remove-Item -Path ./src/.gitignore -Force

#Clear Content database.php
Clear-Content -Path ./src/config/database.php -Force

#databases.php Add Content Databases 
$databases = @"
<?php

use Illuminate\Support\Str;

return [

    /*
    |--------------------------------------------------------------------------
    | Default Database Connection Name
    |--------------------------------------------------------------------------
    |
    | Here you may specify which of the database connections below you wish
    | to use as your default connection for all database work. Of course
    | you may use many connections at once using the Database library.
    |
    */

    'default' => env('DB_CONNECTION', 'mysql'),

    /*
    |--------------------------------------------------------------------------
    | Database Connections
    |--------------------------------------------------------------------------
    |
    | Here are each of the database connections setup for your application.
    | Of course, examples of configuring each database platform that is
    | supported by Laravel is shown below to make development simple.
    |
    |
    | All database work in Laravel is done through the PHP PDO facilities
    | so make sure you have the driver for your particular database of
    | choice installed on your machine before you begin development.
    |
    */

    'connections' => [

        'sqlite' => [
            'driver' => 'sqlite',
            'url' => env('DATABASE_URL'),
            'database' => env('DB_DATABASE', database_path('database.sqlite')),
            'prefix' => '',
            'foreign_key_constraints' => env('DB_FOREIGN_KEYS', true),
        ],

        'mysql' => [
            'driver' => 'mysql',
            'url' => env('DATABASE_URL'),
            'host' => env('DB_HOST', 'mariadb'),
            'port' => env('DB_PORT', '3306'),
            'database' => env('DB_DATABASE', 'laravel'),
            'username' => env('DB_USERNAME', 'user'),
            'password' => env('DB_PASSWORD', 'pass'),
            'unix_socket' => env('DB_SOCKET', ''),
            'charset' => 'utf8mb4',
            'collation' => 'utf8mb4_unicode_ci',
            'prefix' => '',
            'prefix_indexes' => true,
            'strict' => true,
            'engine' => null,
            'options' => extension_loaded('pdo_mysql') ? array_filter([
                PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
            ]) : [],
        ],

        'pgsql' => [
            'driver' => 'pgsql',
            'url' => env('DATABASE_URL'),
            'host' => env('DB_HOST', '127.0.0.1'),
            'port' => env('DB_PORT', '5432'),
            'database' => env('DB_DATABASE', 'forge'),
            'username' => env('DB_USERNAME', 'forge'),
            'password' => env('DB_PASSWORD', ''),
            'charset' => 'utf8',
            'prefix' => '',
            'prefix_indexes' => true,
            'schema' => 'public',
            'sslmode' => 'prefer',
        ],

        'sqlsrv' => [
            'driver' => 'sqlsrv',
            'url' => env('DATABASE_URL'),
            'host' => env('DB_HOST', 'localhost'),
            'port' => env('DB_PORT', '1433'),
            'database' => env('DB_DATABASE', 'forge'),
            'username' => env('DB_USERNAME', 'forge'),
            'password' => env('DB_PASSWORD', ''),
            'charset' => 'utf8',
            'prefix' => '',
            'prefix_indexes' => true,
        ],

    ],

    /*
    |--------------------------------------------------------------------------
    | Migration Repository Table
    |--------------------------------------------------------------------------
    |
    | This table keeps track of all the migrations that have already run for
    | your application. Using this information, we can determine which of
    | the migrations on disk haven't actually been run in the database.
    |
    */

    'migrations' => 'migrations',

    /*
    |--------------------------------------------------------------------------
    | Redis Databases
    |--------------------------------------------------------------------------
    |
    | Redis is an open source, fast, and advanced key-value store that also
    | provides a richer body of commands than a typical key-value system
    | such as APC or Memcached. Laravel makes it easy to dig right in.
    |
    */

    'redis' => [

        'client' => env('REDIS_CLIENT', 'predis'),

        'options' => [
            'cluster' => env('REDIS_CLUSTER', 'predis'),
            'prefix' => env('REDIS_PREFIX', Str::slug(env('APP_NAME', 'laravel'), '_').'_database_'),
        ],

        'default' => [
            'url' => env('REDIS_URL'),
            'host' => env('REDIS_HOST', '127.0.0.1'),
            'password' => env('REDIS_PASSWORD', null),
            'port' => env('REDIS_PORT', 6379),
            'database' => env('REDIS_DB', 0),
        ],

        'cache' => [
            'url' => env('REDIS_URL'),
            'host' => env('REDIS_HOST', '127.0.0.1'),
            'password' => env('REDIS_PASSWORD', null),
            'port' => env('REDIS_PORT', 6379),
            'database' => env('REDIS_CACHE_DB', 1),
        ],

    ],

];

"@

Add-Content -Path ./src/config/database.php -Value $databases

#.envDocker Add Content Dockerfile
$envDocker = @"
#Nginx services
PUBLIC_PORT=8000
PORT=80

# phpMyAdmin services
PMAS_PORT=80
PMAS_PUBLIC_PORT=8081

# Mysql
DB_PORT=3306
DB_PUBLIC_PORT=8991
"@

Add-Content ./.env -Value $envDocker

#.env Laravel
$envLaravel = @"
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000

LOG_CHANNEL=stack

DB_CONNECTION=mysql # Default Mysql
DB_HOST=mariadb
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=user
DB_PASSWORD=pass

BROADCAST_DRIVER=log
CACHE_DRIVER=file
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_DRIVER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_APP_CLUSTER=mt1

MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
"@

Add-Content -Path ./src/.env -Value $envLaravel

$mariadbEnv = @"
MARIADB_DATABASE=laravel
MARIADB_USER=user
MARIADB_PASSWORD=pass
MARIADB_ROOT_PASSWORD=root
"@

Add-Content -Path ./env/.mariadb.env -Value $mariadbEnv

$phpMyAdminEnv = @"
PMA_ARBITRARY=1
PMA_HOST=mariadb
PMA_PORT=3306
PMA_USER=root
PMA_PASSWORD=root
"@

Add-Content -Path ./env/.phpmyadmin.env -Value $phpMyAdminEnv
$nginxEnv = @"
PUBLIC_PORT=8000
PORT=80
"@

Add-Content -Path ./env/.nginx.env -Value $nginxEnv

$envDevelopmentLocal = @"
# Nginx services
PUBLIC_PORT=8000
PORT=80

# Mysql services
DB_CONNECTION=mysql
DB_HOST=mariadb
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=user
DB_PASSWORD=pass
DB_ROOT_PASSWORD=root

DB_PUBLIC_PORT=8991

# phpMyAdmin services
PMAS_PORT=80
PMAS_PUBLIC_PORT=8081

# MariaDB Services
MARIA_DATABASE=laravel
MARIA_USER=user
MARIA_PASSWORD=pass
MARIA_ROOT_PASSWORD=root
"@

Add-Content -Path ./env/.env.development.local -Value $envDevelopmentLocal


#Nginx.conf
$nginxconf = @'
server {
    listen 80;
    index index.php index.html;

    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;

    root /var/www/html/public;

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass app:9000; 
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_hide_header X-Powered-By;
    }

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
}
'@

Add-Content -Path ./src/.docker/nginx/nginx.conf -Value $nginxconf

#Dockerfile
$dockerfile = @'
FROM php:7.4-fpm-alpine as base
WORKDIR /var/www/html
#Install extensions
RUN docker-php-ext-install pdo_mysql

FROM base as dev 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY ./src .

EXPOSE 9000
CMD ["php-fpm"]
'@
Add-Content -Path ./Dockerfile -Value $dockerfile

#docker-compose.yml
$dockerCompose = @'
version: '3.8'
services:
  # PHP Services
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: dev
    container_name: app
    tty: true
    working_dir: /var/www/html
    volumes: 
      - ./src/:/var/www/html
    healthcheck:
      test: wget --quiet --tries=1 --spider http://localhost:8000 || exit 1z
      interval: 1m30s
      timeout: 30s
      retries: 5
      start_period: 30s
    depends_on:
      - mariadb
    networks:
      - app-network
  
  # Nginx Services
  webserver:
    image: nginx:1.17-alpine
    container_name: webserver
    tty: true
    restart: unless-stopped
    env_file:
      - ./env/.nginx.env
    volumes:
      - ./src/:/var/www/html
      - ./src/.docker/nginx/nginx.conf:/etc/nginx/conf.d/default.conf
    ports:
      - "${PUBLIC_PORT}:${PORT}"
    healthcheck:
      test: ["CMD", "curl", "--fail", "http://nginx.host.com"]
      interval: 1m30s
      timeout: 30s
      retries: 5
      start_period: 30s
    networks:
      - app-network
  
  # MariaDB Services
  mariadb:
    image: mariadb:10.4.24
    container_name: maria_database
    tty: true
    restart: unless-stopped
    env_file:
      - ./env/.mariadb.env
    volumes:
      - ./src/.docker/db:/var/lib/mysql
    ports:
      - "${DB_PUBLIC_PORT}:${DB_PORT}"
    healthcheck:
      test: ["executable", "arg"]
      interval: 1m30s
      timeout: 30s
      retries: 5
      start_period: 30s
    networks:
      - app-network

  # PhpMyAdmin
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin
    tty: true
    env_file:
      - ./env/.phpmyadmin.env
    volumes:
      - ./src/.docker/phpmyadmin:/etc/phpmyadmin/config.user.inc.php
    ports:
      - "${PMAS_PUBLIC_PORT}:${PMAS_PORT}"
    restart: unless-stopped
    networks:
      - app-network
    depends_on:
      - mariadb

# NETWORK
networks:
  app-network:
    name: app-network
    driver: bridge
'@

Add-Content -Path ./docker-compose.yml -Value $dockerCompose

$dockerIgnore = @"
/deloy
/script
.dockerignore
Dockerfile
docker-compose.yml
/src/.docker/nginx/nginx.conf

bootstrap/cache/services.php

storage/app/*
storage/framework/cache/*
storage/framework/sessions/*
storage/framework/views/*
storage/logs/*

vendor/**/test*
vendor/**/tests*
vendor/**/Tests*

/src/vendor

**/*node_modules

**.git
.idea
**.gitignore
**.gitattributes
**.sass-cache
*.env*
composer.json

*.config.js
?ulpfile.js
?untfile.js
package.json
phpunit.xml
readme.md
phpspec.yml

Dockerfile
docker-compose.yml
run
run.ps1
"@

Add-Content -Path ./.dockerignore -Value $dockerIgnore

$gitIgnore = @"
src/node_modules
src/public/hot
src/public/storage
src/storage/*.key
src/vendor
# src/.env
src/.env.backup
src/.phpunit.result.cache
src/Homestead.json
src/Homestead.yaml
src/npm-debug.log
src/yarn-error.log
src/.idea
src/.vscode
src./github

.dockerignore
README.md

.gitignore

docker-compose.dev.yml
"@

Add-Content -Path ./.gitignore -Value $gitIgnore

#config.yml / Circle
$circleConfig = @"
version: 2
jobs:
  format_code:
    machine:
      image: ubuntu-2004:current
    resource_class: large
    docker_layer_caching: true
    steps:
      - checkout
      - run: echo "Start format code"
      - run: 
          name: "Start services ..."
          command: docker-compose -f docker-compose.yml up -d
      - run:
          name: "Install composer ..."
          command: docker-compose -f docker-compose.yml exec app composer install
      - run:
          name: "Test database connection ..."
          command: docker-compose -f docker-compose.yml down


  build:
    machine: 
      image: ubuntu-2004:current
    resource_class: large
    docker_layer_caching: true
    steps:
      - checkout
      - run: echo "Start build"
      - run: docker-compose -f docker-compose.yml up -d
      - run: docker-compose -f docker-compose.yml exec app composer install
      - run: docker-compose -f docker-compose.yml down


  test_database:
    machine: 
      image: ubuntu-2004:current
    resource_class: large
    docker_layer_caching: true
    steps:
      - checkout
      - run: echo "Start test databases"
      - run: docker-compose -f docker-compose.yml up -d
      - run: docker-compose -f docker-compose.yml exec app composer install
      - run: docker-compose -f docker-compose.yml exec app php artisan make:test UserTest --unit
          
  
  test_unit:
    machine: 
      image: ubuntu-2004:current
    resource_class: large
    docker_layer_caching: true
    requires:
      - build
    steps:  
      - checkout
      - run: echo "Start test_unit"
      - run: docker-compose -f docker-compose.yml up -d
      - run: docker-compose -f docker-compose.yml exec app composer install
      - run: docker-compose -f docker-compose.yml exec app php artisan make:test UserTest --unit
      - run: docker-compose -f docker-compose.yml down
  
  test_coverage:
    machine: 
      image: ubuntu-2004:current
    resource_class: large
    docker_layer_caching: true
    requires:
      - build
    # parallelism: 3
    steps:  
      - checkout
      - run: echo "Start tets coverage"
      - run: 
          name: "Start services ..."
          command: docker-compose -f docker-compose.yml up -d
    
      - run: 
          name: "Install composer ..."
          command: docker-compose -f docker-compose.yml exec app composer install

      - run: 
          name: "Running test coverage ..."
          command: docker-compose -f docker-compose.yml exec app php artisan make:test UserTest --unit
    
  test_php:
    machine: 
      image: ubuntu-2004:current
    resource_class: large
    docker_layer_caching: true
    requires:
      - build
    steps:  
      - checkout
      - run: echo "Start test php"
      - run: docker-compose -f docker-compose.yml up -d
      - run: docker-compose -f docker-compose.yml exec app composer install
      - run: docker-compose -f docker-compose.yml exec app php artisan make:test UserTest --unit
  
  production:
    machine: 
      image: ubuntu-2004:current
    resource_class: large
    docker_layer_caching: true
    requires:
      - build
    steps:  
      - checkout
      - run: echo "Production"
      - run: docker-compose -f docker-compose.yml up -d
      - run: docker-compose -f docker-compose.yml down

workflows:
  version: 2
  linting:
    jobs:
      - format_code

  build_and_test:
    jobs:
      - build
      - test_php:
          requires:
            - build

      - test_unit:
          requires:
            - build

      - test_coverage:
          requires:
            - build

      - test_database:
          requires:
            - build
          
  production:
    jobs:
      - test_php
      - test_unit
      - test_coverage
      - test_database
      - production:
          requires:
            - test_php
            - test_unit
            - test_coverage
            - test_database
          filters:
            branches:
              only: 
               - master

"@

Add-Content -Path ./.circleci/config.yml -Value $circleConfig

