#!/bin/bash

echo "🔍 DIAGNOSTIC 403 FORBIDDEN - K'rine Tattoo Filament"
echo "=================================================="

# 1. Test de base - APP_KEY
echo "1. Vérification APP_KEY:"
if grep -q "APP_KEY=base64:" .env; then
    echo "✅ APP_KEY présente"
else
    echo "❌ APP_KEY manquante - GÉNÉRATION:"
    php artisan key:generate --force
fi

# 2. Test de connexion DB
echo -e "\n2. Test connexion base de données:"
if php artisan tinker --execute="DB::connection()->getPdo(); echo 'DB OK';" 2>/dev/null | grep -q "DB OK"; then
    echo "✅ Base de données connectée"
else
    echo "❌ Erreur de connexion DB"
    echo "SOLUTION IMMÉDIATE - Utiliser sessions fichier:"
    sed -i.bak 's/SESSION_DRIVER=database/SESSION_DRIVER=file/' .env
    echo "✅ Sessions changées vers 'file'"
fi

# 3. Test sessions
echo -e "\n3. Test sessions:"
SESSION_DRIVER=$(grep SESSION_DRIVER .env | cut -d'=' -f2)
echo "Driver actuel: $SESSION_DRIVER"

if [ "$SESSION_DRIVER" = "file" ]; then
    echo "✅ Sessions en mode fichier (compatible)"
    # Vérifier permissions storage
    if [ -w "storage/framework/sessions" ]; then
        echo "✅ Répertoire sessions accessible"
    else
        echo "🔧 Création/permission du répertoire sessions:"
        mkdir -p storage/framework/sessions
        chmod -R 775 storage
        echo "✅ Permissions corrigées"
    fi
else
    echo "⚠️ Sessions en mode database - risque de 403"
fi

# 4. Test CSRF
echo -e "\n4. Configuration CSRF:"
echo "Création d'un test de token CSRF..."
php artisan tinker --execute="
echo 'CSRF Token: ' . csrf_token();
echo 'Session ID: ' . session()->getId();
" 2>/dev/null || echo "❌ Impossible de générer CSRF token"

# 5. Nettoyage des caches
echo -e "\n5. Nettoyage des caches:"
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear
echo "✅ Caches vidés"

# 6. Test route Filament
echo -e "\n6. Vérification routes Filament:"
if php artisan route:list | grep -q "admin.*filament"; then
    echo "✅ Routes Filament détectées"
    php artisan route:list | grep filament | head -3
else
    echo "❌ Aucune route Filament trouvée"
fi

# 7. Test permissions
echo -e "\n7. Vérification permissions:"
if [ -w "storage" ] && [ -w "bootstrap/cache" ]; then
    echo "✅ Permissions OK"
else
    echo "🔧 Correction des permissions:"
    chmod -R 775 storage bootstrap/cache
    echo "✅ Permissions corrigées"
fi

# 8. Test URL et domaine
echo -e "\n8. Configuration URL:"
APP_URL=$(grep APP_URL .env | cut -d'=' -f2-)
echo "URL configurée: $APP_URL"
if [[ "$APP_URL" == *"votre-domaine"* ]]; then
    echo "⚠️ URL générique détectée - à modifier en production"
fi

# 9. Solutions immédiates pour le 403
echo -e "\n🔧 SOLUTIONS IMMÉDIATES POUR LE 403:"
echo "=================================="

echo "A. Désactiver temporairement CSRF (DÉVELOPPEMENT UNIQUEMENT):"
echo "   Dans app/Http/Middleware/VerifyCsrfToken.php, ajouter '/admin/*' aux exceptions"

echo -e "\nB. Forcer sessions en mode fichier:"
echo "   SESSION_DRIVER=file dans .env"

echo -e "\nC. Vider complètement le cache navigateur et cookies"

echo -e "\nD. Test direct avec curl:"
echo "   curl -I http://votre-domaine.com/admin"

# 10. Script de test en direct
echo -e "\n10. Test de la page admin:"
if command -v curl >/dev/null 2>&1; then
    echo "Test HTTP de la page admin..."
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/admin 2>/dev/null || echo "ERROR")
    if [ "$RESPONSE" = "200" ]; then
        echo "✅ Page admin accessible (200)"
    elif [ "$RESPONSE" = "403" ]; then
        echo "❌ Erreur 403 confirmée"
    elif [ "$RESPONSE" = "500" ]; then
        echo "❌ Erreur 500 - problème serveur"
    else
        echo "⚠️ Réponse: $RESPONSE"
    fi
else
    echo "ℹ️ curl non disponible pour test HTTP"
fi

echo -e "\n📋 RÉCAPITULATIF:"
echo "================"
echo "• APP_KEY: $(grep APP_KEY .env | cut -d'=' -f2 | cut -c1-20)..."
echo "• SESSION_DRIVER: $(grep SESSION_DRIVER .env | cut -d'=' -f2)"
echo "• APP_DEBUG: $(grep APP_DEBUG .env | cut -d'=' -f2)"
echo "• APP_ENV: $(grep APP_ENV .env | cut -d'=' -f2)"

echo -e "\n🎯 ACTIONS PRIORITAIRES:"
echo "1. Vérifiez que les sessions fonctionnent (mode file recommandé)"
echo "2. Videz complètement le cache navigateur"
echo "3. Testez avec un navigateur privé"
echo "4. Vérifiez les logs en temps réel: tail -f storage/logs/laravel.log"

echo -e "\n✨ Diagnostic terminé !"