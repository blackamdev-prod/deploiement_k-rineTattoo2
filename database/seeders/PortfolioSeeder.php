<?php

namespace Database\Seeders;

use App\Models\Portfolio;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PortfolioSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Créer les portfolios seulement s'ils n'existent pas (via titre unique)
        $portfolios = [
            [
                'title' => 'Fleur Minimaliste',
                'description' => 'Tatouage floral line-art délicat',
                'image' => 'assets/images/portfolio/image1.png',
                'category' => 'minimaliste',
                'tag' => 'Minimaliste',
                'duration' => '3 heures',
                'zone' => 'Dos',
                'is_active' => true,
                'sort_order' => 1,
            ],
            [
                'title' => 'Cœurs Brodés',
                'description' => 'Tatouages assortis style broderie vintage',
                'image' => 'assets/images/portfolio/image2.png',
                'category' => 'minimaliste',
                'tag' => 'Minimaliste',
                'duration' => '2 heures',
                'zone' => 'Avant-bras',
                'is_active' => true,
                'sort_order' => 2,
            ],
            [
                'title' => 'Branche Feuillue',
                'description' => 'Line-art botanique épuré et délicat',
                'image' => 'assets/images/portfolio/image3.png',
                'category' => 'line-art',
                'tag' => 'Line-art',
                'duration' => '4 heures',
                'zone' => 'Avant-bras',
                'is_active' => true,
                'sort_order' => 3,
            ],
            [
                'title' => 'Phénix Couleur',
                'description' => 'Tatouage coloré avec dégradés vibrants',
                'image' => 'assets/images/portfolio/image4.png',
                'category' => 'aquarelle',
                'tag' => 'Couleur',
                'duration' => '8 heures',
                'zone' => 'Cuisse',
                'is_active' => true,
                'sort_order' => 4,
            ],
            [
                'title' => 'Rose Nuque',
                'description' => 'Tatouage délicat line-art rouge',
                'image' => 'assets/images/portfolio/image5.png',
                'category' => 'line-art',
                'tag' => 'Line-art',
                'duration' => '2 heures',
                'zone' => 'Nuque',
                'is_active' => true,
                'sort_order' => 5,
            ],
            [
                'title' => 'Portrait Féminin',
                'description' => 'Portrait réaliste avec éléments géométriques',
                'image' => 'assets/images/portfolio/image6.png',
                'category' => 'realistic',
                'tag' => 'Réaliste',
                'duration' => '6 heures',
                'zone' => 'Bras',
                'is_active' => true,
                'sort_order' => 6,
            ],
        ];

        foreach ($portfolios as $portfolio) {
            Portfolio::updateOrCreate(
                ['title' => $portfolio['title']],
                $portfolio
            );
        }
    }
}