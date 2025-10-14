<!-- Section À Propos -->
<section id="about" class="about">
    <div class="container">
        <div class="about-content">
            <div class="about-text">
                <div class="section-header">
                    @isset($sectionTitle)
                        {!! $sectionTitle !!}
                    @else
                        <h2 class="section-title">
                            À Propos de<br>
                            <span class="title-accent">K'RINE TATTOO</span>
                        </h2>
                        <div class="title-underline"></div>
                    @endisset
                </div>

                <div class="about-description">
                    @isset($description)
                        {!! $description !!}
                    @else
                        <p>
                            Découvrez l'<span class="highlight-word">univers artistique</span> de K'RINE TATTOO, où chaque trait d'aiguille raconte une histoire unique. Depuis plus de cinq années de passion dédiée à l'art corporel, je donne vie à vos <span class="highlight-word">projets les plus personnels</span>, créant des œuvres qui vous accompagneront toute votre vie.
                        </p>
                        
                        <p>
                            Votre vision devient réalité grâce à mon <span class="highlight-word">approche personnalisée</span> et mon <span class="highlight-word">expertise technique</span>. Ensemble, nous créons une <span class="highlight-word">œuvre sur mesure</span> qui reflète parfaitement votre personnalité, vos valeurs et votre esthétique personnelle.
                        </p>

                        <p>
                            Dans mon studio situé au cœur de la Martinique, je vous accueille dans un <span class="highlight-word">environnement professionnel</span> alliant confort et sécurité. Chaque séance se déroule dans le respect des <span class="highlight-word">normes d'hygiène les plus strictes</span>, pour une expérience sereine et mémorable.
                        </p>
                    @endisset
                </div>

                <!-- Grille des Fonctionnalités -->
                <div class="features-grid">
                    @isset($features)
                        {!! $features !!}
                    @else
                        <div class="feature">
                            <i data-lucide="paintbrush-2" class="feature-icon"></i>
                            <h3 class="feature-title">Créativité Unique</h3>
                            <p class="feature-description">Chaque tatouage est une œuvre d'art personnalisée, créée spécialement pour vous refléter votre personnalité.</p>
                        </div>
                        <div class="feature">
                            <i data-lucide="sparkle" class="feature-icon"></i>
                            <h3 class="feature-title">Passion Authentique</h3>
                            <p class="feature-description">Une passion sincère pour l'art du tatouage qui transparaît dans chaque création et chaque interaction.</p>
                        </div>
                        <div class="feature">
                            <i data-lucide="badge-check" class="feature-icon"></i>
                            <h3 class="feature-title">Hygiène Irréprochable</h3>
                            <p class="feature-description">Respect strict des normes sanitaires les plus élevées pour votre sécurité et votre tranquillité d'esprit.</p>
                        </div>
                        <div class="feature">
                            <i data-lucide="gem" class="feature-icon"></i>
                            <h3 class="feature-title">Excellence Reconnue</h3>
                            <p class="feature-description">Une réputation d'excellence bâtie au fil des années grâce à un savoir-faire exceptionnel et reconnu.</p>
                        </div>
                    @endisset
                </div>
            </div>

            <!-- Carte Profil -->
            <div class="profile-card">
                @isset($profileCard)
                    {!! $profileCard !!}
                @else
                    <div class="profile-content">
                        <img src="{{ asset('storage/assets/images/logo.png') }}" alt="K'RINE TATTOO Logo" class="profile-logo">
                        <h3 class="profile-name">Karine Gertrude</h3>
                        <p class="profile-title">Artiste Tatoueuse Professionnelle</p>
                        <div class="profile-credentials">
                            <p>• Spécialiste styles Réaliste,Minimaliste & Line-art </p>
                            <p>• Formation Hygiene et Salubrite dans les metiers de l'Esthetique et Tatouage. </p>
                        </div>
                    </div>
                    
                    <div class="profile-quote">
                        <blockquote>
                            Chaque tatouage est une collaboration entre l'artiste et le client pour créer quelque chose d'unique et de personnel.
                        </blockquote>
                        <div class="quote-signature">Karine, Artiste Tatoueur</div>
                    </div>
                @endisset
            </div>
        </div>
        
        <!-- Additional Content Slot -->
        {!! $slot ?? '' !!}
    </div>
</section>