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
                        <img src="{{ asset('storage/assets/images/artiste.png') }}" 
                             alt="K'rine - Artiste tatoueur professionnel au travail" 
                             class="featured-img"
                             loading="eager"
                             width="400"
                             height="600">
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