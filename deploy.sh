#!/bin/bash
cd $FORGE_SITE_PATH

# Pull latest changes
git pull origin $FORGE_SITE_BRANCH

# Install Composer dependencies
$FORGE_COMPOSER install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# Clear caches
$FORGE_PHP artisan config:clear
$FORGE_PHP artisan cache:clear
$FORGE_PHP artisan route:clear
$FORGE_PHP artisan view:clear

# Fix npm/rollup issues and build assets
rm -rf node_modules package-lock.json
npm install --force
npm run build

# Ensure logo exists
mkdir -p public/images
if [ ! -f "public/images/logo.png" ]; then
    if [ -f "logo.png" ]; then
        cp logo.png public/images/logo.png
        echo "Logo copied from root to public/images/"
    else
        echo "Warning: Logo not found in repository"
    fi
else
    echo "Logo already exists in public/images/"
fi

# Run migrations
$FORGE_PHP artisan migrate --force

# Create storage link
$FORGE_PHP artisan storage:link

# Cache for production
$FORGE_PHP artisan config:cache
$FORGE_PHP artisan route:cache
$FORGE_PHP artisan view:cache

# Optimize application
$FORGE_PHP artisan optimize

# Restart queues
$FORGE_PHP artisan queue:restart

echo "Deployment completed successfully!"