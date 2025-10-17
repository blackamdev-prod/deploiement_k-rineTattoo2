<!-- Section Portfolio -->
<section id="portfolio" class="portfolio">
    <div class="container">
        <div class="section-header text-center">
            @isset($sectionHeader)
                {!! $sectionHeader !!}
            @else
                <h2 class="section-title text-white">
                    Notre <span class="title-accent">Portfolio</span>
                </h2>
                <div class="title-underline"></div>
            @endisset
        </div>

        <!-- Filtres Portfolio -->
        <div class="portfolio-filters">
            @isset($filters)
                {!! $filters !!}
            @else
                <button class="filter-btn active" data-filter="all"><span>Tous</span></button>
                <button class="filter-btn" data-filter="realistic"><span>Réaliste</span></button>
                <button class="filter-btn" data-filter="minimaliste"><span>Minimaliste</span></button>
                <button class="filter-btn" data-filter="line-art"><span>Line-art</span></button>
                <button class="filter-btn" data-filter="aquarelle"><span>Couleur</span></button>
            @endisset
        </div>

        <!-- Grille Portfolio -->
        <div class="portfolio-grid">
            @isset($portfolioItems)
                {!! $portfolioItems !!}
            @else
                @php
                    // Utiliser directement les exemples statiques pour éviter les erreurs de BDD
                    $portfolios = collect([
                            (object) [
                                'title' => 'Tatouage Réaliste Portrait',
                                'description' => 'Portrait réaliste en noir et blanc, technique fine et détaillée',
                                'image' => 'assets/images/portfolio/image1.png',
                                'category' => 'realistic',
                                'duration' => '4-5 heures',
                                'zone' => 'Avant-bras'
                            ],
                            (object) [
                                'title' => 'Design Minimaliste Géométrique',
                                'description' => 'Création minimaliste aux lignes épurées et géométriques',
                                'image' => 'assets/images/portfolio/image2.png',
                                'category' => 'minimaliste',
                                'duration' => '2-3 heures',
                                'zone' => 'Poignet'
                            ],
                            (object) [
                                'title' => 'Line-art Floral',
                                'description' => 'Composition florale délicate en traits fins et élégants',
                                'image' => 'assets/images/portfolio/image3.png',
                                'category' => 'line-art',
                                'duration' => '3-4 heures',
                                'zone' => 'Épaule'
                            ],
                            (object) [
                                'title' => 'Aquarelle Abstraite',
                                'description' => 'Mélange de couleurs vibrantes style aquarelle moderne',
                                'image' => 'assets/images/portfolio/image4.png',
                                'category' => 'aquarelle',
                                'duration' => '5-6 heures',
                                'zone' => 'Dos'
                            ],
                            (object) [
                                'title' => 'Mandala Détaillé',
                                'description' => 'Mandala complexe avec motifs symétriques traditionnels',
                                'image' => 'assets/images/portfolio/image5.png',
                                'category' => 'realistic',
                                'duration' => '6-8 heures',
                                'zone' => 'Cuisse'
                            ],
                            (object) [
                                'title' => 'Symbole Minimaliste',
                                'description' => 'Symbole personnel simple et significatif',
                                'image' => 'assets/images/portfolio/image6.png',
                                'category' => 'minimaliste',
                                'duration' => '1-2 heures',
                                'zone' => 'Nuque'
                            ],
                            (object) [
                                'title' => 'Tribal Moderne',
                                'description' => 'Interprétation moderne des motifs tribaux traditionnels',
                                'image' => 'assets/images/portfolio/image7.png',
                                'category' => 'realistic',
                                'duration' => '4-6 heures',
                                'zone' => 'Mollet'
                            ],
                            (object) [
                                'title' => 'Calligraphie Artistique',
                                'description' => 'Texte personnalisé en calligraphie élégante et stylisée',
                                'image' => 'assets/images/portfolio/image8.png',
                                'category' => 'line-art',
                                'duration' => '2-4 heures',
                                'zone' => 'Côtes'
                            ]
                        ]);
                @endphp
                
                @foreach($portfolios as $portfolio)
                    <div class="portfolio-item" data-category="{{ $portfolio->category }}">
                        <div class="portfolio-image">
                            @if(isset($portfolio->image) && is_string($portfolio->image))
                                @if(str_starts_with($portfolio->image, 'http'))
                                    <img src="{{ $portfolio->image }}" alt="{{ $portfolio->title }}" loading="lazy">
                                @else
                                    <img src="{{ asset($portfolio->image) }}" alt="{{ $portfolio->title }}" loading="lazy">
                                @endif
                            @else
                                <img src="{{ asset('assets/images/artiste.png') }}" alt="{{ $portfolio->title }}" loading="lazy">
                            @endif
                            <div class="portfolio-overlay">
                                <i data-lucide="zoom-in" class="view-icon"></i>
                            </div>
                            <span class="portfolio-tag">
                                {{ match($portfolio->category) {
                                    'realistic' => 'Réaliste',
                                    'minimaliste' => 'Minimaliste', 
                                    'line-art' => 'Line-art',
                                    'aquarelle' => 'Couleur',
                                    default => ucfirst($portfolio->category)
                                } }}
                            </span>
                        </div>
                        <div class="portfolio-content">
                            <h3>{{ $portfolio->title }}</h3>
                            <p>{{ $portfolio->description }}</p>
                            @if(isset($portfolio->duration) || isset($portfolio->zone))
                                <div class="portfolio-details">
                                    @if(isset($portfolio->duration))
                                        <div><strong>Durée:</strong> {{ $portfolio->duration }}</div>
                                    @endif
                                    @if(isset($portfolio->zone))
                                        <div><strong>Zone:</strong> {{ $portfolio->zone }}</div>
                                    @endif
                                </div>
                            @endif
                        </div>
                    </div>
                @endforeach
            @endisset
        </div>

        <!-- Statistiques Portfolio -->
        <div class="portfolio-stats">
            @isset($stats)
                {!! $stats !!}
            @else
                <div class="stat">
                    <div class="stat-number">1000+</div>
                    <div class="stat-label">Tatouages réalisés</div>
                </div>
                <div class="stat">
                    <div class="stat-number">5+</div>
                    <div class="stat-label">Années d'expérience</div>
                </div>
                <div class="stat">
                    <div class="stat-number">98%</div>
                    <div class="stat-label">Clients satisfaits</div>
                </div>
                <div class="stat">
                    <div class="stat-number">5j/7</div>
                    <div class="stat-label">Suivi post-tatouage</div>
                </div>
            @endisset
        </div>

        <!-- CTA Portfolio -->
        <div class="portfolio-cta">
            @isset($portfolioCta)
                {!! $portfolioCta !!}
            @else
                <p>Prêt à créer votre propre œuvre d'art ? Contactez-moi pour discuter de votre projet.</p>
                <a href="#contact" class="btn btn-primary">Demander une Consultation</a>
            @endisset
        </div>
        
        <!-- Additional Content Slot -->
        {!! $slot ?? '' !!}
    </div>
</section>