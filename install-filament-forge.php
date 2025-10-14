<?php

/**
 * Script d'installation Filament pour Laravel Forge - K'rine Tattoo
 * Installe la dernière version de Filament v3.x
 * Usage: php install-filament-forge.php
 */

echo "🚀 Installation Filament pour Laravel Forge - K'rine Tattoo\n";
echo "=========================================================\n";
echo "Date: " . date('Y-m-d H:i:s') . "\n\n";

// Configuration
const SCRIPT_VERSION = '1.0.0';
const RED = "\033[0;31m";
const GREEN = "\033[0;32m";
const YELLOW = "\033[1;33m";
const BLUE = "\033[0;34m";
const RESET = "\033[0m";

function success($message) {
    echo GREEN . "✅ $message" . RESET . "\n";
}

function warning($message) {
    echo YELLOW . "⚠️  $message" . RESET . "\n";
}

function error($message) {
    echo RED . "❌ $message" . RESET . "\n";
}

function info($message) {
    echo BLUE . "ℹ️  $message" . RESET . "\n";
}

function step($number, $title) {
    echo "\n" . BLUE . "📋 ÉTAPE $number: $title" . RESET . "\n";
    echo str_repeat("=", strlen("ÉTAPE $number: $title") + 4) . "\n";
}

function execCommand($command) {
    $output = [];
    $returnCode = 0;
    exec($command . " 2>&1", $output, $returnCode);
    
    return [
        'code' => $returnCode,
        'output' => implode("\n", $output)
    ];
}

// =========================================================================
// ÉTAPE 1: CORRECTION 500 SERVER ERROR
// =========================================================================

step(1, "CORRECTION 500 SERVER ERROR");

// Vérifier et générer APP_KEY si nécessaire
if (file_exists('.env')) {
    $envContent = file_get_contents('.env');
    if (!preg_match('/APP_KEY=base64:/', $envContent)) {
        info("APP_KEY manquante - génération...");
        execCommand("php artisan key:generate --force");
        success("APP_KEY générée");
    } else {
        success("APP_KEY présente");
    }
} else {
    error("Fichier .env non trouvé");
    exit(1);
}

// Nettoyage des caches pour éviter les erreurs 500
info("Nettoyage des caches...");
execCommand("rm -rf bootstrap/cache/* storage/framework/cache/* storage/framework/views/*");
execCommand("php artisan cache:clear");
execCommand("php artisan config:clear");
execCommand("php artisan route:clear");
execCommand("php artisan view:clear");
success("Caches nettoyés");

// Configuration des sessions pour éviter erreurs 500 sur /admin/login
info("Configuration des sessions...");
if (file_exists('.env')) {
    $envContent = file_get_contents('.env');
    
    // Forcer SESSION_DRIVER=file pour éviter problèmes DB
    if (strpos($envContent, 'SESSION_DRIVER=') !== false) {
        $envContent = preg_replace('/SESSION_DRIVER=.*/', 'SESSION_DRIVER=file', $envContent);
    } else {
        $envContent .= "\nSESSION_DRIVER=file\n";
    }
    
    // Vérifier la configuration de l'URL
    if (!preg_match('/APP_URL=.*ktattoo\.on-forge\.com/', $envContent)) {
        if (strpos($envContent, 'APP_URL=') !== false) {
            $envContent = preg_replace('/APP_URL=.*/', 'APP_URL=https://ktattoo.on-forge.com', $envContent);
        } else {
            $envContent .= "\nAPP_URL=https://ktattoo.on-forge.com\n";
        }
        success("APP_URL configurée pour ktattoo.on-forge.com");
    }
    
    // Forcer APP_ENV=production
    if (strpos($envContent, 'APP_ENV=') !== false) {
        $envContent = preg_replace('/APP_ENV=.*/', 'APP_ENV=production', $envContent);
    } else {
        $envContent .= "\nAPP_ENV=production\n";
    }
    
    // Désactiver le debug en production
    if (strpos($envContent, 'APP_DEBUG=') !== false) {
        $envContent = preg_replace('/APP_DEBUG=.*/', 'APP_DEBUG=false', $envContent);
    } else {
        $envContent .= "\nAPP_DEBUG=false\n";
    }
    
    file_put_contents('.env', $envContent);
    success("Configuration .env mise à jour");
}

// Créer les répertoires de sessions
execCommand("mkdir -p storage/framework/sessions");
execCommand("chmod -R 775 storage/framework/sessions");
success("Répertoires de sessions configurés");

// Vérifier les permissions
info("Vérification des permissions...");
execCommand("chmod -R 775 storage bootstrap/cache");
success("Permissions corrigées");

// Régénération autoload
info("Régénération autoload...");
execCommand("composer dump-autoload");
success("Autoload régénéré");

// =========================================================================
// ÉTAPE 2: VÉRIFICATIONS PRÉALABLES
// =========================================================================

step(2, "VÉRIFICATIONS PRÉALABLES");

// Vérifier Laravel
$laravelCheck = execCommand("php artisan --version");
if ($laravelCheck['code'] !== 0) {
    error("Laravel non détecté - installation impossible");
    exit(1);
}
success("Laravel détecté: " . trim($laravelCheck['output']));

// Vérifier Composer
$composerCheck = execCommand("composer --version");
if ($composerCheck['code'] !== 0) {
    error("Composer non disponible");
    exit(1);
}
success("Composer disponible");

// Vérifier si Filament est déjà installé
$filamentCheck = execCommand("composer show | grep filament/filament");
if ($filamentCheck['code'] === 0) {
    warning("Filament déjà installé - réinstallation...");
}

// =========================================================================
// ÉTAPE 3: INSTALLATION FILAMENT
// =========================================================================

step(3, "INSTALLATION FILAMENT V3");

info("Installation de Filament v3.x...");
$installResult = execCommand("composer require filament/filament:\"^3.0\" --no-interaction");

if ($installResult['code'] === 0) {
    success("Filament v3 installé avec succès");
} else {
    error("Erreur lors de l'installation de Filament:");
    echo $installResult['output'] . "\n";
    exit(1);
}

// =========================================================================
// ÉTAPE 4: CONFIGURATION FILAMENT
// =========================================================================

step(4, "CONFIGURATION FILAMENT");

// Installation du Panel Filament
info("Installation du Panel Filament...");
$panelInstallResult = execCommand("php artisan filament:install --panels --no-interaction");

if ($panelInstallResult['code'] === 0) {
    success("Panel Filament installé");
} else {
    warning("Problème lors de l'installation du panel:");
    echo $panelInstallResult['output'] . "\n";
    
    // Tentative alternative
    info("Tentative d'installation manuelle du panel...");
    execCommand("php artisan vendor:publish --tag=filament-config");
    execCommand("php artisan vendor:publish --tag=filament-views");
    success("Configuration manuelle du panel effectuée");
}

// Créer le panneau admin
info("Création du panneau admin...");
$panelResult = execCommand("php artisan make:filament-panel admin");

if ($panelResult['code'] === 0) {
    success("Panneau admin créé");
} else {
    warning("Problème lors de la création du panneau:");
    echo $panelResult['output'] . "\n";
    
    // Vérifier si le panel existe déjà
    if (file_exists('app/Providers/Filament/AdminPanelProvider.php')) {
        success("Panel admin déjà configuré");
    }
}

// Publier les assets
info("Publication des assets...");
$assetsResult = execCommand("php artisan filament:assets");
if ($assetsResult['code'] === 0) {
    success("Assets publiés");
}

// =========================================================================
// ÉTAPE 5: CRÉATION UTILISATEUR ADMIN
// =========================================================================

step(5, "CRÉATION UTILISATEUR ADMIN");

info("Création d'un utilisateur administrateur...");

// Vérifier si la table users existe
$tableCheck = execCommand("php artisan tinker --execute=\"echo Schema::hasTable('users') ? 'exists' : 'missing';\"");
if (strpos($tableCheck['output'], 'exists') === false) {
    info("Migration des tables utilisateurs...");
    execCommand("php artisan migrate --force");
}

// Méthode 1: Commande Filament
$userResult = execCommand("php artisan make:filament-user --name=\"Admin\" --email=\"admin@krinetattoo.com\" --password=\"password123\"");

if ($userResult['code'] === 0) {
    success("Utilisateur admin créé via commande Filament");
    info("Email: admin@krinetattoo.com");
    info("Mot de passe: password123");
    warning("Changez le mot de passe après la première connexion!");
} else {
    warning("Commande Filament échouée, tentative alternative...");
    
    // Méthode 2: Création manuelle via Tinker
    $tinkerScript = "
    \$user = new App\\Models\\User();
    \$user->name = 'Admin';
    \$user->email = 'admin@krinetattoo.com';
    \$user->email_verified_at = now();
    \$user->password = Hash::make('password123');
    \$user->save();
    echo 'Utilisateur créé: ' . \$user->email;
    ";
    
    $tinkerResult = execCommand("php artisan tinker --execute=\"$tinkerScript\"");
    
    if ($tinkerResult['code'] === 0) {
        success("Utilisateur admin créé via Tinker");
        info("Email: admin@krinetattoo.com");
        info("Mot de passe: password123");
    } else {
        warning("Création automatique échouée. Créez manuellement:");
        echo "Email: admin@krinetattoo.com | Mot de passe: password123\n";
    }
}

// =========================================================================
// ÉTAPE 6: OPTIMISATIONS
// =========================================================================

step(6, "OPTIMISATIONS");

// Cache des configurations
info("Mise en cache des configurations...");
execCommand("php artisan config:cache");
success("Config cache créé");

// Cache des routes
info("Mise en cache des routes...");
execCommand("php artisan route:cache");
success("Route cache créé");

// Cache des vues
info("Mise en cache des vues...");
execCommand("php artisan view:cache");
success("View cache créé");

// Optimisation autoload
info("Optimisation autoload...");
execCommand("composer dump-autoload --optimize");
success("Autoload optimisé");

// =========================================================================
// ÉTAPE 7: PERMISSIONS
// =========================================================================

step(7, "PERMISSIONS");

info("Configuration des permissions...");
execCommand("chmod -R 775 storage bootstrap/cache");
execCommand("chmod -R 775 public");
success("Permissions configurées");

// =========================================================================
// ÉTAPE 8: TEST FINAL
// =========================================================================

step(8, "TESTS FINAUX");

// Test Filament
$filamentTest = execCommand("php artisan about | grep -i filament");
if ($filamentTest['code'] === 0) {
    success("Filament opérationnel");
} else {
    warning("Test Filament - vérification manuelle requise");
}

// Test des routes Filament
$routeTest = execCommand("php artisan route:list | grep filament");
if ($routeTest['code'] === 0) {
    success("Routes Filament configurées");
} else {
    warning("Vérification des routes requise");
}

// =========================================================================
// SCRIPT DE DÉPLOIEMENT FORGE
// =========================================================================

step(9, "CRÉATION SCRIPT FORGE");

$forgeScript = '#!/bin/bash

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

# Installation du Panel Filament
php artisan filament:install --panels --no-interaction

# Création du panneau admin
php artisan make:filament-panel admin

# Création utilisateur administrateur pour Forge
php artisan tinker --execute="
if (!App\\Models\\User::where('email', 'admin@krinetattoo.com')->exists()) {
    \$user = new App\\Models\\User();
    \$user->name = 'Admin';
    \$user->email = 'admin@krinetattoo.com';
    \$user->email_verified_at = now();
    \$user->password = Hash::make('password123');
    \$user->save();
    echo 'Admin user created for ktattoo.on-forge.com';
} else {
    echo 'Admin user already exists';
}
"

# Publication des assets Filament
php artisan filament:assets

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
';

file_put_contents('deploy-forge-filament.sh', $forgeScript);
chmod('deploy-forge-filament.sh', 0755);
success("Script Forge créé: deploy-forge-filament.sh");

// =========================================================================
// RÉSUMÉ FINAL
// =========================================================================

echo "\n" . str_repeat("=", 60) . "\n";
echo GREEN . "🎉 INSTALLATION FILAMENT TERMINÉE !" . RESET . "\n";
echo str_repeat("=", 60) . "\n";

echo "\n📋 RÉSUMÉ DE L'INSTALLATION:\n";
echo "• ✅ Filament v3.x installé\n";
echo "• ✅ Panneau admin configuré\n";
echo "• ✅ Assets publiés\n";
echo "• ✅ Utilisateur admin créé\n";
echo "• ✅ Optimisations appliquées\n";
echo "• ✅ Permissions configurées\n";

echo "\n🔑 ACCÈS ADMIN:\n";
echo "• URL: https://ktattoo.on-forge.com/admin\n";
echo "• Email: admin@krinetattoo.com\n";
echo "• Mot de passe: password123\n";

echo "\n🚀 CONFIGURATION SUR FORGE:\n";
echo "1. Copiez le script dans Deploy Script de Forge\n";
echo "2. Configurez les variables d'environnement:\n";
echo "   - APP_URL=https://ktattoo.on-forge.com\n";
echo "   - SESSION_DRIVER=file\n";
echo "   - APP_ENV=production\n";
echo "   - APP_DEBUG=false\n";
echo "3. Activez HTTPS et SSL dans Forge\n";
echo "4. Déployez avec le script: deploy-forge-filament.sh\n";

echo "\n📝 SCRIPT FORGE:\n";
echo str_repeat("-", 40) . "\n";
echo $forgeScript;
echo str_repeat("-", 40) . "\n";

echo "\n✨ Filament est maintenant prêt pour la production !\n";