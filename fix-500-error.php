<?php

// Script de diagnostic et correction d'erreur 500
// Usage: php fix-500-error.php

require_once 'vendor/autoload.php';

echo "🔧 Diagnostic erreur 500 Laravel\n";
echo "================================\n\n";

// Démarre l'application Laravel
try {
    $app = require_once 'bootstrap/app.php';
    $kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
    $kernel->bootstrap();
    echo "✅ Application Laravel démarrée\n";
} catch (Exception $e) {
    echo "❌ Erreur de démarrage Laravel:\n";
    echo $e->getMessage() . "\n";
    exit(1);
}

echo "\n1. Test de configuration...\n";

// Test APP_KEY
$appKey = config('app.key');
if (empty($appKey)) {
    echo "❌ APP_KEY manquante\n";
    echo "Solution: php artisan key:generate --force\n";
} else {
    echo "✅ APP_KEY configurée\n";
}

// Test de base de données
echo "\n2. Test base de données...\n";
try {
    DB::connection()->getPdo();
    echo "✅ Connexion DB réussie\n";
    
    // Test table users
    if (Schema::hasTable('users')) {
        echo "✅ Table users existe\n";
    } else {
        echo "⚠️  Table users manquante\n";
        echo "Solution: php artisan migrate --force\n";
    }
    
} catch (Exception $e) {
    echo "❌ Erreur DB: " . $e->getMessage() . "\n";
    echo "Configuration actuelle:\n";
    echo "  DB_HOST: " . config('database.connections.mysql.host') . "\n";
    echo "  DB_DATABASE: " . config('database.connections.mysql.database') . "\n";
    echo "  DB_USERNAME: " . config('database.connections.mysql.username') . "\n";
    echo "  DB_PASSWORD: " . (empty(config('database.connections.mysql.password')) ? '[VIDE]' : '[CONFIGURÉ]') . "\n\n";
    
    echo "Solutions:\n";
    echo "1. Configurer DB_PASSWORD dans .env\n";
    echo "2. Ou changer SESSION_DRIVER=file\n";
}

// Test sessions
echo "\n3. Test sessions...\n";
$sessionDriver = config('session.driver');
echo "Driver sessions: $sessionDriver\n";

if ($sessionDriver === 'database') {
    try {
        if (Schema::hasTable('sessions')) {
            echo "✅ Table sessions existe\n";
        } else {
            echo "❌ Table sessions manquante\n";
            echo "Solution: php artisan session:table && php artisan migrate --force\n";
        }
    } catch (Exception $e) {
        echo "❌ Impossible de vérifier table sessions\n";
        echo "Solution: Changer SESSION_DRIVER=file dans .env\n";
    }
} else {
    echo "✅ Sessions en mode $sessionDriver\n";
    
    if ($sessionDriver === 'file') {
        $sessionPath = storage_path('framework/sessions');
        if (!is_dir($sessionPath)) {
            echo "⚠️  Répertoire sessions manquant\n";
            echo "Création...\n";
            mkdir($sessionPath, 0775, true);
            echo "✅ Répertoire créé\n";
        } else {
            echo "✅ Répertoire sessions OK\n";
        }
    }
}

// Test permissions
echo "\n4. Test permissions...\n";
$storagePath = storage_path();
$bootstrapPath = base_path('bootstrap/cache');

if (is_writable($storagePath) && is_writable($bootstrapPath)) {
    echo "✅ Permissions OK\n";
} else {
    echo "❌ Permissions insuffisantes\n";
    echo "Solution: chmod -R 775 storage bootstrap/cache\n";
}

// Test route principale
echo "\n5. Test route web...\n";
try {
    $routes = Route::getRoutes();
    $homeRoute = $routes->getByName('home') ?? $routes->getByMethod('GET')['/'] ?? null;
    
    if ($homeRoute) {
        echo "✅ Route principale trouvée\n";
    } else {
        echo "⚠️  Route principale non définie\n";
        echo "Vérifiez routes/web.php\n";
    }
} catch (Exception $e) {
    echo "❌ Erreur routes: " . $e->getMessage() . "\n";
}

echo "\n" . str_repeat("=", 50) . "\n";
echo "SOLUTIONS RAPIDES POUR L'ERREUR 500:\n";
echo str_repeat("=", 50) . "\n";

echo "\n🔧 SOLUTION 1 - Sessions fichier (Recommandée):\n";
echo "sed -i.bak 's/SESSION_DRIVER=database/SESSION_DRIVER=file/' .env\n";
echo "mkdir -p storage/framework/sessions\n";
echo "chmod -R 775 storage\n";

echo "\n🔧 SOLUTION 2 - Base de données:\n";
echo "1. Configurez DB_PASSWORD dans .env\n";
echo "2. php artisan migrate --force\n";
echo "3. php artisan session:table\n";
echo "4. php artisan migrate --force\n";

echo "\n🔧 SOLUTION 3 - Nettoyage caches:\n";
echo "php artisan config:clear\n";
echo "php artisan cache:clear\n";
echo "php artisan view:clear\n";

echo "\n🔧 SOLUTION 4 - Permissions:\n";
echo "chmod -R 775 storage bootstrap/cache\n";
echo "chmod 644 .env\n";

echo "\n📋 APRÈS CORRECTION, TESTEZ:\n";
echo "curl -I http://votre-domaine.com\n";
echo "ou visitez /admin dans le navigateur\n";

echo "\n✨ Diagnostic terminé!\n";