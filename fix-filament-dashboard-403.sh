#!/bin/bash

# Fix 403 FORBIDDEN sur dashboard Filament après login
set -e

echo "🎯 FIX 403 FORBIDDEN - Dashboard Filament"
echo "========================================"

# 1. Diagnostic utilisateur admin
echo "=== VÉRIFICATION USER ADMIN ==="
php artisan tinker --execute="
\$admin = App\Models\User::where('email', 'admin@krinetattoo.com')->first();
if (\$admin) {
    echo 'Admin ID: ' . \$admin->id;
    echo 'Admin Email: ' . \$admin->email;
    echo 'Admin Name: ' . \$admin->name;
    echo 'Email Verified: ' . (\$admin->email_verified_at ? 'YES' : 'NO');
} else {
    echo 'Admin user: NOT FOUND';
    \$admin = App\Models\User::create([
        'name' => 'Admin K\'rine Tattoo',
        'email' => 'admin@krinetattoo.com',
        'password' => Hash::make('KrineTattoo2024!'),
        'email_verified_at' => now(),
    ]);
    echo 'Admin user created: ' . \$admin->id;
}
" || echo "Admin check failed"

# 2. Vérifier les resources Filament
echo -e "\n=== FILAMENT RESOURCES ==="
ls -la app/Filament/Resources/ 2>/dev/null || echo "No Filament resources directory"
ls -la app/Filament/Pages/ 2>/dev/null || echo "No Filament pages directory"

# 3. Simplifier le AdminPanelProvider
echo -e "\n=== SIMPLIFICATION ADMINPANELPROVIDER ==="
if [ -f "app/Providers/Filament/AdminPanelProvider.php" ]; then
    # Backup
    cp app/Providers/Filament/AdminPanelProvider.php app/Providers/Filament/AdminPanelProvider.php.backup
    
    # Version simplifiée sans resources/pages qui peuvent causer 403
    cat > app/Providers/Filament/AdminPanelProvider.php << 'PROVIDER_EOF'
<?php

namespace App\Providers\Filament;

use Filament\Http\Middleware\Authenticate;
use Filament\Http\Middleware\AuthenticateSession;
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
            ->colors([
                'primary' => Color::Blue,
            ])
            ->brandName('K\'rine Tattoo - Admin')
            ->pages([
                Dashboard::class,
            ])
            ->widgets([
                AccountWidget::class,
                FilamentInfoWidget::class,
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
PROVIDER_EOF
    echo "✅ AdminPanelProvider simplifié"
fi

# 4. Clear caches Filament
echo -e "\n=== CLEAR CACHES FILAMENT ==="
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Supprimer cache compilé
rm -rf storage/framework/cache/* 2>/dev/null || true
rm -rf storage/framework/views/* 2>/dev/null || true
rm -rf bootstrap/cache/* 2>/dev/null || true

# 5. Recréer config cache
php artisan config:cache

# 6. Créer page de test dashboard simple
echo -e "\n=== PAGE TEST DASHBOARD ==="
mkdir -p app/Filament/Pages
cat > app/Filament/Pages/TestDashboard.php << 'TEST_PAGE_EOF'
<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;

class TestDashboard extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-home';
    protected static string $view = 'filament.pages.test-dashboard';
    protected static ?string $title = 'Test Dashboard';
    
    public static function getNavigationLabel(): string
    {
        return 'Test Dashboard';
    }
}
TEST_PAGE_EOF

# 7. Créer vue test dashboard
mkdir -p resources/views/filament/pages
cat > resources/views/filament/pages/test-dashboard.blade.php << 'TEST_VIEW_EOF'
<x-filament-panels::page>
    <div class="space-y-6">
        <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-xl font-semibold mb-4">✅ Dashboard Filament fonctionne!</h2>
            <p class="text-gray-600">Si vous voyez cette page, le problème 403 est résolu.</p>
            
            <div class="mt-4 space-y-2">
                <p><strong>Utilisateur:</strong> {{ auth()->user()->name }}</p>
                <p><strong>Email:</strong> {{ auth()->user()->email }}</p>
                <p><strong>ID:</strong> {{ auth()->user()->id }}</p>
            </div>
        </div>
    </div>
</x-filament-panels::page>
TEST_VIEW_EOF

# 8. Permissions finales
chmod -R 755 app/Filament/
chmod -R 755 resources/views/filament/

echo -e "\n✅ FIX DASHBOARD FILAMENT 403 TERMINÉ"
echo "===================================="
echo ""
echo "🔗 Test: https://deploiement_krinetattoo-pobc9vdh.on-forge.com/admin"
echo "📧 Login: admin@krinetattoo.com"
echo "🔑 Password: KrineTattoo2024!"
echo ""
echo "📋 CHANGEMENTS:"
echo "   - AdminPanelProvider simplifié (sans resources problématiques)"
echo "   - Page de test dashboard ajoutée"
echo "   - Cache Filament nettoyé"
echo ""
echo "⚠️ Le dashboard devrait maintenant être accessible après login"