<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Order;
use Illuminate\Support\Facades\Mail;

class OrderController extends Controller
{
    public function index()
    {
        $orders = Order::with('orderItems', 'shippingAddress', 'user', 'payment')->orderByDesc('id')->get();
        // Logic to retrieve and display orders
        return view('admin.pages.orders', compact('orders'));
    }

    public function confirm(Request $request)
    {
        $updated = Order::whereKey($request->id)->where('status', 'pending')
            ->whereDoesntHave('payment', fn ($query) => $query->where('payment_method', 'payos')->where('status', '!=', 'completed'))
            ->update(['status' => 'processing']);

        if ($updated) {

            return response()->json([
                'message' => 'Xác nhận đơn hàng thành công',
                'status'  => true
            ]);
        }

        return response()->json([
            'message' => 'Đơn hàng không tồn tại',
            'status'  => false
        ]);
    }
    public function complete(int $id)
    {
        $updated = Order::whereKey($id)->where('status', 'processing')->update(['status' => 'completed']);
        if ($updated) {
            toastr()->success('Đã đánh dấu đơn hàng là đã giao.');
        } else {
            toastr()->error('Chỉ có thể đánh dấu đã giao cho đơn đang xử lý.');
        }
        return back();
    }

    public function showOrderDetail($id)
    {
        $order = Order::with('orderItems.product', 'shippingAddress', 'user', 'payment')->find($id);

        return view('admin.pages.order-detail', compact('order'));
    }

    public function sendInvoice(Request $request)
    {
        $id = $request->id;

        // Tải đơn hàng cùng đầy đủ quan hệ
        $order = Order::with('orderItems.product', 'shippingAddress', 'user', 'payment')->find($id);

        // Kiểm tra đơn hàng
        if (!$order) {
            return response()->json([
                'status' => false,
                'message' => 'Không tìm thấy đơn hàng. Vui lòng kiểm tra lại!',
            ]);
        }

        // Kiểm tra email khách hàng
        if (!$order->user || !$order->user->email) {
            return response()->json([
                'status' => false,
                'message' => 'Không thể gửi hóa đơn vì thiếu email khách hàng!',
            ]);
        }

        // Kiểm tra thông tin giao hàng
        if (!$order->shippingAddress) {
            return response()->json([
                'status' => false,
                'message' => 'Đơn hàng chưa có thông tin giao hàng, không thể gửi hóa đơn!',
            ]);
        }

        try {
            // Gửi hóa đơn qua email
            Mail::send('admin.emails.invoice', compact('order'), function ($message) use ($order) {
                $message->to($order->user->email)
                    ->subject('Hóa đơn đơn hàng Vinmark – Thực phẩm sạch giao tận nhà');
            });

            return response()->json([
                'status' => true,
                'message' => 'Hóa đơn đã được gửi thành công đến email khách hàng!',
            ]);
        } catch (\Throwable $th) {
            // Bạn có thể dùng Log::error() nếu muốn
            // Log::error("Lỗi gửi hóa đơn: " . $th->getMessage());

            return response()->json([
                'status' => false,
                'message' => 'Hệ thống gặp lỗi khi gửi hóa đơn. Vui lòng thử lại sau!',
                // 'debug' => $th->getMessage() // bật khi debug
            ]);
        }
    }

    public function cancelOrder(Request $request)
    {
        $data = $request->validate(['id' => 'required|integer|min:1']);
        try {
            app(\App\Services\CancelOrder::class)->execute($data['id']);
        } catch (\Illuminate\Validation\ValidationException $error) {
            return response()->json(['status' => false, 'message' => $error->getMessage()]);
        }
        return response()->json(['status' => true, 'message' => 'Đơn hàng đã được hủy thành công.']);
    }
}
