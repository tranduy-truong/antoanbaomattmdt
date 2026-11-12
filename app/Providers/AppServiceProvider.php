<?php

namespace App\Providers;

use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        if (parse_url(config('app.url'), PHP_URL_SCHEME) === 'https' || config('app.azure_hosted')) {
            URL::forceScheme('https');
        }
    }
}
