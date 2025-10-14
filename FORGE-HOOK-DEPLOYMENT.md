# 🚀 Hook de Déploiement Laravel Forge

## Configuration du hook dans Forge

### 1. Dans l'interface Forge

1. Allez dans votre serveur → votre site
2. Cliquez sur l'onglet **"Deployment"**
3. Dans **"Deploy Script"**, collez le contenu ci-dessous :

```bash
cd /home/forge/votre-domaine.com

# Git pull pour récupérer les dernières modifications
git pull origin main

# Exécution du script de déploiement
./forge-deploy-filament-v3.sh

# Redémarrage des services si nécessaire
if [ -f /etc/supervisor/conf.d/votre-domaine.com.conf ]; then
    sudo supervisorctl restart votre-domaine.com-worker:*
fi

# Rechargement PHP-FPM
sudo service php8.2-fpm reload
```

### 2. Activation du déploiement automatique

1. Dans **"Auto Deployment"**, activez le déploiement automatique
2. Choisissez la branche `main`
3. Sauvegardez

---

## Script de déploiement complet

Le script `forge-deploy-filament-v3.sh` effectue :

### ✅ **Résolution erreur 500**
- Nettoyage des caches Laravel
- Configuration sessions fichier (contourne problème DB)
- Correction des permissions

### ✅ **Configuration Filament v3**
- Installation/vérification du panel admin
- Publication des assets
- Configuration des routes `/admin`

### ✅ **Optimisations production**
- Cache des configurations
- Optimisation Composer
- Permissions sécurisées

### ✅ **Gestion base de données**
- Test de connexion automatique
- Migrations si DB disponible
- Fallback sessions fichier sinon

---

## Variables d'environnement Forge

Dans l'interface Forge → **Environment**, configurez :

```env
APP_NAME="K'rine Tattoo"
APP_ENV=production
APP_KEY=base64:VOTRE_CLE_GENEREE
APP_DEBUG=false
APP_URL=https://votre-domaine.com

# Base de données (configurée automatiquement par Forge)
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=forge
DB_USERNAME=forge
DB_PASSWORD=GENERE_PAR_FORGE

# Sessions et Cache
SESSION_DRIVER=file
SESSION_LIFETIME=120
CACHE_STORE=file
QUEUE_CONNECTION=database

# Mail (optionnel)
MAIL_MAILER=log
```

---

## Commandes post-déploiement

### Après le premier déploiement :

```bash
# SSH dans votre serveur Forge
ssh forge@votre-ip

# Aller dans le répertoire
cd /home/forge/votre-domaine.com

# Créer l'utilisateur admin (si DB configurée)
php create-admin-forge.php
```

---

## Tests et validation

### 1. Vérifier le déploiement
```bash
# Test de l'application
curl -I https://votre-domaine.com

# Test de l'admin Filament
curl -I https://votre-domaine.com/admin
```

### 2. Logs en cas de problème
```bash
# Logs Laravel
tail -f storage/logs/laravel.log

# Logs Nginx
tail -f /var/log/nginx/votre-domaine.com-error.log

# Logs PHP-FPM
tail -f /var/log/php8.2-fpm.log
```

---

## Déploiement manuel

Si vous préférez déployer manuellement :

```bash
# SSH dans Forge
ssh forge@votre-ip

# Aller dans le répertoire
cd /home/forge/votre-domaine.com

# Pull des modifications
git pull origin main

# Exécuter le script
./forge-deploy-filament-v3.sh
```

---

## Résolution de problèmes

### Erreur 500 persistante
```bash
# Permissions
chmod -R 775 storage bootstrap/cache

# Nettoyage complet
php artisan optimize:clear

# Vérifier .env
cat .env | grep -E "(APP_KEY|SESSION_DRIVER|DB_)"
```

### Admin Filament inaccessible
```bash
# Vérifier routes
php artisan route:list | grep admin

# Republier assets
php artisan filament:assets

# Créer utilisateur
php create-admin-forge.php
```

### Base de données inaccessible
```bash
# Test connexion
php artisan tinker
# Dans tinker: DB::connection()->getPdo();

# Passer en sessions fichier
sed -i 's/SESSION_DRIVER=database/SESSION_DRIVER=file/' .env
```

---

## Support

En cas de problème :

1. **Vérifiez les logs** Laravel et Nginx
2. **Exécutez le diagnostic** : `php fix-500-error.php`
3. **Testez manuellement** : `./forge-deploy-filament-v3.sh`
4. **Contactez le support** avec les logs d'erreur

---

**✨ Avec cette configuration, votre application sera déployée automatiquement à chaque push sur main !**