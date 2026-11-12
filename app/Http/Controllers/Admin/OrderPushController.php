<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Support\AdminOrderPush;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class OrderPushController extends Controller
{
    public function store(Request $request)
    {
        abort_unless(config('services.admin_push.public_key') && config('services.admin_push.private_key'), 503);
        $data = $request->validate([
            'endpoint' => ['required', 'url:https', 'max:2048'],
            'keys.p256dh' => ['required', 'regex:/^[A-Za-z0-9_-]{87}$/'],
            'keys.auth' => ['required', 'regex:/^[A-Za-z0-9_-]{22}$/'],
        ]);
        abort_unless(AdminOrderPush::allowedEndpoint($data['endpoint']), 422, 'Trình duyệt này chưa được hỗ trợ.');

        $now = now();
        DB::table('admin_push_subscriptions')->upsert([[
            'id' => hash('sha256', $data['endpoint']),
            'admin_id' => Auth::guard('admin')->id(),
            'endpoint' => $data['endpoint'],
            'public_key' => $data['keys']['p256dh'],
            'auth_token' => $data['keys']['auth'],
            'created_at' => $now,
            'updated_at' => $now,
        ]], ['id'], ['admin_id', 'public_key', 'auth_token', 'updated_at']);

        return response()->noContent();
    }

    public function destroy(Request $request)
    {
        $data = $request->validate(['endpoint' => ['required', 'string', 'max:2048']]);
        DB::table('admin_push_subscriptions')
            ->where('admin_id', Auth::guard('admin')->id())
            ->where('id', hash('sha256', $data['endpoint']))->delete();

        return response()->noContent();
    }
}
