<!-- Section Héro -->
<section id="home" class="hero">
    @isset($backgroundVideo)
        {!! $backgroundVideo !!}
    @else
        <video class="hero-video" autoplay muted loop>
            <source src="assets/videos/fume.mp4" type="video/mp4">
        </video>
    @endisset
    
    <div class="hero-overlay"></div>
    <div class="container">
        <div class="hero-content">
            <div class="hero-text">
                <div class="hero-brand">
                    @isset($heroLogo)
                        {!! $heroLogo !!}
                    @endif
                    <div class="hero-title">
                        @isset($title)
                            {!! $title !!}
                        @else
                            <h1 class="title-main">K'RINE</h1>
                            <h1 class="title-accent">TATTOO</h1>
                        @endisset
                    </div>
                </div>
                
                <p class="hero-description">
                    {{ $description ?? "L'art du tatouage redéfini. Découvrez un univers où créativité, expertise et passion se rencontrent pour créer votre œuvre d'art corporelle unique." }}
                </p>

                <div class="hero-buttons">
                    @isset($buttons)
                        {!! $buttons !!}
                    @else
                        <a href="#contact" class="btn btn-primary btn-lg">
                            Prendre Rendez-vous
                            <i data-lucide="arrow-right" class="icon-sm"></i>
                        </a>
                        <a href="#portfolio" class="btn btn-outline btn-lg">
                            Voir Portfolio
                        </a>
                    @endisset
                </div>

            </div>

            <!-- Image Mise en Avant -->
            <div class="hero-image">
                @isset($heroImage)
                    {!! $heroImage !!}
                @else
                    <div class="image-container">
                        <!-- Image avec fallback multiple -->
                        <img src="{{ asset('assets/images/artiste.png') }}" 
                             alt="K'rine - Artiste tatoueur professionnel au travail" 
                             class="featured-img"
                             loading="eager"
                             width="400"
                             height="600"
                             onerror="this.onerror=null; this.src='{{ asset('storage/assets/images/artiste.png') }}'; if(!this.complete || this.naturalHeight === 0) { this.style.display='none'; document.querySelector('.featured-img-fallback').style.display='flex'; }">
                        
                        <!-- Fallback élégant avec SVG -->
                        <div class="featured-img-fallback" style="display: none;">
                            <div class="artist-silhouette">
                                <svg viewBox="0 0 400 600" class="artist-svg">
                                    <!-- Silhouette d'artiste tatoueur -->
                                    <defs>
                                        <linearGradient id="artistGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                                            <stop offset="0%" style="stop-color:#D4B896;stop-opacity:0.8" />
                                            <stop offset="100%" style="stop-color:#8B7355;stop-opacity:0.6" />
                                        </linearGradient>
                                    </defs>
                                    <!-- Corps -->
                                    <ellipse cx="200" cy="150" rx="60" ry="80" fill="url(#artistGrad)" opacity="0.7"/>
                                    <!-- Tête -->
                                    <circle cx="200" cy="80" r="35" fill="url(#artistGrad)" opacity="0.8"/>
                                    <!-- Bras avec machine à tatouer -->
                                    <rect x="260" y="120" width="40" height="15" rx="7" fill="url(#artistGrad)" opacity="0.6"/>
                                    <!-- Machine à tatouer -->
                                    <rect x="300" y="115" width="20" height="25" rx="3" fill="#D4B896" opacity="0.9"/>
                                    <!-- Détails décoratifs -->
                                    <circle cx="180" cy="70" r="3" fill="#D4B896"/>
                                    <circle cx="220" cy="75" r="2" fill="#D4B896"/>
                                    <path d="M170,400 Q200,350 230,400 T290,420" stroke="#D4B896" stroke-width="2" fill="none" opacity="0.5"/>
                                    <path d="M110,450 Q140,400 170,450 T230,470" stroke="#D4B896" stroke-width="1" fill="none" opacity="0.3"/>
                                </svg>
                            </div>
                            <div class="artist-info">
                                <h3>K'rine</h3>
                                <p>Artiste Tatoueur Professionnel</p>
                                <div class="artist-features">
                                    <span><i data-lucide="award"></i> +5 ans d'expérience</span>
                                    <span><i data-lucide="heart"></i> Art personnalisé</span>
                                    <span><i data-lucide="star"></i> Expertise technique</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="decorative-box decorative-box-1"></div>
                    <div class="decorative-box decorative-box-2"></div>
                @endisset
            </div>
        </div>
        
        <!-- Additional Content Slot -->
        {!! $slot ?? '' !!}
    </div>
</section>