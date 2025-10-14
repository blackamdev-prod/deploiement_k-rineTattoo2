<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Foundation\Console\ViewCacheCommand;

class DisableViewCacheServiceProvider extends ServiceProvider
{
    public function register()
    {
        // Override the view:cache command to do nothing
        $this->app->singleton('command.view.cache', function () {
            return new class extends ViewCacheCommand {
                public function handle()
                {
                    $this->info('View caching disabled for Filament compatibility.');
                    return 0;
                }
            };
        });
    }

    public function boot()
    {
        // Ensure views are never cached in production
        if (app()->environment('production')) {
            config(['view.cache' => false]);
        }
    }
}