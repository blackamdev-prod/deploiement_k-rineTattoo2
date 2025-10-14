<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;
use App\Models\Portfolio;
use Illuminate\Support\Facades\DB;

class SetupProduction extends Command
{
    protected $signature = 'app:setup-production';
    protected $description = 'Setup production database with initial data';

    public function handle()
    {
        $this->info('🚀 Setting up production environment...');

        // Test database connection
        try {
            DB::connection()->getPdo();
            $this->info('✓ Database connection successful');
        } catch (\Exception $e) {
            $this->error('✗ Database connection failed: ' . $e->getMessage());
            return 1;
        }

        // Run migrations
        $this->info('Running migrations...');
        $this->call('migrate', ['--force' => true]);

        // Seed database
        $this->info('Seeding database...');
        $this->call('db:seed', ['--force' => true]);

        // Summary
        $portfolioCount = Portfolio::count();
        $userCount = User::count();

        $this->info('');
        $this->info('✅ Production setup completed!');
        $this->info("📊 Portfolios: {$portfolioCount}");
        $this->info("👥 Users: {$userCount}");
        
        if (User::where('email', 'admin@krinetattoo.com')->exists()) {
            $this->info('');
            $this->info('🔑 Admin access:');
            $this->info('   URL: /admin');
            $this->info('   Email: admin@krinetattoo.com');
            $this->info('   Password: KrineTattoo2024!');
            $this->warn('   ⚠️  Change password after first login!');
        }

        return 0;
    }
}