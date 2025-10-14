<?php

use App\Mail\DemandeRendezVous;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DemandeRendezVousController;

Route::get('/', function () {
    return view('LandingPage');
});

Route::post('/demande-rendez-vous', [DemandeRendezVousController::class, 'store']);

// Route de test sans CSRF pour diagnostic
Route::post('/test-form-direct', [DemandeRendezVousController::class, 'store'])->withoutMiddleware('VerifyCsrfToken');

// Page de test du formulaire
Route::get('/test-form', function() {
    return view('test-form');
});

Route::get('/test-brevo-images', function() {
    try {
        $embedImages = [];
        
        $mail = new \App\Mail\DemandeRendezVous(
            'Sophie',
            'Martin',
            'sophie.martin@example.com',
            '+33 6 98 76 54 32',
            'géométrique',
            'épaule',
            'grand',
            'Je souhaiterais un tatouage géométrique sur l\'épaule. J\'ai préparé plusieurs images de référence pour montrer le style que je recherche.',
            [],
            $embedImages
        );
        
        // Créer une image de test simple (pixel blanc)
        $imageData = base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAGA0VQI6AAAAABJRU5ErkJggg==');
        $imagePath = storage_path('app/test-reference.png');
        file_put_contents($imagePath, $imageData);
        
        // Intégrer l'image
        $cid = $mail->embed($imagePath);
        $embedImages[] = [
            'cid' => $cid,
            'name' => 'reference-geometrique.png',
            'mime' => 'image/png'
        ];
        
        // Attacher l'image comme fichier joint aussi
        $mail->attach($imagePath, [
            'as' => 'reference-geometrique.png',
            'mime' => 'image/png'
        ]);
        
        // Mettre à jour les images dans le mail
        $mail->images = $embedImages;
        
        \Illuminate\Support\Facades\Mail::to('franciettaskill@gmail.com')->send($mail);
        
        return '<h1>🖼️ Email avec IMAGES envoyé!</h1>
                <p><strong>Test images de référence → franciettaskill@gmail.com</strong></p>
                <ul>
                    <li>✅ Image intégrée dans l\'email (visible directement)</li>
                    <li>✅ Image aussi en pièce jointe</li>
                    <li>✅ Template K\'RINE TATTOO</li>
                    <li>✅ Via Brevo (Production)</li>
                </ul>
                <p><em>Vérifiez votre email pour voir l\'image directement affichée!</em></p>';
    } catch (Exception $e) {
        return '<h1>❌ Erreur lors de l\'envoi</h1><p>' . $e->getMessage() . '</p>';
    }
});

Route::get('/test-brevo-template', function() {
    try {
        $mail = new \App\Mail\DemandeRendezVous(
            'Marie',
            'Dubois',
            'marie.dubois@example.com',
            '+33 6 12 34 56 78',
            'réaliste',
            'avant-bras',
            'moyen',
            'Je souhaiterais un tatouage représentant un loup dans un style réaliste. J\'ai déjà quelques idées et des références visuelles à partager.',
            []
        );
        
        // Créer un fichier de test réaliste
        $testFilePath = storage_path('app/reference-tattoo.txt');
        file_put_contents($testFilePath, "=== RÉFÉRENCES TATOUAGE ===\n\nStyle: Réaliste\nMotif: Loup\nZone: Avant-bras\nTaille: Environ 15cm\n\nNotes:\n- Préférence pour les tons noir et gris\n- Regard intense du loup\n- Intégration possible avec tatouage existant\n\nDate de la demande: " . now()->format('d/m/Y à H:i'));
        
        $mail->attach($testFilePath, [
            'as' => 'references-tattoo-marie.txt',
            'mime' => 'text/plain'
        ]);
        
        Mail::to('franciettaskill@gmail.com')->send($mail);
        
        return '<h1>🎨 Email K\'RINE TATTOO envoyé!</h1>
                <p><strong>Demande réaliste envoyée vers franciettaskill@gmail.com</strong></p>
                <ul>
                    <li>✅ Template K\'RINE TATTOO appliqué</li>
                    <li>✅ Design professionnel (noir, beige sable, crème)</li>
                    <li>✅ Via Brevo (Production)</li>
                    <li>✅ Avec fichier de références joint</li>
                </ul>
                <p><em>Vérifiez votre boîte email franciettaskill@gmail.com</em></p>';
    } catch (Exception $e) {
        return '<h1>❌ Erreur lors de l\'envoi</h1><p>' . $e->getMessage() . '</p>';
    }
});

