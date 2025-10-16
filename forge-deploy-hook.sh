#!/bin/bash

cd $FORGE_SITE_PATH

echo "=== FORGE DEPLOYMENT START ==="

# Standard Laravel Forge deployment
git pull origin main
$FORGE_COMPOSER install --no-interaction --prefer-dist --optimize-autoloader

# CRITICAL: Ensure image directories exist and copy images
echo "Setting up image assets..."
mkdir -p public/assets/images
mkdir -p storage/app/public/assets/images

# Copy image from repository root to public (primary location)
if [ -f "artiste.png" ]; then
    cp artiste.png public/assets/images/artiste.png
    echo "✓ Image copied to public/assets/images/"
else
    echo "⚠ Warning: artiste.png not found in repository root"
fi

# Also copy to storage (backup location)
if [ -f "public/assets/images/artiste.png" ]; then
    cp public/assets/images/artiste.png storage/app/public/assets/images/artiste.png
    echo "✓ Image copied to storage backup location"
fi

# Ensure storage link exists
if [ ! -L "public/storage" ]; then
    $FORGE_PHP artisan storage:link
    echo "✓ Storage link created"
else
    echo "✓ Storage link already exists"
fi

# Set correct permissions BEFORE clearing cache
echo "Setting permissions..."
chmod -R 755 public/assets/ 2>/dev/null || true
chmod -R 755 storage/app/public/assets/ 2>/dev/null || true
chmod 644 public/assets/images/* 2>/dev/null || true
chmod 644 storage/app/public/assets/images/* 2>/dev/null || true

# Clear all caches
echo "Clearing caches..."
$FORGE_PHP artisan config:clear
$FORGE_PHP artisan cache:clear
$FORGE_PHP artisan view:clear
$FORGE_PHP artisan route:clear

# Optimize for production
echo "Optimizing for production..."
$FORGE_PHP artisan config:cache
$FORGE_PHP artisan route:cache
$FORGE_PHP artisan view:cache

# Verify image exists
echo "Verifying image deployment..."
if [ -f "public/assets/images/artiste.png" ]; then
    echo "✓ Image successfully deployed to public/assets/images/"
    ls -la public/assets/images/artiste.png
else
    echo "✗ Image NOT found in public/assets/images/"
fi

if [ -f "storage/app/public/assets/images/artiste.png" ]; then
    echo "✓ Backup image exists in storage/"
else
    echo "✗ Backup image NOT found in storage/"
fi

echo "=== FORGE DEPLOYMENT COMPLETED ==="