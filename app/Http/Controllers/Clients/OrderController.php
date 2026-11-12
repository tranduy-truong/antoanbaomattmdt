<?php

namespace App\Http\Controllers\Clients;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Order;
class OrderController extends Controller
{
    public function showOrder($id)
    {
        $order = Order::with(['orderItems.product', 'user', 'shippingAddress', 'payment'])->where('user_id', auth()->id())->findOrFail($id);
        $userId = auth()->id();

        return view('clients.pages.order_detail', compact('order'));
    }

    public function cancelOrder(int $id)
    {
        app(\App\Services\CancelOrder::class)->execute($id, auth()->id());
        return back()->with('success', 'Đơn hàng đã được hủy thành công.');
    }
}
