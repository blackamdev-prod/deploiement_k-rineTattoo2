<!-- En-tête -->
<header class="header">
    <div class="container">
        <div class="header-content">
            <!-- Logo à Gauche -->
            <div class="logo desktop-logo">
                @isset($logo)
                    {!! $logo !!}
                @else
                    <img src="{{ asset('images/logo.png') }}" alt="K'RINE TATTOO" class="logo-img">
                @endisset
            </div>
            
            <!-- Navigation Desktop -->
            <nav class="nav-desktop">
                @isset($navigation)
                    {!! $navigation !!}
                @else
                    <a href="#home" class="nav-link">Accueil</a>
                    <a href="#about" class="nav-link">À Propos</a>
                    <a href="#services" class="nav-link">Services</a>
                    <a href="#portfolio" class="nav-link">Portfolio</a>
                    <a href="#contact" class="nav-link">Contact</a>
                @endisset
            </nav>
            
            <!-- CTA -->
            <div class="header-cta">
                @isset($cta)
                    {!! $cta !!}
                @else
                    <a href="#contact" class="btn btn-primary">Prendre RDV</a>
                @endisset
            </div>

            <!-- Bouton Menu Mobile -->
            <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="Ouvrir le menu de navigation" aria-expanded="false" aria-controls="mobileNav">
                <span class="hamburger-line hamburger-line-1"></span>
                <span class="hamburger-line hamburger-line-2"></span>
                <span class="hamburger-line hamburger-line-3"></span>
            </button>
        </div>

        <!-- Navigation Mobile -->
        <div class="nav-mobile" id="mobileNav">
            <div class="nav-mobile-content">
                <!-- Bouton de fermeture -->
                <button class="mobile-close-btn" id="mobileCloseBtn" aria-label="Fermer le menu">
                    <span class="close-line-1"></span>
                    <span class="close-line-2"></span>
                </button>
                
                <!-- Navigation Mobile Links -->
                @isset($mobileNavigation)
                    {!! $mobileNavigation !!}
                @else
                    <a href="#home" class="nav-link-mobile">Accueil</a>
                    <a href="#about" class="nav-link-mobile">À Propos</a>
                    <a href="#services" class="nav-link-mobile">Services</a>
                    <a href="#portfolio" class="nav-link-mobile">Portfolio</a>
                    <a href="#contact" class="nav-link-mobile">Contact</a>
                @endisset
                
                <!-- Portfolio Showcase Mobile -->
                @isset($mobileShowcase)
                    {!! $mobileShowcase !!}
                @else
                    <div class="mobile-portfolio-showcase">
                        <h4 class="showcase-title">Découvrez mes créations</h4>
                        <div class="showcase-grid">
                            @php
                                // Portfolio mobile showcase avec sélection aléatoire
                                $showcasePortfolio = collect([
                                    (object) [
                                        'title' => 'Line-art Floral Élégant',
                                        'description' => 'Composition délicate',
                                        'image' => 'assets/images/portfolio/image1.jpg',
                                        'category' => 'Line-art',
                                        'alt' => 'Tatouage floral délicat'
                                    ],
                                    (object) [
                                        'title' => 'Tatouages Minimalistes',
                                        'description' => 'Symboles significatifs',
                                        'image' => 'assets/images/portfolio/image2.jpg',
                                        'category' => 'Minimaliste',
                                        'alt' => 'Petits tatouages minimalistes'
                                    ],
                                    (object) [
                                        'title' => 'Branche Line-art',
                                        'description' => 'Motif végétal fin',
                                        'image' => 'assets/images/portfolio/image3.jpg',
                                        'category' => 'Line-art',
                                        'alt' => 'Branche en traits fins'
                                    ],
                                    (object) [
                                        'title' => 'Phénix Aquarelle',
                                        'description' => 'Couleurs vibrantes',
                                        'image' => 'assets/images/portfolio/image4.jpg',
                                        'category' => 'Couleur',
                                        'alt' => 'Phénix coloré style aquarelle'
                                    ],
                                    (object) [
                                        'title' => 'Design Minimaliste',
                                        'description' => 'Épuré et délicat',
                                        'image' => 'assets/images/portfolio/image5.jpg',
                                        'category' => 'Line-art',
                                        'alt' => 'Design minimaliste rouge'
                                    ],
                                    (object) [
                                        'title' => 'Portrait Réaliste',
                                        'description' => 'Technique détaillée',
                                        'image' => 'assets/images/portfolio/image6.jpg',
                                        'category' => 'Réaliste',
                                        'alt' => 'Portrait féminin réaliste'
                                    ],
                                    (object) [
                                        'title' => 'Calligraphie et Roses',
                                        'description' => 'Art et lettrage',
                                        'image' => 'assets/images/portfolio/image7.jpg',
                                        'category' => 'Réaliste',
                                        'alt' => 'Calligraphie avec roses'
                                    ],
                                    (object) [
                                        'title' => 'Design Tribal Moderne',
                                        'description' => 'Géométrie contemporaine',
                                        'image' => 'assets/images/portfolio/image8.jpg',
                                        'category' => 'Réaliste',
                                        'alt' => 'Motifs géométriques tribaux'
                                    ]
                                ]);
                                
                                // Sélection aléatoire de 4 éléments pour la vitrine mobile
                                $randomShowcase = $showcasePortfolio->shuffle()->take(4);
                            @endphp
                            
                            @foreach($randomShowcase as $item)
                                <div class="showcase-item">
                                    <div class="showcase-image">
                                        <img src="{{ asset($item->image) }}" alt="{{ $item->alt }}" loading="lazy">
                                        <div class="showcase-overlay">
                                            <span class="showcase-tag">{{ $item->category }}</span>
                                        </div>
                                    </div>
                                    <div class="showcase-content">
                                        <h5>{{ $item->title }}</h5>
                                        <p>{{ $item->description }}</p>
                                    </div>
                                </div>
                            @endforeach
                        </div>
                        <a href="#portfolio" class="showcase-link nav-link-mobile">Voir tout le portfolio</a>
                    </div>
                @endisset
            </div>
        </div>
        
        <!-- Additional Content Slot -->
        {!! $slot ?? '' !!}
    </div>
</header>