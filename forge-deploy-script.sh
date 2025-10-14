#!/bin/bash

# Script de déploiement Laravel Forge pour K'rine Tattoo
# Copier ce contenu dans Deploy Script de Laravel Forge

cd $FORGE_SITE_PATH

# Git pull
git pull origin $FORGE_SITE_BRANCH

# Nettoyage des caches pour éviter 500 errors
rm -rf bootstrap/cache/* storage/framework/cache/* storage/framework/views/*

# Installation des dépendances
composer install --no-dev --optimize-autoloader

# Découverte des packages
php artisan package:discover --ansi

# Vérification APP_KEY
if ! grep -q "APP_KEY=base64:" .env; then
    php artisan key:generate --force
fi

# Configuration pour éviter erreurs 500 sur /admin/login
# Forcer SESSION_DRIVER=file
sed -i "s/SESSION_DRIVER=.*/SESSION_DRIVER=file/" .env
if ! grep -q "SESSION_DRIVER=" .env; then
    echo "SESSION_DRIVER=file" >> .env
fi

# Configurer APP_URL pour ktattoo.on-forge.com
sed -i "s|APP_URL=.*|APP_URL=https://ktattoo.on-forge.com|" .env
if ! grep -q "APP_URL=" .env; then
    echo "APP_URL=https://ktattoo.on-forge.com" >> .env
fi

# Forcer production
sed -i "s/APP_ENV=.*/APP_ENV=production/" .env
sed -i "s/APP_DEBUG=.*/APP_DEBUG=false/" .env

# Créer répertoires sessions
mkdir -p storage/framework/sessions
chmod -R 775 storage/framework/sessions

# Migrations
php artisan migrate --force

# Installation Filament si pas encore fait
if ! composer show | grep -q "filament/filament"; then
    composer require filament/filament:"^3.0" --no-interaction
fi

# Installation du Panel Filament
php artisan filament:install --panels --no-interaction 2>/dev/null || echo "Panel already installed"

# Création du panneau admin
php artisan make:filament-panel admin 2>/dev/null || echo "Admin panel already exists"

# Publication et configuration des assets Filament
php artisan filament:assets

# Configuration des routes Filament pour éviter 404
# S'assurer que le provider Filament est enregistré
if [ -f "app/Providers/Filament/AdminPanelProvider.php" ]; then
    echo "Filament AdminPanelProvider found"
else
    echo "Creating default AdminPanelProvider"
    mkdir -p app/Providers/Filament
    cat > app/Providers/Filament/AdminPanelProvider.php << 'EOF'
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
EOF
fi

# S'assurer que le provider est enregistré dans bootstrap/providers.php
if ! grep -q "AdminPanelProvider" bootstrap/providers.php; then
    sed -i '/App\\Providers\\AppServiceProvider::class,/a\    App\\Providers\\Filament\\AdminPanelProvider::class,' bootstrap/providers.php
    echo "AdminPanelProvider added to bootstrap/providers.php"
fi

# Création utilisateur administrateur
php artisan tinker --execute='
$email = "admin@krinetattoo.com";
if (!App\Models\User::where("email", $email)->exists()) {
    $user = new App\Models\User();
    $user->name = "Admin";
    $user->email = $email;
    $user->email_verified_at = now();
    $user->password = Hash::make("password123");
    $user->save();
    echo "Admin user created\n";
} else {
    echo "Admin user already exists\n";
}'

# Vérification des routes Filament
echo "Vérification des routes Filament..."
php artisan route:list | grep -i filament || echo "Routes Filament en cours de configuration..."

# Nettoyage avant optimisations
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Forcer la découverte des routes
php artisan route:cache
php artisan route:clear

# Optimisations finales
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Test final des routes
echo "Test des routes après optimisation:"
php artisan route:list | grep admin || echo "ATTENTION: Routes admin non trouvées"

# Permissions finales
chmod -R 775 storage bootstrap/cache
chmod -R 775 public

echo "✅ Déploiement Filament réussi"
echo "🔗 Admin URL: https://ktattoo.on-forge.com/admin"
echo "📧 Email: admin@krinetattoo.com"
echo "🔑 Password: password123"

# Test final de la page admin
echo "Test final de l'URL admin..."
if curl -s -o /dev/null -w "%{http_code}" https://ktattoo.on-forge.com/admin | grep -q "200\|302"; then
    echo "✅ Page admin accessible"
else
    echo "⚠️  Vérifiez manuellement: https://ktattoo.on-forge.com/admin"
fi