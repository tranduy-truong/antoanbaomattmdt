<?php

namespace App\Support;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Minishlink\WebPush\Subscription;
use Minishlink\WebPush\WebPush;

class AdminOrderPush
{
    public static function allowedEndpoint(string $endpoint): bool
    {
        $url = parse_url($endpoint);
        $host = strtolower($url['host'] ?? '');

        return ($url['scheme'] ?? '') === 'https'
            && !isset($url['user']) && !isset($url['pass'])
            && ($url['port'] ?? 443) === 443
            && ($host === 'fcm.googleapis.com' || str_ends_with($host, '.notify.windows.com'));
    }

    public function send(int $id): void
    {
        if (!config('services.admin_push.public_key') || !config('services.admin_push.private_key')) {
            return;
        }

        $push = new WebPush(['VAPID' => [
            'subject' => config('services.admin_push.subject'),
            'publicKey' => config('services.admin_push.public_key'),
            'privateKey' => config('services.admin_push.private_key'),
        ]], ['TTL' => 300, 'urgency' => 'high'], 5, ['allow_redirects' => false]);
        $payload = json_encode(['id' => $id, 'url' => route('admin.order-detail', ['id' => $id], false)], JSON_THROW_ON_ERROR);
        $ids = [];
        foreach (DB::table('admin_push_subscriptions')->get() as $row) {
            $admin = Auth::guard('admin')->getProvider()->retrieveById($row->admin_id);
            if (!$admin?->role?->permissions?->contains('name', 'manage_orders') || !self::allowedEndpoint($row->endpoint)) {
                continue;
            }
            try {
                $push->queueNotification(Subscription::create([
                    'endpoint' => $row->endpoint,
                    'publicKey' => $row->public_key,
                    'authToken' => $row->auth_token,
                    'contentEncoding' => 'aes128gcm',
                ]), $payload);
                $ids[$row->endpoint] = $row->id;
            } catch (\Throwable $error) {
                logger()->warning('Admin order push subscription could not be queued', ['order_id' => $id]);
            }
        }

        foreach ($push->flush() as $report) {
            if ($report->isSubscriptionExpired()) {
                $key = $ids[$report->getEndpoint()] ?? null;
                if ($key) {
                    DB::table('admin_push_subscriptions')->where('id', $key)->delete();
                }
            } elseif (!$report->isSuccess()) {
                logger()->warning('Admin order push was rejected', ['order_id' => $id]);
            }
        }
    }
}
