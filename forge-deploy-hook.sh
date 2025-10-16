#!/bin/bash

cd $FORGE_SITE_PATH

# Standard Laravel Forge deployment
git pull origin main
$FORGE_COMPOSER install --no-interaction --prefer-dist --optimize-autoloader

# Custom: Copy images to public assets
echo "Copying assets..."
mkdir -p public/assets/images
if [ -f "artiste.png" ]; then
    cp artiste.png public/assets/images/
    echo "Image artiste.png copied to public/assets/images/"
fi

# Ensure storage link exists
if [ ! -L "public/storage" ]; then
    $FORGE_PHP artisan storage:link
fi

# Clear all caches
$FORGE_PHP artisan config:clear
$FORGE_PHP artisan cache:clear
$FORGE_PHP artisan view:clear
$FORGE_PHP artisan route:clear

# Optimize for production
$FORGE_PHP artisan config:cache
$FORGE_PHP artisan route:cache
$FORGE_PHP artisan view:cache

# Set correct permissions
chmod -R 755 public/assets/
chmod 644 public/assets/images/* 2>/dev/null || true

echo "Deployment completed successfully!"