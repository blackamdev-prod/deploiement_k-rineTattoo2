#!/bin/bash

# Fix pour l'erreur "Target class [config] does not exist"
# Problème de binding Laravel identifié

cd /home/forge/ktattoo.on-forge.com/current

echo "=== FIX CONFIG BINDING ERROR ==="
echo "Date: $(date)"
echo ""

# 1. Vérifier le problème de bootstrap/providers
echo "1. === VERIFICATION PROVIDERS ==="
echo "Contenu actuel de bootstrap/providers.php:"
cat bootstrap/providers.php
echo ""

# 2. Sauvegarder et corriger bootstrap/providers.php
echo "2. === CORRECTION PROVIDERS ==="
cp bootstrap/providers.php bootstrap/providers.php.backup

# Créer un providers.php minimal et fonctionnel
cat > bootstrap/providers.php << 'EOFPROVIDERS'
<?php

return [
    App\Providers\AppServiceProvider::class,
];
EOFPROVIDERS

echo "✅ Providers.php réinitialisé avec AppServiceProvider uniquement"
echo ""

# 3. Supprimer TOUS les caches
echo "3. === SUPPRESSION CACHES COMPLETS ==="
rm -rf bootstrap/cache/*
rm -rf storage/framework/cache/data/*
rm -rf storage/framework/views/*
rm -rf storage/framework/sessions/*
echo "✅ Tous les caches supprimés"
echo ""

# 4. Test Laravel de base
echo "4. === TEST LARAVEL BASE ==="
php artisan --version || echo "❌ Laravel de base ne fonctionne pas"
echo ""

# 5. Si Laravel de base fonctionne, tester config
echo "5. === TEST CONFIG ==="
cat > test-config.php << 'EOFTEST'
<?php
try {
    require_once __DIR__.'/vendor/autoload.php';
    $app = require_once __DIR__.'/bootstrap/app.php';
    
    echo "Test accès config...\n";
    $config = $app->make('config');
    echo "✅ Config accessible\n";
    echo "APP_NAME: " . $config->get('app.name', 'non défini') . "\n";
    
} catch (Exception $e) {
    echo "❌ Erreur config: " . $e->getMessage() . "\n";
}
EOFTEST

php test-config.php
rm -f test-config.php
echo ""

# 6. Régénération autoload propre
echo "6. === REGENERATION AUTOLOAD ==="
composer dump-autoload --no-scripts
echo "✅ Autoload régénéré sans scripts"
echo ""

# 7. Test Laravel après correction
echo "7. === TEST APRES CORRECTION ==="
php artisan --version
echo ""

# 8. Si ça fonctionne, réinstaller Filament proprement
echo "8. === REINSTALLATION FILAMENT ==="
echo "Ajout du provider Filament..."
cat > bootstrap/providers.php << 'EOFPROVIDERS2'
<?php

return [
    App\Providers\AppServiceProvider::class,
    App\Providers\Filament\AdminPanelProvider::class,
];
EOFPROVIDERS2

echo "✅ Provider Filament rajouté"
echo ""

# 9. Test avec Filament
echo "9. === TEST AVEC FILAMENT ==="
php artisan --version || echo "❌ Erreur avec provider Filament"

# Si erreur avec Filament, le retirer temporairement
if [ $? -ne 0 ]; then
    echo "⚠️ Erreur avec Filament, restoration providers minimal"
    cat > bootstrap/providers.php << 'EOFPROVIDERS3'
<?php

return [
    App\Providers\AppServiceProvider::class,
];
EOFPROVIDERS3
fi
echo ""

# 10. Test final HTTP
echo "10. === TEST HTTP FINAL ==="
cat > test-http-final.php << 'EOFHTTPFINAL'
<?php
try {
    require_once __DIR__.'/vendor/autoload.php';
    $app = require_once __DIR__.'/bootstrap/app.php';
    $kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);
    
    $request = Illuminate\Http\Request::create('/', 'GET');
    $response = $kernel->handle($request);
    
    echo "Status page d'accueil: " . $response->getStatusCode() . "\n";
    
    if ($response->getStatusCode() === 200) {
        echo "✅ Application Laravel fonctionne\n";
        
        // Test page admin seulement si Laravel fonctionne
        $adminRequest = Illuminate\Http\Request::create('/admin', 'GET');
        $adminResponse = $kernel->handle($adminRequest);
        echo "Status page admin: " . $adminResponse->getStatusCode() . "\n";
        
    } else {
        echo "❌ Application Laravel ne fonctionne pas\n";
    }
    
} catch (Exception $e) {
    echo "❌ Erreur: " . $e->getMessage() . "\n";
}
EOFHTTPFINAL

php test-http-final.php
rm -f test-http-final.php
echo ""

# 11. Instructions finales
echo "11. === RESULTATS ET INSTRUCTIONS ==="
echo "Si Laravel fonctionne maintenant:"
echo "1. Testez https://ktattoo.on-forge.com/"
echo "2. Si la page d'accueil fonctionne, le problème était les providers"
echo "3. Pour réinstaller Filament proprement:"
echo "   php artisan filament:install --panels"
echo "   php artisan make:filament-panel admin"
echo ""
echo "Si le problème persiste:"
echo "1. Vérifiez le fichier .env pour les variables manquantes"
echo "2. Redémarrez PHP-FPM: sudo service php8.4-fpm restart"
echo "3. Vérifiez les permissions: chmod -R 775 storage bootstrap/cache"

echo "=== FIN FIX CONFIG BINDING ==="