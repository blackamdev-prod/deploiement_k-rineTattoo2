#!/bin/bash

# Script de configuration de la base de données pour Laravel Forge
set -e

echo "=== Configuration de la base de données K'rine Tattoo ==="

# Vérifier la connexion à la base de données
echo "1. Vérification de la connexion à la base de données..."
php artisan tinker --execute="
try {
    DB::connection()->getPdo();
    echo 'Connexion à la base de données: OK';
} catch (Exception \$e) {
    echo 'Erreur de connexion: ' . \$e->getMessage();
    exit(1);
}
"

# Vérifier l'état des migrations
echo "2. Vérification de l'état des migrations..."
php artisan migrate:status

# Exécuter les migrations si nécessaire
echo "3. Exécution des migrations..."
php artisan migrate --force

# Vérifier si le seeding est nécessaire
echo "4. Vérification des données existantes..."
PORTFOLIO_COUNT=$(php artisan tinker --execute="echo App\Models\Portfolio::count();" 2>/dev/null || echo "0")
USER_COUNT=$(php artisan tinker --execute="echo App\Models\User::count();" 2>/dev/null || echo "0")

echo "   - Portfolios existants: $PORTFOLIO_COUNT"
echo "   - Utilisateurs existants: $USER_COUNT"

# Seeder les portfolios si la table est vide
if [ "$PORTFOLIO_COUNT" = "0" ]; then
    echo "5. Ajout des données de portfolio..."
    php artisan db:seed --class=PortfolioSeeder --force
    echo "✓ Données de portfolio ajoutées"
else
    echo "5. Les données de portfolio existent déjà"
fi

# Créer un utilisateur admin si aucun utilisateur n'existe
if [ "$USER_COUNT" = "0" ]; then
    echo "6. Création d'un utilisateur administrateur..."
    php artisan tinker --execute="
    App\Models\User::create([
        'name' => 'Admin K\'rine Tattoo',
        'email' => 'admin@krinetattoo.com',
        'password' => Hash::make('KrineTattoo2024!'),
        'email_verified_at' => now(),
    ]);
    echo 'Utilisateur admin créé: admin@krinetattoo.com';
    "
    echo "✓ Utilisateur administrateur créé"
    echo "   Email: admin@krinetattoo.com"
    echo "   Mot de passe: KrineTattoo2024!"
else
    echo "6. Des utilisateurs existent déjà"
fi

# Optimiser la base de données
echo "7. Optimisation de la base de données..."
php artisan db:show --counts --views

echo ""
echo "✅ Configuration de la base de données terminée avec succès!"
echo ""
echo "📊 Résumé:"
echo "   - Migrations: ✓ Appliquées"
echo "   - Portfolios: $(php artisan tinker --execute="echo App\Models\Portfolio::count();" 2>/dev/null) entrées"
echo "   - Utilisateurs: $(php artisan tinker --execute="echo App\Models\User::count();" 2>/dev/null) entrées"
echo ""
echo "🔗 Accès admin: https://votre-domaine.com/admin"
echo "   Email: admin@krinetattoo.com"
echo "   Mot de passe: KrineTattoo2024!"
echo ""