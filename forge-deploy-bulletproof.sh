#!/bin/bash

# Script de déploiement ultra-minimal et sans échec pour Laravel Forge
# Version bulletproof - uniquement l'essentiel

set -e

echo "🚀 Déploiement minimal bulletproof..."

# 0. Configuration production (FIX 403)
if [ -f ".env" ]; then
    sed -i 's/APP_ENV=local/APP_ENV=production/' .env || true
    sed -i 's/APP_DEBUG=true/APP_DEBUG=false/' .env || true
    sed -i 's|APP_URL=.*|APP_URL=https://deploiement_krinetattoo-pobc9vdh.on-forge.com|' .env || true
fi

# 1. Code
git pull origin main

# 2. Dependencies
composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# 3. Clear caches (avec gestion d'erreur) + vues compilées
php artisan cache:clear || true
php artisan config:clear || true
php artisan route:clear || true
php artisan view:clear || true
rm -rf storage/framework/views/* || true

# 4. Build assets
npm install --production=false --legacy-peer-deps
npm run build

# 5. Database
php artisan migrate --force

# 5.1 Fix Filament après migration (PRODUCTION SAFE)
rm -rf bootstrap/cache/routes*.php || true
php artisan filament:install --panels --force || true
php artisan vendor:publish --tag=filament-panels-views --force || true

# 5.2 IMPORTANT: Cache seulement config, PAS routes ni vues
php artisan config:cache
# ÉVITER: php artisan route:cache et view:cache (problème avec Filament)

# 6. Storage et Permissions (FIX 403 + "No input file specified")
php artisan storage:link --force || true
chmod -R 755 . || true
chmod -R 775 storage bootstrap/cache || true
chmod 755 public || true
chmod 644 public/index.php || true
chmod 644 public/.htaccess || true
chown -R forge:forge . || true

# 6.1 Vérifier que index.php existe et n'est pas vide
if [ ! -f "public/index.php" ] || [ ! -s "public/index.php" ]; then
    echo "⚠️ CRITICAL: public/index.php missing or empty - recreating..."
    git checkout HEAD -- public/index.php || echo "Git restore failed"
fi

# 7. Logo (simple)
mkdir -p public/images
[ -f "logo.png" ] && cp logo.png public/images/ || true

echo "✅ Déploiement terminé"
echo ""
echo "🔗 Site: https://deploiement_krinetattoo-pobc9vdh.on-forge.com"
echo "🔗 Admin: https://deploiement_krinetattoo-pobc9vdh.on-forge.com/admin"
echo "📧 Email: admin@krinetattoo.com"
echo "🔑 Password: KrineTattoo2024!"
echo ""
echo "⚠️ SI 403 PERSISTE, exécuter: ./fix-403-final-ultimate.sh"