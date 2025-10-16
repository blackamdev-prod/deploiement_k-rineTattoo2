#!/bin/bash

# Script de déploiement pour Laravel Forge
# Assure la copie des assets et images

echo "=== DEPLOYMENT SCRIPT FOR FORGE ==="

# 1. Copier les images vers le dossier public
echo "Copying images to public/assets/images..."
mkdir -p public/assets/images
cp artiste.png public/assets/images/ 2>/dev/null || echo "artiste.png not found in root"

# 2. Vérifier que le lien storage existe
echo "Checking storage link..."
if [ ! -L "public/storage" ]; then
    echo "Creating storage link..."
    php artisan storage:link
else
    echo "Storage link already exists"
fi

# 3. Vérifier les permissions
echo "Setting permissions..."
chmod 755 public/assets/images/
chmod 644 public/assets/images/artiste.png 2>/dev/null || echo "Image file not found"

# 4. Clear cache
echo "Clearing Laravel cache..."
php artisan config:clear
php artisan cache:clear
php artisan view:clear

echo "=== DEPLOYMENT COMPLETED ==="