#!/bin/bash

# Fix dashboard Filament qui n'apparaît pas après connexion
set -e

echo "🔧 FIX Dashboard Filament après connexion..."

# 1. Créer une page dashboard simple qui fonctionne
echo "=== CRÉATION DASHBOARD SIMPLE ==="
mkdir -p app/Filament/Pages

cat > app/Filament/Pages/SimpleDashboard.php << 'DASHBOARD_EOF'
<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;

class SimpleDashboard extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-home';
    protected static string $view = 'filament.pages.simple-dashboard';
    protected static ?string $navigationLabel = 'Dashboard';
    protected static ?string $title = 'Dashboard';
    
    public function mount(): void
    {
        // Forcer l'authentification
        if (!auth()->check()) {
            redirect()->route('filament.admin.auth.login');
        }
    }
    
    protected function getViewData(): array
    {
        return [
            'user' => auth()->user(),
            'users_count' => \App\Models\User::count(),
            'portfolios_count' => \App\Models\Portfolio::count(),
        ];
    }
}
DASHBOARD_EOF

# 2. Créer la vue dashboard
mkdir -p resources/views/filament/pages
cat > resources/views/filament/pages/simple-dashboard.blade.php << 'VIEW_EOF'
<x-filament-panels::page>
    <div class="grid gap-6 mb-8 md:grid-cols-2">
        <!-- User Info -->
        <div class="p-6 bg-white rounded-lg shadow-sm">
            <h3 class="text-lg font-medium text-gray-900 mb-4">👋 Bienvenue</h3>
            <div class="space-y-2">
                <p><strong>Nom:</strong> {{ $user->name }}</p>
                <p><strong>Email:</strong> {{ $user->email }}</p>
                <p><strong>Connecté:</strong> ✅ Oui</p>
            </div>
        </div>

        <!-- Stats -->
        <div class="p-6 bg-white rounded-lg shadow-sm">
            <h3 class="text-lg font-medium text-gray-900 mb-4">📊 Statistiques</h3>
            <div class="space-y-2">
                <p><strong>Utilisateurs:</strong> {{ $users_count }}</p>
                <p><strong>Portfolio:</strong> {{ $portfolios_count }}</p>
                <p><strong>Site:</strong> <a href="{{ config('app.url') }}" target="_blank" class="text-blue-600">Voir le site</a></p>
            </div>
        </div>
    </div>

    <!-- Status -->
    <div class="p-6 bg-green-50 rounded-lg">
        <h3 class="text-lg font-medium text-green-800 mb-2">✅ Dashboard Filament fonctionne!</h3>
        <p class="text-green-700">
            Vous êtes connecté avec succès au panel admin de K'rine Tattoo.
        </p>
        
        @if(request()->getHost() !== 'deploiement_krinetattoo-pobc9vdh.on-forge.com')
            <div class="mt-4 p-4 bg-yellow-50 rounded border-l-4 border-yellow-400">
                <p class="text-yellow-800">
                    <strong>Note:</strong> Pour une expérience optimale, configurez le Document Root 
                    vers le dossier <code>/public</code> dans Laravel Forge.
                </p>
            </div>
        @endif
    </div>
</x-filament-panels::page>
VIEW_EOF

# 3. Modifier AdminPanelProvider pour utiliser notre dashboard
if [ -f "app/Providers/Filament/AdminPanelProvider.php" ]; then
    # Backup
    cp app/Providers/Filament/AdminPanelProvider.php app/Providers/Filament/AdminPanelProvider.php.backup
    
    # Remplacer Dashboard::class par notre SimpleDashboard
    sed -i.bak 's/Dashboard::class/\\App\\Filament\\Pages\\SimpleDashboard::class/' app/Providers/Filament/AdminPanelProvider.php
    echo "✅ AdminPanelProvider modifié pour utiliser SimpleDashboard"
fi

# 4. Créer route de redirection après login
echo -e "\n=== ROUTE REDIRECTION ==="
if ! grep -q "filament-dashboard-redirect" routes/web.php 2>/dev/null; then
    echo "" >> routes/web.php
    echo "// Filament dashboard redirect" >> routes/web.php
    echo "Route::get('/admin/dashboard', function() {" >> routes/web.php
    echo "    if (auth()->check()) {" >> routes/web.php
    echo "        return redirect('/admin');" >> routes/web.php
    echo "    }" >> routes/web.php
    echo "    return redirect('/admin/login');" >> routes/web.php
    echo "})->name('filament-dashboard-redirect');" >> routes/web.php
    echo "✅ Route redirection ajoutée"
fi

# 5. Clear cache
php artisan cache:clear || true
php artisan config:clear || true
php artisan view:clear || true
php artisan route:clear || true

# 6. Recache config
php artisan config:cache || true

echo -e "\n✅ FIX DASHBOARD FILAMENT TERMINÉ"
echo "================================="
echo ""
echo "🔗 Test connexion: https://deploiement_krinetattoo-pobc9vdh.on-forge.com/admin"
echo "📧 Email: admin@krinetattoo.com"
echo "🔑 Password: KrineTattoo2024!"
echo ""
echo "📋 CHANGEMENTS:"
echo "   - Dashboard simple créé (SimpleDashboard)"
echo "   - Vue personnalisée avec infos utilisateur"
echo "   - Redirection après login configurée"
echo "   - Affichage stats (users, portfolio)"
echo ""
echo "⚠️ Le dashboard devrait maintenant s'afficher après connexion"