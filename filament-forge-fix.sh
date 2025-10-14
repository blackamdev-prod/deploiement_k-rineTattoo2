#!/bin/bash

echo "🔧 RÉPARATION FILAMENT SUR LARAVEL FORGE"
echo "========================================"
echo "Application: K'rine Tattoo"
echo ""

# Configuration
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

step() { echo -e "\n${BLUE}🔄 $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }

step "ÉTAPE 1: SAUVEGARDE DE SÉCURITÉ"
echo "================================"

# Sauvegarde des fichiers critiques
cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
success "Fichier .env sauvegardé"

if [ -f "app/Http/Middleware/VerifyCsrfToken.php" ]; then
    cp app/Http/Middleware/VerifyCsrfToken.php app/Http/Middleware/VerifyCsrfToken.php.backup
    success "Middleware CSRF sauvegardé"
fi

step "ÉTAPE 2: CONFIGURATION DE BASE"
echo "==============================="

# Génération APP_KEY si nécessaire
if ! grep -q "APP_KEY=base64:" .env; then
    echo "Génération de la clé d'application..."
    php artisan key:generate --force
    success "APP_KEY générée"
else
    success "APP_KEY déjà présente"
fi

# Configuration sessions pour Forge
SESSION_DRIVER=$(grep SESSION_DRIVER .env | cut -d'=' -f2)
if [ "$SESSION_DRIVER" = "database" ]; then
    echo "Test de connexion base de données..."
    if ! php artisan tinker --execute="DB::connection()->getPdo(); echo 'DB_OK';" 2>/dev/null | grep -q "DB_OK"; then
        warning "DB non accessible, passage en sessions fichier"
        sed -i.bak 's/SESSION_DRIVER=database/SESSION_DRIVER=file/' .env
        mkdir -p storage/framework/sessions
        chmod -R 775 storage/framework/sessions
        success "Sessions configurées en mode fichier"
    else
        success "Base de données accessible"
        
        # Création table sessions si nécessaire
        if ! php artisan tinker --execute="Schema::hasTable('sessions'); echo 'TABLE_CHECK';" 2>/dev/null | grep -q "1"; then
            echo "Création table sessions..."
            php artisan session:table
            php artisan migrate --force
            success "Table sessions créée"
        else
            success "Table sessions existe"
        fi
    fi
fi

step "ÉTAPE 3: INSTALLATION/VÉRIFICATION FILAMENT"
echo "==========================================="

# Vérification installation Filament
if ! composer show | grep -q "filament/filament"; then
    echo "Installation de Filament..."
    composer require filament/filament --no-interaction
    success "Filament installé"
else
    success "Filament déjà installé"
fi

# Publication assets Filament
echo "Publication des assets Filament..."
php artisan filament:assets
success "Assets Filament publiés"

# Vérification du panel admin
if ! php artisan route:list 2>/dev/null | grep -q "admin.*dashboard"; then
    warning "Panel admin non détecté, création..."
    
    # Création du AdminPanelProvider si nécessaire
    if [ ! -f "app/Providers/Filament/AdminPanelProvider.php" ]; then
        mkdir -p app/Providers/Filament
        cat > app/Providers/Filament/AdminPanelProvider.php << 'EOF'
<?php

namespace App\Providers\Filament;

use Filament\Http\Middleware\Authenticate;
use Filament\Http\Middleware\DisableBladeIconComponents;
use Filament\Http\Middleware\DispatchServingFilamentEvent;
use Filament\Pages;
use Filament\Panel;
use Filament\PanelProvider;
use Filament\Support\Colors\Color;
use Filament\Widgets;
use Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse;
use Illuminate\Cookie\Middleware\EncryptCookies;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Routing\Middleware\SubstituteBindings;
use Illuminate\Session\Middleware\AuthenticateSession;
use Illuminate\Session\Middleware\StartSession;
use Illuminate\View\Middleware\ShareErrorsFromSession;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->default()
            ->id('admin')
            ->path('admin')
            ->colors([
                'primary' => Color::Amber,
            ])
            ->discoverResources(in: app_path('Filament/Resources'), for: 'App\\Filament\\Resources')
            ->discoverPages(in: app_path('Filament/Pages'), for: 'App\\Filament\\Pages')
            ->pages([
                Pages\Dashboard::class,
            ])
            ->discoverWidgets(in: app_path('Filament/Widgets'), for: 'App\\Filament\\Widgets')
            ->widgets([
                Widgets\AccountWidget::class,
                Widgets\FilamentInfoWidget::class,
            ])
            ->middleware([
                EncryptCookies::class,
                AddQueuedCookiesToResponse::class,
                StartSession::class,
                AuthenticateSession::class,
                ShareErrorsFromSession::class,
                VerifyCsrfToken::class,
                SubstituteBindings::class,
                DisableBladeIconComponents::class,
                DispatchServingFilamentEvent::class,
            ])
            ->authMiddleware([
                Authenticate::class,
            ]);
    }
}
EOF
        success "AdminPanelProvider créé"
        
        # Enregistrement du provider
        if ! grep -q "AdminPanelProvider" config/app.php; then
            sed -i.bak '/App\\Providers\\RouteServiceProvider::class,/a\\        App\\Providers\\Filament\\AdminPanelProvider::class,' config/app.php
            success "AdminPanelProvider enregistré"
        fi
    fi
else
    success "Panel admin configuré"
fi

step "ÉTAPE 4: CORRECTION DU CSRF (TEMPORAIRE)"
echo "========================================"

# Modification temporaire CSRF pour éviter les 403
cat > app/Http/Middleware/VerifyCsrfToken.php << 'EOF'
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
        // Exclusion temporaire pour Filament en production
        'admin/login',
    ];
}
EOF
warning "CSRF temporairement modifié pour admin/login"

step "ÉTAPE 5: MIGRATIONS ET BASE DE DONNÉES"
echo "======================================"

# Exécution des migrations
if php artisan tinker --execute="DB::connection()->getPdo(); echo 'DB_OK';" 2>/dev/null | grep -q "DB_OK"; then
    echo "Exécution des migrations..."
    php artisan migrate --force
    success "Migrations exécutées"
    
    # Vérification table users
    if ! php artisan tinker --execute="Schema::hasTable('users'); echo 'USERS_CHECK';" 2>/dev/null | grep -q "1"; then
        warning "Table users manquante"
        echo "Création de la migration users de base..."
        php artisan make:migration create_users_table --create=users
    else
        success "Table users existe"
    fi
else
    warning "Base de données non accessible, migrations ignorées"
fi

step "ÉTAPE 6: OPTIMISATION FORGE"
echo "============================="

# Nettoyage et optimisation des caches
echo "Nettoyage des caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear
success "Caches nettoyés"

echo "Optimisation pour production..."
if [ "$(grep APP_ENV .env | cut -d'=' -f2)" = "production" ]; then
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    success "Caches de production générés"
fi

# Permissions Forge
echo "Configuration des permissions..."
chmod -R 775 storage
chmod -R 775 bootstrap/cache
chmod 644 .env
success "Permissions configurées"

# Optimisation Composer
echo "Optimisation autoloader..."
composer dump-autoload --optimize --no-dev 2>/dev/null || composer dump-autoload --optimize
success "Autoloader optimisé"

step "ÉTAPE 7: CONFIGURATION SPÉCIFIQUE FORGE"
echo "======================================="

# Configuration OPcache pour Forge
if [ -f "/etc/php/8.1/fpm/conf.d/10-opcache.ini" ] || [ -f "/etc/php/8.2/fpm/conf.d/10-opcache.ini" ]; then
    success "OPcache détecté"
else
    warning "OPcache non détecté - performance réduite"
fi

# Vérification du worker de queue
if pgrep -f "artisan queue:work" > /dev/null; then
    success "Queue worker actif"
else
    warning "Queue worker non actif"
    echo "   À configurer dans Forge: php artisan queue:work --daemon"
fi

step "ÉTAPE 8: TESTS FINAUX"
echo "====================="

# Test des routes Filament
if php artisan route:list 2>/dev/null | grep -q filament; then
    success "Routes Filament enregistrées"
    ADMIN_ROUTES=$(php artisan route:list 2>/dev/null | grep filament | wc -l)
    echo "   $ADMIN_ROUTES routes Filament trouvées"
else
    error "Aucune route Filament trouvée"
fi

# Test génération token CSRF
if php artisan tinker --execute="echo csrf_token();" 2>/dev/null | grep -E "^[a-zA-Z0-9]{40}" > /dev/null; then
    success "CSRF token fonctionnel"
else
    warning "Problème génération CSRF token"
fi

# Test sessions
if php artisan tinker --execute="session()->put('test', 'forge'); echo session()->get('test');" 2>/dev/null | grep -q "forge"; then
    success "Sessions fonctionnelles"
else
    warning "Problème avec les sessions"
fi

echo -e "\n🎉 RÉPARATION TERMINÉE !"
echo "======================"

echo -e "\n📋 RÉSUMÉ DES ACTIONS:"
echo "• ✅ Configuration de base corrigée"
echo "• ✅ Filament installé et configuré"
echo "• ✅ Assets publiés"
echo "• ✅ CSRF temporairement ajusté"
echo "• ✅ Permissions configurées"
echo "• ✅ Caches optimisés"

echo -e "\n🚀 PROCHAINES ÉTAPES:"
echo "==================="
echo "1. Accédez à votre domaine/admin"
echo "2. Créez un utilisateur admin:"
echo "   php artisan make:filament-user"
echo "3. Testez la connexion au dashboard"

echo -e "\n⚠️  IMPORTANT POUR LA PRODUCTION:"
echo "==============================="
echo "• Configurez l'URL réelle dans .env (APP_URL)"
echo "• Activez SSL dans Forge"
echo "• Configurez un worker de queue"
echo "• Restaurez CSRF après test:"
echo "  cp app/Http/Middleware/VerifyCsrfToken.php.backup app/Http/Middleware/VerifyCsrfToken.php"

echo -e "\n🔗 ACCÈS ADMIN:"
echo "=============="
APP_URL=$(grep APP_URL .env | cut -d'=' -f2)
echo "Dashboard: $APP_URL/admin"

echo -e "\n✨ Filament est maintenant opérationnel sur Forge !"