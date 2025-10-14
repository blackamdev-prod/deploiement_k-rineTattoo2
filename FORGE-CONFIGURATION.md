# 🚀 Configuration Optimale Filament sur Laravel Forge

## Guide complet pour K'rine Tattoo

---

## 📋 **Checklist pré-déploiement**

### ✅ **Serveur Forge requis :**
- [x] PHP 8.1+ 
- [x] MySQL 8.0+
- [x] Node.js 18+
- [x] Redis activé
- [x] SSL configuré

---

## 🔧 **Configuration étape par étape**

### **1. Configuration du serveur Forge**

#### **a) Variables d'environnement (.env)**
```env
APP_NAME="K'rine Tattoo"
APP_ENV=production
APP_KEY=base64:VOTRE_CLE_GENEREE
APP_DEBUG=false
APP_URL=https://votre-domaine.com

# Base de données
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=krine_tattoo
DB_USERNAME=forge
DB_PASSWORD=MOT_DE_PASSE_SECURISE

# Sessions et Cache
SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
CACHE_STORE=redis
QUEUE_CONNECTION=database

# Mail (optionnel)
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailgun.org
MAIL_PORT=587
MAIL_USERNAME=
MAIL_PASSWORD=
```

#### **b) Configuration PHP (dans Forge)**
```ini
# Optimisations recommandées
post_max_size = 64M
upload_max_filesize = 64M
max_execution_time = 300
memory_limit = 512M

# OPcache (activé par défaut sur Forge)
opcache.enable=1
opcache.memory_consumption=256
opcache.max_accelerated_files=20000
```

### **2. Script de déploiement Forge**

#### **Hook de déploiement automatique :**
```bash
cd /home/forge/votre-domaine.com

# Mise à jour du code
git pull origin main

# Installation des dépendances
composer install --no-dev --optimize-autoloader

# Migrations et optimisations
php artisan migrate --force
php artisan filament:assets
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Permissions
chmod -R 775 storage bootstrap/cache

# Redémarrage des services
sudo supervisorctl restart krine-tattoo-worker:*
```

### **3. Configuration spécifique Filament**

#### **a) Panel Provider (si manquant)**
Créez `app/Providers/Filament/AdminPanelProvider.php` :
```php
<?php

namespace App\Providers\Filament;

use Filament\Panel;
use Filament\PanelProvider;
use Filament\Support\Colors\Color;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->default()
            ->id('admin')
            ->path('admin')
            ->colors(['primary' => Color::Amber])
            ->discoverResources(in: app_path('Filament/Resources'), for: 'App\\Filament\\Resources')
            ->pages([Pages\Dashboard::class])
            ->widgets([
                Widgets\AccountWidget::class,
                Widgets\FilamentInfoWidget::class,
            ]);
    }
}
```

#### **b) Enregistrement dans config/app.php :**
```php
'providers' => [
    // ...
    App\Providers\Filament\AdminPanelProvider::class,
],
```

---

## 🚨 **Résolution des problèmes courants**

### **Problème 1: Erreur 403 FORBIDDEN**

**Causes :**
- Sessions non fonctionnelles
- CSRF token invalide
- Base de données inaccessible

**Solutions immédiates :**
```bash
# 1. Utiliser le script de correction
./filament-forge-fix.sh

# 2. Ou manuellement :
# Changer sessions vers fichier
sed -i 's/SESSION_DRIVER=database/SESSION_DRIVER=file/' .env

# Vider les caches
php artisan config:clear
php artisan cache:clear

# Corriger permissions
chmod -R 775 storage
```

### **Problème 2: Routes Filament non trouvées**

**Solution :**
```bash
# Vérifier l'installation
composer require filament/filament

# Publier les assets
php artisan filament:assets

# Vérifier les routes
php artisan route:list | grep filament
```

### **Problème 3: Erreur de base de données**

**Solutions :**
```bash
# Tester la connexion
php artisan tinker
# Dans tinker : DB::connection()->getPdo();

# Créer la base si nécessaire
mysql -u root -p
CREATE DATABASE krine_tattoo;
```

### **Problème 4: Assets non chargés**

**Solutions :**
```bash
# Republier les assets
php artisan filament:assets

# Vider le cache des vues
php artisan view:clear

# Vérifier les permissions
ls -la public/
```

---

## ⚡ **Optimisations performance Forge**

### **1. Configuration Redis**
```bash
# Dans Forge, activer Redis
# Puis dans .env :
CACHE_STORE=redis
SESSION_DRIVER=redis  # Alternative à database
QUEUE_CONNECTION=redis
```

### **2. Queue Workers**
```bash
# Configuration dans Forge > Queue
# Commande : php artisan queue:work --daemon
# Processus : 3
# Auto-restart : Oui
```

### **3. Scheduled Jobs**
```bash
# Dans Forge > Scheduler
# Commande : php artisan schedule:run
# Fréquence : Chaque minute
```

### **4. Monitoring**
```bash
# Installation Horizon (optionnel)
composer require laravel/horizon
php artisan horizon:install
php artisan horizon:publish
```

---

## 🔐 **Sécurité en production**

### **1. Variables sensibles**
```bash
# Générer des mots de passe forts
APP_KEY=base64:$(php artisan key:generate --show)
DB_PASSWORD=$(openssl rand -base64 32)
```

### **2. Permissions strictes**
```bash
# Fichiers
find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;

# Répertoires spéciaux
chmod -R 775 storage bootstrap/cache
chmod 600 .env
```

### **3. Configuration SSL**
- Activer "Force HTTPS" dans Forge
- Configurer `APP_URL=https://...`
- Redirection automatique HTTP → HTTPS

---

## 📊 **Tests et validation**

### **Tests automatiques :**
```bash
# Exécuter le diagnostic
./filament-forge-diagnostic.sh

# Tests manuels
curl -I https://votre-domaine.com/admin
php artisan route:list | grep filament
php artisan tinker # puis Session::put('test', 'ok')
```

### **Création du premier admin :**
```bash
php artisan make:filament-user
# Suivre les instructions interactives
```

---

## 🎯 **Checklist post-déploiement**

- [ ] ✅ Application accessible via le domaine
- [ ] ✅ Dashboard Filament sur `/admin`
- [ ] ✅ Connexion admin fonctionnelle
- [ ] ✅ SSL activé et fonctionnel
- [ ] ✅ Base de données connectée
- [ ] ✅ Sessions fonctionnelles
- [ ] ✅ Caches optimisés
- [ ] ✅ Queue workers actifs
- [ ] ✅ Permissions correctes
- [ ] ✅ Logs accessibles (`storage/logs/`)

---

## 📞 **Support et dépannage**

### **Logs importants :**
```bash
# Laravel
tail -f storage/logs/laravel.log

# Nginx (sur Forge)
tail -f /var/log/nginx/votre-domaine.com-error.log

# PHP-FPM
tail -f /var/log/php8.1-fpm.log
```

### **Commandes de diagnostic :**
```bash
# Status général
./filament-forge-diagnostic.sh

# Test rapide Filament
php artisan route:list | grep filament
composer show filament/filament

# Test base de données
php artisan migrate:status
```

---

## 🎉 **Ressources utiles**

- **Documentation Filament :** [filamentphp.com](https://filamentphp.com)
- **Laravel Forge :** [forge.laravel.com](https://forge.laravel.com)
- **Support Forge :** support@laravel.com

---

**🚀 Avec cette configuration, Filament fonctionnera parfaitement sur Laravel Forge !**