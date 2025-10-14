#!/bin/bash

# Script de déploiement pour Laravel Forge - K'rine Tattoo
# Ce script configure automatiquement l'application Laravel avec Filament

echo "🚀 Début du déploiement Laravel Forge - K'rine Tattoo"

# 1. Installation des dépendances Composer
echo "📦 Installation des dépendances Composer..."
composer install --no-dev --optimize-autoloader

# 2. Génération de la clé d'application si nécessaire
echo "🔑 Vérification de la clé d'application..."
if grep -q "APP_KEY=$" .env || grep -q "APP_KEY=\"\"" .env; then
    echo "Génération de la clé d'application..."
    php artisan key:generate --force
else
    echo "Clé d'application déjà présente"
fi

# 3. Vérification de la configuration de base de données
echo "🗄️ Test de connexion à la base de données..."
if php artisan migrate:status &>/dev/null; then
    echo "✅ Connexion à la base de données réussie"
    
    # 4. Exécution des migrations
    echo "🔄 Exécution des migrations..."
    php artisan migrate --force
    
    # 5. Création de la table sessions si nécessaire
    echo "📊 Vérification de la table sessions..."
    php artisan session:table 2>/dev/null || echo "Table sessions déjà créée"
    php artisan migrate --force
    
else
    echo "❌ Erreur de connexion à la base de données"
    echo "Veuillez vérifier les paramètres DB_* dans votre .env sur Forge"
    echo "Configuration actuelle requise :"
    echo "  DB_CONNECTION=mysql"
    echo "  DB_HOST=127.0.0.1"
    echo "  DB_PORT=3306"
    echo "  DB_DATABASE=krine_tattoo"
    echo "  DB_USERNAME=forge"
    echo "  DB_PASSWORD=votre-mot-de-passe-db"
    exit 1
fi

# 6. Publication des assets Filament
echo "🎨 Publication des assets Filament..."
php artisan filament:assets

# 7. Optimisation des performances
echo "⚡ Optimisation des performances..."

# Cache de configuration
php artisan config:cache

# Cache des routes
php artisan route:cache

# Cache des vues
php artisan view:cache

# Cache des événements
php artisan event:cache

# Optimisation de l'autoloader Composer
composer dump-autoload --optimize

# 8. Nettoyage des caches si nécessaire
echo "🧹 Nettoyage des anciens caches..."
php artisan cache:clear
php artisan view:clear

# 9. Vérification des permissions
echo "🔒 Vérification des permissions..."
chmod -R 775 storage
chmod -R 775 bootstrap/cache

# 10. Test de l'application
echo "🧪 Test de l'application..."
if php artisan route:list | grep -q filament; then
    echo "✅ Routes Filament détectées"
else
    echo "⚠️ Aucune route Filament détectée - vérifiez la configuration"
fi

# 11. Vérification de la session
echo "🔐 Vérification de la configuration des sessions..."
SESSION_DRIVER=$(php artisan tinker --execute="echo config('session.driver');" 2>/dev/null | tail -1)
echo "Driver de session actuel: $SESSION_DRIVER"

if [ "$SESSION_DRIVER" = "database" ]; then
    echo "✅ Sessions configurées en base de données"
    
    # Test de création d'une session
    if php artisan tinker --execute="Session::put('test', 'forge_deploy'); echo Session::get('test');" 2>/dev/null | grep -q "forge_deploy"; then
        echo "✅ Test de session réussi"
    else
        echo "⚠️ Test de session échoué - vérifiez la table sessions"
    fi
else
    echo "ℹ️ Sessions configurées en: $SESSION_DRIVER"
fi

# 12. Création d'un utilisateur admin Filament (optionnel)
echo "👤 Voulez-vous créer un utilisateur admin Filament maintenant ?"
echo "   (Vous pouvez le faire plus tard avec: php artisan make:filament-user)"

# 13. Informations finales
echo ""
echo "🎉 Déploiement terminé avec succès !"
echo ""
echo "📋 Résumé de la configuration :"
echo "   • Application: $(php artisan tinker --execute="echo config('app.name');" 2>/dev/null | tail -1)"
echo "   • URL: $(php artisan tinker --execute="echo config('app.url');" 2>/dev/null | tail -1)"
echo "   • Environnement: $(php artisan tinker --execute="echo app()->environment();" 2>/dev/null | tail -1)"
echo "   • Dashboard Filament: $(php artisan tinker --execute="echo config('app.url');" 2>/dev/null | tail -1)/admin"
echo ""
echo "🔗 Accès au dashboard Filament :"
echo "   URL: /admin"
echo "   Pour créer un admin: php artisan make:filament-user"
echo ""
echo "📝 Prochaines étapes sur Laravel Forge :"
echo "   1. Vérifiez que votre domaine pointe vers cette application"
echo "   2. Configurez SSL si ce n'est pas déjà fait"
echo "   3. Créez votre premier utilisateur admin Filament"
echo "   4. Testez l'accès au dashboard admin"

echo ""
echo "✨ Déploiement Forge terminé !"