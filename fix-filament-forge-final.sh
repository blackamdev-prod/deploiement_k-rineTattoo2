#!/bin/bash

# Fix final pour Filament sur Laravel Forge
set -e

echo "🔧 FIX FINAL - Filament sur Laravel Forge"
echo "========================================"

# 1. Test étapes pour identifier où ça bloque
echo "=== TESTS DIAGNOSTICS ==="
echo "Test 1: https://deploiement_krinetattoo-pobc9vdh.on-forge.com/step1-php.php"
echo "Test 2: https://deploiement_krinetattoo-pobc9vdh.on-forge.com/admin"
echo ""
echo "Continuez seulement si Test 1 affiche 'PHP WORKS'"

# 2. Configuration Filament spécifique Forge
echo "=== CONFIGURATION FILAMENT FORGE ==="

# Simplifier AdminPanelProvider au maximum
cat > app/Providers/Filament/AdminPanelProvider.php << 'PROVIDER_EOF'
<?php

namespace App\Providers\Filament;

use Filament\Http\Middleware\Authenticate;
use Filament\Http\Middleware\DisableBladeIconComponents;
use Filament\Http\Middleware\DispatchServingFilamentEvent;
use Filament\Pages\Dashboard;
use Filament\Panel;
use Filament\PanelProvider;
use Filament\Support\Colors\Color;
use Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse;
use Illuminate\Cookie\Middleware\EncryptCookies;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Routing\Middleware\SubstituteBindings;
use Illuminate\Session\Middleware\StartSession;
use Illuminate\View\Middleware\ShareErrorsFromSession;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->default()
            ->id('admin')
            ->path('admin')
            ->login()
            ->colors(['primary' => Color::Blue])
            ->brandName('K\'rine Tattoo')
            ->pages([Dashboard::class])
            ->middleware([
                EncryptCookies::class,
                AddQueuedCookiesToResponse::class,
                StartSession::class,
                ShareErrorsFromSession::class,
                VerifyCsrfToken::class,
                SubstituteBindings::class,
                DisableBladeIconComponents::class,
                DispatchServingFilamentEvent::class,
            ])
            ->authMiddleware([Authenticate::class]);
    }
}
PROVIDER_EOF

# 3. Créer route test simple pour admin
echo "=== ROUTE TEST ADMIN ==="
if ! grep -q "admin-simple-test" routes/web.php 2>/dev/null; then
    echo "" >> routes/web.php
    echo "Route::get('/admin-simple-test', function() {" >> routes/web.php
    echo "    return 'ADMIN ROUTE WORKS - Filament should work';" >> routes/web.php
    echo "});" >> routes/web.php
fi

# 4. Configuration .env optimale pour Forge
echo "=== CONFIGURATION ENV ==="
if [ -f ".env" ]; then
    sed -i.bak 's/APP_ENV=.*/APP_ENV=production/' .env
    sed -i.bak 's/APP_DEBUG=.*/APP_DEBUG=false/' .env
    sed -i.bak 's|APP_URL=.*|APP_URL=https://deploiement_krinetattoo-pobc9vdh.on-forge.com|' .env
    
    # Session driver file (plus stable sur Forge)
    sed -i.bak 's/SESSION_DRIVER=.*/SESSION_DRIVER=file/' .env
    
    echo "✅ Environment optimisé pour Forge"
fi

# 5. Clear TOUT et optimiser pour Forge
echo "=== CACHE FORGE OPTIMISÉ ==="
rm -rf storage/framework/cache/* 2>/dev/null || true
rm -rf storage/framework/sessions/* 2>/dev/null || true
rm -rf storage/framework/views/* 2>/dev/null || true
rm -rf bootstrap/cache/* 2>/dev/null || true

php artisan cache:clear || true
php artisan config:clear || true
php artisan route:clear || true
php artisan view:clear || true

# 6. Permissions optimales Forge
chmod -R 755 . || true
chmod -R 775 storage bootstrap/cache || true
chmod 644 .env || true
chown -R forge:forge . 2>/dev/null || true

# 7. Composer optimisé
composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev || true

# 8. Cache seulement config (pas routes/views pour éviter erreurs Filament)
php artisan config:cache || true

# 9. Vérifier user admin
echo "=== VÉRIFICATION ADMIN ==="
php artisan tinker --execute="
\$admin = App\Models\User::firstOrCreate(
    ['email' => 'admin@krinetattoo.com'],
    [
        'name' => 'Admin K\'rine Tattoo',
        'password' => Hash::make('KrineTattoo2024!'),
        'email_verified_at' => now()
    ]
);
echo 'Admin ready: ' . \$admin->email;
" || echo "Admin check failed"

echo ""
echo "✅ FIX FILAMENT FORGE TERMINÉ"
echo "============================"
echo ""
echo "🧪 TESTS DANS L'ORDRE:"
echo "1. https://deploiement_krinetattoo-pobc9vdh.on-forge.com/step1-php.php"
echo "   → Doit afficher: PHP WORKS"
echo ""
echo "2. https://deploiement_krinetattoo-pobc9vdh.on-forge.com/admin-simple-test" 
echo "   → Doit afficher: ADMIN ROUTE WORKS"
echo ""
echo "3. https://deploiement_krinetattoo-pobc9vdh.on-forge.com/admin"
echo "   → Doit afficher: Login Filament"
echo ""
echo "🔑 LOGIN:"
echo "   Email: admin@krinetattoo.com"
echo "   Password: KrineTattoo2024!"
echo ""
echo "⚠️ Si étapes 1 ou 2 échouent → Problème serveur/Document Root"
echo "⚠️ Si étape 3 échoue → Problème spécifique Filament"