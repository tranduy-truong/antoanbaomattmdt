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
                    'order' => 'Chỉ có thể hủy đơn chưa thanh toán và đang chờ xác nhận.',
                ]);
            }

            if ($order->payment?->payment_method === 'payos') {
                $payment = $order->payment()->lockForUpdate()->firstOrFail();
                if ($payment->status !== 'pending' || !$payment->payos_link_id) {
                    throw ValidationException::withMessages(['order' => 'Không thể hủy giao dịch này.']);
                }
                try {
                    $link = \App\Support\VinmarkPayOS::client()->paymentRequests
                        ->cancel($payment->payos_link_id, 'Vinmark cancelled order');
                } catch (\PayOS\Exceptions\PayOSException) {
                    throw ValidationException::withMessages(['order' => 'payOS chưa xác nhận hủy. Hãy thử lại.']);
                }
                if ($link->status !== \PayOS\Models\V2\PaymentRequests\PaymentLinkStatus::CANCELLED
                    || $link->amountPaid !== 0) {
                    throw ValidationException::withMessages(['order' => 'Giao dịch đã nhận tiền hoặc chưa được hủy.']);
                }
                $payment->update(['status' => 'failed']);
            }

            $quantities = $order->orderItems->groupBy('product_id')->sortKeys();
            foreach ($quantities as $productId => $items) {
                Product::whereKey($productId)->increment('stock', $items->sum('quantity'));
            }

            $order->update(['status' => 'cancelled']);
        }, 3);
    }
}
