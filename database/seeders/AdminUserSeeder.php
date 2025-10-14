<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Utiliser updateOrCreate pour éviter les erreurs de doublon
        User::updateOrCreate(
            ['email' => 'admin@krinetattoo.com'],
            [
                'name' => 'Admin K\'rine Tattoo',
                'password' => Hash::make('KrineTattoo2024!'),
                'email_verified_at' => now(),
            ]
        );
    }
}