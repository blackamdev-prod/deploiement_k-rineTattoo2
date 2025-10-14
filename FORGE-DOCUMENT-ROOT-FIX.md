# 🚨 FIX CRITIQUE: Document Root Laravel Forge

## PROBLÈME IDENTIFIÉ
**"No input file specified"** = Document Root mal configuré dans Laravel Forge

## SOLUTION IMMÉDIATE

### 1. Dans Laravel Forge Panel

1. **Connectez-vous à Laravel Forge**
2. **Sites** → **deploiement_krinetattoo-pobc9vdh**
3. **Onglet "Settings"** ou **"General"**
4. **Document Root** → Modifier :

   **❌ INCORRECT (cause du problème):**
   ```
   /home/forge/deploiement_krinetattoo-pobc9vdh.on-forge.com
   ```

   **✅ CORRECT (solution):**
   ```
   /home/forge/deploiement_krinetattoo-pobc9vdh.on-forge.com/public
   ```

5. **Cliquer "Update"** ou **"Save"**
6. **Attendre 1-2 minutes** pour propagation

### 2. Alternative via SSH Forge

```bash
# Connexion SSH
ssh forge@your-server-ip

# Vérifier le path actuel
cd /home/forge/deploiement_krinetattoo-pobc9vdh.on-forge.com
pwd
ls -la

# Vérifier que public/index.php existe
ls -la public/index.php

# Si nécessaire, corriger les permissions
chmod 755 public
chmod 644 public/index.php
chmod 644 public/.htaccess
```

### 3. Test immédiat après changement

```bash
curl -I https://deploiement_krinetattoo-pobc9vdh.on-forge.com
```

**Doit retourner `200 OK` au lieu de `403` ou `No input file specified`**

## POURQUOI CE PROBLÈME ?

Laravel nécessite que le Document Root pointe vers le dossier `/public`, pas vers la racine du projet :

- **Racine projet** : `/home/forge/domain.com` → ❌ Expose les fichiers sensibles  
- **Dossier public** : `/home/forge/domain.com/public` → ✅ Sécurisé et correct

## VÉRIFICATION POST-FIX

Après changement du Document Root, ces URLs doivent fonctionner :

- ✅ `https://deploiement_krinetattoo-pobc9vdh.on-forge.com` → Page d'accueil Laravel
- ✅ `https://deploiement_krinetattoo-pobc9vdh.on-forge.com/admin` → Login Filament
- ✅ Tous les assets (CSS, JS, images)

## SI LE PROBLÈME PERSISTE

Si même avec le bon Document Root vous avez des erreurs :

1. **Vérifier SSL** : Doit être actif et valide
2. **Nginx Configuration** : Vérifier qu'elle est standard Laravel
3. **Permissions serveur** : Problème plus profond nécessitant support Forge

**LE DOCUMENT ROOT EST LA CAUSE N°1 des erreurs 403/"No input file specified" sur Laravel Forge.**