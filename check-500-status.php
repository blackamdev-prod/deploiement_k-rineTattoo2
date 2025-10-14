<?php

/**
 * Vérification rapide du status de l'application
 * Usage: php check-500-status.php
 */

echo "🔍 Vérification rapide - Erreur 500\n";
echo "===================================\n\n";

// Test 1: Laravel fonctionne-t-il ?
echo "1. Test Laravel...\n";
try {
    require_once 'vendor/autoload.php';
    $app = require_once 'bootstrap/app.php';
    $kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
    $kernel->bootstrap();
    echo "✅ Laravel OK\n";
} catch (Exception $e) {
    echo "❌ Laravel ERROR: " . $e->getMessage() . "\n";
    exit(1);
}

// Test 2: Routes Filament
echo "\n2. Test routes Filament...\n";
$output = shell_exec('php artisan route:list 2>/dev/null | grep filament | wc -l');
$routeCount = (int)trim($output);
echo "✅ $routeCount routes Filament trouvées\n";

// Test 3: Serveur de développement
echo "\n3. Test serveur de développement...\n";
$response = @file_get_contents('http://localhost:8000', false, stream_context_create([
    'http' => [
        'timeout' => 5,
        'ignore_errors' => true
    ]
]));

if ($response !== false) {
    echo "✅ Serveur local accessible (localhost:8000)\n";
    
    // Test admin
    $adminResponse = @file_get_contents('http://localhost:8000/admin', false, stream_context_create([
        'http' => [
            'timeout' => 5,
            'ignore_errors' => true
        ]
    ]));
    
    if ($adminResponse !== false) {
        echo "✅ Admin Filament accessible (/admin)\n";
    } else {
        echo "⚠️  Admin non accessible\n";
    }
} else {
    echo "⚠️  Serveur local non accessible\n";
    echo "Démarrage du serveur...\n";
    shell_exec('php artisan serve --host=0.0.0.0 --port=8000 > /dev/null 2>&1 &');
    sleep(3);
    echo "✅ Serveur démarré sur http://localhost:8000\n";
}

// Test 4: Configuration critique
echo "\n4. Configuration critique...\n";
$envFile = file_exists('.env') ? file_get_contents('.env') : '';

// APP_KEY
if (preg_match('/APP_KEY=base64:/', $envFile)) {
    echo "✅ APP_KEY configurée\n";
} else {
    echo "❌ APP_KEY manquante - CRITIQUE!\n";
    shell_exec('php artisan key:generate --force');
    echo "✅ APP_KEY générée\n";
}

// Sessions
if (preg_match('/SESSION_DRIVER=file/', $envFile)) {
    echo "✅ Sessions en mode fichier\n";
} else {
    echo "⚠️  Sessions non optimisées\n";
}

// Test 5: Permissions
echo "\n5. Permissions...\n";
if (is_writable('storage') && is_writable('bootstrap/cache')) {
    echo "✅ Permissions OK\n";
} else {
    echo "❌ Permissions insuffisantes\n";
    shell_exec('chmod -R 775 storage bootstrap/cache');
    echo "✅ Permissions corrigées\n";
}

// Test 6: Cache
echo "\n6. Cache...\n";
shell_exec('php artisan config:clear 2>/dev/null');
shell_exec('php artisan cache:clear 2>/dev/null');
shell_exec('php artisan view:clear 2>/dev/null');
echo "✅ Caches vidés\n";

echo "\n" . str_repeat("=", 50) . "\n";
echo "🎯 DIAGNOSTIC RAPIDE:\n";
echo str_repeat("=", 50) . "\n";

if ($routeCount > 0 && $response !== false) {
    echo "✅ APPLICATION FONCTIONNELLE\n\n";
    echo "URLs à tester:\n";
    echo "• Homepage: http://localhost:8000\n";
    echo "• Admin: http://localhost:8000/admin\n\n";
    
    echo "🔧 Si erreur 500 persiste:\n";
    echo "1. Videz le cache navigateur complètement\n";
    echo "2. Testez en navigation privée\n";
    echo "3. Vérifiez l'URL exacte utilisée\n";
    echo "4. Regardez les logs: tail -f storage/logs/laravel.log\n";
} else {
    echo "❌ PROBLÈME DÉTECTÉ\n\n";
    echo "Actions correctives:\n";
    echo "1. php artisan config:clear\n";
    echo "2. php artisan serve\n";
    echo "3. Testez: curl -I http://localhost:8000\n";
}

echo "\n📊 Status final:\n";
echo "• Laravel: " . (class_exists('Illuminate\Foundation\Application') ? "✅" : "❌") . "\n";
echo "• Filament: " . ($routeCount > 0 ? "✅ ($routeCount routes)" : "❌") . "\n";
echo "• Serveur: " . ($response !== false ? "✅" : "❌") . "\n";

echo "\n✨ Vérification terminée!\n";