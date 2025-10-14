#!/bin/bash

echo "🔧 DIAGNOSTIC FILAMENT SUR LARAVEL FORGE"
echo "========================================"
echo "Application: K'rine Tattoo"
echo "Date: $(date)"
echo ""

# Configuration et couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'affichage
status_ok() { echo -e "${GREEN}✅ $1${NC}"; }
status_error() { echo -e "${RED}❌ $1${NC}"; }
status_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
status_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

echo "🔍 ÉTAPE 1: VÉRIFICATION DE L'ENVIRONNEMENT FORGE"
echo "================================================="

# Vérification PHP
echo "1.1 Version PHP:"
PHP_VERSION=$(php -v | head -n1 | cut -d' ' -f2 | cut -d'.' -f1,2)
echo "   Version PHP: $PHP_VERSION"
if [[ $(echo "$PHP_VERSION >= 8.1" | bc -l 2>/dev/null) -eq 1 ]]; then
    status_ok "PHP $PHP_VERSION compatible"
else
    status_error "PHP $PHP_VERSION trop ancien (requis: 8.1+)"
fi

# Vérification Composer
echo -e "\n1.2 Composer:"
if command -v composer >/dev/null 2>&1; then
    COMPOSER_VERSION=$(composer --version 2>/dev/null | cut -d' ' -f3)
    status_ok "Composer installé ($COMPOSER_VERSION)"
else
    status_error "Composer non trouvé"
fi

# Vérification Node.js
echo -e "\n1.3 Node.js:"
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    status_ok "Node.js installé ($NODE_VERSION)"
else
    status_warning "Node.js non installé (requis pour Vite)"
fi

echo -e "\n🗄️ ÉTAPE 2: VÉRIFICATION BASE DE DONNÉES"
echo "========================================"

# Test de connexion DB
echo "2.1 Connexion base de données:"
if php artisan tinker --execute="DB::connection()->getPdo(); echo 'DB_OK';" 2>/dev/null | grep -q "DB_OK"; then
    status_ok "Connexion base de données réussie"
    
    # Vérification des migrations
    echo -e "\n2.2 État des migrations:"
    if php artisan migrate:status 2>/dev/null | grep -q "Migration table not found"; then
        status_warning "Table migrations non trouvée"
        echo "   Solution: php artisan migrate:install"
    else
        PENDING_MIGRATIONS=$(php artisan migrate:status 2>/dev/null | grep "Pending" | wc -l)
        if [ "$PENDING_MIGRATIONS" -gt 0 ]; then
            status_warning "$PENDING_MIGRATIONS migrations en attente"
            echo "   Solution: php artisan migrate --force"
        else
            status_ok "Toutes les migrations appliquées"
        fi
    fi
    
    # Vérification table sessions
    echo -e "\n2.3 Table sessions:"
    SESSION_DRIVER=$(grep SESSION_DRIVER .env | cut -d'=' -f2)
    if [ "$SESSION_DRIVER" = "database" ]; then
        if php artisan tinker --execute="Schema::hasTable('sessions'); echo 'TABLE_CHECK';" 2>/dev/null | grep -q "1"; then
            status_ok "Table sessions existe"
        else
            status_error "Table sessions manquante"
            echo "   Solution: php artisan session:table && php artisan migrate"
        fi
    else
        status_info "Sessions en mode $SESSION_DRIVER"
    fi
    
else
    status_error "Impossible de se connecter à la base de données"
    echo "   Variables DB actuelles:"
    echo "   DB_HOST: $(grep DB_HOST .env | cut -d'=' -f2)"
    echo "   DB_DATABASE: $(grep DB_DATABASE .env | cut -d'=' -f2)"
    echo "   DB_USERNAME: $(grep DB_USERNAME .env | cut -d'=' -f2)"
    echo "   DB_PASSWORD: [$(grep DB_PASSWORD .env | cut -d'=' -f2 | sed 's/./*/g')]"
fi

echo -e "\n🔐 ÉTAPE 3: CONFIGURATION LARAVEL"
echo "================================"

# APP_KEY
echo "3.1 Clé d'application:"
APP_KEY=$(grep APP_KEY .env | cut -d'=' -f2)
if [[ "$APP_KEY" =~ ^base64: ]]; then
    status_ok "APP_KEY configurée"
else
    status_error "APP_KEY manquante ou invalide"
    echo "   Solution: php artisan key:generate --force"
fi

# APP_URL
echo -e "\n3.2 URL de l'application:"
APP_URL=$(grep APP_URL .env | cut -d'=' -f2)
echo "   APP_URL: $APP_URL"
if [[ "$APP_URL" == *"votre-domaine"* ]] || [[ "$APP_URL" == *"localhost"* ]]; then
    status_warning "URL générique détectée"
    echo "   Solution: Configurer l'URL réelle dans Forge"
else
    status_ok "URL configurée"
fi

# APP_ENV et DEBUG
echo -e "\n3.3 Environnement:"
APP_ENV=$(grep APP_ENV .env | cut -d'=' -f2)
APP_DEBUG=$(grep APP_DEBUG .env | cut -d'=' -f2)
echo "   APP_ENV: $APP_ENV"
echo "   APP_DEBUG: $APP_DEBUG"

if [ "$APP_ENV" = "production" ] && [ "$APP_DEBUG" = "false" ]; then
    status_ok "Configuration production correcte"
else
    status_warning "Configuration non optimale pour production"
fi

echo -e "\n📦 ÉTAPE 4: VÉRIFICATION FILAMENT"
echo "================================"

# Installation Filament
echo "4.1 Installation Filament:"
if composer show | grep -q "filament/filament"; then
    FILAMENT_VERSION=$(composer show filament/filament | grep "versions" | head -1 | awk '{print $3}')
    status_ok "Filament installé ($FILAMENT_VERSION)"
else
    status_error "Filament non installé"
    echo "   Solution: composer require filament/filament"
fi

# Provider Filament
echo -e "\n4.2 Providers Filament:"
if grep -r "FilamentServiceProvider" config/ 2>/dev/null || grep -r "AdminPanelProvider" app/ 2>/dev/null; then
    status_ok "Providers Filament détectés"
else
    status_warning "Providers Filament non trouvés"
    echo "   Solution: Vérifier l'installation Filament"
fi

# Routes Filament
echo -e "\n4.3 Routes Filament:"
if php artisan route:list 2>/dev/null | grep -q filament; then
    status_ok "Routes Filament enregistrées"
    ADMIN_ROUTE=$(php artisan route:list 2>/dev/null | grep "admin.*dashboard" | awk '{print $2}' | head -1)
    echo "   Route admin: /$ADMIN_ROUTE"
else
    status_error "Aucune route Filament trouvée"
fi

# Assets Filament
echo -e "\n4.4 Assets Filament:"
if [ -d "public/js" ] || [ -d "public/css" ]; then
    status_ok "Répertoires assets présents"
else
    status_warning "Répertoires assets manquants"
    echo "   Solution: php artisan filament:assets"
fi

echo -e "\n🌐 ÉTAPE 5: CONFIGURATION SERVEUR WEB"
echo "===================================="

# Vérification .htaccess
echo "5.1 Configuration Apache (.htaccess):"
if [ -f "public/.htaccess" ]; then
    status_ok "Fichier .htaccess présent"
    
    # Vérification mod_rewrite
    if grep -q "RewriteEngine On" public/.htaccess; then
        status_ok "mod_rewrite activé"
    else
        status_warning "mod_rewrite non configuré"
    fi
else
    status_error "Fichier .htaccess manquant"
fi

# Permissions
echo -e "\n5.2 Permissions des fichiers:"
if [ -w "storage" ] && [ -w "bootstrap/cache" ]; then
    status_ok "Permissions storage/cache OK"
else
    status_error "Permissions insuffisantes"
    echo "   Solution: chmod -R 775 storage bootstrap/cache"
fi

echo -e "\n🔍 ÉTAPE 6: TESTS DE FONCTIONNEMENT"
echo "=================================="

# Test CSRF Token
echo "6.1 Test génération CSRF:"
if php artisan tinker --execute="echo csrf_token();" 2>/dev/null | grep -E "^[a-zA-Z0-9]{40}" >/dev/null; then
    status_ok "CSRF token généré correctement"
else
    status_error "Impossible de générer CSRF token"
fi

# Test Sessions
echo -e "\n6.2 Test sessions:"
if php artisan tinker --execute="session()->put('test', 'ok'); echo session()->get('test');" 2>/dev/null | grep -q "ok"; then
    status_ok "Sessions fonctionnelles"
else
    status_error "Problème avec les sessions"
fi

# Test URL Admin
echo -e "\n6.3 Test accès admin:"
if command -v curl >/dev/null 2>&1; then
    if [ ! -z "$APP_URL" ] && [[ "$APP_URL" != *"votre-domaine"* ]]; then
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL/admin" 2>/dev/null || echo "ERROR")
        case $HTTP_CODE in
            200) status_ok "Page admin accessible (200)" ;;
            403) status_error "Erreur 403 - Accès interdit" ;;
            404) status_error "Erreur 404 - Page non trouvée" ;;
            500) status_error "Erreur 500 - Erreur serveur" ;;
            *) status_warning "Code de réponse: $HTTP_CODE" ;;
        esac
    else
        status_info "Test URL ignoré (URL non configurée)"
    fi
else
    status_info "curl non disponible pour test HTTP"
fi

echo -e "\n📊 ÉTAPE 7: RÉSUMÉ ET RECOMMANDATIONS"
echo "===================================="

echo "Configuration actuelle:"
echo "• PHP: $PHP_VERSION"
echo "• Laravel: $(php artisan --version 2>/dev/null | cut -d' ' -f3 || echo 'Non détecté')"
echo "• Filament: $(composer show filament/filament 2>/dev/null | grep versions | awk '{print $3}' || echo 'Non installé')"
echo "• Environnement: $APP_ENV"
echo "• Sessions: $SESSION_DRIVER"

echo -e "\n🚀 ACTIONS RECOMMANDÉES:"
echo "======================="

# Génération des solutions
cat << 'EOF'

1. Si erreur de connexion DB:
   • Vérifiez les credentials dans l'interface Forge
   • Testez: mysql -u forge -p krine_tattoo

2. Si Filament non accessible:
   • php artisan filament:assets
   • php artisan optimize:clear
   • chmod -R 775 storage bootstrap/cache

3. Si erreur 403:
   • ./fix-403-immediate.sh
   • Videz le cache navigateur complètement

4. Si erreur 500:
   • tail -f storage/logs/laravel.log
   • php artisan config:cache

5. Configuration Forge optimale:
   • PHP 8.1+ 
   • Node.js installé
   • Redis activé
   • Queue worker configuré

EOF

echo -e "\n✨ Diagnostic Forge terminé !"
echo "Pour une correction automatique, exécutez: ./filament-forge-fix.sh"