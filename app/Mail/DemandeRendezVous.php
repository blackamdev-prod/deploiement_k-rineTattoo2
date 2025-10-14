<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Mail\Mailables\Attachment;
use Illuminate\Queue\SerializesModels;

class DemandeRendezVous extends Mailable
{
    use Queueable, SerializesModels;

    public $prenom;
    public $nom;
    public $email;
    public $telephone;
    public $style;
    public $zone;
    public $taille;
    public $description;
    public $files;
    public $images;
    public $fileAttachments = [];

    /**
     * Create a new message instance.
     */
    public function __construct($prenom, $nom, $email, $telephone = null, $style = null, $zone = null, $taille = null, $description = null, $files = null, $images = [], $fileAttachments = [])
    {
        $this->prenom = $prenom;
        $this->nom = $nom;
        $this->email = $email;
        $this->telephone = $telephone;
        $this->style = $style;
        $this->zone = $zone;
        $this->taille = $taille;
        $this->description = $description;
        $this->files = $files;
        $this->images = $images;
        $this->fileAttachments = $fileAttachments;
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Nouvelle demande de rendez-vous - K\'RINE TATTOO',
        );
    }

    /**
     * Get the message content definition.
     */
    // public function content(): Content
    // {
    //     return new Content(
    //         view: 'emails.demande-rendez-vous',
    //     );
    // }

    /**
     * Build the message.
     */
    public function build()
    {
        $message = $this->view('emails.demande-rendez-vous')
                        ->subject('Nouvelle demande de rendez-vous - K\'RINE TATTOO');

        // Attacher les images avec CID pour affichage inline
        foreach ($this->images as $index => $image) {
            if (str_starts_with($image['mime'], 'image/')) {
                $cid = 'image_' . $index;
                $message->attachData(
                    $image['data'],
                    $image['name'],
                    [
                        'mime' => $image['mime'],
                        'cid' => $cid
                    ]
                );
                
                // Ajouter le CID à l'image pour le template
                $this->images[$index]['cid'] = $cid;
            }
        }

        // Attacher AUSSI tous les fichiers comme pièces jointes téléchargeables
        foreach ($this->fileAttachments as $attachment) {
            $message->attachData(
                $attachment['data'],
                $attachment['name'],
                [
                    'mime' => $attachment['mime']
                ]
            );
        }

        return $message;
    }

    /**
     * Get the attachments for the message.
     *
     * @return array<int, \Illuminate\Mail\Mailables\Attachment>
     */
    public function attachments(): array
    {
        // Laisser vide car on gère tout dans build()
        return [];
    }
}
