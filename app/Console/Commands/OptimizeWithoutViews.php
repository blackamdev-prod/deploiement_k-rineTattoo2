<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class OptimizeWithoutViews extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'optimize';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Cache framework bootstrap files without view caching to avoid Filament issues';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Caching framework bootstrap, configuration, and metadata (excluding views)...');

        // Cache config
        $this->call('config:cache');
        $this->line('<fg=green>config</fg=green> ......................................................... <fg=yellow>DONE</fg=yellow>');

        // Cache events  
        $this->call('event:cache');
        $this->line('<fg=green>events</fg=green> ......................................................... <fg=yellow>DONE</fg=yellow>');

        // Cache routes
        $this->call('route:cache');
        $this->line('<fg=green>routes</fg=green> ......................................................... <fg=yellow>DONE</fg=yellow>');

        // Intentionally skip view:cache to avoid Filament compilation issues
        $this->line('<fg=green>views</fg=green> .......................................................... <fg=yellow>SKIPPED (Filament compatibility)</fg=yellow>');

        $this->info('Application cached successfully (views excluded for Filament compatibility)!');

        return 0;
    }
}