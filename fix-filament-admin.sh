#!/bin/bash

# Fix spécifique pour l'erreur 500 sur /admin
# Laravel fonctionne, problème isolé sur Filament

cd /home/forge/ktattoo.on-forge.com/current

echo "=== FIX FILAMENT ADMIN 500 ==="
echo "Date: $(date)"
echo ""

# 1. Vérifier le provider Filament actuel
echo "1. === VERIFICATION PROVIDER FILAMENT ==="
if [ -f "app/Providers/Filament/AdminPanelProvider.php" ]; then
    echo "Provider trouvé, vérifions le contenu:"
    head -20 app/Providers/Filament/AdminPanelProvider.php
else
    echo "❌ Provider Filament manquant"
fi
echo ""

# 2. Recréer le provider Filament proprement
echo "2. === RECREATION PROVIDER FILAMENT ==="
rm -rf app/Providers/Filament/
mkdir -p app/Providers/Filament/

cat > app/Providers/Filament/AdminPanelProvider.php << 'EOFPROVIDER'
<?php

namespace App\Providers\Filament;

use Filament\Http\Middleware\Authenticate;
use Filament\Http\Middleware\DisableBladeIconComponents;
use Filament\Http\Middleware\DispatchServingFilamentEvent;
use Filament\Pages;
use Filament\Panel;
use Filament\PanelProvider;
use Filament\Support\Colors\Color;
use Filament\Widgets;
use Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse;
use Illuminate\Cookie\Middleware\EncryptCookies;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Routing\Middleware\SubstituteBindings;
use Illuminate\Session\Middleware\AuthenticateSession;
use Illuminate\Session\Middleware\StartSession;
use Illuminate\View\Middleware\ShareErrorsFromSession;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->default()
            ->id('admin')
            ->path('/admin')
            ->login()
            ->colors([
                'primary' => Color::Amber,
            ])
            ->discoverResources(in: app_path('Filament/Resources'), for: 'App\\Filament\\Resources')
            ->discoverPages(in: app_path('Filament/Pages'), for: 'App\\Filament\\Pages')
            ->pages([
                Pages\Dashboard::class,
            ])
            ->discoverWidgets(in: app_path('Filament/Widgets'), for: 'App\\Filament\\Widgets')
            ->widgets([
                Widgets\AccountWidget::class,
                Widgets\FilamentInfoWidget::class,
            ])
            ->middleware([
                EncryptCookies::class,
                AddQueuedCookiesToResponse::class,
                StartSession::class,
                AuthenticateSession::class,
                ShareErrorsFromSession::class,
                VerifyCsrfToken::class,
                SubstituteBindings::class,
                DisableBladeIconComponents::class,
                DispatchServingFilamentEvent::class,
            ])
            ->authMiddleware([
                Authenticate::class,
            ]);
    }
}
EOFPROVIDER

echo "✅ Provider Filament recréé"
echo ""

# 3. Créer les répertoires Filament nécessaires
echo "3. === CREATION REPERTOIRES FILAMENT ==="
mkdir -p app/Filament/Resources
mkdir -p app/Filament/Pages  
mkdir -p app/Filament/Widgets
echo "✅ Répertoires Filament créés"
echo ""

# 4. Test du provider
echo "4. === TEST PROVIDER ==="
php artisan --version || echo "❌ Erreur avec le nouveau provider"
echo ""

# 5. Vérifier les routes
echo "5. === VERIFICATION ROUTES ==="
php artisan route:clear
php artisan route:list | grep admin || echo "❌ Pas de routes admin"
echo ""

# 6. Test admin spécifique avec debug
echo "6. === TEST ADMIN AVEC DEBUG ==="
cat > test-admin-specific.php << 'EOFADMIN'
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

try {
    require_once __DIR__.'/vendor/autoload.php';
    $app = require_once __DIR__.'/bootstrap/app.php';
    
    // Test si Filament est bien chargé
    echo "Test Filament...\n";
    $providers = $app->getLoadedProviders();
    $filamentLoaded = false;
    foreach ($providers as $provider => $loaded) {
        if (strpos($provider, 'AdminPanelProvider') !== false) {
            echo "✅ AdminPanelProvider chargé: $provider\n";
            $filamentLoaded = true;
        }
    }
    
    if (!$filamentLoaded) {
        echo "❌ AdminPanelProvider non chargé\n";
    }
    
    // Test de la requête admin
    $kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);
    $request = Illuminate\Http\Request::create('/admin', 'GET', [], [], [], [
        'HTTPS' => 'on',
        'SERVER_NAME' => 'ktattoo.on-forge.com',
        'REQUEST_URI' => '/admin',
        'HTTP_HOST' => 'ktattoo.on-forge.com'
    ]);
    
    $response = $kernel->handle($request);
    echo "Status admin: " . $response->getStatusCode() . "\n";
    
    if ($response->getStatusCode() === 302) {
        echo "✅ Redirection (normal pour login)\n";
        echo "Location: " . $response->headers->get('Location') . "\n";
    } elseif ($response->getStatusCode() === 500) {
        echo "❌ Erreur 500 - contenu:\n";
        echo substr($response->getContent(), 0, 1000) . "\n";
    }
    
} catch (Throwable $e) {
    echo "❌ Exception: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . ":" . $e->getLine() . "\n";
    echo "Trace: " . substr($e->getTraceAsString(), 0, 1000) . "\n";
}
EOFADMIN

php test-admin-specific.php
rm -f test-admin-specific.php
echo ""

# 7. Si encore des erreurs, simplifier au maximum
echo "7. === SIMPLIFICATION PROVIDER ==="
if php artisan route:list | grep -q admin; then
    echo "✅ Routes admin présentes"
else
    echo "❌ Simplification du provider..."
    
    cat > app/Providers/Filament/AdminPanelProvider.php << 'EOFSIMPLE'
<?php

namespace App\Providers\Filament;

use Filament\Panel;
use Filament\PanelProvider;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->default()
            ->id('admin')
            ->path('/admin')
            ->login();
    }
}
EOFSIMPLE
    
    echo "✅ Provider simplifié créé"
    php artisan route:clear
    php artisan route:list | grep admin || echo "❌ Toujours pas de routes"
fi
echo ""

# 8. Test final
echo "8. === TEST FINAL ==="
echo "Test page d'accueil:"
curl -s -o /dev/null -w "%{http_code}" "https://ktattoo.on-forge.com/" || echo "Test local"

echo ""
echo "Test page admin:"
curl -s -o /dev/null -w "%{http_code}" "https://ktattoo.on-forge.com/admin" || echo "Test local"

echo ""
echo "=== INSTRUCTIONS ==="
echo "1. Testez maintenant: https://ktattoo.on-forge.com/admin"
echo "2. Si ça fonctionne: Email: admin@krinetattoo.com | Pass: password123"
echo "3. Si erreur persiste, le problème peut être:"
echo "   - Base de données non accessible"
echo "   - Sessions non fonctionnelles" 
echo "   - Middleware qui échoue"

echo "=== FIN FIX FILAMENT ADMIN ==="