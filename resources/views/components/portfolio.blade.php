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
                    $portfolios = \App\Models\Portfolio::active()->ordered()->get();
                    // Debug: Afficher le nombre de portfolios trouvés
                    // dd($portfolios->count(), $portfolios->pluck(['id', 'title', 'image'])->toArray());
                @endphp
                
                {{-- Debug temporaire : Nombre de portfolios --}}
                <!-- Total portfolios actifs: {{ $portfolios->count() }} -->
                
                @foreach($portfolios as $portfolio)
                    <div class="portfolio-item" data-category="{{ $portfolio->category }}">
                        <div class="portfolio-image">
                            <img src="{{ asset('storage/' . $portfolio->image) }}" alt="{{ $portfolio->title }}">
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
                            @if($portfolio->duration || $portfolio->zone)
                                <div class="portfolio-details">
                                    @if($portfolio->duration)
                                        <div><strong>Durée:</strong> {{ $portfolio->duration }}</div>
                                    @endif
                                    @if($portfolio->zone)
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