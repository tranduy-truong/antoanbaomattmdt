<?php

namespace App\Services;

use App\Models\Order;
use App\Models\Product;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class CancelOrder
{
    public function execute(int $id, ?int $userId = null): void
    {
        DB::transaction(function () use ($id, $userId) {
            $query = Order::whereKey($id);
            if ($userId !== null) {
                $query->where('user_id', $userId);
            }

            $order = $query->lockForUpdate()->firstOrFail();
            if (in_array($order->status, ['cancelled', 'canceled'], true)) {
                return;
            }
            if (!$order->canCancel()) {
                throw ValidationException::withMessages([
                    'order' => 'Chỉ có thể hủy đơn COD đang chờ xác nhận.',
                ]);
            }

            $quantities = $order->orderItems->groupBy('product_id')->sortKeys();
            foreach ($quantities as $productId => $items) {
                Product::whereKey($productId)->increment('stock', $items->sum('quantity'));
            }

            $order->update(['status' => 'cancelled']);
        }, 3);
    }
}
