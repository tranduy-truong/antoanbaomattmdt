<?php

namespace App\Http\Controllers\Clients;

use App\Http\Controllers\Controller;
use App\Models\CartItem;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Payment;
use App\Models\ShippingAddress;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Http;

class CheckoutController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $addresses = ShippingAddress::where('user_id', $user->id)->get();
        $defaultAddress = $addresses->where('default', true)->first();
        if (is_null($defaultAddress) || is_null($addresses)) {
            toastr()->error('Vui lòng thêm địa chỉ giao hàng trước khi thanh toán.');
            return redirect()->route('account');
        }

        $cartItems = CartItem::where('user_id', $user->id)->with('product')->get();
        $totalPrice = $cartItems->sum(function ($item) {
            return $item->product->price * $item->quantity;
        });
        return view('clients.pages.checkout', compact('addresses', 'defaultAddress', 'cartItems', 'totalPrice'));
    }

    // get address for checkout page ajax
    public function getAddress(Request $request)
    {
        $address = ShippingAddress::where('id', $request->address_id)
            ->where('user_id', Auth::id())
            ->first();
        if (!$address) {
            return response()->json([
                'success' => false,
                'message' => 'Không tìm thấy địa chỉ!.'
            ]);
        }

        return response()->json([
            'success' => true,
            'data' => $address
        ]);
    }

    public function placeOrder(Request $request)
    {
        $request->validate([
            'address_id' => 'required|exists:shipping_addresses,id',
            'payment_method' => 'required|in:cash,paypal'
        ]);
        // validate cart not empty
        $user = Auth::user();
        $cartItems = CartItem::where('user_id', $user->id)->with('product')->get();

        if ($cartItems->isEmpty()) {
            toastr()->error('Giỏ hàng trống. Vui lòng thêm sản phẩm trước khi thanh toán.');
            return redirect()->route('cart');
        }
        DB::beginTransaction();
        try {
            // create order
            $order = new Order();
            $order->user_id = $user->id;
            $order->shipping_address_id = $request->address_id;
            $order->total_price = $cartItems->sum(fn($item) => $item->quantity * $item->product->price);
            $order->status = 'pending';
            $order->save();

            // create order items
            foreach ($cartItems as $item) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item->product->id,
                    'quantity' => $item->quantity,
                    'price' => $item->product->price,
                ]);
                $product = $item->product;
                // decrease product stock
                if ($product->stock < $item->quantity) {
                    throw new \Exception("Sản phẩm {$product->name} không đủ số lượng trong kho.");
                }
                $product->decrement('stock', $item->quantity);
            }

            // create payment
            Payment::create([
                'order_id' => $order->id,
                'amount' => $order->total_price,
                'payment_method' => $request->payment_method,
                'status' => 'pending',
                'paid_at' => null,
            ]);

            // delete products in cart when order success
            CartItem::where('user_id', $user->id)->delete();
            DB::commit();
            toastr()->success('Đặt hàng thành công!');
            return redirect()->route('account');
        } catch (\Exception $e) {
            Log::error("Lỗi đặt hàng: " . $e->getMessage());
            DB::rollBack();
            toastr()->error('Đặt hàng thất bại. Vui lòng thử lại sau.' . $e->getMessage());
            return redirect()->route('checkout');
        }
    }

    // Handle PayPal order placement
    public function placeOrderPaypal(Request $request)
    {
        $request->validate([
            'orderID' => 'required',
            'payerID' => 'required',
            'transactionID' => 'required',
            'amount' => 'required|numeric',
            'address_id' => 'required|exists:shipping_addresses,id',
            'payment_method' => 'required|string'
        ]);

        $user = Auth::user();
        $cartItems = CartItem::where('user_id', $user->id)->with('product')->get();

        if ($cartItems->isEmpty()) {
            return response()->json(['success' => false, 'message' => 'Giỏ hàng trống.']);
        }

        DB::beginTransaction();
        try {
            // Tính tổng giá sản phẩm trong giỏ
            $subtotalUSD = $request->amount;
            $totalPriceVND = $subtotalUSD * 25000 + 25000; // nhân tỷ giá & cộng phí ship

            // Tạo đơn hàng
            $order = Order::create([
                'user_id' => $user->id,
                'shipping_address_id' => $request->address_id,
                'total_price' => $totalPriceVND,
                'status' => 'pending',
            ]);
            
            foreach ($cartItems as $item) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item->product->id,
                    'quantity' => $item->quantity,
                    'price' => $item->product->price,
                ]);

                $product = $item->product;
                // decrease product stock
                if ($product->stock < $item->quantity) {
                    throw new \Exception("Sản phẩm {$product->name} không đủ số lượng trong kho.");
                }
                $product->decrement('stock', $item->quantity);
            }

            Payment::create([
                'order_id' => $order->id,
                'amount' => $totalPriceVND,
                'payment_method' => 'paypal',
                'status' => 'completed',
                'paid_at' => now(),
                'transaction_id' => $request->transactionID,
            ]);

            CartItem::where('user_id', $user->id)->delete();

            DB::commit();
            return response()->json(['success' => true]);
        } catch (\Exception $e) {
            Log::error("Lỗi PayPal: " . $e->getMessage());
            DB::rollBack();
            return response()->json(['success' => false, 'message' => 'Đặt hàng qua PayPal thất bại.']);
        }
    }

    // Handle Momo order placement
   public function placeOrderMoMo(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:1000',
            'address_id' => 'required|exists:shipping_addresses,id',
        ]);

        $user = Auth::user();
        $cartItems = CartItem::where('user_id', $user->id)->with('product')->get();
        if ($cartItems->isEmpty()) {
            return response()->json(['success' => false, 'message' => 'Giỏ hàng trống.']);
        }

        DB::beginTransaction();
        try {
            // 1. TẠO ĐƠN HÀNG NGAY LÚC NÀY VỚI TRẠNG THÁI PENDING
            $order = Order::create([
                'user_id' => $user->id,
                'shipping_address_id' => $request->address_id,
                'total_price' => $request->amount,
                'payment_method' => 'momo',
                'status' => 'pending', // Chờ thanh toán
            ]);

            foreach ($cartItems as $item) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item->product_id,
                    'quantity' => $item->quantity,
                    'price' => $item->product->price
                ]);
            }

            // Xóa giỏ hàng luôn vì đã chốt thành đơn
            CartItem::where('user_id', $user->id)->delete();
            DB::commit();

            // 2. CHUẨN BỊ CALL API MOMO
            $endpoint = env('MOMO_ENDPOINT', 'https://test-payment.momo.vn/v2/gateway/api/create');
            $partnerCode = env('MOMO_PARTNER_CODE', 'MOMOBKUN20180529');
            $accessKey = env('MOMO_ACCESS_KEY', 'klm05TvNBzhg7h7j');
            $secretKey = env('MOMO_SECRET_KEY', 'at67qH6mk8w5Y1nAyMoYKMWACiEi2bsa');

            $orderInfo = "Thanh toan don hang #" . $order->id;
            
            // Ép kiểu số nguyên để fix lỗi Format Request 20
            $amount = (int) $request->amount; 
            
            // DÙNG CHÍNH ID ĐƠN HÀNG LÀM ORDER ID CHO MOMO DỄ QUẢN LÝ
            $orderId = (string) $order->id . "_" . time(); 
            $requestId = (string) time();

            $redirectUrl = route('checkout.momoReturn'); 
            $ipnUrl = route('checkout.momoNotify');      
            $extraData = (string) $order->id; // Gắn ID đơn hàng vào đây để lát MoMo trả về dễ lấy
            $requestType = "payWithATM";
            
            // Tạo chữ ký
            $rawHash = "accessKey=" . $accessKey .
                "&amount=" . $amount .
                "&extraData=" . $extraData .
                "&ipnUrl=" . $ipnUrl .
                "&orderId=" . $orderId .
                "&orderInfo=" . $orderInfo .
                "&partnerCode=" . $partnerCode .
                "&redirectUrl=" . $redirectUrl .
                "&requestId=" . $requestId .
                "&requestType=" . $requestType;

            $signature = hash_hmac("sha256", $rawHash, $secretKey);

            $data = [
                'partnerCode' => $partnerCode,
                'partnerName' => "Vinmark",
                'storeId' => "VinmarkStore",
                'requestId' => $requestId,
                'amount' => $amount, // Kiểu INT
                'orderId' => $orderId,
                'orderInfo' => $orderInfo,
                'redirectUrl' => $redirectUrl,
                'ipnUrl' => $ipnUrl,
                'lang' => 'vi',
                'extraData' => $extraData,
                'requestType' => $requestType,
                'signature' => $signature
            ];

            $result = Http::withHeaders(['Content-Type' => 'application/json'])->post($endpoint, $data);
            $jsonResult = $result->json();

            if (isset($jsonResult['payUrl'])) {
                return response()->json(['payUrl' => $jsonResult['payUrl']]);
            } else {
                return response()->json(['success' => false, 'message' => 'Lỗi MoMo', 'response' => $jsonResult]);
            }
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("Lỗi tạo đơn MoMo: " . $e->getMessage());
            return response()->json(['success' => false, 'message' => 'Lỗi hệ thống.']);
        }
    }
    public function momoReturn(Request $request)
    {
        // Nhờ lúc nãy nhét ID vào extraData, giờ mình lấy ra tìm lại đúng đơn hàng đó
        $order_id_real = $request->extraData; 
        $order = Order::find($order_id_real);

        if (!$order) {
            toastr()->error('Không tìm thấy đơn hàng!');
            return redirect('/account');
        }

        if ($request->resultCode == 0) {
            // Thanh toán thành công -> Cập nhật trạng thái
            if ($order->status == 'pending') {
                $order->status = 'completed'; // Hoặc 'processing' tùy logic web bạn
                $order->save();

                Payment::create([
                    'order_id' => $order->id,
                    'payment_method' => 'momo',
                    'amount' => $order->total_price,
                    'paid_at' => now(),
                    'status' => 'completed',
                    'transaction_id' => $request->transId ?? null,
                ]);
            }
            toastr()->success('Thanh toán MoMo thành công!');
            return redirect('/account');
        } else {
            // Khách bấm hủy hoặc lỗi -> Cập nhật thất bại
            $order->status = 'cancelled';
            $order->save();
            toastr()->error('Thanh toán bị hủy hoặc thất bại.');
            return redirect('/checkout');
        }
    }
    public function momoNotify(Request $request)
    {
        Log::info('MoMo IPN:', $request->all());

        // Tùy chọn: xử lý lưu Order, Payment ở đây khi MoMo báo IPN thành công
        // if ($request->resultCode == 0) { ... }

        return response('OK', 200);
    }

    // VNPay QR Payment
    public function placeOrderVnpayQR(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:1000',
            'address_id' => 'required|exists:shipping_addresses,id',
        ]);

        $user = Auth::user();
        $cartItems = CartItem::where('user_id', $user->id)->with('product')->get();
        if ($cartItems->isEmpty()) {
            return response()->json(['success' => false, 'message' => 'Giỏ hàng trống.']);
        }

        DB::beginTransaction();
        try {
            // 1. Tạo đơn hàng và lưu chi tiết
            $order = Order::create([
                'user_id' => $user->id,
                'shipping_address_id' => $request->address_id,
                'total_price' => $request->amount,
                'payment_method' => 'vnpay',
                'status' => 'pending',
            ]);

            Payment::create([
                'order_id' => $order->id,
                'amount' => $order->total_price,
                'payment_method' => 'vnpay',
                'status' => 'pending',
                'paid_at' => null,
            ]);

            foreach ($cartItems as $item) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item->product_id,
                    'quantity' => $item->quantity,
                    'price' => $item->product->price,
                ]);
            }

            // Xóa giỏ hàng sau khi đã chốt đơn
            CartItem::where('user_id', $user->id)->delete();
            DB::commit();

            // 2. Cấu hình các thông số VNPAY
            $vnp_Url = env('VNP_URL');
            $vnp_TmnCode = env('VNP_TMNCODE');
            $vnp_HashSecret = env('VNP_HASHSECRET');
            $vnp_Returnurl = env('VNP_RETURN_URL');

            $vnp_TxnRef = $order->id . '_' . time();
            $vnp_OrderInfo = "Thanh toan don hang #" . $order->id;
            $vnp_Amount = (int)$request->amount * 100; // VNPay yêu cầu nhân 100

            // 3. Khởi tạo mảng dữ liệu gửi đi
            $inputData = [
                'vnp_Version' => '2.1.0',
                'vnp_Command' => 'pay',
                'vnp_TmnCode' => $vnp_TmnCode,
                'vnp_Amount' => $vnp_Amount,
                'vnp_CurrCode' => 'VND',
                'vnp_TxnRef' => $vnp_TxnRef,
                'vnp_OrderInfo' => $vnp_OrderInfo,
                'vnp_OrderType' => 'billpayment', 
                'vnp_Locale' => 'vn',
                'vnp_ReturnUrl' => $vnp_Returnurl,
                'vnp_IpAddr' => request()->ip(),
                'vnp_CreateDate' => date('YmdHis'),
            ];

            // 4. Mã hóa chữ ký và tạo URL chuẩn theo tài liệu VNPAY
            ksort($inputData);
            $query = "";
            $i = 0;
            $hashdata = "";
            foreach ($inputData as $key => $value) {
                if ($i == 1) {
                    $hashdata .= '&' . urlencode($key) . "=" . urlencode($value);
                } else {
                    $hashdata .= urlencode($key) . "=" . urlencode($value);
                    $i = 1;
                }
                $query .= urlencode($key) . "=" . urlencode($value) . '&';
            }

            $vnp_Url = $vnp_Url . "?" . $query;
            if (isset($vnp_HashSecret)) {
                $vnpSecureHash = hash_hmac('sha512', $hashdata, $vnp_HashSecret);
                $vnp_Url .= 'vnp_SecureHash=' . $vnpSecureHash;
            }

            // Trả link thanh toán về cho trình duyệt
            return response()->json(['payUrl' => $vnp_Url]);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Lỗi VNPAY QR: ' . $e->getMessage());
            return response()->json(['success' => false, 'message' => 'Lỗi hệ thống.']);
        }
    }

    public function vnpayReturn(Request $request)
    {
        $vnp_HashSecret = env('VNP_HASHSECRET');

        // 1. Lọc và lấy tất cả các tham số bắt đầu bằng "vnp_"
        $inputData = array();
        foreach ($request->all() as $key => $value) {
            if (substr($key, 0, 4) == "vnp_") {
                $inputData[$key] = $value;
            }
        }

        // 2. Tách mã chữ ký VNPAY gửi về ra khỏi mảng dữ liệu
        $vnp_SecureHash = $inputData['vnp_SecureHash'] ?? '';
        unset($inputData['vnp_SecureHash']);
        unset($inputData['vnp_SecureHashType']);

        // 3. Sắp xếp mảng theo thứ tự Alphabet và tạo chuỗi dữ liệu (HashData)
        ksort($inputData);
        $i = 0;
        $hashData = "";
        foreach ($inputData as $key => $value) {
            if ($i == 1) {
                $hashData = $hashData . '&' . urlencode($key) . "=" . urlencode($value);
            } else {
                $hashData = $hashData . urlencode($key) . "=" . urlencode($value);
                $i = 1;
            }
        }

        // 4. Mã hóa chuỗi bằng thuật toán SHA512
        $secureHash = hash_hmac('sha512', $hashData, $vnp_HashSecret);

        // 5. Kiểm tra chữ ký
        if ($secureHash === $vnp_SecureHash) {
            // ✅ CHỮ KÝ HỢP LỆ
            
            // Lấy ID đơn hàng từ vnp_TxnRef (vd: 16_1775561520 -> 16)
            $orderId = explode('_', $request->vnp_TxnRef)[0];
            $order = Order::find($orderId);

            if (!$order) {
                toastr()->error('Không tìm thấy đơn hàng.');
                return redirect('/checkout');
            }

            if ($request->vnp_ResponseCode == '00') {
                // Giao dịch thành công
                if ($order->status === 'pending') {
                    $order->status = 'completed';
                    $order->save();

                    $payment = Payment::where('order_id', $order->id)->first();
                    if ($payment) {
                        $payment->status = 'completed';
                        $payment->paid_at = now();
                        $payment->transaction_id = $request->vnp_TransactionNo;
                        $payment->save();
                    }
                }
                toastr()->success('Thanh toán VNPay thành công!');
                return redirect('/account');
            } else {
                // Khách hàng hủy giao dịch hoặc lỗi ngân hàng
                $order->status = 'cancelled';
                $order->save();
                toastr()->error('Giao dịch không thành công hoặc bị hủy.');
                return redirect('/checkout');
            }
        } else {
            // ❌ CHỮ KÝ KHÔNG HỢP LỆ (Bị can thiệp dữ liệu)
            Log::error('VNPAY Hash sai: Chuỗi tạo ra là ' . $secureHash . ' nhưng nhận về là ' . $vnp_SecureHash);
            toastr()->error('Lỗi bảo mật: Dữ liệu thanh toán không hợp lệ!');
            return redirect('/checkout');
        }
    }
}