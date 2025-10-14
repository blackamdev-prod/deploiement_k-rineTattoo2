#!/bin/bash

# Fix des chemins Forge pour K'rine Tattoo
# Corrige le problème de chemins /releases vs /current

echo "=== FIX CHEMINS FORGE ==="
echo "Date: $(date)"
echo ""

# 1. Vérifier les liens symboliques Forge
echo "1. === VERIFICATION LIENS SYMBOLIQUES ==="
echo "Lien current:"
ls -la /home/forge/ktattoo.on-forge.com/current
echo ""
echo "Répertoires releases:"
ls -la /home/forge/ktattoo.on-forge.com/releases/ | tail -3
echo ""

# 2. Aller dans le bon répertoire
cd /home/forge/ktattoo.on-forge.com/current
echo "Répertoire de travail: $(pwd)"
echo ""

# 3. Vérifier et corriger les chemins dans les fichiers de cache
echo "2. === CORRECTION CHEMINS CACHE ==="

# Supprimer les caches qui contiennent les mauvais chemins
rm -rf bootstrap/cache/*
rm -rf storage/framework/cache/data/*
rm -rf storage/framework/views/*

echo "✅ Caches avec mauvais chemins supprimés"
echo ""

# 4. Regenerer l'autoload avec le bon chemin
echo "3. === REGENERATION AUTOLOAD DEPUIS CURRENT ==="
composer dump-autoload --optimize --no-dev
echo "✅ Autoload régénéré depuis /current"
echo ""

# 5. Restaurer la configuration production
echo "4. === RESTAURATION PRODUCTION ==="
if [ -f .env.backup.* ]; then
    # Trouver le backup le plus récent
    latest_backup=$(ls -t .env.backup.* | head -1)
    cp "$latest_backup" .env
    echo "✅ Configuration production restaurée depuis $latest_backup"
else
    # Configuration manuelle si pas de backup
    sed -i 's/APP_DEBUG=true/APP_DEBUG=false/' .env
    sed -i 's/APP_ENV=local/APP_ENV=production/' .env
    echo "✅ Configuration production restaurée manuellement"
fi
echo ""

# 6. Nettoyer et optimiser depuis le bon répertoire
echo "5. === OPTIMISATION DEPUIS CURRENT ==="
php artisan config:cache
php artisan route:cache
php artisan view:cache
echo "✅ Optimisations appliquées depuis /current"
echo ""

# 7. Test final depuis le bon répertoire
echo "6. === TEST FINAL ==="
echo "Version Laravel:"
php artisan --version
echo ""

echo "Test route admin:"
php artisan route:list | grep admin
echo ""

# 8. Test HTTP direct
echo "Test HTTP direct:"
cat > test-final.php << 'EOFINAL'
<?php
try {
    require_once __DIR__.'/vendor/autoload.php';
    $app = require_once __DIR__.'/bootstrap/app.php';
    $kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);
    
    $request = Illuminate\Http\Request::create('/admin', 'GET', [], [], [], [
        'HTTPS' => 'on',
        'SERVER_NAME' => 'ktattoo.on-forge.com',
        'REQUEST_URI' => '/admin',
        'HTTP_HOST' => 'ktattoo.on-forge.com'
    ]);
    
    $response = $kernel->handle($request);
    echo "Status Code: " . $response->getStatusCode() . "\n";
    
    if ($response->getStatusCode() === 302) {
        echo "✅ Redirection vers login (normal)\n";
        echo "Location: " . $response->headers->get('Location') . "\n";
    } elseif ($response->getStatusCode() === 200) {
        echo "✅ Page chargée avec succès\n";
    } else {
        echo "❌ Erreur: " . $response->getStatusCode() . "\n";
        echo substr($response->getContent(), 0, 500) . "\n";
    }
    
} catch (Exception $e) {
    echo "❌ Exception: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . ":" . $e->getLine() . "\n";
}
EOFINAL

php test-final.php
rm -f test-final.php
echo ""

# 9. Instructions finales
echo "7. === INSTRUCTIONS FINALES ==="
echo "Si le problème persiste:"
echo "1. Dans Forge, aller dans Site > Meta"
echo "2. Vérifier que 'Quick Deploy' est activé"
echo "3. Cliquer sur 'Deploy Now' pour forcer un nouveau déploiement"
echo "4. Ou redémarrer les services:"
echo "   sudo service php8.4-fpm restart"
echo "   sudo service nginx restart"
echo ""

echo "URL à tester: https://ktattoo.on-forge.com/admin"
echo "Email: admin@krinetattoo.com"
echo "Password: password123"

echo "=== FIN FIX CHEMINS FORGE ==="