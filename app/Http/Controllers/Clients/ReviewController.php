<?php

namespace App\Http\Controllers\Clients;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Review;
use App\Models\Product;
use Illuminate\Support\Facades\Auth;

class ReviewController extends Controller
{
     public function index(Product $product)
    {
        return view('clients.components.include.review-list', compact('product'))->render();
    }
    public static function hasCompletedPurchase(int $userId, int $productId): bool
    {
        return \App\Models\OrderItem::where('product_id', $productId)
            ->whereHas('order', fn ($order) => $order->where('user_id', $userId)->where('status', 'completed'))
            ->exists();
    }

    public function createReview(Request $request)
    {
        $data = $request->validate([
            'product_id' => 'required|integer|exists:products,id',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:1000',
        ]);

        $userId = Auth::id();
        abort_unless($userId, 401);
        \Illuminate\Support\Facades\DB::transaction(function () use ($data, $userId) {
            \App\Models\User::whereKey($userId)->lockForUpdate()->firstOrFail();
            if (!self::hasCompletedPurchase($userId, $data['product_id'])) {
                throw \Illuminate\Validation\ValidationException::withMessages([
                    'product_id' => 'Bạn có thể đánh giá sản phẩm sau khi đơn đã giao.',
                ]);
            }
            if (Review::where('user_id', $userId)->where('product_id', $data['product_id'])->exists()) {
                throw \Illuminate\Validation\ValidationException::withMessages([
                    'product_id' => 'Bạn đã đánh giá sản phẩm này.',
                ]);
            }

            Review::create($data + ['user_id' => $userId]);
        }, 3);

        return response()->json([
            'status' => 'success',
            'message' => 'Đánh giá sản phẩm đã được gửi.',
        ], 201);
    }
}
