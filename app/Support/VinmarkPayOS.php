<?php

namespace App\Support;

use PayOS\PayOS;

final class VinmarkPayOS
{
    public static function configured(): bool
    {
        return (bool) (config('services.payos.client_id')
            && config('services.payos.api_key')
            && config('services.payos.checksum_key'));
    }

    public static function enabled(): bool
    {
        return config('services.payos.enabled') && self::configured();
    }

    public static function createLink(\App\Models\Order $order, \App\Models\Payment $payment): string
    {
        $amount = (int) $payment->amount;
        if ($amount <= 0 || (float) $payment->amount !== (float) $amount) {
            throw new \UnexpectedValueException('payOS requires a positive whole VND amount.');
        }

        $code = random_int(100000000, 999999999);
        $payment->payos_order_code = $code;
        $payment->save();
        $url = route('order.show', ['id' => $order->id]);
        $link = self::client()->paymentRequests->create(
            new \PayOS\Models\V2\PaymentRequests\CreatePaymentLinkRequest(
                orderCode: $code,
                amount: $amount,
                description: (string) $code,
                cancelUrl: $url,
                returnUrl: $url,
            )
        );

        if ($link->orderCode !== $code || $link->amount !== $amount
            || parse_url($link->checkoutUrl, PHP_URL_SCHEME) !== 'https'
            || parse_url($link->checkoutUrl, PHP_URL_HOST) !== 'pay.payos.vn') {
            throw new \UnexpectedValueException('Unexpected payOS payment link.');
        }

        $payment->payos_link_id = $link->paymentLinkId;
        $payment->payos_checkout_url = $link->checkoutUrl;
        $payment->save();

        return $link->checkoutUrl;
    }

    public static function client(): PayOS
    {
        if (!self::configured()) {
            throw new \LogicException('Vinmark payOS credentials are missing.');
        }

        return new PayOS(
            clientId: config('services.payos.client_id'),
            apiKey: config('services.payos.api_key'),
            checksumKey: config('services.payos.checksum_key'),
            maxRetries: 0,
        );
    }
}
