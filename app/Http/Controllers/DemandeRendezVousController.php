<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use App\Mail\DemandeRendezVous;
use Illuminate\Mail\Mailables\Attachment;
use Exception;

class DemandeRendezVousController extends Controller
{
    public function store(Request $request)
    {
        try {
            // Log de traitement simplifié
            \Log::info('=== NOUVELLE DEMANDE RENDEZ-VOUS ===');
            \Log::info('Client: ' . $request->get('prenom') . ' ' . $request->get('nom'));
            \Log::info('Email: ' . $request->get('email'));
            \Log::info('Fichiers: ' . ($request->hasFile('files') ? count($request->file('files')) . ' fichier(s)' : 'Aucun'));
            
            if ($request->hasFile('files')) {
                foreach ($request->file('files') as $index => $file) {
                    \Log::info("Fichier {$index}: " . $file->getClientOriginalName() . ' (' . $file->getMimeType() . ', ' . round($file->getSize()/1024, 1) . 'KB)');
                }
            }
            
            // Validation personnalisée pour les fichiers
            $rules = [
                'prenom' => 'required|string|max:255',
                'nom' => 'required|string|max:255',
                'email' => 'required|email|max:255',
                'telephone' => 'nullable|string|max:255',
                'style' => 'nullable|string|max:255',
                'zone' => 'nullable|string|max:255',
                'taille' => 'nullable|string|max:255',
                'description' => 'required|string'
            ];
            
            // Validation des fichiers seulement s'ils existent
            if ($request->hasFile('files')) {
                $rules['files.*'] = 'file|mimes:jpeg,png,jpg,webp|max:10240';
            }
            
            $validated = $request->validate($rules);

            $embedImages = [];
            $fileAttachments = [];
            
            if ($request->hasFile('files')) {
                foreach ($request->file('files') as $index => $file) {
                    $mimeType = $file->getMimeType();
                    $fileName = $file->getClientOriginalName();
                    $fileData = file_get_contents($file->getRealPath());
                    
                    // Attacher TOUS les fichiers comme pièces jointes
                    $fileAttachments[] = [
                        'data' => $fileData,
                        'name' => $fileName,
                        'mime' => $mimeType
                    ];
                    
                    // Si c'est une image, l'ajouter aussi pour affichage dans l'email
                    if (str_starts_with($mimeType, 'image/')) {
                        $embedImages[] = [
                            'data' => $fileData,
                            'name' => $fileName,
                            'mime' => $mimeType
                        ];
                    }
                }
                
                \Log::info('Fichiers traités: ' . count($fileAttachments) . ' pièce(s) jointe(s), ' . count($embedImages) . ' image(s) inline');
            }

            $mail = new DemandeRendezVous(
                $validated['prenom'],
                $validated['nom'],
                $validated['email'],
                $validated['telephone'],
                $validated['style'],
                $validated['zone'],
                $validated['taille'],
                $validated['description'],
                [],
                $embedImages,
                $fileAttachments
            );

            Mail::to('franciettaskill@gmail.com')->send($mail);
            \Log::info('✅ Email envoyé avec succès - Demande de ' . $validated['prenom'] . ' ' . $validated['nom']);

            return redirect('/#contact')->with('success', 'Votre demande a été envoyée avec succès ! Je vous répondrai dans les 24h.');
            
        } catch (\Illuminate\Validation\ValidationException $e) {
            \Log::error('❌ Erreur de validation: ' . json_encode($e->errors()));
            return redirect('/#contact')->withErrors($e->errors())->withInput();
        } catch (Exception $e) {
            \Log::error('❌ Erreur lors du traitement: ' . $e->getMessage());
            \Log::error('Stack trace: ' . $e->getTraceAsString());
            return redirect('/#contact')->with('error', 'Une erreur est survenue lors de l\'envoi. Veuillez réessayer.');
        }
    }
}
