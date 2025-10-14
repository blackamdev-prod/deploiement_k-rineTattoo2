<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demande de Rendez-vous - K'RINE TATTOO</title>
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@300;400;500;600;700&family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Variables couleurs - Charte graphique K'RINE TATTOO - EXACTES de la landing page */
        :root {
            --noir-profond: #000000;
            --beige-sable: #D4B896;
            --creme-ecru: #F5F1EB;
            --blanc-casse: #FEFEFE;
            --beige-clair: #F8F6F3;
            --tattoo-accent: rgba(212, 184, 150, 0.7);
            --tattoo-charcoal: rgba(0, 0, 0, 0.8);
        }

        body {
            font-family: 'Montserrat', sans-serif;
            line-height: 1.7;
            color: var(--noir-profond);
            max-width: 650px;
            margin: 0 auto;
            padding: 0;
            background-color: var(--blanc-casse);
            font-weight: 300;
            letter-spacing: 0.01em;
        }

        .email-wrapper {
            background: var(--blanc-casse);
            margin: 20px;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
        }

        .header {
            background: var(--noir-profond);
            color: var(--blanc-casse);
            text-align: center;
            padding: 40px 30px;
            position: relative;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(90deg, 
                transparent 0%, 
                rgba(212, 184, 150, 0.1) 20%, 
                rgba(212, 184, 150, 0.2) 50%, 
                rgba(212, 184, 150, 0.1) 80%, 
                transparent 100%);
        }

        .header h1 {
            font-family: 'Oswald', sans-serif;
            font-size: 2.5rem;
            font-weight: 300;
            margin: 0;
            letter-spacing: 3px;
            text-transform: uppercase;
            position: relative;
            z-index: 2;
        }

        .header .subtitle {
            font-size: 1rem;
            font-weight: 300;
            margin-top: 10px;
            color: var(--beige-sable);
            letter-spacing: 1px;
            position: relative;
            z-index: 2;
        }

        .content {
            padding: 40px 30px;
        }

        .section-title {
            font-family: 'Oswald', sans-serif;
            font-size: 1.5rem;
            font-weight: 300;
            color: var(--noir-profond);
            margin: 0 0 25px 0;
            text-transform: uppercase;
            letter-spacing: 3px;
            position: relative;
            padding-bottom: 15px;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 40px;
            height: 0.5px;
            background: var(--beige-sable);
        }

        .info-block {
            background: var(--creme-ecru);
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 30px;
            border-left: 3px solid var(--beige-sable);
            box-shadow: 0 2px 8px rgba(212, 184, 150, 0.15);
        }

        .info-row {
            display: flex;
            margin-bottom: 12px;
            align-items: center;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-label {
            font-family: 'Oswald', sans-serif;
            font-weight: 400;
            color: var(--noir-profond);
            min-width: 120px;
            font-size: 0.9rem;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .info-value {
            color: var(--tattoo-charcoal);
            font-weight: 300;
            font-size: 0.95rem;
            letter-spacing: 0.01em;
        }

        .project-details {
            background: var(--beige-clair);
            padding: 25px;
            border-radius: 8px;
            border: 1px solid var(--tattoo-accent);
            margin-top: 20px;
        }

        .project-details p {
            margin: 0;
            font-style: italic;
            color: var(--tattoo-charcoal);
            line-height: 1.7;
            font-weight: 300;
            letter-spacing: 0.01em;
        }

        .footer {
            background: var(--creme-ecru);
            text-align: center;
            padding: 30px;
            border-top: 0.5px solid var(--tattoo-accent);
            color: var(--tattoo-charcoal);
            font-size: 0.85rem;
        }

        .footer p {
            margin: 5px 0;
            font-weight: 300;
            letter-spacing: 0.01em;
        }

        .footer .main-text {
            font-weight: 400;
            color: var(--noir-profond);
        }

        /* Responsive */
        @media (max-width: 600px) {
            .email-wrapper {
                margin: 10px;
                border-radius: 12px;
            }
            
            .header {
                padding: 30px 20px;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .content {
                padding: 30px 20px;
            }
            
            .info-block {
                padding: 20px;
            }
            
            .info-row {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .info-label {
                min-width: auto;
                margin-bottom: 4px;
            }
        }
    </style>
</head>
<body>
    <div class="email-wrapper">
        <div class="header">
            <h1>K'RINE TATTOO</h1>
            <p class="subtitle">Nouvelle demande de rendez-vous</p>
        </div>

        <div class="content">
            <h2 class="section-title">👤 Informations du client</h2>
            
            <div class="info-block">
                <div class="info-row">
                    <span class="info-label">Prénom :</span>
                    <span class="info-value">{{ $prenom ?? 'Non spécifié' }}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Nom :</span>
                    <span class="info-value">{{ $nom ?? 'Non spécifié' }}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Email :</span>
                    <span class="info-value">{{ $email ?? 'Non spécifié' }}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Téléphone :</span>
                    <span class="info-value">{{ $telephone ?: 'Non renseigné' }}</span>
                </div>
            </div>

            <h2 class="section-title">🎨 Détails du projet</h2>
            
            <div class="info-block">
                @if($style)
                <div class="info-row">
                    <span class="info-label">Style :</span>
                    <span class="info-value">{{ ucfirst($style) }}</span>
                </div>
                @endif
                
                @if($zone)
                <div class="info-row">
                    <span class="info-label">Zone :</span>
                    <span class="info-value">{{ ucfirst($zone) }}</span>
                </div>
                @endif
                
                @if($taille)
                <div class="info-row">
                    <span class="info-label">Taille :</span>
                    <span class="info-value">{{ ucfirst($taille) }}</span>
                </div>
                @endif
            </div>

            @if($description)
            <h3 class="section-title">📝 Description du projet</h3>
            <div class="project-details">
                <p>{{ $description }}</p>
            </div>
            @endif

            @if($images && count($images) > 0)
            <h3 class="section-title">🖼️ Images de référence</h3>
            <div class="info-block">
                <div class="info-row">
                    <span class="info-label">Images :</span>
                    <span class="info-value">{{ count($images) }} image(s) de référence</span>
                </div>
                
                <!-- Affichage des images inline -->
                <div style="margin-top: 20px;">
                    @foreach($images as $index => $image)
                    <div style="margin-bottom: 20px; text-align: center;">
                        <p style="margin: 0 0 10px 0; font-weight: 400; color: var(--noir-profond); font-size: 0.9rem;">
                            📸 {{ $image['name'] }}
                        </p>
                        <!-- Image avec CID pour affichage compatible email -->
                        @if(isset($image['cid']))
                        <img src="cid:{{ $image['cid'] }}" 
                             alt="Image de référence {{ $index + 1 }}"
                             style="max-width: 100%; max-height: 300px; border-radius: 8px; border: 2px solid var(--beige-sable); box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
                        @else
                        <div style="padding: 20px; background: var(--creme-ecru); border-radius: 8px; text-align: center; color: var(--tattoo-charcoal);">
                            📸 Image de référence : {{ $image['name'] }}<br>
                            <small>Consultez les pièces jointes pour voir cette image</small>
                        </div>
                        @endif
                    </div>
                    @endforeach
                </div>
                
                <div style="margin-top: 15px; padding: 15px; background: var(--beige-clair); border-radius: 8px; border-left: 3px solid var(--beige-sable);">
                    <p style="margin: 0; font-size: 0.9rem; color: var(--tattoo-charcoal); font-style: italic;">
                        💡 Les images sont également disponibles en pièces jointes pour téléchargement
                    </p>
                </div>
            </div>
            @endif

            @if($fileAttachments && count($fileAttachments) > 0)
            <h3 class="section-title">📎 Pièces jointes</h3>
            <div class="info-block">
                <div class="info-row">
                    <span class="info-label">Total :</span>
                    <span class="info-value">{{ count($fileAttachments) }} fichier(s) en pièce jointe</span>
                </div>
                <div style="margin-top: 15px; padding: 15px; background: var(--creme-ecru); border-radius: 8px;">
                    <p style="margin: 0; font-size: 0.9rem; color: var(--tattoo-charcoal);">
                        💡 <strong>Consultez les pièces jointes</strong> de cet email pour accéder à tous les fichiers envoyés par le client.
                    </p>
                </div>
            </div>
            @endif
        </div>

        <div class="footer">
            <p class="main-text">📧 Email automatique envoyé depuis le site K'RINE TATTOO</p>
            <p>🕒 Envoyé le {{ now()->format('d/m/Y à H:i') }}</p>
            <p>Répondez directement à cet email pour contacter le client</p>
        </div>
    </div>
</body>
</html>