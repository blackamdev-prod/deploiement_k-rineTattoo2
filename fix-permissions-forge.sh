#!/bin/bash

# Fix permissions complet pour Laravel Forge
set -e

echo "🔒 FIX PERMISSIONS LARAVEL FORGE"
echo "================================"

# 1. Permissions dossiers critiques
echo "=== PERMISSIONS STORAGE & CACHE ==="
chmod -R 775 storage
chmod -R 775 bootstrap/cache
echo "✅ Storage et cache: 775"

# 2. Permissions générales
echo "=== PERMISSIONS GÉNÉRALES ==="
chmod -R 755 .
chmod 644 .env 2>/dev/null || echo ".env not found"
chmod 644 composer.json
chmod 644 package.json
echo "✅ Permissions générales: 755"

# 3. Permissions public/
echo "=== PERMISSIONS PUBLIC ==="
chmod 755 public
chmod 644 public/index.php
chmod 644 public/.htaccess 2>/dev/null || echo ".htaccess not found"
chmod -R 644 public/*.php 2>/dev/null || true
chmod -R 755 public/build/ 2>/dev/null || true
echo "✅ Public directory: OK"

# 4. Ownership Forge (si possible)
echo "=== OWNERSHIP FORGE ==="
chown -R forge:forge . 2>/dev/null && echo "✅ Ownership: forge:forge" || echo "⚠️ Cannot set ownership (normal if not root)"

# 5. Permissions spécifiques Filament
echo "=== PERMISSIONS FILAMENT ==="
chmod -R 775 storage/app/
chmod -R 775 storage/framework/
chmod -R 775 storage/logs/
chmod -R 755 resources/views/ 2>/dev/null || true
echo "✅ Filament directories: OK"

# 6. Clear storage caches
echo "=== CLEAR STORAGE CACHES ==="
rm -rf storage/framework/cache/* 2>/dev/null || true
rm -rf storage/framework/sessions/* 2>/dev/null || true
rm -rf storage/framework/views/* 2>/dev/null || true
echo "✅ Storage caches cleared"

# 7. Artisan commands avec nouvelles permissions
echo "=== ARTISAN COMMANDS ==="
php artisan cache:clear || true
php artisan config:clear || true
php artisan view:clear || true
php artisan storage:link --force || true

# 8. Vérification finale
echo "=== VÉRIFICATION PERMISSIONS ==="
echo "Storage: $(ls -ld storage | awk '{print $1}')"
echo "Bootstrap/cache: $(ls -ld bootstrap/cache | awk '{print $1}')"
echo "Public: $(ls -ld public | awk '{print $1}')"
echo "Index.php: $(ls -l public/index.php | awk '{print $1}')"

echo ""
echo "✅ PERMISSIONS FORGE APPLIQUÉES"
echo "==============================="
echo ""
echo "🧪 TEST MAINTENANT:"
echo "   https://krinetattoo.on-forge.com/admin"
echo ""
echo "⚠️ Les permissions 775 sur storage et cache sont critiques pour Filament"