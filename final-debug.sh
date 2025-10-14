#!/bin/bash

# Diagnostic final pour identifier l'erreur 500 exacte
# Script ultime pour K'rine Tattoo

cd /home/forge/ktattoo.on-forge.com/current

echo "=== DIAGNOSTIC FINAL 500 ERROR ==="
echo "Date: $(date)"
echo "Répertoire: $(pwd)"
echo ""

# 1. Activation debug complet
echo "1. === ACTIVATION DEBUG COMPLET ==="
cp .env .env.production.backup
sed -i 's/APP_DEBUG=false/APP_DEBUG=true/' .env
sed -i 's/APP_ENV=production/APP_ENV=local/' .env
echo "LOG_LEVEL=debug" >> .env
echo "✅ Debug activé"
echo ""

# 2. Vider TOUS les logs pour avoir du propre
echo "2. === NETTOYAGE LOGS ==="
> storage/logs/laravel.log
echo "✅ Logs Laravel vidés"
echo ""

# 3. Test avec capture d'erreur complète
echo "3. === TEST AVEC CAPTURE ERREUR ==="
cat > capture-error.php << 'EOFCAPTURE'
<?php
// Activation complète des erreurs
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/storage/logs/php-errors.log');

echo "=== CAPTURE ERREUR COMPLETE ===\n";
echo "PHP Version: " . phpversion() . "\n";
echo "Memory: " . ini_get('memory_limit') . "\n";
echo "Max execution: " . ini_get('max_execution_time') . "\n";
echo "Working dir: " . getcwd() . "\n\n";

try {
    echo "1. Chargement autoload...\n";
    require_once __DIR__.'/vendor/autoload.php';
    echo "   ✅ Autoload OK\n";

    echo "2. Chargement bootstrap...\n";
    $app = require_once __DIR__.'/bootstrap/app.php';
    echo "   ✅ Bootstrap OK\n";

    echo "3. Création kernel...\n";
    $kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);
    echo "   ✅ Kernel OK\n";

    echo "4. Test configuration...\n";
    $config = $app->make('config');
    echo "   APP_NAME: " . $config->get('app.name') . "\n";
    echo "   APP_ENV: " . $config->get('app.env') . "\n";
    echo "   APP_DEBUG: " . ($config->get('app.debug') ? 'true' : 'false') . "\n";
    echo "   ✅ Config OK\n";

    echo "5. Test database...\n";
    try {
        $db = $app->make('db');
        $db->connection()->getPdo();
        echo "   ✅ Database OK\n";
    } catch (Exception $e) {
        echo "   ⚠️ Database ERROR: " . $e->getMessage() . "\n";
    }

    echo "6. Test providers...\n";
    $providers = $app->getLoadedProviders();
    echo "   Providers chargés: " . count($providers) . "\n";
    foreach ($providers as $provider => $loaded) {
        if (strpos($provider, 'Filament') !== false) {
            echo "   - " . $provider . " (" . ($loaded ? 'loaded' : 'not loaded') . ")\n";
        }
    }

    echo "7. Création requête admin...\n";
    $request = Illuminate\Http\Request::create('/admin', 'GET', [], [], [], [
        'HTTPS' => 'on',
        'SERVER_NAME' => 'ktattoo.on-forge.com',
        'REQUEST_URI' => '/admin',
        'HTTP_HOST' => 'ktattoo.on-forge.com',
        'REQUEST_METHOD' => 'GET'
    ]);
    echo "   ✅ Request créée\n";

    echo "8. Traitement requête...\n";
    ob_start();
    $response = $kernel->handle($request);
    $output = ob_get_clean();
    
    echo "   Status: " . $response->getStatusCode() . "\n";
    echo "   Headers: " . json_encode($response->headers->all()) . "\n";
    
    if ($response->getStatusCode() === 500) {
        echo "   Content (premiers 2000 chars):\n";
        echo "   " . str_replace("\n", "\n   ", substr($response->getContent(), 0, 2000)) . "\n";
    }
    
    if ($output) {
        echo "   Output buffer: " . $output . "\n";
    }

} catch (Throwable $e) {
    echo "\n❌ ERREUR FATALE:\n";
    echo "Message: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . ":" . $e->getLine() . "\n";
    echo "Type: " . get_class($e) . "\n";
    echo "\nStack trace:\n";
    echo $e->getTraceAsString() . "\n";
    
    if ($e->getPrevious()) {
        echo "\nPrevious exception:\n";
        echo "Message: " . $e->getPrevious()->getMessage() . "\n";
        echo "File: " . $e->getPrevious()->getFile() . ":" . $e->getPrevious()->getLine() . "\n";
    }
}

echo "\n=== FIN CAPTURE ===\n";
EOFCAPTURE

php capture-error.php 2>&1
rm -f capture-error.php
echo ""

# 4. Vérifier les logs générés
echo "4. === VERIFICATION LOGS ==="
echo "Laravel log (dernières 20 lignes):"
if [ -f "storage/logs/laravel.log" ]; then
    tail -20 storage/logs/laravel.log
else
    echo "Pas de log Laravel généré"
fi
echo ""

echo "PHP errors log:"
if [ -f "storage/logs/php-errors.log" ]; then
    cat storage/logs/php-errors.log
    rm -f storage/logs/php-errors.log
else
    echo "Pas d'erreur PHP capturée"
fi
echo ""

# 5. Vérifier les logs système
echo "5. === LOGS SYSTEME ==="
echo "Nginx error log (dernières 10 lignes):"
sudo tail -10 /var/log/nginx/error.log 2>/dev/null || echo "Nginx log non accessible"
echo ""

echo "PHP-FPM log (dernières 10 lignes):"
sudo tail -10 /var/log/php8.4-fpm.log 2>/dev/null || echo "PHP-FPM log non accessible"
echo ""

# 6. Test avec curl direct
echo "6. === TEST CURL DIRECT ==="
curl -v -H "Host: ktattoo.on-forge.com" -H "User-Agent: Mozilla/5.0" "http://localhost/admin" 2>&1 | head -30
echo ""

# 7. Vérifier la configuration Nginx
echo "7. === CONFIGURATION NGINX ==="
echo "Sites Nginx disponibles:"
ls -la /etc/nginx/sites-available/ | grep ktattoo 2>/dev/null || echo "Pas de config ktattoo trouvée"
echo ""

# 8. Restaurer production et donner instructions
echo "8. === RESTAURATION PRODUCTION ==="
cp .env.production.backup .env
echo "✅ Production restaurée"
echo ""

echo "=== INSTRUCTIONS FINALES ==="
echo "1. Si l'erreur est identifiée ci-dessus, nous pouvons la corriger"
echo "2. Sinon, essayez de redémarrer les services:"
echo "   sudo service php8.4-fpm restart"
echo "   sudo service nginx restart"
echo "3. Vérifiez dans Forge > Sites > ktattoo.on-forge.com > Meta"
echo "   que le répertoire racine pointe vers /public"
echo ""

echo "=== FIN DIAGNOSTIC FINAL ==="