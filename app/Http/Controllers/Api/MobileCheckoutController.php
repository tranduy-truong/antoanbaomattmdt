<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CartItem;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Payment;
use App\Models\Product;
use App\Models\ShippingAddress;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class MobileCheckoutController extends Controller
{
    public function login(Request $request): JsonResponse
    {
        $data = $request->validate([
            'email' => 'required|email|max:255',
            'password' => 'required|string|max:255',
        ]);
        $user = User::where('email', $data['email'])->first();
        if (!$user || !$user->isActive() || !Hash::check($data['password'], $user->password)) {
            return response()->json(['message' => 'Email hoặc mật khẩu Vinmark không hợp lệ.'], 401);
        }

        $token = Crypt::encryptString(json_encode([
            'purpose' => 'mobile_checkout',
            'id' => $user->id,
            'expires' => now()->addDays(7)->timestamp,
            'password_version' => hash('sha256', $user->password),
        ], JSON_THROW_ON_ERROR));

        return response()->json([
            '_id' => (string) $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'token' => $token,
        ]);
    }

    public function sessionUser(Request $request): ?User
    {
        $token = $request->bearerToken();
        if (!$token) {
            return null;
        }

        try {
            $claims = json_decode(Crypt::decryptString($token), true, flags: JSON_THROW_ON_ERROR);
        } catch (DecryptException | \JsonException) {
            return null;
        }

        if (($claims['purpose'] ?? null) !== 'mobile_checkout' || ($claims['expires'] ?? 0) <= now()->timestamp) {
            return null;
        }

        $user = User::find($claims['id'] ?? null);
        return $user && $user->isActive()
            && hash_equals(hash('sha256', $user->password), $claims['password_version'] ?? '')
            ? $user : null;
    }

    public function cart(Request $request): JsonResponse
    {
        $user = $this->sessionUser($request);
        if (!$user) {
            return response()->json(['message' => 'Vui lòng đăng nhập Vinmark.'], 401);
        }

        return response()->json(CartItem::where('user_id', $user->id)->pluck('quantity', 'product_id')->all() ?: (object) []);
    }

    public function updateCart(Request $request): JsonResponse
    {
        $user = $this->sessionUser($request);
        if (!$user) {
            return response()->json(['message' => 'Vui lòng đăng nhập Vinmark.'], 401);
        }

        $data = $request->validate([
            'items' => 'required|array|min:1|max:100',
            'items.*.id' => 'required|integer|min:1|distinct',
            'items.*.quantity' => 'required|integer|min:0|max:999',
            'mode' => 'required|in:add,set,merge',
        ]);
        DB::transaction(function () use ($data, $user) {
            User::whereKey($user->id)->lockForUpdate()->firstOrFail();
            foreach ($data['items'] as $item) {
                $keys = ['user_id' => $user->id, 'product_id' => $item['id']];
                $current = CartItem::where($keys)->lockForUpdate()->first();
                $quantity = match ($data['mode']) {
                    'add' => ($current?->quantity ?? 0) + $item['quantity'],
                    'merge' => max($current?->quantity ?? 0, $item['quantity']),
                    'set' => $item['quantity'],
                };
                if ($quantity === 0) {
                    $current?->delete();
                    continue;
                }
                $product = Product::find($item['id']);
                if (!$product || $product->status !== 'in_stock' || $quantity > min(999, $product->stock)) {
                    if ($data['mode'] === 'merge') {
                        continue;
                    }
                    throw ValidationException::withMessages(['items' => 'Sản phẩm không còn đủ hàng.']);
                }
                CartItem::updateOrCreate($keys, ['quantity' => $quantity]);
            }
        }, 3);

        return $this->cart($request);
    }

    public function wishlist(Request $request, ?int $id = null): JsonResponse
    {
        $user = $this->sessionUser($request);
        if (!$user) {
            return response()->json(['message' => 'Vui lòng đăng nhập Vinmark.'], 401);
        }

        if ($request->isMethod('GET')) {
            $catalog = app(CatalogController::class);
            $products = $catalog->catalogProducts()
                ->whereIn('id', \App\Models\Wishlist::where('user_id', $user->id)->select('product_id'))
                ->orderByDesc('id')->get();
            return response()->json($products->map($catalog->productData(...)));
        }

        auth()->guard('web')->setUser($user);
        $request->merge(['product_id' => $id]);
        $controller = app(\App\Http\Controllers\Clients\WishlistController::class);
        return $request->isMethod('PUT') ? $controller->addToWishList($request)
            : $controller->removeWishListItem($request);
    }

    public function addresses(Request $request): JsonResponse
    {
        $user = $this->sessionUser($request);
        if (!$user) {
            return response()->json(['message' => 'Vui lòng đăng nhập lại Vinmark.'], 401);
        }

        if ($request->isMethod('GET')) {
            return response()->json(ShippingAddress::where('user_id', $user->id)
                ->orderByDesc('default')->orderBy('id')->get(['id', 'full_name', 'phone', 'address', 'city', 'default']));
        }

        auth()->guard('web')->setUser($user);
        $account = app(\App\Http\Controllers\Clients\AccountController::class);
        return match ($request->method()) {
            'POST' => $account->addAddress($request),
            'PUT' => $account->updatePrimaryAddress($request->route('id')),
            'DELETE' => $account->deleteAddress($request->route('id')),
        };
    }

    public function profile(Request $request): JsonResponse
    {
        $user = $this->sessionUser($request);
        return $user ? response()->json($this->profileData($user))
            : response()->json(['message' => 'Vui lòng đăng nhập lại Vinmark.'], 401);
    }

    public function updateProfile(Request $request): JsonResponse
    {
        $user = $this->sessionUser($request);
        if (!$user) {
            return response()->json(['message' => 'Vui lòng đăng nhập lại Vinmark.'], 401);
        }

        auth()->guard('web')->setUser($user);
        app(\App\Http\Controllers\Clients\AccountController::class)->update($request);
        return response()->json($this->profileData($user->refresh()));
    }

    public function changePassword(Request $request): JsonResponse
    {
        $user = $this->sessionUser($request);
        if (!$user) {
            return response()->json(['message' => 'Vui lòng đăng nhập lại Vinmark.'], 401);
        }

        auth()->guard('web')->setUser($user);
        return app(\App\Http\Controllers\Clients\AccountController::class)->changePassword($request);
    }

    private function profileData(User $user): array
    {
        return [
            '_id' => (string) $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'phone' => $user->phone_number,
            'profileAddress' => $user->address,
            'avatar' => $user->avatar ? ['url' => url('storage/' . $user->avatar)] : null,
            'orderCount' => $user->orders()->count(),
        ];
    }

    public function productReviews(int $id): JsonResponse
    {
        Product::findOrFail($id);
        return $this->reviewList(\App\Models\Review::where('product_id', $id));
    }

    public function ownReviews(Request $request): JsonResponse
    {
        $user = $this->sessionUser($request);
        return $user ? $this->reviewList(\App\Models\Review::where('user_id', $user->id))
            : response()->json(['message' => 'Vui lòng đăng nhập Vinmark.'], 401);
    }

    public function submitReview(Request $request): JsonResponse
    {
        $user = $this->sessionUser($request);
        if (!$user) {
            return response()->json(['message' => 'Vui lòng đăng nhập Vinmark.'], 401);
        }

        auth()->guard('web')->setUser($user);
        return app(\App\Http\Controllers\Clients\ReviewController::class)->createReview($request);
    }

    private function reviewList(\Illuminate\Database\Eloquent\Builder $query): JsonResponse
    {
        $reviews = $query->with(['user', 'product.firstImage'])->orderByDesc('id')->get();
        return response()->json([
            'total' => $reviews->count(),
            'data' => $reviews->map(fn ($review) => [
                '_id' => (string) $review->id,
                'productId' => (string) $review->product_id,
                'productName' => $review->product?->name,
                'productImage' => $review->product?->firstImage ? url('storage/' . $review->product->firstImage->image) : null,
                'customerName' => $review->user?->name ?? 'Khách hàng Vinmark',
                'userAvatar' => $review->user?->avatar ? url('storage/' . $review->user->avatar) : null,
                'rating' => (int) $review->rating,
                'content' => $review->comment,
                'createdAt' => $review->created_at?->toIso8601String(),
            ]),
        ]);
    }

    public function cancelOrder(Request $request, int $id): JsonResponse
    {
        $user = $this->sessionUser($request);
        if (!$user) {
            return response()->json(['message' => 'Vui lòng đăng nhập Vinmark.'], 401);
        }

        app(\App\Services\CancelOrder::class)->execute($id, $user->id);
        return response()->json(['message' => 'Đơn hàng đã được hủy.']);
    }

    public function orders(Request $request): JsonResponse
    {
        $user = $this->sessionUser($request);
        if (!$user) {
            return response()->json(['message' => 'Vui lòng đăng nhập Vinmark.'], 401);
        }

        $orders = $user->orders()->with(['orderItems.product.firstImage', 'shippingAddress', 'payment'])
            ->orderByDesc('id')->get();

        $reviewed = \App\Models\Review::where('user_id', $user->id)->pluck('product_id')->flip();

        return response()->json($orders->map(fn (Order $order) => [
            '_id' => (string) $order->id,
            'status' => $order->status,
            'createdAt' => $order->created_at?->format('d/m/Y H:i'),
            'totalPrice' => (float) $order->total_price,
            'customerName' => $order->shippingAddress?->full_name,
            'address' => $order->shippingAddress
                ? implode(', ', array_filter([$order->shippingAddress->address, $order->shippingAddress->city]))
                : null,
            'paymentMethod' => $order->payment?->payment_method,
            'paymentStatus' => $order->payment?->status,
            'paymentUrl' => $order->payment?->status === 'pending' ? $order->payment->payos_checkout_url : null,
            'canCancel' => $order->canCancel(),
            'items' => $order->orderItems->map(fn (OrderItem $item) => [
                'productId' => (string) $item->product_id,
                'name' => $item->product?->name ?? ('Sản phẩm #' . $item->product_id),
                'image' => $item->product?->firstImage ? url('storage/' . $item->product->firstImage->image) : null,
                'quantity' => (int) $item->quantity,
                'price' => (float) $item->price,
                'reviewable' => $order->status === 'completed' && $item->product !== null && !$reviewed->has($item->product_id),
            ]),
        ]));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'request_id' => 'required|uuid',
            'payment_method' => 'sometimes|in:cash,payos',
            'shipping_address_id' => 'sometimes|required|integer|min:1',
            'items' => 'required|array|min:1|max:100',
            'items.*.id' => 'required|integer|min:1|distinct',
            'items.*.quantity' => 'required|integer|min:1|max:999',
            'items.*.price' => 'required|numeric|min:0',
        ]);

        $user = $this->sessionUser($request);
        if (!$user) {
            return response()->json(['message' => 'Phiên đăng nhập Vinmark đã hết hạn.'], 401);
        }

        $method = $data['payment_method'] ?? 'cash';
        try {
            $order = DB::transaction(function () use ($user, $data, $method) {
                User::whereKey($user->id)->lockForUpdate()->firstOrFail();
                $existing = Order::where('user_id', $user->id)->where('mobile_request_id', $data['request_id'])->first();
                if ($existing) {
                    return $existing;
                }

                if ($method === 'payos' && !\App\Support\VinmarkPayOS::enabled()) {
                    throw ValidationException::withMessages(['payment_method' => 'Chuyển khoản QR hiện chưa khả dụng.']);
                }

                $address = ShippingAddress::where('user_id', $user->id)->where('default', true)->first();
                if (!$address) {
                    throw ValidationException::withMessages(['address' => 'Hãy đặt địa chỉ giao hàng mặc định trong tài khoản Vinmark trên web.']);
                }

                if (isset($data['shipping_address_id']) && (int) $data['shipping_address_id'] !== $address->id) {
                    throw ValidationException::withMessages(['address' => 'Địa chỉ mặc định đã thay đổi. Hãy kiểm tra lại trước khi đặt.']);
                }

                $items = collect($data['items'])->keyBy('id');
                $products = Product::whereIn('id', $items->keys())->orderBy('id')->lockForUpdate()->get()->keyBy('id');
                $total = 0;
                foreach ($items as $id => $item) {
                    $product = $products->get($id);
                    if (!$product || $product->status !== 'in_stock' || $product->stock < $item['quantity']) {
                        throw ValidationException::withMessages(['items' => 'Có sản phẩm không còn đủ hàng. Hãy mở lại giỏ để cập nhật.']);
                    }
                    if ((float) $product->price !== (float) $item['price']) {
                        throw ValidationException::withMessages(['items' => 'Giá sản phẩm đã thay đổi. Hãy mở lại giỏ để cập nhật.']);
                    }
                    $total += $product->price * $item['quantity'];
                }

                $order = new Order([
                    'user_id' => $user->id,
                    'shipping_address_id' => $address->id,
                    'total_price' => $total,
                    'status' => 'pending',
                ]);
                $order->mobile_request_id = $data['request_id'];
                $order->save();

                foreach ($items as $id => $item) {
                    $product = $products->get($id);
                    OrderItem::create([
                        'order_id' => $order->id,
                        'product_id' => $id,
                        'quantity' => $item['quantity'],
                        'price' => $product->price,
                    ]);
                    $product->decrement('stock', $item['quantity']);
                    $cartItem = CartItem::where('user_id', $user->id)->where('product_id', $id)->lockForUpdate()->first();
                    if ($cartItem && $cartItem->quantity <= $item['quantity']) {
                        $cartItem->delete();
                    } elseif ($cartItem) {
                        $cartItem->decrement('quantity', $item['quantity']);
                    }
                }
                $payment = Payment::create([
                    'order_id' => $order->id,
                    'amount' => $total,
                    'payment_method' => $method,
                    'status' => 'pending',
                ]);

                if ($method === 'payos') {
                    \App\Support\VinmarkPayOS::createLink($order, $payment);
                }

                return $order;
            }, $method === 'payos' ? 1 : 3);
        } catch (\PayOS\Exceptions\PayOSException | \UnexpectedValueException $error) {
            logger()->warning('Không tạo được thanh toán payOS cho đơn app', ['exception_type' => get_class($error)]);
            return response()->json(['message' => 'Chưa tạo được mã QR. Vui lòng thử lại.'], 502);
        }

        $payment = $order->payment;
        return response()->json([
            'id' => $order->id,
            'paymentMethod' => $payment?->payment_method,
            'paymentStatus' => $payment?->status,
            'paymentUrl' => $payment?->status === 'pending' ? $payment->payos_checkout_url : null,
        ]);
    }
}
