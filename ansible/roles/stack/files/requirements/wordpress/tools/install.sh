#!/bin/bash

cd /var/www/html

if [ -d "wordpress/index.php" ]; then
  echo "✅ Wordpress already exists."
else
  echo "📦 Installing WordPress..."

  mkdir -p wordpress
  cd wordpress

  # Wait for DB to be reachable
  echo "⏳ Waiting for MariaDB to be ready..."
    sleep 10

  # Install wp-cli
  curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp

  # Download and configure WordPress
  wp core download --allow-root
  wp config create \
    --dbhost=$BDD_HOST \
    --dbname=$BDD_NAME \
    --dbuser=$BDD_USER \
    --dbpass=$BDD_USER_PASSWORD \
    --allow-root

  wp core install \
    --url=$WP_URL \
    --title="Inception - fbily" \
    --admin_user=$WP_ADMIN_USER \
    --admin_password=$WP_ADMIN_PASSWORD \
    --admin_email=$WP_ADMIN_MAIL \
    --skip-email \
    --allow-root

  wp user create \
    $WP_USER $WP_USER_MAIL \
    --user_pass=$WP_USER_PASSWORD \
    --role=author \
    --allow-root

  wp theme activate twentytwentyfour --allow-root

fi

exec php-fpm8.2 -F
