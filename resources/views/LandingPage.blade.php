<!DOCTYPE html>
<html lang="fr">
@include('components.head')
<body>

    @include('components.header')

    <!-- Contenu Principal -->
    <main class="main-content">
        @include('components.hero')
        @include('components.about')
        @include('components.services')
        @include('components.portfolio')
        @include('components.contact')
    </main>

    @include('components.footer')

    <!-- JavaScript -->
    <script src="assets/js/script.js"></script>
    <script>
        // Initialize Lucide icons
        lucide.createIcons();
    </script>
</body>