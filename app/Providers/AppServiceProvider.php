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
        \App\Models\Order::created(function (\App\Models\Order $order): void {
            $id = (int) $order->getKey();
            $order->getConnection()->afterCommit(function () use ($id): void {
                \Illuminate\Support\defer(function () use ($id): void {
                    try {
                        app(\App\Support\AdminOrderPush::class)->send($id);
                    } catch (\Throwable $error) {
                        logger()->warning('Admin order push failed', ['order_id' => $id]);
                    }
                })->always();
            });
        });

        if (parse_url(config('app.url'), PHP_URL_SCHEME) === 'https' || config('app.azure_hosted')) {
            URL::forceScheme('https');
        }
    }
}
