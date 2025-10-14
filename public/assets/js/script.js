// Basculement Menu Mobile
document.addEventListener('DOMContentLoaded', function() {
    // Gestion de la disparition du header dans la section hero
    const header = document.querySelector('.header');
    const heroSection = document.querySelector('.hero');
    
    function handleHeaderVisibility() {
        if (heroSection) {
            const heroRect = heroSection.getBoundingClientRect();
            const isInHeroSection = heroRect.top <= 0 && heroRect.bottom >= 0;
            
            if (isInHeroSection) {
                header.classList.add('hidden');
            } else {
                header.classList.remove('hidden');
            }
        }
    }
    
    // Écouter le scroll
    window.addEventListener('scroll', handleHeaderVisibility);
    // Vérifier au chargement initial
    handleHeaderVisibility();
    
    // Effet Parallax harmonisé
    function handleParallax() {
        const scrolled = window.pageYOffset;
        const windowHeight = window.innerHeight;
        
        // Système de vitesses harmonisées basées sur le nombre d'or (φ = 1.618)
        const baseSpeed = 0.1;
        const phi = 1.618;
        
        // Parallax vidéo hero - mouvement plus subtil
        const heroVideo = document.querySelector('.hero-video');
        if (heroVideo) {
            const speed = scrolled * baseSpeed * phi; // ~0.162
            heroVideo.style.transform = `translateY(${-speed}px)`;
        }
        
        // Parallax éléments décoratifs - vitesses échelonnées
        const decorativeBoxes = document.querySelectorAll('.decorative-box');
        decorativeBoxes.forEach((box, index) => {
            const rect = box.getBoundingClientRect();
            const elementTop = rect.top + scrolled;
            const elementVisible = scrolled + windowHeight > elementTop && rect.bottom > 0;
            
            if (elementVisible) {
                const speedMultiplier = (index + 1) * (baseSpeed / phi); // 0.062, 0.124
                const normalizedScroll = (scrolled - elementTop + windowHeight) * speedMultiplier;
                box.style.transform = `translateY(${normalizedScroll}px) rotate(${normalizedScroll * 0.1}deg)`;
            }
        });
        
        // Parallax icônes - mouvement uniforme et subtil
        const icons = document.querySelectorAll('.service-icon, .feature-icon');
        icons.forEach((icon) => {
            const rect = icon.getBoundingClientRect();
            const elementTop = rect.top + scrolled;
            const elementVisible = scrolled + windowHeight > elementTop && rect.bottom > 0;
            
            if (elementVisible) {
                const centerProgress = (scrolled + windowHeight/2 - elementTop) / windowHeight;
                const parallaxSpeed = Math.sin(centerProgress * Math.PI) * baseSpeed * 20;
                icon.style.transform = `translateY(${parallaxSpeed}px)`;
            }
        });
        
        // Parallax images portfolio - effet d'ondulation
        const portfolioImages = document.querySelectorAll('.portfolio-image img');
        portfolioImages.forEach((img, index) => {
            const rect = img.getBoundingClientRect();
            const elementTop = rect.top + scrolled;
            const elementVisible = scrolled + windowHeight > elementTop && rect.bottom > 0;
            
            if (elementVisible) {
                const progress = (scrolled + windowHeight - elementTop) / (windowHeight + rect.height);
                const wave = Math.sin(progress * Math.PI + index * 0.5) * baseSpeed * 15;
                img.style.transform = `translateY(${wave}px) scale(${1 + Math.abs(wave) * 0.001})`;
            }
        });
        
        // Parallax sur les statistiques
        const stats = document.querySelectorAll('.stat');
        stats.forEach((stat, index) => {
            const rect = stat.getBoundingClientRect();
            const elementTop = rect.top + scrolled;
            const elementVisible = scrolled + windowHeight > elementTop && rect.bottom > 0;
            
            if (elementVisible) {
                const delay = index * 0.1;
                const progress = Math.max(0, Math.min(1, (scrolled + windowHeight - elementTop) / windowHeight));
                const easeProgress = progress * progress * (3 - 2 * progress); // smooth step
                const translateY = (1 - easeProgress) * 30;
                stat.style.transform = `translateY(${translateY}px)`;
                stat.style.opacity = easeProgress;
            }
        });
    }
    
    // Détection des capacités de l'appareil
    const isLowPerformanceDevice = () => {
        return window.navigator.hardwareConcurrency < 4 || 
               window.devicePixelRatio > 2 ||
               /Mobi|Android/i.test(navigator.userAgent);
    };
    
    // Configuration du parallax selon les performances
    const parallaxConfig = {
        enabled: !isLowPerformanceDevice(),
        reducedMotion: window.matchMedia('(prefers-reduced-motion: reduce)').matches
    };
    
    // Optimisation des performances avec throttle intelligent
    let ticking = false;
    let lastScrollTop = 0;
    const scrollThreshold = 5; // Seuil minimum de scroll pour déclencher l'animation
    
    function updateParallax() {
        const currentScrollTop = window.pageYOffset;
        
        if (!parallaxConfig.enabled || 
            parallaxConfig.reducedMotion ||
            Math.abs(currentScrollTop - lastScrollTop) < scrollThreshold) {
            return;
        }
        
        if (!ticking) {
            requestAnimationFrame(() => {
                handleParallax();
                lastScrollTop = currentScrollTop;
                ticking = false;
            });
            ticking = true;
        }
    }
    
    // Écouter le scroll pour le parallax seulement si les performances le permettent
    if (parallaxConfig.enabled && !parallaxConfig.reducedMotion) {
        window.addEventListener('scroll', updateParallax, { passive: true });
        // Initialiser au chargement
        requestAnimationFrame(handleParallax);
    }
    
    // Gérer les changements de préférences d'accessibilité
    window.matchMedia('(prefers-reduced-motion: reduce)').addEventListener('change', (e) => {
        parallaxConfig.reducedMotion = e.matches;
        if (e.matches) {
            // Réinitialiser tous les transforms si l'utilisateur préfère la réduction de mouvement
            document.querySelectorAll('.hero-video, .decorative-box, .service-icon, .feature-icon, .portfolio-image img, .stat').forEach(el => {
                el.style.transform = '';
                el.style.opacity = '';
            });
        }
    });
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const mobileNav = document.getElementById('mobileNav');
    const mobileCloseBtn = document.getElementById('mobileCloseBtn');
    
    // Function to close mobile menu with elegant animation
    function closeMobileMenu() {
        if (mobileNav.classList.contains('active')) {
            mobileNav.classList.add('closing');
            mobileMenuBtn.classList.remove('active');
            
            // Update accessibility attributes
            mobileMenuBtn.setAttribute('aria-expanded', 'false');
            mobileMenuBtn.setAttribute('aria-label', 'Ouvrir le menu de navigation');
            
            setTimeout(() => {
                mobileNav.classList.remove('active', 'closing');
            }, 400); // Match CSS transition duration
        }
    }
    
    if (mobileMenuBtn && mobileNav) {
        mobileMenuBtn.addEventListener('click', function() {
            const isOpen = mobileNav.classList.contains('active');
            
            if (isOpen) {
                closeMobileMenu();
            } else {
                // Ouvrir le menu - Transformation CSS pure
                mobileMenuBtn.classList.add('active');
                mobileNav.classList.add('active');
                mobileMenuBtn.setAttribute('aria-expanded', 'true');
                mobileMenuBtn.setAttribute('aria-label', 'Fermer le menu de navigation');
            }
        });
    }
    
    // Gestionnaire pour le bouton de fermeture dédié
    if (mobileCloseBtn) {
        mobileCloseBtn.addEventListener('click', function() {
            closeMobileMenu();
        });
    }
    
    // Fermer menu mobile au clic sur les liens
    const mobileLinks = document.querySelectorAll('.nav-link-mobile');
    mobileLinks.forEach(link => {
        link.addEventListener('click', function() {
            closeMobileMenu();
        });
    });
    
    // Fermer menu mobile au clic sur l'overlay (style Patek Philippe)
    if (mobileNav) {
        mobileNav.addEventListener('click', function(e) {
            if (e.target === mobileNav) {
                closeMobileMenu();
            }
        });
    }
    
    // Fermer menu mobile avec la touche Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && mobileNav.classList.contains('active')) {
            closeMobileMenu();
        }
    });
    
    // Filtre Portfolio
    const filterBtns = document.querySelectorAll('.filter-btn');
    const portfolioItems = document.querySelectorAll('.portfolio-item');
    
    filterBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const filter = this.getAttribute('data-filter');
            
            // Mettre à jour bouton actif
            filterBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            
            // Filtrer les éléments
            portfolioItems.forEach(item => {
                if (filter === 'all' || item.getAttribute('data-category') === filter) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    });
    
    // Défilement fluide pour liens navigation
    const navLinks = document.querySelectorAll('a[href^="#"]');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Gestionnaire Formulaire Contact
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            // Ajouter votre logique d'envoi de formulaire ici
            alert('Merci pour votre message ! Nous vous recontacterons bientôt.');
        });
    }


    // Gestionnaire Upload de Fichiers
    const fileInput = document.getElementById('fileUpload');
    const fileList = document.getElementById('fileList');
    let uploadedFiles = [];

    if (fileInput && fileList) {
        fileInput.addEventListener('change', function(e) {
            const files = Array.from(e.target.files);
            
            files.forEach(file => {
                // Vérifier la taille du fichier (5MB max)
                if (file.size > 5 * 1024 * 1024) {
                    alert(`Le fichier "${file.name}" est trop volumineux (max 5MB)`);
                    return;
                }
                
                // Ajouter le fichier à la liste
                uploadedFiles.push(file);
                addFileToList(file);
            });
            
            // Réinitialiser l'input pour permettre de sélectionner le même fichier
            fileInput.value = '';
        });
    }

    function addFileToList(file) {
        const fileItem = document.createElement('div');
        fileItem.className = 'file-item';
        
        const fileInfo = document.createElement('div');
        fileInfo.className = 'file-item-info';
        
        const fileIcon = document.createElement('i');
        fileIcon.setAttribute('data-lucide', getFileIcon(file.type));
        fileIcon.className = 'icon-sm';
        
        const fileName = document.createElement('span');
        fileName.className = 'file-item-name';
        fileName.textContent = file.name;
        
        const removeBtn = document.createElement('button');
        removeBtn.className = 'file-remove';
        removeBtn.type = 'button';
        removeBtn.innerHTML = '<i data-lucide="x" class="icon-sm"></i>';
        
        removeBtn.addEventListener('click', function() {
            // Retirer le fichier de la liste
            const index = uploadedFiles.indexOf(file);
            if (index > -1) {
                uploadedFiles.splice(index, 1);
            }
            fileItem.remove();
        });
        
        fileInfo.appendChild(fileIcon);
        fileInfo.appendChild(fileName);
        fileItem.appendChild(fileInfo);
        fileItem.appendChild(removeBtn);
        
        fileList.appendChild(fileItem);
        
        // Réinitialiser les icônes Lucide pour les nouveaux éléments
        lucide.createIcons();
    }

    function getFileIcon(fileType) {
        if (fileType.startsWith('image/')) {
            return 'image';
        } else if (fileType === 'application/pdf') {
            return 'file-text';
        } else {
            return 'file';
        }
    }

    // Portfolio Image Zoom Functionality
    const portfolioImages = document.querySelectorAll('.portfolio-image img');
    const portfolioOverlays = document.querySelectorAll('.portfolio-overlay');
    
    // Créer le modal de zoom
    const zoomModal = document.createElement('div');
    zoomModal.className = 'portfolio-zoom-modal';
    zoomModal.innerHTML = `
        <div class="zoom-overlay"></div>
        <div class="zoom-content">
            <img src="" alt="" class="zoom-image">
            <button class="zoom-close" aria-label="Fermer">&times;</button>
        </div>
    `;
    document.body.appendChild(zoomModal);

    const zoomOverlay = zoomModal.querySelector('.zoom-overlay');
    const zoomImage = zoomModal.querySelector('.zoom-image');
    const zoomClose = zoomModal.querySelector('.zoom-close');

    // Fonction pour ouvrir le zoom
    function openZoom(imageSrc, imageAlt) {
        zoomImage.src = imageSrc;
        zoomImage.alt = imageAlt;
        zoomModal.classList.add('active');
        document.body.style.overflow = 'hidden';
        
        // Animation d'entrée
        requestAnimationFrame(() => {
            zoomModal.style.opacity = '1';
            zoomImage.style.transform = 'scale(1)';
        });
    }

    // Fonction pour fermer le zoom
    function closeZoom() {
        zoomModal.style.opacity = '0';
        zoomImage.style.transform = 'scale(0.8)';
        
        setTimeout(() => {
            zoomModal.classList.remove('active');
            document.body.style.overflow = '';
        }, 300);
    }

    // Ajouter les événements de clic sur les overlays
    portfolioOverlays.forEach((overlay, index) => {
        overlay.addEventListener('click', (e) => {
            e.preventDefault();
            const img = portfolioImages[index];
            if (img) {
                openZoom(img.src, img.alt);
            }
        });
    });

    // Fermer le modal
    zoomClose.addEventListener('click', closeZoom);
    zoomOverlay.addEventListener('click', closeZoom);

    // Fermer avec la touche Escape
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && zoomModal.classList.contains('active')) {
            closeZoom();
        }
    });
});