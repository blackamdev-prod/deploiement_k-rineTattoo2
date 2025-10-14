#!/bin/bash

# Diagnostic étape par étape pour identifier la cause exacte du 403
set -e

echo "🔍 DIAGNOSTIC 403 - ÉTAPE PAR ÉTAPE"
echo "================================="

# ÉTAPE 1: Test PHP basique
echo "=== ÉTAPE 1: Test PHP basique ==="
echo "<?php echo 'PHP WORKS: ' . date('Y-m-d H:i:s'); ?>" > public/step1-php.php
chmod 644 public/step1-php.php
echo "✅ Créé: /step1-php.php"

# ÉTAPE 2: Test Laravel bootstrap
echo -e "\n=== ÉTAPE 2: Test Laravel bootstrap ==="
cat > public/step2-laravel.php << 'STEP2_EOF'
<?php
try {
    require_once '../vendor/autoload.php';
    $app = require_once '../bootstrap/app.php';
    echo 'LARAVEL WORKS: Environment = ' . $app->environment();
} catch (Exception $e) {
    echo 'LARAVEL ERROR: ' . $e->getMessage();
}
STEP2_EOF
chmod 644 public/step2-laravel.php
echo "✅ Créé: /step2-laravel.php"

# ÉTAPE 3: Test route simple
echo -e "\n=== ÉTAPE 3: Test route simple ==="
cat > public/step3-route.php << 'STEP3_EOF'
<?php
try {
    require_once '../vendor/autoload.php';
    $app = require_once '../bootstrap/app.php';
    
    // Test route
    $request = Illuminate\Http\Request::create('/test', 'GET');
    $response = $app->handle($request);
    
    echo 'ROUTES WORK: Status = ' . $response->getStatusCode();
} catch (Exception $e) {
    echo 'ROUTES ERROR: ' . $e->getMessage();
}
STEP3_EOF
chmod 644 public/step3-route.php
echo "✅ Créé: /step3-route.php"

# ÉTAPE 4: Test Filament sans authentification
echo -e "\n=== ÉTAPE 4: Test Filament service ==="
cat > public/step4-filament.php << 'STEP4_EOF'
<?php
try {
    require_once '../vendor/autoload.php';
    $app = require_once '../bootstrap/app.php';
    
    // Boot Laravel
    $app->make('Illuminate\Contracts\Http\Kernel')->bootstrap();
    
    // Test Filament service
    $filament = app('filament');
    $panels = $filament->getPanels();
    
    echo 'FILAMENT WORKS: Panels = ' . implode(', ', array_keys($panels));
    
    if (isset($panels['admin'])) {
        $adminPanel = $panels['admin'];
        echo ' | Admin Path = ' . $adminPanel->getPath();
    }
} catch (Exception $e) {
    echo 'FILAMENT ERROR: ' . $e->getMessage();
}
STEP4_EOF
chmod 644 public/step4-filament.php
echo "✅ Créé: /step4-filament.php"

# ÉTAPE 5: Créer route admin manuelle
echo -e "\n=== ÉTAPE 5: Route admin manuelle ==="
# Ajouter route simple pour tester
if ! grep -q "step5-admin-test" routes/web.php 2>/dev/null; then
    echo "" >> routes/web.php
    echo "// Step 5 - Test admin route" >> routes/web.php
    echo "Route::get('/step5-admin-test', function() {" >> routes/web.php
    echo "    return 'ADMIN ROUTE WORKS - ' . now();" >> routes/web.php
    echo "});" >> routes/web.php
    echo "✅ Route admin test ajoutée"
fi

# ÉTAPE 6: Clear cache pour tests
echo -e "\n=== ÉTAPE 6: Clear cache ==="
php artisan route:clear || true
php artisan cache:clear || true
php artisan config:clear || true

# ÉTAPE 7: Informations système
echo -e "\n=== ÉTAPE 7: Informations système ==="
echo "Project path: $(pwd)"
echo "Public path: $(pwd)/public"
echo "Laravel version: $(php artisan --version 2>/dev/null || echo 'Unknown')"
echo "PHP version: $(php -v | head -1)"

# ÉTAPE 8: Test permissions
echo -e "\n=== ÉTAPE 8: Permissions ==="
ls -la public/step*.php | head -5
echo "Index.php: $(ls -la public/index.php)"

echo -e "\n🧪 TESTS À FAIRE (dans l'ordre):"
echo "================================"
echo "1. https://deploiement_krinetattoo-pobc9vdh.on-forge.com/step1-php.php"
echo "   → Doit afficher: PHP WORKS: [date]"
echo ""
echo "2. https://deploiement_krinetattoo-pobc9vdh.on-forge.com/step2-laravel.php"
echo "   → Doit afficher: LARAVEL WORKS: Environment = production"
echo ""
echo "3. https://deploiement_krinetattoo-pobc9vdh.on-forge.com/step3-route.php"
echo "   → Doit afficher: ROUTES WORK: Status = 200"
echo ""
echo "4. https://deploiement_krinetattoo-pobc9vdh.on-forge.com/step4-filament.php"
echo "   → Doit afficher: FILAMENT WORKS: Panels = admin"
echo ""
echo "5. https://deploiement_krinetattoo-pobc9vdh.on-forge.com/step5-admin-test"
echo "   → Doit afficher: ADMIN ROUTE WORKS - [date]"
echo ""
echo "6. https://deploiement_krinetattoo-pobc9vdh.on-forge.com/admin"
echo "   → Login Filament (le vrai test)"
echo ""
echo "⚠️ DIAGNOSTIC:"
echo "- Si étape 1 échoue → Document Root problème"
echo "- Si étape 2 échoue → Laravel bootstrap problème"
echo "- Si étape 3 échoue → Routes Laravel problème"  
echo "- Si étape 4 échoue → Filament configuration problème"
echo "- Si étape 5 OK mais 6 échoue → Middleware/Auth Filament problème"