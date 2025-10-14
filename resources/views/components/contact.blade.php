<!-- Section Contact -->
<section id="contact" class="contact">
    <div class="container">
        <div class="section-header text-center">
            @isset($sectionHeader)
                {!! $sectionHeader !!}
            @else
                <h2 class="section-title">
                    Nous <span class="title-accent">Contacter</span>
                </h2>
                <div class="title-underline"></div>
                <p class="section-description">
                    Prêt à donner vie à votre projet ? Contactez-moi pour une consultation personnalisée 
                    et découvrons ensemble comment créer votre tatouage unique.
                </p>
            @endisset
        </div>

        <div class="contact-content">
            <!-- Formulaire Contact -->
            <div class="contact-form-container">
                <div class="contact-form-card">
                    @isset($formTitle)
                        {!! $formTitle !!}
                    @else
                        <h3 class="form-title">
                            <i data-lucide="calendar" class="icon-md"></i>
                            Demande de Rendez-vous
                        </h3>
                    @endisset
                    
                    @isset($contactForm)
                        {!! $contactForm !!}
                    @else
                        <!-- Messages de succès/erreur -->
                        @if(session('success'))
                            <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                                {{ session('success') }}
                            </div>
                        @endif

                        @if(session('error'))
                            <div class="alert alert-error" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                                {{ session('error') }}
                            </div>
                        @endif

                        @if($errors->any())
                            <div class="alert alert-error" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                                <ul style="margin: 0; padding-left: 20px;">
                                    @foreach($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        <form class="contact-form" action="/demande-rendez-vous" method="POST" enctype="multipart/form-data">
                            @csrf
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Prénom *</label>
                                    <input type="text" name="prenom" placeholder="Votre prénom" value="{{ old('prenom') }}" required>
                                </div>
                                <div class="form-group">
                                    <label>Nom *</label>
                                    <input type="text" name="nom" placeholder="Votre nom" value="{{ old('nom') }}" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Email *</label>
                                <input type="email" name="email" placeholder="votre@email.fr" value="{{ old('email') }}" required>
                            </div>

                            <div class="form-group">
                                <label>Téléphone</label>
                                <input type="tel" name="telephone" placeholder="+596 696 00 44 21" value="{{ old('telephone') }}">
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Style souhaité</label>
                                    <select name="style">
                                        <option value="">Sélectionner un style</option>
                                        <option value="realiste">Réaliste</option>
                                        <option value="geometrique">Géométrique</option>
                                        <option value="traditionnel">Traditionnel</option>
                                        <option value="cover-up">Cover-up</option>
                                        <option value="autre">Autre</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Zone du corps</label>
                                    <select name="zone">
                                        <option value="">Sélectionner une zone</option>
                                        <option value="bras">Bras</option>
                                        <option value="avant-bras">Avant-bras</option>
                                        <option value="epaule">Épaule</option>
                                        <option value="dos">Dos</option>
                                        <option value="poitrine">Poitrine</option>
                                        <option value="jambe">Jambe</option>
                                        <option value="autre">Autre</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Taille du tatouage</label>
                                <select name="taille">
                                    <option value="">Sélectionner une taille</option>
                                    <option value="petit">Petit (moins de 5 cm)</option>
                                    <option value="moyen">Moyen (5-10 cm)</option>
                                    <option value="grand">Grand (10-20 cm)</option>
                                    <option value="tres-grand">Très grand (plus de 20 cm)</option>
                                    <option value="sur-mesure">Pièce sur mesure</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Description de votre projet *</label>
                                <textarea name="description" placeholder="Décrivez-moi votre idée de tatouage, vos inspirations, la taille souhaitée..." required>{{ old('description') }}</textarea>
                            </div>

                            <div class="form-group">
                                <label>Images de référence (optionnel)</label>
                                <input type="file" name="files[]" multiple accept=".png,.jpg,.jpeg,.webp">
                                <small>PNG, JPG, WEBP - Max 10MB par fichier</small>
                            </div>

                            <button type="submit" class="btn btn-primary btn-full">
                                Envoyer ma Demande
                            </button>

                            <p class="form-note">
                                Je vous répondrai dans les 24h pour organiser notre première consultation.
                            </p>
                        </form>
                    @endisset
                </div>
            </div>


            <!-- Info Contact & Horaires -->
            <div class="contact-info-container">
                <!-- Informations Contact -->
                <div class="contact-info-card">
                    @isset($contactInfo)
                        {!! $contactInfo !!}
                    @else
                        <h3>Informations de Contact</h3>
                        <div class="contact-details">
                            <div class="contact-detail">
                                <i data-lucide="map-pin" class="icon-md"></i>
                                <div>
                                    <h4>Adresse</h4>
                                    <p>K'rine Tattoo<br>2 Rue des Barrières<br>97232 Le Lamentin, Martinique</p>
                                </div>
                            </div>
                            <div class="contact-detail">
                                <i data-lucide="smartphone" class="icon-md"></i>
                                <div>
                                    <h4>Téléphone</h4>
                                    <a href="tel:+59669600442">+596 696 00 44 21</a>
                                </div>
                            </div>
                            <div class="contact-detail">
                                <i data-lucide="at-sign" class="icon-md"></i>
                                <div>
                                    <h4>Email</h4>
                                    <a href="mailto:krinetattoo@gmail.com">krinetattoo@gmail.com</a>
                                </div>
                            </div>
                            <div class="contact-detail">
                                <i data-lucide="camera" class="icon-md"></i>
                                <div>
                                    <h4>Instagram</h4>
                                    <a href="#" target="_blank">@krine_tattoo</a>
                                </div>
                            </div>
                        </div>
                    @endisset
                </div>

                <!-- Horaires d'Ouverture -->
                <div class="hours-card">
                    @isset($hours)
                        {!! $hours !!}
                    @else
                        <h3>
                            <i data-lucide="timer" class="icon-md"></i>
                            Horaires d'Ouverture
                        </h3>
                        <div class="hours-list">
                            <div class="hour-item">
                                <span>Lundi</span>
                                <span class="closed">Fermé</span>
                            </div>
                            <div class="hour-item">
                                <span>Mardi</span>
                                <span>10h - 17h</span>
                            </div>
                            <div class="hour-item">
                                <span>Mercredi</span>
                                <span>10h - 17h</span>
                            </div>
                            <div class="hour-item">
                                <span>Jeudi</span>
                                <span>10h - 17h</span>
                            </div>
                            <div class="hour-item">
                                <span>Vendredi</span>
                                <span>10h - 17h</span>
                            </div>
                            <div class="hour-item">
                                <span>Samedi</span>
                                <span>10h - 17h</span>
                            </div>
                            <div class="hour-item">
                                <span>Dimanche</span>
                                <span class="closed">Fermé</span>
                            </div>
                        </div>
                        
                        <div class="hours-note">
                            <p><strong>Tatouages uniquement sur rendez-vous.</strong><br>
                            N'hésitez pas à me contacter pour organiser notre rencontre.</p>
                        </div>
                    @endisset
                </div>

                <!-- Contact Urgence -->
                <div class="emergency-contact">
                    @isset($emergencyContact)
                        {!! $emergencyContact !!}
                    @else
                        <h3>Suivi Post-Tatouage</h3>
                        <p>Besoin de conseils après votre tatouage ?<br>
                        Je suis disponible 5j/7 pour le suivi de cicatrisation.</p>
                    @endisset
                </div>
            </div>
        </div>

        <!-- Carte Google Maps -->
        <div class="map-container">
            @isset($mapSection)
                {!! $mapSection !!}
            @else
                <h3 class="map-title">
                    <i data-lucide="map-pin" class="icon-md"></i>
                    Localisation du Studio
                </h3>
                <div class="map-wrapper">
                    <iframe 
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3774.1234567890!2d-61.003456!3d14.586789!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8c14c1234567890%3A0x1234567890abcdef!2s2%20Rue%20des%20Barri%C3%A8res%2C%2097232%20Le%20Lamentin%2C%20Martinique!5e0!3m2!1sfr!2sfr!4v1234567890123!5m2!1sfr!2sfr"
                        width="100%" 
                        height="400" 
                        style="border:0;" 
                        allowfullscreen="" 
                        loading="lazy" 
                        referrerpolicy="no-referrer-when-downgrade">
                    </iframe>
                </div>
                <p class="map-description">
                    📍 Studio facilement accessible au cœur du Lamentin<br>
                    🚗 Parking disponible à proximité
                </p>
            @endisset
        </div>
        
        <!-- Additional Content Slot -->
        {!! $slot ?? '' !!}
    </div>
</section>