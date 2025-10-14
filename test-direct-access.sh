#!/bin/bash

# Test accès direct sans URL rewriting
set -e

echo "🧪 TEST ACCÈS DIRECT - Contourner URL rewriting"
echo "=============================================="

# 1. Créer test direct via index.php
echo "=== CRÉER TEST DIRECT ==="
cat > public/direct-test.php << 'DIRECT_EOF'
<?php
// Test direct sans passer par Laravel routing
echo "✅ ACCÈS DIRECT PHP FONCTIONNE\n";
echo "Timestamp: " . date('Y-m-d H:i:s') . "\n";
echo "Server: " . ($_SERVER['HTTP_HOST'] ?? 'unknown') . "\n";
echo "Document Root: " . ($_SERVER['DOCUMENT_ROOT'] ?? 'unknown') . "\n";

// Test Laravel bootstrap
try {
    require_once '../vendor/autoload.php';
    $app = require_once '../bootstrap/app.php';
    echo "✅ Laravel Bootstrap: OK\n";
    echo "Environment: " . $app->environment() . "\n";
} catch (Exception $e) {
    echo "❌ Laravel Error: " . $e->getMessage() . "\n";
}
DIRECT_EOF

# 2. Créer test Laravel avec index.php explicite
echo "=== CRÉER TEST LARAVEL DIRECT ==="
cat > public/laravel-direct.php << 'LARAVEL_EOF'
<?php
// Test Laravel direct
try {
    require_once '../vendor/autoload.php';
    $app = require_once '../bootstrap/app.php';
    
    // Boot Laravel
    $kernel = $app->make('Illuminate\Contracts\Http\Kernel');
    
    // Test route simple
    $request = \Illuminate\Http\Request::create('/test-internal', 'GET');
    $response = $kernel->handle($request);
    
    echo "✅ LARAVEL ROUTING: OK\n";
    echo "Status: " . $response->getStatusCode() . "\n";
    echo "Response: " . $response->getContent() . "\n";
    
} catch (Exception $e) {
    echo "❌ Laravel Routing Error: " . $e->getMessage() . "\n";
}
LARAVEL_EOF

# 3. Ajouter route test interne
if ! grep -q "test-internal" routes/web.php 2>/dev/null; then
    echo "" >> routes/web.php
    echo "Route::get('/test-internal', function() {" >> routes/web.php
    echo "    return 'Internal route works: ' . now();" >> routes/web.php
    echo "});" >> routes/web.php
fi

# 4. Vérifier configuration Nginx probable
echo "=== INFO CONFIGURATION ==="
echo "Si 404 persiste, problème probable:"
echo "1. Module rewrite Apache/Nginx désactivé"
echo "2. .htaccess ignoré par configuration serveur"
echo "3. AllowOverride None dans configuration Apache"

chmod 644 public/direct-test.php
chmod 644 public/laravel-direct.php

echo ""
echo "✅ TESTS DIRECTS CRÉÉS"
echo "====================="
echo ""
echo "🧪 TESTS DANS L'ORDRE:"
echo ""
echo "1. https://krinetattoo.on-forge.com/direct-test.php"
echo "   → Test PHP direct (doit marcher)"
echo ""
echo "2. https://krinetattoo.on-forge.com/laravel-direct.php"
echo "   → Test Laravel direct (doit marcher)"
echo ""
echo "3. https://krinetattoo.on-forge.com/test"
echo "   → Test routing Laravel (peut échouer si rewrite problème)"
echo ""
echo "⚠️ DIAGNOSTIC:"
echo "- Si 1 et 2 marchent mais pas 3 → Problème URL rewriting"
echo "- Si 2 échoue → Problème Laravel"
echo "- Si 1 échoue → Problème PHP/Document Root encore"