<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Insert admin user if not exists
        $adminExists = DB::table('users')->where('email', 'admin@krinetattoo.com')->exists();
        if (!$adminExists) {
            DB::table('users')->insert([
                'name' => 'Admin K\'rine Tattoo',
                'email' => 'admin@krinetattoo.com',
                'password' => Hash::make('KrineTattoo2024!'),
                'email_verified_at' => now(),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Insert portfolio data if not exists
        $portfolioExists = DB::table('portfolios')->exists();
        if (!$portfolioExists) {
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
                    'created_at' => now(),
                    'updated_at' => now(),
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
                    'created_at' => now(),
                    'updated_at' => now(),
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
                    'created_at' => now(),
                    'updated_at' => now(),
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
                    'created_at' => now(),
                    'updated_at' => now(),
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
                    'created_at' => now(),
                    'updated_at' => now(),
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
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
            ];

            DB::table('portfolios')->insert($portfolios);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Remove inserted data
        DB::table('users')->where('email', 'admin@krinetattoo.com')->delete();
        DB::table('portfolios')->whereIn('title', [
            'Fleur Minimaliste', 'Cœurs Brodés', 'Branche Feuillue', 
            'Phénix Couleur', 'Rose Nuque', 'Portrait Féminin'
        ])->delete();
    }
};
