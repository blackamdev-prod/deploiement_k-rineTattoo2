<!DOCTYPE html>
<html>
<head>
    <title>Test Formulaire K'RINE TATTOO</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; }
        .form-group { margin: 15px 0; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, select, textarea { width: 100%; padding: 8px; margin-bottom: 10px; }
        button { background: #000; color: #D4B896; padding: 15px 30px; border: none; cursor: pointer; }
        .debug { background: #f5f5f5; padding: 10px; margin: 10px 0; border-left: 3px solid #ccc; }
    </style>
</head>
<body>
    <h1>🎨 Test Formulaire K'RINE TATTOO</h1>
    
    <div class="debug">
        <strong>DEBUG INFO:</strong><br>
        Current Time: {{ now() }}<br>
        CSRF Token: {{ csrf_token() }}<br>
        Session ID: {{ session()->getId() }}
    </div>

    @if(session('success'))
        <div style="background: #d4edda; color: #155724; padding: 15px; margin: 10px 0;">
            ✅ {{ session('success') }}
        </div>
    @endif

    @if(session('error'))
        <div style="background: #f8d7da; color: #721c24; padding: 15px; margin: 10px 0;">
            ❌ {{ session('error') }}
        </div>
    @endif

    @if($errors->any())
        <div style="background: #f8d7da; color: #721c24; padding: 15px; margin: 10px 0;">
            <strong>Erreurs:</strong>
            <ul>
                @foreach($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <form action="/demande-rendez-vous" method="POST" enctype="multipart/form-data">
        @csrf
        
        <div class="form-group">
            <label>Prénom *</label>
            <input type="text" name="prenom" value="Test" required>
        </div>

        <div class="form-group">
            <label>Nom *</label>
            <input type="text" name="nom" value="Formulaire" required>
        </div>

        <div class="form-group">
            <label>Email *</label>
            <input type="email" name="email" value="franciettaskill@gmail.com" required>
        </div>

        <div class="form-group">
            <label>Téléphone</label>
            <input type="tel" name="telephone" value="+596 696 00 44 21">
        </div>

        <div class="form-group">
            <label>Style</label>
            <select name="style">
                <option value="realiste" selected>Réaliste</option>
                <option value="traditionnel">Traditionnel</option>
            </select>
        </div>

        <div class="form-group">
            <label>Zone</label>
            <select name="zone">
                <option value="avant-bras" selected>Avant-bras</option>
                <option value="dos">Dos</option>
            </select>
        </div>

        <div class="form-group">
            <label>Taille</label>
            <select name="taille">
                <option value="grand" selected>Grand</option>
                <option value="moyen">Moyen</option>
            </select>
        </div>

        <div class="form-group">
            <label>Description *</label>
            <textarea name="description" rows="4" required>Test du formulaire web - vérification que les emails arrivent avec images en pièces jointes.</textarea>
        </div>

        <div class="form-group">
            <label>Images de référence</label>
            <input type="file" name="files[]" multiple accept="image/*,.pdf">
            <small>Sélectionnez 1-2 images pour tester les pièces jointes</small>
        </div>

        <button type="submit">🚀 ENVOYER TEST</button>
    </form>

    <div class="debug">
        <p><strong>Instructions:</strong></p>
        <ol>
            <li>Ajoutez une image dans le champ fichier</li>
            <li>Cliquez "ENVOYER TEST"</li>
            <li>Vérifiez les logs Laravel</li>
            <li>Vérifiez l'email reçu</li>
        </ol>
    </div>
</body>
</html>