<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CatalogController extends Controller
{
    public function categories(): JsonResponse
    {
        return response()->json(Category::whereHas('products', fn ($query) => $query->where('status', 'in_stock'))->orderBy('name')->get()->map(fn (Category $category) => [
            '_id' => (string) $category->id,
            'name' => $category->name,
            'banner' => $category->image ? [['url' => url('storage/' . $category->image)]] : [],
        ]));
    }

    public function products(Request $request): JsonResponse
    {
        $validated = $request->validate(['q' => ['nullable', 'string', 'max:150']]);
        $products = $this->catalogProducts();

        if (!empty($validated['q'])) {
            $products->where('name', 'like', '%' . $validated['q'] . '%');
        }

        $user = app(MobileCheckoutController::class)->sessionUser($request);
        $favoriteIds = $user ? \App\Models\Wishlist::where('user_id', $user->id)
            ->pluck('product_id')->flip() : collect();

        return response()->json($products->orderByDesc('id')->get()->map(fn (Product $product) =>
            $this->productData($product) + ['isFavorite' => $favoriteIds->has($product->id)]
        ));
    }

    public function product(int $id): JsonResponse
    {
        $product = $this->catalogProducts()->findOrFail($id);

        return response()->json($this->productData($product));
    }

    public function catalogProducts(): Builder
    {
        return Product::where('status', 'in_stock')
            ->with(['images' => fn ($query) => $query->orderBy('id')])
            ->withAvg('reviews', 'rating')
            ->withCount('reviews');
    }

    public function productData(Product $product): array
    {
        $images = $product->images->pluck('image')->filter()
            ->map(fn (string $path) => ['url' => url('storage/' . $path)])->values()->all();

        return [
            '_id' => (string) $product->id,
            'name' => $product->name,
            'description' => $product->description,
            'price' => (float) $product->price,
            'stock' => (int) $product->stock,
            'unit' => $product->unit,
            'category' => (string) $product->category_id,
            'status' => 'active',
            'rating' => round((float) $product->reviews_avg_rating, 1),
            'reviewCount' => $product->reviews_count,
            'images' => $images ?: [['url' => url('storage/uploads/products/default-product.png')]],
        ];
    }
}
