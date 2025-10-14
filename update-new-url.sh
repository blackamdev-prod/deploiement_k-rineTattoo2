#!/bin/bash

# Mise à jour pour nouvelle URL krinetattoo.on-forge.com
echo "🔄 Mise à jour URL vers krinetattoo.on-forge.com"

# 1. Mettre à jour .env
if [ -f ".env" ]; then
    sed -i.bak 's|APP_URL=.*|APP_URL=https://krinetattoo.on-forge.com|' .env
    echo "✅ APP_URL mis à jour"
fi

# 2. Clear cache pour nouvelle URL
php artisan config:clear
php artisan cache:clear
php artisan config:cache

echo "✅ Configuration mise à jour pour krinetattoo.on-forge.com"
echo ""
echo "🧪 NOUVEAUX TESTS:"
echo "   https://krinetattoo.on-forge.com/step1-php.php"
echo "   https://krinetattoo.on-forge.com/admin"