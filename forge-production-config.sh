#!/bin/bash

# Configuration spécifique Laravel Forge pour corriger 403
set -e

echo "🔧 Configuration production Laravel Forge..."

# 1. Vérifier qu'on est sur Forge (document root)
if [ ! -f "/home/forge" ]; then
    echo "⚠️ Attention: pas sur Laravel Forge"
fi

# 2. Configuration .env pour PRODUCTION
echo "Setting production environment..."
if [ -f ".env" ]; then
    # Backup
    cp .env .env.backup.$(date +%s)
    
    # Corrections critiques
    sed -i 's/APP_ENV=local/APP_ENV=production/' .env
    sed -i 's/APP_DEBUG=true/APP_DEBUG=false/' .env
    
    echo "✓ Environment configuré en production"
else
    echo "❌ Fichier .env manquant!"
fi

# 3. Permissions Laravel Forge standard
echo "Setting Forge permissions..."
chmod -R 755 .
chmod -R 775 storage bootstrap/cache
chmod 644 .env
chmod 644 public/index.php
chmod 644 public/.htaccess

# 4. Ownership Forge (si on a les droits)
chown -R forge:forge . 2>/dev/null || echo "⚠️ Cannot set ownership (normal if not root)"

# 5. Document Root - Vérification
echo "📁 Document Root should be: $(pwd)/public"
echo "🔍 Verify in Forge Panel: Sites > your-site > Document Root"

# 6. Clear caches avec la nouvelle config
php artisan config:clear
php artisan cache:clear
php artisan route:clear

# 7. Re-cache en production
php artisan config:cache

echo "✅ Configuration Forge terminée"
echo ""
echo "🔧 Actions manuelles requises dans Forge Panel:"
echo "   1. Sites > Votre Site > Document Root → $(pwd)/public"
echo "   2. Sites > SSL → Activer SSL"
echo "   3. Sites > Nginx Config → Vérifier configuration"