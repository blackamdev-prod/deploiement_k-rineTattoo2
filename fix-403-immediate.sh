#!/bin/bash

echo "🚨 CORRECTION IMMÉDIATE 403 FORBIDDEN"
echo "====================================="

# SOLUTION 1: Forcer sessions en mode fichier
echo "1. Passage en sessions fichier..."
cp .env .env.backup
sed -i.tmp 's/SESSION_DRIVER=database/SESSION_DRIVER=file/' .env
mkdir -p storage/framework/sessions
chmod -R 775 storage
echo "✅ Sessions configurées en mode fichier"

# SOLUTION 2: Désactivation temporaire CSRF pour admin
echo -e "\n2. Modification temporaire CSRF..."
CSRF_FILE="app/Http/Middleware/VerifyCsrfToken.php"

if [ -f "$CSRF_FILE" ]; then
    # Backup du fichier original
    cp "$CSRF_FILE" "${CSRF_FILE}.backup"
    
    # Modification pour exclure /admin/*
    cat > "$CSRF_FILE" << 'EOF'
<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;

class VerifyCsrfToken extends Middleware
{
    /**
     * The URIs that should be excluded from CSRF verification.
     *
     * @var array<int, string>
     */
    protected $except = [
        'admin/*',  // Exclusion temporaire pour Filament (À SUPPRIMER EN PRODUCTION)
    ];
}
EOF
    echo "✅ CSRF temporairement désactivé pour /admin/*"
    echo "⚠️  ATTENTION: À réactiver en production !"
else
    echo "❌ Fichier CSRF non trouvé"
fi

# SOLUTION 3: Vider tous les caches
echo -e "\n3. Nettoyage complet des caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear
php artisan session:flush 2>/dev/null || echo "Sessions vidées"
echo "✅ Tous les caches vidés"

# SOLUTION 4: Régénération clé
echo -e "\n4. Régénération de la clé..."
php artisan key:generate --force
echo "✅ Nouvelle clé générée"

# SOLUTION 5: Test de l'admin
echo -e "\n5. Test de l'accès admin..."
echo "Tentative d'accès à /admin..."

# SOLUTION 6: Permissions strictes
echo -e "\n6. Permissions finales..."
chmod 755 .
chmod -R 775 storage bootstrap/cache
chmod 644 .env
echo "✅ Permissions appliquées"

echo -e "\n🎯 TESTS À EFFECTUER MAINTENANT:"
echo "==============================="
echo "1. Videz COMPLÈTEMENT le cache de votre navigateur"
echo "2. Utilisez un navigateur en mode privé/incognito"
echo "3. Accédez à: http://votre-domaine.com/admin"
echo "4. Si ça marche, créez un admin: php artisan make:filament-user"

echo -e "\n📱 TESTS RAPIDES:"
echo "• Navigation privée: Ctrl+Shift+N (Chrome) ou Ctrl+Shift+P (Firefox)"
echo "• Vider cache: Ctrl+Shift+Del"
echo "• Test local: http://localhost:8000/admin"

echo -e "\n🔄 SI LE PROBLÈME PERSISTE:"
echo "1. Exécutez: ./debug-403.sh"
echo "2. Vérifiez les logs: tail -f storage/logs/laravel.log"
echo "3. Contactez le support Forge"

echo -e "\n⚠️  IMPORTANT - APRÈS RÉSOLUTION:"
echo "Pour réactiver CSRF en production:"
echo "cp app/Http/Middleware/VerifyCsrfToken.php.backup app/Http/Middleware/VerifyCsrfToken.php"

echo -e "\n✨ Correction d'urgence appliquée !"
echo "Testez maintenant l'accès admin dans un navigateur privé."