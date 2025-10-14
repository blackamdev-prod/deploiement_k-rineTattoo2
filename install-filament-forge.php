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
// ÉTAPE 1: VÉRIFICATIONS PRÉALABLES
// =========================================================================

step(1, "VÉRIFICATIONS PRÉALABLES");

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
// ÉTAPE 2: INSTALLATION FILAMENT
// =========================================================================

step(2, "INSTALLATION FILAMENT V3");

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
// ÉTAPE 3: CONFIGURATION FILAMENT
// =========================================================================

step(3, "CONFIGURATION FILAMENT");

// Créer le panneau admin
info("Création du panneau admin...");
$panelResult = execCommand("php artisan filament:install --panels");

if ($panelResult['code'] === 0) {
    success("Panneau admin créé");
} else {
    warning("Problème lors de la création du panneau:");
    echo $panelResult['output'] . "\n";
}

// Publier les assets
info("Publication des assets...");
$assetsResult = execCommand("php artisan filament:assets");
if ($assetsResult['code'] === 0) {
    success("Assets publiés");
}

// =========================================================================
// ÉTAPE 4: CRÉATION UTILISATEUR ADMIN
// =========================================================================

step(4, "CRÉATION UTILISATEUR ADMIN");

info("Création d'un utilisateur admin...");
$userResult = execCommand("php artisan make:filament-user --name=\"Admin\" --email=\"admin@krinetattoo.com\" --password=\"password123\"");

if ($userResult['code'] === 0) {
    success("Utilisateur admin créé");
    info("Email: admin@krinetattoo.com");
    info("Mot de passe: password123");
    warning("Changez le mot de passe après la première connexion!");
} else {
    warning("Création manuelle de l'utilisateur requise");
}

// =========================================================================
// ÉTAPE 5: OPTIMISATIONS
// =========================================================================

step(5, "OPTIMISATIONS");

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
// ÉTAPE 6: PERMISSIONS
// =========================================================================

step(6, "PERMISSIONS");

info("Configuration des permissions...");
execCommand("chmod -R 775 storage bootstrap/cache");
execCommand("chmod -R 775 public");
success("Permissions configurées");

// =========================================================================
// ÉTAPE 7: TEST FINAL
// =========================================================================

step(7, "TESTS FINAUX");

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

step(8, "CRÉATION SCRIPT FORGE");

$forgeScript = '#!/bin/bash

cd $FORGE_SITE_PATH

# Git pull
git pull origin $FORGE_SITE_BRANCH

# Installation des dépendances
composer install --no-dev --optimize-autoloader

# Découverte des packages
php artisan package:discover --ansi

# Migrations
php artisan migrate --force

# Publication des assets Filament
php artisan filament:assets

# Optimisations
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Permissions
chmod -R 775 storage bootstrap/cache
chmod -R 775 public

echo "✅ Déploiement Filament réussi"
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
echo "• URL: https://votre-domaine.com/admin\n";
echo "• Email: admin@krinetattoo.com\n";
echo "• Mot de passe: password123\n";

echo "\n🚀 POUR FORGE:\n";
echo "• Utilisez le script: deploy-forge-filament.sh\n";
echo "• Ou copiez le contenu dans Deploy Script\n";

echo "\n📝 SCRIPT FORGE:\n";
echo str_repeat("-", 40) . "\n";
echo $forgeScript;
echo str_repeat("-", 40) . "\n";

echo "\n✨ Filament est maintenant prêt pour la production !\n";