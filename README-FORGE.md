# Déploiement K'rine Tattoo sur Laravel Forge

## 🚀 Guide de déploiement automatique

### 1. Configuration préliminaire sur Forge

Avant d'exécuter le script, configurez votre `.env` sur Laravel Forge :

```env
APP_NAME="K'rine Tattoo"
APP_ENV=production
APP_KEY=base64:B+OkELSABmuMSRMj6Kf+jUA6vP0QjxiT5xTaCOz84Sw=
APP_DEBUG=false
APP_URL=https://votre-domaine-reel.com

# Base de données (À CONFIGURER)
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=krine_tattoo
DB_USERNAME=forge
DB_PASSWORD=VOTRE_MOT_DE_PASSE_DB_ICI

# Sessions
SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=false

# Cache
CACHE_STORE=redis
QUEUE_CONNECTION=database
```

### 2. Exécution du script de déploiement

```bash
# Rendez le script exécutable
chmod +x forge-deploy.sh

# Lancez le déploiement
./forge-deploy.sh
```

### 3. Configuration manuelle après le script

#### Créer un utilisateur admin Filament :
```bash
php artisan make:filament-user
```

#### Vérifier les routes Filament :
```bash
php artisan route:list | grep filament
```

### 4. Test de l'application

- **Frontend** : `https://votre-domaine.com`
- **Admin Filament** : `https://votre-domaine.com/admin`

## 🔧 Résolution des problèmes courants

### Erreur 403 FORBIDDEN

**Cause** : Sessions non fonctionnelles ou CSRF token invalide

**Solutions** :
1. Vérifiez la connexion à la base de données
2. Vérifiez que la table `sessions` existe
3. Videz les caches : `php artisan cache:clear`

### Erreur de base de données

**Cause** : Paramètres de connexion incorrects

**Solutions** :
1. Vérifiez `DB_PASSWORD` dans `.env`
2. Vérifiez que la base de données `krine_tattoo` existe
3. Testez : `php artisan migrate:status`

### Assets Filament manquants

**Cause** : Assets non publiés

**Solution** :
```bash
php artisan filament:assets
php artisan view:cache
```

### Erreur APP_KEY

**Cause** : Clé d'application manquante ou invalide

**Solution** :
```bash
php artisan key:generate --force
php artisan config:cache
```

## 📋 Checklist post-déploiement

- [ ] ✅ Application accessible sur le domaine
- [ ] ✅ Dashboard Filament accessible sur `/admin`
- [ ] ✅ Connexion admin fonctionnelle
- [ ] ✅ SSL configuré
- [ ] ✅ Domaine configuré correctement
- [ ] ✅ Base de données connectée
- [ ] ✅ Caches optimisés

## 🔐 Sécurité en production

### Variables d'environnement critiques :
- `APP_KEY` : Généré automatiquement
- `APP_DEBUG=false` : Obligatoire en production
- `DB_PASSWORD` : Mot de passe fort
- `APP_URL` : URL réelle du site

### Permissions recommandées :
```bash
chmod -R 775 storage
chmod -R 775 bootstrap/cache
chmod 644 .env
```

## 📞 Support

En cas de problème, vérifiez les logs :
```bash
tail -f storage/logs/laravel.log
```

## 🎯 Fonctionnalités Filament incluses

- Dashboard administrateur
- Gestion des utilisateurs
- Interface d'administration moderne
- Authentification sécurisée
- Tableaux et formulaires dynamiques