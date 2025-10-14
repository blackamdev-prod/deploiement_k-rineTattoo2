#!/bin/bash

# Clear cache après correction AdminPanelProvider
set -e

echo "🔄 Clear cache Filament après correction..."

# Clear tous les caches
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Supprimer cache physique
rm -rf storage/framework/cache/* 2>/dev/null || true
rm -rf storage/framework/views/* 2>/dev/null || true
rm -rf bootstrap/cache/* 2>/dev/null || true

# Recache config
php artisan config:cache

echo "✅ Cache cleared - Dashboard Filament devrait fonctionner"
echo "🔗 Test: https://deploiement_krinetattoo-pobc9vdh.on-forge.com/admin"