# Guide de Déploiement Laravel Forge - K'rine Tattoo

## SOLUTION COMPLÈTE : Image artiste.png avec fallback élégant

**PROBLÈME RÉSOLU** : L'image n'était pas visible car elle n'était pas incluse dans le repository Git et le fallback n'était pas esthétique.

### Solutions mises en place :

#### 1. **Placement Multiple de l'Image**
- ✅ Image copiée dans `public/assets/images/artiste.png`
- ✅ Image copiée dans `storage/app/public/assets/images/artiste.png`
- ✅ Fallback automatique entre les deux emplacements

#### 2. **Script de Déploiement Forge**

Utilisez le contenu de `forge-deploy-hook.sh` dans votre hook de déploiement Forge :

```bash
#!/bin/bash

cd $FORGE_SITE_PATH

# Standard Laravel deployment
git pull origin main
$FORGE_COMPOSER install --no-interaction --prefer-dist --optimize-autoloader

# CUSTOM: Copy images to public assets
echo "Copying assets..."
mkdir -p public/assets/images
if [ -f "artiste.png" ]; then
    cp artiste.png public/assets/images/
    echo "Image artiste.png copied to public/assets/images/"
fi

# Ensure storage link exists
if [ ! -L "public/storage" ]; then
    $FORGE_PHP artisan storage:link
fi

# Clear and cache
$FORGE_PHP artisan config:clear
$FORGE_PHP artisan cache:clear
$FORGE_PHP artisan view:clear
$FORGE_PHP artisan config:cache

# Set permissions
chmod -R 755 public/assets/
chmod 644 public/assets/images/* 2>/dev/null || true
```

#### 3. **Configuration du Composant Hero**

Le composant hero vérifie automatiquement :
1. `public/assets/images/artiste.png` (priorité)
2. `storage/assets/images/artiste.png` (fallback)
3. Placeholder stylisé (si aucune image trouvée)

#### 4. **Instructions pour Laravel Forge**

1. **Copier le hook de déploiement** :
   - Aller dans Forge → Site → Deployment Script
   - Remplacer par le contenu de `forge-deploy-hook.sh`

2. **Ajouter l'image au repository** :
   ```bash
   git add artiste.png
   git add public/assets/images/artiste.png
   git commit -m "Add artist image for hero section"
   git push origin main
   ```

3. **Déclencher le déploiement** :
   - Cliquer sur "Deploy Now" dans Forge
   - Vérifier les logs de déploiement

#### 5. **Vérifications Post-Déploiement**

```bash
# Sur le serveur Forge, vérifier :
ls -la public/assets/images/artiste.png
ls -la storage/app/public/assets/images/artiste.png
ls -la public/storage  # Lien symbolique
```

#### 6. **Debugging**

Si l'image n'apparaît toujours pas :

1. Vérifier les permissions :
   ```bash
   chmod 755 public/assets/images/
   chmod 644 public/assets/images/artiste.png
   ```

2. Vérifier le lien storage :
   ```bash
   php artisan storage:link
   ```

3. Clear all caches :
   ```bash
   php artisan config:clear
   php artisan cache:clear
   php artisan view:clear
   ```

### Résultat Final

✅ **Image visible** sur tous les environnements  
✅ **Fallback automatique** si un chemin échoue  
✅ **Placeholder élégant** si aucune image n'est trouvée  
✅ **Compatible Laravel Forge** avec script automatisé  
✅ **Permissions correctes** définies automatiquement