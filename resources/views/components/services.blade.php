<!-- Section Services -->
<section id="services" class="services">
    <div class="container">
        <div class="section-header text-center">
            @isset($sectionHeader)
                {!! $sectionHeader !!}
            @else
                <h2 class="section-title">
                    Nos <span class="title-accent">Services</span>
                </h2>
                <div class="title-underline"></div>
                <p class="section-description">
                    Une gamme complète de services pour donner vie à vos projets artistiques, 
                    de la consultation initiale aux soins post-tatouage.
                </p>
            @endisset
        </div>

        <!-- Grille Services Principaux -->
        <div class="services-grid">
            @isset($mainServices)
                {!! $mainServices !!}
            @else
                <div class="service-card">
                    <div class="service-header">
                        <i data-lucide="pen-tool" class="service-icon"></i>
                        <span class="service-price">À partir de 150€</span>
                    </div>
                    <h3 class="service-title">Tatouage Personnalisé</h3>
                    <p class="service-description">Création sur-mesure de votre tatouage, du croquis initial à la réalisation finale.</p>
                    <ul class="service-features">
                        <li>Consultation gratuite</li>
                        <li>Croquis personnalisé</li>
                        <li>Check-up</li>
                        <li>Cover-up/reprise inclus</li>
                    </ul>
                    <div class="service-duration">
                        <i data-lucide="timer" class="icon-sm"></i>
                        <span>Durée: 2-8h selon complexité</span>
                    </div>
                </div>

                <div class="service-card">
                    <div class="service-header">
                        <i data-lucide="eye" class="service-icon"></i>
                        <span class="service-price">À partir de 100€</span>
                    </div>
                    <h3 class="service-title">Tatouage Réaliste</h3>
                    <p class="service-description">Spécialiste des portraits et paysages d'un réalisme exceptionnel.</p>
                    <ul class="service-features">
                        <li>Reproductions fidèles de photos personnelles</li>
                        <li>Détails précis et travail des ombres et lumières</li>
                    </ul>
                    <div class="service-duration">
                        <i data-lucide="timer" class="icon-sm"></i>
                        <span>Durée: 2-12h selon complexité</span>
                    </div>
                </div>

                <div class="service-card">
                    <div class="service-header">
                        <i data-lucide="compass" class="service-icon"></i>
                        <span class="service-price">À partir de 70€</span>
                    </div>
                    <h3 class="service-title">Tatouage Minimaliste & Line-Art</h3>
                    <p class="service-description">Designs modernes et épurés, alliant précision et esthétique contemporaine.</p>
                    <ul class="service-features">
                        <li>Mandalas</li>
                        <li>Formes géométriques</li>
                        <li>Calligraphie</li>
                    </ul>
                    <div class="service-duration">
                        <i data-lucide="timer" class="icon-sm"></i>
                        <span>Durée: 2-6h selon complexité</span>
                    </div>
                </div>

                <div class="service-card">
                    <div class="service-header">
                        <i data-lucide="rotate-cw" class="service-icon"></i>
                        <span class="service-price">À partir de 30€</span>
                    </div>
                    <h3 class="service-title">Retouche</h3>
                    <p class="service-description">Retouche de vos tatouages pour raviver les couleurs et perfectionner les détails.</p>
                    <ul class="service-features">
                        <li>1 mois gratuit (tatouage réalisé par moi)</li>
                        <li>Retouche couleurs et lignes</li>
                        <li>Tarif dégressif selon ancienneté</li>
                        <li>Tatouage externe: à partir de 70€</li>
                    </ul>
                    <div class="service-duration">
                        <i data-lucide="timer" class="icon-sm"></i>
                        <span>Durée: 1-2h selon complexité</span>
                    </div>
                </div>
            @endisset
        </div>

        <!-- Services Additionnels -->
        <div class="additional-services">
            @isset($additionalServicesTitle)
                {!! $additionalServicesTitle !!}
            @else
                <h3 class="additional-title">Services Complémentaires</h3>
            @endisset
            
            <div class="additional-grid">
                @isset($additionalServices)
                    {!! $additionalServices !!}
                @else
                    <div class="additional-service">
                        <div class="additional-service-header">
                            <i data-lucide="message-circle" class="additional-icon"></i>
                        </div>
                        <h4>Consultation & Devis</h4>
                        <p>Échange personnalisé pour définir votre projet</p>
                        <div class="additional-price price-free">
                            <i data-lucide="gift" class="icon-sm"></i>
                            <span>Gratuit</span>
                        </div>
                    </div>
                    <div class="additional-service">
                        <div class="additional-service-header">
                            <i data-lucide="palette" class="additional-icon"></i>
                        </div>
                        <h4>Croquis Personnalisé</h4>
                        <p>Création d'un design unique selon vos souhaits</p>
                        <div class="additional-price price-paid">
                            <i data-lucide="palette" class="icon-sm"></i>
                            <span>50€</span>
                        </div>
                    </div>
                    <div class="additional-service">
                        <div class="additional-service-header">
                            <i data-lucide="heart" class="additional-icon"></i>
                        </div>
                        <h4>Suivi Post-Tatouage</h4>
                        <p>Accompagnement personnalisé pendant la cicatrisation</p>
                        <div class="additional-price price-free">
                            <i data-lucide="heart-handshake" class="icon-sm"></i>
                            <span>Gratuit</span>
                        </div>
                    </div>
                @endisset
            </div>
        </div>

        <!-- CTA Services -->
        <div class="services-cta">
            @isset($servicesCta)
                {!! $servicesCta !!}
            @else
                <p>Chaque projet est unique. N'hésitez pas à me contacter pour un devis personnalisé.</p>
                <div class="cta-buttons">
                    <a href="#contact" class="btn btn-primary">Demander un Devis</a>
                    <a href="#portfolio" class="btn btn-outline">Voir nos Réalisations</a>
                </div>
            @endisset
        </div>
        
        <!-- Additional Content Slot -->
        {!! $slot ?? '' !!}
    </div>
</section>