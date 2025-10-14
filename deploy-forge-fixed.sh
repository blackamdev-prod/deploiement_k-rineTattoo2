#!/bin/bash

cd $FORGE_SITE_PATH

# Git pull
git pull origin $FORGE_SITE_BRANCH

# Installation des dépendances (sans scripts problématiques)
composer install --no-dev --optimize-autoloader --no-scripts

# Exécution manuelle des scripts nécessaires (sans Filament)
php artisan package:discover --ansi

# Migrations (si nécessaire)
if [ -f "database/migrations" ]; then
    php artisan migrate --force
fi

# Optimisations
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Permissions
chmod -R 775 storage bootstrap/cache

echo "✅ Déploiement réussi sans erreur Filament"
