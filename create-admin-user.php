<?php

// Script pour créer un utilisateur admin Filament
// Usage: php create-admin-user.php

require_once 'vendor/autoload.php';

use Illuminate\Support\Facades\Hash;
use App\Models\User;

// Démarre l'application Laravel
$app = require_once 'bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "🔧 Création d'un utilisateur admin pour Filament v3\n";
echo "================================================\n\n";

// Vérification de la connexion DB
try {
    DB::connection()->getPdo();
    echo "✅ Connexion à la base de données réussie\n\n";
} catch (Exception $e) {
    echo "❌ Erreur de connexion à la base de données:\n";
    echo $e->getMessage() . "\n\n";
    echo "Veuillez configurer correctement:\n";
    echo "- DB_HOST\n";
    echo "- DB_DATABASE\n";
    echo "- DB_USERNAME\n";
    echo "- DB_PASSWORD\n\n";
    exit(1);
}

// Paramètres admin par défaut
$name = "Admin K'rine Tattoo";
$email = "admin@krinetattoo.com";
$password = "admin123"; // À changer après première connexion

echo "Création de l'utilisateur admin:\n";
echo "Nom: $name\n";
echo "Email: $email\n";
echo "Mot de passe: $password\n\n";

try {
    // Vérifier si l'utilisateur existe déjà
    $existingUser = User::where('email', $email)->first();
    
    if ($existingUser) {
        echo "⚠️  Un utilisateur avec cet email existe déjà.\n";
        echo "Mise à jour du mot de passe...\n";
        
        $existingUser->update([
            'password' => Hash::make($password)
        ]);
        
        echo "✅ Mot de passe mis à jour pour: $email\n";
    } else {
        // Créer le nouvel utilisateur
        $user = User::create([
            'name' => $name,
            'email' => $email,
            'password' => Hash::make($password),
            'email_verified_at' => now(),
        ]);
        
        echo "✅ Utilisateur admin créé avec succès!\n";
    }
    
    echo "\n🎉 Configuration terminée!\n\n";
    echo "Accès admin:\n";
    echo "URL: " . config('app.url') . "/admin\n";
    echo "Email: $email\n";
    echo "Mot de passe: $password\n\n";
    echo "⚠️  IMPORTANT: Changez le mot de passe après votre première connexion!\n";
    
} catch (Exception $e) {
    echo "❌ Erreur lors de la création de l'utilisateur:\n";
    echo $e->getMessage() . "\n\n";
    
    if (strpos($e->getMessage(), 'users') !== false) {
        echo "La table 'users' n'existe probablement pas.\n";
        echo "Exécutez d'abord: php artisan migrate --force\n";
    }
}