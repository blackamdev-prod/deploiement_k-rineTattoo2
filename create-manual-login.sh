#!/bin/bash

# Créer login Filament manuel en attendant Document Root fix
echo "🔧 Création login Filament manuel..."

# Créer login simple dans public/
cat > public/admin-login.php << 'LOGIN_EOF'
<?php
session_start();

// Données admin
$admin_email = 'admin@krinetattoo.com';
$admin_password = 'KrineTattoo2024!';

if ($_POST['email'] ?? false) {
    $email = $_POST['email'];
    $password = $_POST['password'];
    
    if ($email === $admin_email && $password === $admin_password) {
        $_SESSION['admin_logged'] = true;
        header('Location: admin-dashboard.php');
        exit;
    } else {
        $error = 'Identifiants incorrects';
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>K'rine Tattoo - Admin Login</title>
    <style>
        body { font-family: Arial; max-width: 400px; margin: 100px auto; padding: 20px; }
        .form-group { margin: 15px 0; }
        label { display: block; margin-bottom: 5px; }
        input { width: 100%; padding: 10px; border: 1px solid #ddd; }
        button { background: #3b82f6; color: white; padding: 10px 20px; border: none; cursor: pointer; }
        .error { color: red; margin: 10px 0; }
    </style>
</head>
<body>
    <h2>K'rine Tattoo - Admin</h2>
    
    <?php if (isset($error)): ?>
        <div class="error"><?= $error ?></div>
    <?php endif; ?>
    
    <form method="POST">
        <div class="form-group">
            <label>Email:</label>
            <input type="email" name="email" required>
        </div>
        <div class="form-group">
            <label>Mot de passe:</label>
            <input type="password" name="password" required>
        </div>
        <button type="submit">Connexion</button>
    </form>
    
    <p><small>Email: admin@krinetattoo.com<br>Password: KrineTattoo2024!</small></p>
</body>
</html>
LOGIN_EOF

# Créer dashboard simple
cat > public/admin-dashboard.php << 'DASHBOARD_EOF'
<?php
session_start();
if (!($_SESSION['admin_logged'] ?? false)) {
    header('Location: admin-login.php');
    exit;
}

try {
    require_once '../vendor/autoload.php';
    $app = require_once '../bootstrap/app.php';
    
    // Boot Laravel
    $app->make('Illuminate\Contracts\Http\Kernel')->bootstrap();
    
    // Compter users et portfolios
    $users = \App\Models\User::count();
    $portfolios = \App\Models\Portfolio::count();
    
} catch (Exception $e) {
    $error = $e->getMessage();
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>K'rine Tattoo - Dashboard</title>
    <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; }
        .card { background: #f9f9f9; padding: 20px; margin: 15px 0; border-radius: 5px; }
        .stats { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .logout { float: right; background: #dc2626; color: white; padding: 5px 10px; text-decoration: none; }
    </style>
</head>
<body>
    <h1>K'rine Tattoo - Dashboard Admin</h1>
    <a href="?logout=1" class="logout">Déconnexion</a>
    
    <?php if (isset($error)): ?>
        <div class="card" style="border-left: 4px solid red;">
            <h3>Erreur Laravel</h3>
            <p><?= htmlspecialchars($error) ?></p>
        </div>
    <?php else: ?>
        <div class="stats">
            <div class="card">
                <h3>👥 Utilisateurs</h3>
                <p><strong><?= $users ?></strong> utilisateurs</p>
            </div>
            <div class="card">
                <h3>🎨 Portfolio</h3>
                <p><strong><?= $portfolios ?></strong> œuvres</p>
            </div>
        </div>
    <?php endif; ?>
    
    <div class="card">
        <h3>📊 Status</h3>
        <p><strong>Site:</strong> https://deploiement_krinetattoo-pobc9vdh.on-forge.com</p>
        <p><strong>Admin:</strong> Connecté</p>
        <p><strong>Laravel:</strong> <?= isset($error) ? '❌ Erreur' : '✅ OK' ?></p>
    </div>
    
    <div class="card">
        <h3>⚠️ Document Root</h3>
        <p>Le login Filament normal ne marche pas car le Document Root n'est pas configuré sur <code>/public</code> dans Laravel Forge.</p>
        <p>Une fois corrigé, utilisez: <code>/admin</code></p>
    </div>
</body>
</html>

<?php
if ($_GET['logout'] ?? false) {
    session_destroy();
    header('Location: admin-login.php');
    exit;
}
?>
DASHBOARD_EOF

chmod 644 public/admin-login.php
chmod 644 public/admin-dashboard.php

echo "✅ Login manuel créé"
echo ""
echo "🔗 Login temporaire: https://deploiement_krinetattoo-pobc9vdh.on-forge.com/admin-login.php"
echo "📧 Email: admin@krinetattoo.com"
echo "🔑 Password: KrineTattoo2024!"
echo ""
echo "⚠️ Cette solution temporaire marche même avec Document Root mal configuré"
echo "Une fois Document Root corrigé, utilisez /admin normal"