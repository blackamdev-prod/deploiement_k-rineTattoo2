#!/bin/bash

# Fix immédiat pour l'erreur 500 - K'rine Tattoo
# Exécuter directement sur le serveur Forge

cd $FORGE_SITE_PATH

echo "=== FIX IMMEDIAT 500 ERROR ==="
echo "Répertoire: $(pwd)"
echo ""

# 1. Vérifier le répertoire de travail
echo "1. === VERIFICATION REPERTOIRE ==="
if [ -f "artisan" ]; then
    echo "✅ Dans le bon répertoire Laravel"
else
    echo "❌ Mauvais répertoire - recherche du bon chemin..."
    cd /home/forge/ktattoo.on-forge.com/current 2>/dev/null || cd /home/forge/ktattoo.on-forge.com
    echo "Nouveau répertoire: $(pwd)"
fi
echo ""

# 2. Correction du cache config en mode debug
echo "2. === NETTOYAGE CACHE COMPLET ==="
php artisan config:clear 2>/dev/null || echo "config:clear failed"
php artisan cache:clear 2>/dev/null || echo "cache:clear failed"
php artisan route:clear 2>/dev/null || echo "route:clear failed"
php artisan view:clear 2>/dev/null || echo "view:clear failed"
php artisan event:clear 2>/dev/null || echo "event:clear failed"

# Supprimer manuellement tous les caches
rm -rf bootstrap/cache/config.php
rm -rf bootstrap/cache/routes-v7.php
rm -rf bootstrap/cache/services.php
rm -rf bootstrap/cache/packages.php
rm -rf storage/framework/cache/data/*
rm -rf storage/framework/views/*
rm -rf storage/framework/sessions/*
echo "✅ Caches supprimés manuellement"
echo ""

# 3. Activer le debug temporairement
echo "3. === ACTIVATION DEBUG TEMPORAIRE ==="
cp .env .env.backup.$(date +%s)
sed -i 's/APP_DEBUG=false/APP_DEBUG=true/' .env
sed -i 's/APP_ENV=production/APP_ENV=local/' .env
echo "✅ Debug activé temporairement"
echo ""

# 4. Régénération de l'autoload
echo "4. === REGENERATION AUTOLOAD ==="
composer dump-autoload --optimize 2>/dev/null
echo "✅ Autoload régénéré"
echo ""

# 5. Test Laravel en mode debug
echo "5. === TEST LARAVEL DEBUG ==="
php artisan --version || echo "❌ Laravel non fonctionnel"
echo ""

# 6. Test de la page admin avec debug
echo "6. === TEST PAGE ADMIN DEBUG ==="
cat > test-admin-debug.php << 'EOFTEST'
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

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
    
    echo "Status: " . $response->getStatusCode() . "\n";
    if ($response->getStatusCode() !== 200) {
        echo "Content: " . substr($response->getContent(), 0, 1000) . "\n";
    }
    
} catch (Exception $e) {
    echo "Exception: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . ":" . $e->getLine() . "\n";
    echo "Trace: " . $e->getTraceAsString() . "\n";
} catch (Error $e) {
    echo "Error: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . ":" . $e->getLine() . "\n";
    echo "Trace: " . $e->getTraceAsString() . "\n";
}
EOFTEST

php test-admin-debug.php 2>&1
rm -f test-admin-debug.php
echo ""

# 7. Vérifier les logs d'erreur Laravel
echo "7. === VERIFICATION LOGS ==="
if [ -f "storage/logs/laravel.log" ]; then
    echo "Dernières 10 lignes du log Laravel:"
    tail -10 storage/logs/laravel.log
else
    echo "Pas de fichier de log Laravel"
fi
echo ""

# 8. Correction des permissions
echo "8. === CORRECTION PERMISSIONS ==="
chown -R forge:forge storage bootstrap/cache 2>/dev/null || echo "Correction permissions avec sudo requise"
chmod -R 775 storage bootstrap/cache
echo "✅ Permissions corrigées"
echo ""

# 9. Test final avec debug
echo "9. === TEST FINAL ==="
curl -s -H "Host: ktattoo.on-forge.com" "http://localhost/admin" | head -20
echo ""

# 10. Instructions pour continuer
echo "10. === INSTRUCTIONS ==="
echo "Si l'erreur persiste:"
echo "1. Vérifiez les logs nginx: sudo tail -f /var/log/nginx/error.log"
echo "2. Vérifiez les logs PHP: sudo tail -f /var/log/php8.4-fpm.log"
echo "3. Redémarrez PHP-FPM: sudo service php8.4-fpm restart"
echo "4. Redémarrez Nginx: sudo service nginx restart"
echo ""
echo "Pour restaurer la production:"
echo "mv .env.backup.* .env"

echo "=== FIN FIX IMMEDIAT ==="