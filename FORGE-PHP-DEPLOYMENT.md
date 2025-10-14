# 🐘 Script PHP de Déploiement Laravel Forge

## 🚀 **Script PHP Complet**

Le script `forge-deploy.php` est une solution complète en PHP pur pour le déploiement sur Laravel Forge.

---

## ✨ **Avantages du script PHP**

### ✅ **Plus robuste que Bash**
- Gestion d'erreurs avancée
- Parsing précis des fichiers `.env`
- Tests intelligents de l'état de l'application

### ✅ **Meilleur feedback**
- Messages colorés dans le terminal
- Résumé détaillé des actions
- Temps d'exécution et statistiques

### ✅ **Plus intelligent**
- Détection automatique production/développement
- Tests conditionnels (DB, sessions, etc.)
- Fallback automatique en cas de problème

---

## 🎯 **Fonctionnalités complètes**

### **1. Résolution erreur 500**
```php
// Test et correction automatique des sessions
private function configureSessionsForStability()
{
    if (db_inaccessible) {
        // Passage automatique en sessions fichier
        updateEnvValue('SESSION_DRIVER', 'file');
    }
}
```

### **2. Configuration Filament v3**
```php
// Installation panel si nécessaire
if (!file_exists('app/Providers/Filament/AdminPanelProvider.php')) {
    execCommand("php artisan filament:install --panels --quiet");
}
```

### **3. Tests exhaustifs**
```php
// Vérification routes, CSRF, sessions
private function step8_tests()
{
    // Test routes Filament
    // Test tokens CSRF
    // Test sessions
}
```

---

## 🔧 **Utilisation**

### **Sur Laravel Forge :**

#### **1. Hook de déploiement automatique**
Dans Forge → Deployment → Deploy Script :
```bash
cd /home/forge/votre-domaine.com
git pull origin main
php forge-deploy.php
```

#### **2. Déploiement manuel**
```bash
ssh forge@votre-serveur
cd /home/forge/votre-domaine.com
php forge-deploy.php
```

#### **3. Exécution locale**
```bash
php forge-deploy.php
```

---

## 📊 **Sortie détaillée**

```
🚀 Déploiement Laravel Forge - K'rine Tattoo + Filament v3
=================================================================
Version: 1.0.0
Date: 2025-01-14 10:30:45
Environnement: Production

📋 ÉTAPE 1: PRÉPARATION
========================
✅ Permissions d'écriture OK
✅ Sauvegarde .env créée: .env.backup.20250114_103045
✅ PHP 8.2.0 compatible

📋 ÉTAPE 2: DÉPENDANCES
=======================
ℹ️  Installation des dépendances Composer...
✅ Dépendances Composer installées
✅ Filament v3.3.43 détecté

[... autres étapes ...]

🎉 DÉPLOIEMENT TERMINÉ AVEC SUCCÈS !
====================================

📊 RÉSUMÉ:
• Application Laravel: ✅ Opérationnelle
• Filament v3: ✅ Installé et configuré
• Panel admin: ✅ Disponible sur /admin
• Sessions: ✅ Mode file
• Base de données: ✅ Connectée
• Permissions: ✅ Configurées
• Durée: 45.2s

🔗 ACCÈS:
• Site web: https://votre-domaine.com
• Dashboard Filament: https://votre-domaine.com/admin

👤 CRÉATION ADMIN:
php create-admin-forge.php
```

---

## 🛠️ **Fonctionnalités avancées**

### **Gestion d'erreurs intelligente**
```php
// Fallback automatique si DB inaccessible
if (strpos($dbTest['output'], 'DB_OK') === false) {
    $this->warning("DB inaccessible - passage en sessions fichier");
    $this->updateEnvValue('SESSION_DRIVER', 'file');
}
```

### **Détection d'environnement**
```php
// Optimisations uniquement en production
if ($this->isProduction) {
    $this->execCommand("php artisan config:cache");
    $this->execCommand("php artisan route:cache");
}
```

### **Tests complets**
```php
// Vérification fonctionnalités
$routeCount = execCommand("php artisan route:list | grep filament | wc -l");
$csrfTest = execCommand("php artisan tinker --execute=\"echo csrf_token();\"");
$sessionTest = execCommand("php artisan tinker --execute=\"session()->put('test', 'ok');\"");
```

---

## 🎨 **Personnalisation**

### **Modifier la configuration**
```php
// En haut du fichier
const APP_NAME = "Votre App";
const SCRIPT_VERSION = '1.1.0';

// Changer les credentials admin par défaut
$email = "admin@votre-domaine.com";
$password = "VotreMotDePasse2024!";
```

### **Ajouter des étapes**
```php
private function step10_customSteps()
{
    $this->printStep(10, "ÉTAPES PERSONNALISÉES");
    
    // Vos actions personnalisées
    $this->execCommand("php artisan queue:restart");
    $this->success("Queue redémarrée");
}
```

---

## 🔍 **Débogage**

### **Mode verbose**
Le script affiche automatiquement :
- Chaque action effectuée
- Les erreurs rencontrées
- Les avertissements
- Le temps d'exécution

### **Logs détaillés**
```php
// Ajouter du logging personnalisé
private function logAction($action, $result)
{
    $logEntry = date('Y-m-d H:i:s') . " - $action: $result\n";
    file_put_contents('deploy.log', $logEntry, FILE_APPEND);
}
```

---

## 🚨 **Gestion d'erreurs**

### **Erreurs non-fatales**
- Problème de base de données → Fallback sessions fichier
- Assets manquants → Republication automatique
- Permissions → Correction automatique

### **Erreurs fatales**
- PHP incompatible
- Permissions répertoire principal
- Laravel non fonctionnel

---

## 📋 **Checklist de déploiement**

### **Avant le déploiement**
- [ ] Code pushé sur le repository
- [ ] Variables `.env` configurées sur Forge
- [ ] Base de données créée (optionnel)

### **Après le déploiement**
- [ ] Vérifier l'accès : `curl -I https://votre-domaine.com`
- [ ] Tester l'admin : `https://votre-domaine.com/admin`
- [ ] Créer l'admin : `php create-admin-forge.php`
- [ ] Vérifier les logs : `tail -f storage/logs/laravel.log`

---

## 💡 **Conseils d'optimisation**

### **Performance**
- Script optimisé pour la production
- Cache automatique des configurations
- Autoloader optimisé

### **Sécurité**
- Permissions strictes
- Sauvegarde automatique
- Variables sensibles protégées

### **Maintenance**
- Logs de déploiement
- Rollback possible via sauvegardes
- Tests automatiques

---

**✨ Le script PHP offre la solution la plus robuste et intelligente pour déployer votre application sur Laravel Forge !**