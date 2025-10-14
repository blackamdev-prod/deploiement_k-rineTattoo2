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
                            <div class="showcase-item">
                                <div class="showcase-image">
                                    <img src="{{ asset('storage/assets/images/portfolio/image1.png') }}" alt="Fleur Minimaliste">
                                    <div class="showcase-overlay">
                                        <span class="showcase-tag">Minimaliste</span>
                                    </div>
                                </div>
                                <div class="showcase-content">
                                    <h5>Fleur Minimaliste</h5>
                                    <p>Line-art délicat</p>
                                </div>
                            </div>
                            <div class="showcase-item">
                                <div class="showcase-image">
                                    <img src="{{ asset('storage/assets/images/portfolio/image3.png') }}" alt="Rose Line-Art">
                                    <div class="showcase-overlay">
                                        <span class="showcase-tag">Line-Art</span>
                                    </div>
                                </div>
                                <div class="showcase-content">
                                    <h5>Rose Line-Art</h5>
                                    <p>Élégance pure</p>
                                </div>
                            </div>
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