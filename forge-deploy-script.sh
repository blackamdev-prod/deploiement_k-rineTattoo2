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

# Publication des assets Filament
php artisan filament:assets

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

# Nettoyage avant optimisations
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Optimisations
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Permissions finales
chmod -R 775 storage bootstrap/cache
chmod -R 775 public

echo "✅ Déploiement Filament réussi - ktattoo.on-forge.com/admin/login fonctionnel"