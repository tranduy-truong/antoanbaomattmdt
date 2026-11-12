<?php

use App\Http\Controllers\Api\CatalogController;
use Illuminate\Support\Facades\Route;

Route::get('/categories', [CatalogController::class, 'categories']);
Route::get('/products', [CatalogController::class, 'products']);
Route::get('/products/{id}', [CatalogController::class, 'product'])->whereNumber('id');
Route::post('/mobile/orders', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'store'])->middleware('throttle:10,1');
Route::post('/mobile/login', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'login'])->middleware('throttle:10,1');
Route::post('/mobile/register', [\App\Http\Controllers\Clients\AuthController::class, 'register'])->middleware('throttle:5,1');

Route::get('/mobile/cart', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'cart']);
Route::put('/mobile/cart', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'updateCart'])->middleware('throttle:120,1');
Route::get('/mobile/orders', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'orders']);
Route::get('/mobile/profile', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'profile']);
Route::post('/mobile/profile', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'updateProfile'])->middleware('throttle:20,1');
Route::post('/mobile/password', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'changePassword'])->middleware('throttle:10,1');
Route::match(['get', 'post'], '/mobile/addresses', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'addresses']);
Route::match(['put', 'delete'], '/mobile/addresses/{id}', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'addresses'])->whereNumber('id');
Route::get('/mobile/wishlist', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'wishlist']);
Route::match(['put', 'delete'], '/mobile/wishlist/{id}', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'wishlist'])->whereNumber('id');
Route::get('/mobile/reviews/product/{id}', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'productReviews'])->whereNumber('id');
Route::get('/mobile/reviews/mine', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'ownReviews']);
Route::post('/mobile/reviews', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'submitReview'])->middleware('throttle:20,1');
Route::post('/mobile/orders/{id}/cancel', [\App\Http\Controllers\Api\MobileCheckoutController::class, 'cancelOrder'])->whereNumber('id');
