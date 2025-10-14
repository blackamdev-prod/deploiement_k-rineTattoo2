#!/bin/bash

# Simple deployment script that avoids Filament caching issues
set -e

echo "Starting simple deployment..."

# Update application to latest
git pull origin main

# Install composer dependencies
composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# Clear all caches
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
rm -rf storage/framework/views/*

# Install and build assets
rm -rf node_modules package-lock.json
npm install --force
npm run build

# Ensure logo exists
mkdir -p public/images
if [ ! -f "public/images/logo.png" ] && [ -f "logo.png" ]; then
    cp logo.png public/images/logo.png
    echo "Logo copied to public/images/"
fi

# Run migrations
php artisan migrate --force

# Create storage link
php artisan storage:link

# Only cache config and routes - no views or optimization
php artisan config:cache
php artisan route:cache

# Set permissions
chmod -R 775 storage bootstrap/cache

echo "Simple deployment completed!"