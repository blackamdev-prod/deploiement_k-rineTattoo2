#!/bin/bash

# Fix middlewares Filament pour Laravel Forge
set -e

echo "🛡️ FIX MIDDLEWARES FILAMENT"
echo "==========================="

# 1. Simplifier les middlewares AdminPanelProvider
echo "=== SIMPLIFICATION MIDDLEWARES ==="

# Backup
cp app/Providers/Filament/AdminPanelProvider.php app/Providers/Filament/AdminPanelProvider.php.backup

# Version avec middlewares minimaux pour éviter conflits
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
use Filament\Widgets\AccountWidget;
use Filament\Widgets\FilamentInfoWidget;
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
            ->brandName('K\'rine Tattoo - Admin')
            ->pages([Dashboard::class])
            ->widgets([
                AccountWidget::class,
                FilamentInfoWidget::class,
            ])
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
            ->authMiddleware([
                Authenticate::class,
            ]);
    }
}
PROVIDER_EOF

echo "✅ Middlewares simplifiés (supprimé AuthenticateSession qui peut poser problème)"

# 2. Vérifier app/Http/Kernel.php pour middlewares globaux
echo -e "\n=== VÉRIFICATION KERNEL MIDDLEWARES ==="
if [ -f "app/Http/Kernel.php" ]; then
    echo "✅ Kernel.php exists"
    # Vérifier s'il y a des middlewares problématiques
    grep -n "middleware" app/Http/Kernel.php | head -5 || echo "Middleware check completed"
else
    echo "⚠️ Kernel.php not found (Laravel 11+ utilise bootstrap/app.php)"
fi

# 3. Créer route de test sans middleware
echo -e "\n=== ROUTE TEST SANS MIDDLEWARE ==="
if ! grep -q "admin-no-middleware" routes/web.php 2>/dev/null; then
    echo "" >> routes/web.php
    echo "// Test route admin sans middleware" >> routes/web.php
    echo "Route::get('/admin-no-middleware', function() {" >> routes/web.php
    echo "    return 'ADMIN ACCESSIBLE SANS MIDDLEWARE - ' . now();" >> routes/web.php
    echo "})->withoutMiddleware();" >> routes/web.php
    echo "✅ Route test sans middleware ajoutée"
fi

# 4. Configuration session pour Forge
echo -e "\n=== CONFIGURATION SESSION ==="
if [ -f ".env" ]; then
    # Session driver file plus stable sur Forge
    sed -i.bak 's/SESSION_DRIVER=.*/SESSION_DRIVER=file/' .env
    sed -i.bak 's/SESSION_LIFETIME=.*/SESSION_LIFETIME=120/' .env
    echo "✅ Session driver configuré pour Forge"
fi

# 5. Clear caches middlewares
echo -e "\n=== CLEAR CACHES MIDDLEWARES ==="
php artisan route:clear
php artisan cache:clear
php artisan config:clear

# Recache config
php artisan config:cache

echo ""
echo "✅ MIDDLEWARES FILAMENT CORRIGÉS"
echo "==============================="
echo ""
echo "🧪 TESTS MIDDLEWARES:"
echo "1. https://krinetattoo.on-forge.com/admin-no-middleware"
echo "   → Doit afficher: ADMIN ACCESSIBLE SANS MIDDLEWARE"
echo ""
echo "2. https://krinetattoo.on-forge.com/admin"
echo "   → Login Filament (si étape 1 marche)"
echo ""
echo "📋 CHANGEMENTS MIDDLEWARES:"
echo "   - Supprimé AuthenticateSession (problématique sur Forge)"
echo "   - Session driver = file (plus stable)"
echo "   - Route test sans middleware"
echo ""
echo "⚠️ Si route sans middleware marche mais /admin pas → Problème middlewares Filament"