#!/bin/bash

# Script de diagnostic 500 SERVER ERROR pour K'rine Tattoo
# Utiliser sur le serveur Forge pour diagnostiquer l'erreur 500

cd $FORGE_SITE_PATH

echo "=== DIAGNOSTIC 500 SERVER ERROR ==="
echo "Heure: $(date)"
echo "Répertoire: $(pwd)"
echo ""

# 1. Vérifier les logs Laravel
echo "1. === LOGS LARAVEL ==="
if [ -f "storage/logs/laravel.log" ]; then
    echo "Dernières erreurs Laravel:"
    tail -50 storage/logs/laravel.log | grep -A 5 -B 5 ERROR || echo "Aucune erreur récente dans laravel.log"
else
    echo "Fichier laravel.log introuvable"
fi
echo ""

# 2. Vérifier les logs d'erreur Apache/Nginx
echo "2. === LOGS SERVEUR WEB ==="
echo "Logs d'erreur récents (si accessibles):"
# Forge utilise généralement ces chemins
for log_path in "/var/log/nginx/error.log" "/var/log/apache2/error.log" "/home/forge/.forge/nginx_errors.log"; do
    if [ -f "$log_path" ]; then
        echo "--- $log_path ---"
        tail -20 "$log_path" | grep "$(date '+%Y/%m/%d')" | tail -5 || echo "Aucune erreur récente"
    fi
done
echo ""

# 3. Test direct PHP
echo "3. === TEST PHP DIRECT ==="
echo "Test d'inclusion des fichiers critiques:"

# Test bootstrap
if php -r "try { require_once 'bootstrap/app.php'; echo 'Bootstrap OK\n'; } catch (Exception \$e) { echo 'Bootstrap ERROR: ' . \$e->getMessage() . '\n'; }"  2>&1; then
    echo "✅ Bootstrap fonctionne"
else
    echo "❌ Erreur Bootstrap"
fi

# Test Artisan
echo "Test Artisan:"
if php artisan --version 2>&1; then
    echo "✅ Artisan fonctionne"
else
    echo "❌ Erreur Artisan"
fi
echo ""

# 4. Vérifier les permissions
echo "4. === PERMISSIONS ==="
echo "Permissions des répertoires critiques:"
ls -la storage/ bootstrap/cache/ public/ | head -10
echo ""

# 5. Vérifier la configuration
echo "5. === CONFIGURATION ==="
echo "Variables d'environnement critiques:"
grep -E "(APP_KEY|APP_ENV|APP_DEBUG|SESSION_DRIVER|APP_URL)" .env || echo "Variables manquantes"
echo ""

# 6. Test de la route admin
echo "6. === TEST ROUTE ADMIN ==="
echo "Routes admin disponibles:"
php artisan route:list | grep admin || echo "Aucune route admin trouvée"
echo ""

# 7. Test des providers
echo "7. === PROVIDERS ==="
echo "Providers enregistrés:"
cat bootstrap/providers.php
echo ""

# 8. Test Filament spécifique
echo "8. === TEST FILAMENT ==="
echo "Fichiers Filament:"
ls -la app/Providers/Filament/ 2>/dev/null || echo "Pas de répertoire Filament"
echo ""

echo "Assets Filament:"
ls -la public/js/filament/ public/css/filament/ 2>/dev/null | head -5 || echo "Pas d'assets Filament"
echo ""

# 9. Test de création d'une page de test
echo "9. === CREATION PAGE TEST ==="
cat > test-debug.php << 'EOF'
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "=== TEST DEBUG ===\n";
echo "PHP Version: " . phpversion() . "\n";
echo "Memory Limit: " . ini_get('memory_limit') . "\n";
echo "Working Directory: " . getcwd() . "\n";

try {
    echo "Test 1: Autoload...\n";
    require_once __DIR__.'/vendor/autoload.php';
    echo "✅ Autoload OK\n";

    echo "Test 2: Bootstrap...\n";
    $app = require_once __DIR__.'/bootstrap/app.php';
    echo "✅ Bootstrap OK\n";

    echo "Test 3: Kernel...\n";
    $kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);
    echo "✅ Kernel OK\n";

    echo "Test 4: Request...\n";
    $request = Illuminate\Http\Request::capture();
    echo "✅ Request OK\n";
    echo "URL: " . $request->url() . "\n";
    
    echo "Test 5: Response admin...\n";
    $request = Illuminate\Http\Request::create('/admin', 'GET');
    $response = $kernel->handle($request);
    echo "✅ Response admin: " . $response->getStatusCode() . "\n";
    
} catch (Exception $e) {
    echo "❌ ERREUR: " . $e->getMessage() . "\n";
    echo "Fichier: " . $e->getFile() . ":" . $e->getLine() . "\n";
    echo "Trace:\n" . $e->getTraceAsString() . "\n";
} catch (Error $e) {
    echo "❌ ERROR: " . $e->getMessage() . "\n";
    echo "Fichier: " . $e->getFile() . ":" . $e->getLine() . "\n";
}

echo "=== FIN TEST DEBUG ===\n";
EOF

echo "Exécution du test debug:"
php test-debug.php 2>&1
rm -f test-debug.php
echo ""

# 10. Test URL direct
echo "10. === TEST URL DIRECT ==="
echo "Test de l'URL admin avec curl:"
curl -v -s -L "https://ktattoo.on-forge.com/admin" 2>&1 | head -20
echo ""

echo "=== FIN DIAGNOSTIC ==="
echo "Analyser les résultats ci-dessus pour identifier la cause de l'erreur 500"