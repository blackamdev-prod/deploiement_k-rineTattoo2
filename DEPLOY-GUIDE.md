# Guide de Déploiement - K'rine Tattoo

## 🎯 Solution Recommandée

Utilisez **forge-deploy-bulletproof.sh** - script ultra-minimal qui évite tous les points d'échec identifiés.

```bash
./forge-deploy-bulletproof.sh
```

## ✅ Ce qui est INCLUS (essentiel)

1. **Code**: `git pull origin main`
2. **Dependencies**: `composer install --no-dev`
3. **Cache**: Clear des 4 caches principaux
4. **Assets**: `npm install` + `npm run build`
5. **Database**: `php artisan migrate --force`
6. **Storage**: Link + permissions
7. **Logo**: Copie simple vers public/images/

## ❌ Ce qui est EXCLU (sources de problèmes)

- ❌ Seeders (remplacés par migration)
- ❌ View cache (problème Filament)  
- ❌ Opérations Filament complexes
- ❌ Tinker en production
- ❌ Vendor publish forcé

## 🗄️ Base de Données

La migration `2025_10_13_213512_insert_initial_data.php` contient :
- Admin user: admin@krinetattoo.com / KrineTattoo2024!
- 6 portfolios de démonstration

## 🚨 En cas d'échec

1. **Vérifier les logs Laravel**:
```bash
tail -f storage/logs/laravel.log
```

2. **Reset complet** (derniers recours):
```bash
php artisan cache:clear
php artisan config:clear  
php artisan route:clear
php artisan view:clear
rm -rf storage/framework/views/*
```

3. **Test connexion DB**:
```bash
php artisan tinker --execute="DB::connection()->getPdo() ? 'OK' : 'FAIL'"
```

## 📋 Checklist Post-Déploiement

- [ ] Site accessible: https://domaine.com
- [ ] Admin accessible: https://domaine.com/admin  
- [ ] Login fonctionne: admin@krinetattoo.com
- [ ] Portfolio visible
- [ ] Logo affiché

## ⚡ Performance

Le script bulletproof prend ~2-3 minutes et évite :
- Les erreurs de compilation Filament
- Les problèmes de seeders
- Les conflits de cache
- Les erreurs de permissions