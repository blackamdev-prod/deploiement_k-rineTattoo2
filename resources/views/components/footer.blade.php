<!-- Pied de Page -->
<footer class="footer">
    <div class="container">
        <!-- Contenu Principal Pied de Page -->
        <div class="footer-content">
            <!-- Colonne Marque -->
            <div class="footer-brand">
                @isset($footerBrand)
                    {!! $footerBrand !!}
                @else
                    <div class="footer-logo">
                        <img src="{{ asset('images/logo.png') }}" alt="K'RINE TATTOO">
                        <div>
                            <h3>K'RINE</h3>
                            <p>TATTOO</p>
                        </div>
                    </div>
                    
                    <p class="footer-description">
                        L'art du tatouage redéfini depuis plus de 5 ans. 
                        Chaque création est unique et personnalisée selon vos souhaits.
                    </p>

                    <div class="social-links">
                        <a href="#" class="social-link">
                            <i data-lucide="camera"></i>
                        </a>
                        <a href="#" class="social-link">
                            <i data-lucide="users"></i>
                        </a>
                    </div>
                @endisset
            </div>

            <!-- Liens Rapides -->
            <div class="footer-links">
                @isset($navigationLinks)
                    {!! $navigationLinks !!}
                @else
                    <h4>Navigation</h4>
                    <ul>
                        <li><a href="#home">Accueil</a></li>
                        <li><a href="#about">À Propos</a></li>
                        <li><a href="#services">Services</a></li>
                        <li><a href="#portfolio">Portfolio</a></li>
                        <li><a href="#contact">Contact</a></li>
                    </ul>
                @endisset
            </div>

            <!-- Services -->
            <div class="footer-links">
                @isset($servicesLinks)
                    {!! $servicesLinks !!}
                @else
                    <h4>Nos Services</h4>
                    <ul>
                        <li>Tatouage Personnalisé</li>
                        <li>Tatouage Réaliste</li>
                        <li>Tatouage Minimaliste & Line-Art</li>
                        <li>Retouche</li>
                        <li>Consultation Gratuite</li>
                    </ul>
                @endisset
            </div>

            <!-- Info Contact -->
            <div class="footer-contact">
                @isset($footerContact)
                    {!! $footerContact !!}
                @else
                    <h4>Contact</h4>
                    <div class="footer-contact-item">
                        <i data-lucide="map-pin" class="icon-sm"></i>
                        <div>
                            <p>2 Rue des Barrières</p>
                            <p>97232 Le Lamentin, Martinique</p>
                        </div>
                    </div>
                    
                    <div class="footer-contact-item">
                        <i data-lucide="smartphone" class="icon-sm"></i>
                        <a href="tel:+59669600442">+596 696 00 44 21</a>
                    </div>
                    
                    <div class="footer-contact-item">
                        <i data-lucide="at-sign" class="icon-sm"></i>
                        <a href="mailto:krinetattoo@gmail.com">krinetattoo@gmail.com</a>
                    </div>

                    <div class="footer-hours">
                        <p><strong>Horaires:</strong><br>
                        Mar-Sam: 10h-17h<br>
                        Sur RDV uniquement</p>
                    </div>
                @endisset
            </div>
        </div>

        <!-- Barre Inférieure -->
        <div class="footer-bottom">
            <div class="footer-bottom-content">
                @isset($footerBottomContent)
                    {!! $footerBottomContent !!}
                @else
                    <p>© 2025 K'RINE TATTOO. Tous droits réservés.</p>
                    
                    <div class="footer-made-with">
                        <span>Créé par</span>
                        <span>BLACKAM</span>
                    </div>
                @endisset
            </div>

            <div class="footer-legal">
                @isset($footerLegal)
                    {!! $footerLegal !!}
                @else
                    <a href="#">Mentions Légales</a>
                    <a href="#">Politique de Confidentialité</a>
                    <a href="#">Conditions d'Utilisation</a>
                    <a href="#">Soins Post-Tatouage</a>
                @endisset
            </div>
        </div>
        
        <!-- Additional Content Slot -->
        {!! $slot ?? '' !!}
    </div>
</footer>