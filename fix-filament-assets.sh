#!/bin/bash

# Fix Filament avec assets et upgrade
set -e

echo "🎨 FIX FILAMENT - Assets & Upgrade"
echo "================================="

# 1. Filament assets
echo "=== FILAMENT ASSETS ==="
php artisan filament:assets || echo "Assets command failed"

# 2. Filament upgrade
echo "=== FILAMENT UPGRADE ==="
php artisan filament:upgrade || echo "Upgrade command failed"

# 3. Clear caches après upgrade
echo "=== CLEAR CACHES ==="
php artisan cache:clear
php artisan config:clear
php artisan view:clear
php artisan route:clear

# 4. Publier vues Filament
echo "=== PUBLISH VIEWS ==="
php artisan vendor:publish --tag=filament-panels-views --force
php artisan vendor:publish --tag=filament-forms-views --force

# 5. Build assets
echo "=== BUILD ASSETS ==="
npm install --production=false --legacy-peer-deps || echo "NPM install failed"
npm run build || echo "Build failed"

# 6. Permissions
chmod -R 755 public/
chmod -R 775 storage bootstrap/cache

# 7. Cache config final
php artisan config:cache

echo ""
echo "✅ FILAMENT ASSETS & UPGRADE TERMINÉ"
echo "===================================="
echo ""
echo "🧪 TEST:"
echo "   https://krinetattoo.on-forge.com/admin"
echo ""
echo "🔑 LOGIN:"
echo "   Email: admin@krinetattoo.com"
echo "   Password: KrineTattoo2024!"