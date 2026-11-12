<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use App\Support\VinmarkPayOS;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use PayOS\Exceptions\WebhookException;

class PayOSWebhookController extends Controller
{
    public function __invoke(Request $request): JsonResponse
    {
        abort_unless(VinmarkPayOS::configured(), 503);

        try {
            $data = VinmarkPayOS::client()->webhooks->verify(json_decode($request->getContent(), true));
        } catch (WebhookException) {
            return response()->json(['message' => 'Invalid webhook'], 400);
        }

        if ($data->code !== '00' || $data->currency !== 'VND') {
            return response()->json(['success' => true]);
        }

        DB::transaction(function () use ($data): void {
            $payment = Payment::where('payment_method', 'payos')
                ->where('payos_order_code', $data->orderCode)
                ->where('payos_link_id', $data->paymentLinkId)
                ->lockForUpdate()->first();

            // payOS also sends signed sample data during webhook registration.
            if (!$payment || $payment->status !== 'pending') {
                return;
            }
            if ((float) $payment->amount !== (float) $data->amount || $data->reference === '') {
                logger()->warning('payOS transfer does not match order amount', ['order_id' => $payment->order_id]);
                return;
            }

            $payment->update([
                'status' => 'completed',
                'transaction_id' => $data->reference,
                'paid_at' => now(),
            ]);
        });

        return response()->json(['success' => true]);
    }
}
