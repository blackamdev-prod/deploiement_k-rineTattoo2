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
                
                <!-- Navigation simplifiée mobile - CTA optimisé -->
                <div class="mobile-cta-section">
                    <a href="#contact" class="btn btn-primary mobile-cta-btn">Prendre Rendez-vous</a>
                    <p class="mobile-tagline">Créons ensemble votre œuvre d'art corporelle unique</p>
                </div>
            </div>
        </div>
        
        <!-- Additional Content Slot -->
        {!! $slot ?? '' !!}
    </div>
</header>