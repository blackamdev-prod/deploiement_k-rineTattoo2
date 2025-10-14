#!/bin/bash

# Fix 404 NOT FOUND - Routes Laravel non chargées
set -e

echo "🔧 FIX 404 NOT FOUND - Routes Laravel"
echo "===================================="

echo "✅ PROGRÈS: Plus de 'No input file specified' - Document Root OK!"
echo "❌ PROBLÈME: Routes Laravel pas chargées"

# 1. Vérifier .htaccess dans public/
echo "=== VÉRIFICATION .HTACCESS ==="
if [ ! -f "public/.htaccess" ]; then
    echo "❌ .htaccess manquant - création..."
    cat > public/.htaccess << 'HTACCESS_EOF'
<IfModule mod_rewrite.c>
    <IfModule mod_negotiation.c>
        Options -MultiViews -Indexes
    </IfModule>

    RewriteEngine On

    # Handle Authorization Header
    RewriteCond %{HTTP:Authorization} .
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

    # Redirect Trailing Slashes If Not A Folder...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} (.+)/$
    RewriteRule ^ %1 [L,R=301]

    # Send Requests To Front Controller...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [L]
</IfModule>
HTACCESS_EOF
    chmod 644 public/.htaccess
    echo "✅ .htaccess créé"
else
    echo "✅ .htaccess existe"
fi

# 2. Vérifier index.php
echo -e "\n=== VÉRIFICATION INDEX.PHP ==="
if [ ! -f "public/index.php" ] || [ ! -s "public/index.php" ]; then
    echo "❌ index.php problématique - recréation..."
    cat > public/index.php << 'INDEX_EOF'
<?php

use Illuminate\Contracts\Http\Kernel;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}

require __DIR__.'/../vendor/autoload.php';

$app = require_once __DIR__.'/../bootstrap/app.php';

$kernel = $app->make(Kernel::class);

$response = $kernel->handle(
    $request = Request::capture()
)->send();

$kernel->terminate($request, $response);
INDEX_EOF
    chmod 644 public/index.php
    echo "✅ index.php recréé"
else
    echo "✅ index.php existe"
fi

# 3. Clear tous les caches routes
echo -e "\n=== CLEAR CACHES ROUTES ==="
rm -rf bootstrap/cache/* 2>/dev/null || true
php artisan route:clear || true
php artisan cache:clear || true
php artisan config:clear || true

# 4. Vérifier routes/web.php
echo -e "\n=== VÉRIFICATION ROUTES WEB ==="
if [ ! -f "routes/web.php" ] || [ ! -s "routes/web.php" ]; then
    echo "❌ routes/web.php manquant/vide - création..."
    mkdir -p routes
    cat > routes/web.php << 'ROUTES_EOF'
<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// Test route simple
Route::get('/test', function () {
    return 'Laravel routes working! ' . now();
});
ROUTES_EOF
    echo "✅ routes/web.php créé"
else
    echo "✅ routes/web.php existe"
fi

# 5. Cache config seulement (pas routes pour éviter problèmes)
echo -e "\n=== CACHE CONFIG ==="
php artisan config:cache

# 6. Test routes
echo -e "\n=== TEST ROUTES ==="
php artisan route:list | head -10 || echo "Route listing failed"

echo ""
echo "✅ FIX 404 ROUTES TERMINÉ"
echo "========================"
echo ""
echo "🧪 TESTS MAINTENANT:"
echo "1. https://krinetattoo.on-forge.com/test"
echo "   → Doit afficher: Laravel routes working!"
echo ""
echo "2. https://krinetattoo.on-forge.com"
echo "   → Page d'accueil Laravel"
echo ""
echo "3. https://krinetattoo.on-forge.com/admin"
echo "   → Login Filament"
echo ""
echo "⚠️ Si /test marche mais pas /admin → Problème spécifique Filament"
echo "⚠️ Si rien ne marche → Problème .htaccess/rewrite module"