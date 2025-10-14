#!/bin/bash

# Créer fichier test pour vérifier Document Root
echo "🔧 Création fichier test Document Root"

# 1. Créer fichier test simple
echo "<?php echo 'DOCUMENT ROOT FIXED - SUCCESS!'; ?>" > public/success.php
chmod 644 public/success.php

# 2. Créer fichier test avec infos
cat > public/debug-info.php << 'DEBUG_EOF'
<?php
echo "DOCUMENT ROOT TEST\n";
echo "==================\n";
echo "Server: " . ($_SERVER['HTTP_HOST'] ?? 'unknown') . "\n";
echo "Document Root: " . ($_SERVER['DOCUMENT_ROOT'] ?? 'unknown') . "\n";
echo "Script Path: " . __FILE__ . "\n";
echo "PHP Version: " . PHP_VERSION . "\n";
echo "Time: " . date('Y-m-d H:i:s') . "\n";
echo "\n";
echo "Si vous voyez ce message, Document Root est CORRECT!\n";
DEBUG_EOF
chmod 644 public/debug-info.php

# 3. Vérifier structure
echo ""
echo "=== FICHIERS CRÉÉS ==="
ls -la public/success.php
ls -la public/debug-info.php

echo ""
echo "🧪 TESTS À FAIRE APRÈS changement Document Root:"
echo "   https://deploiement_krinetattoo-pobc9vdh.on-forge.com/success.php"
echo "   https://deploiement_krinetattoo-pobc9vdh.on-forge.com/debug-info.php"
echo ""
echo "✅ Si ces URLs marchent → Document Root corrigé"
echo "❌ Si 'No input file specified' → Document Root toujours incorrect"

echo ""
echo "🚨 ACTIONS REQUISES dans Laravel Forge Panel:"
echo "   Sites > deploiement_krinetattoo-pobc9vdh > Document Root"
echo "   Changer vers: .../public (ajouter /public à la fin)"