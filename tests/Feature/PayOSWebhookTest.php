<?php

namespace Tests\Feature;

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Tests\TestCase;

class PayOSWebhookTest extends TestCase
{
    public function test_only_signed_matching_transfers_complete_a_payment(): void
    {
        config(['services.payos' => ['client_id' => 'test-client', 'api_key' => 'test-api', 'checksum_key' => 'test-checksum']]);
        Schema::create('payments', function (Blueprint $table): void {
            $table->id();
            $table->unsignedBigInteger('order_id');
            $table->string('payment_method');
            $table->decimal('amount', 10, 2);
            $table->string('status');
            $table->string('transaction_id')->nullable();
            $table->timestamp('paid_at')->nullable();
            $table->timestamps();
        });
        $migration = require database_path('migrations/2026_11_12_130000_add_payos_fields_to_payments.php');
        $migration->up();

        DB::table('payments')->insert([
            'order_id' => 123, 'payment_method' => 'payos', 'amount' => 25000,
            'status' => 'pending', 'payos_order_code' => 123456789, 'payos_link_id' => 'test-link',
        ]);

        $data = [
            'orderCode' => 123456789, 'amount' => 25000, 'description' => '123456789',
            'accountNumber' => '123456', 'reference' => 'TEST-REF',
            'transactionDateTime' => '2026-11-12 19:45:00', 'currency' => 'VND',
            'paymentLinkId' => 'test-link', 'code' => '00', 'desc' => 'Success',
        ];
        $endpoint = '/api/payments/payos/webhook';
        $this->postJson($endpoint, ['data' => $data, 'signature' => 'invalid'])->assertStatus(400);
        $this->assertDatabaseHas('payments', ['order_id' => 123, 'status' => 'pending']);
        $send = function (array $data) use ($endpoint) {
            $signature = \App\Support\VinmarkPayOS::client()->getCrypto()->createSignatureFromObj($data, 'test-checksum');
            return $this->postJson($endpoint, ['data' => $data, 'signature' => $signature]);
        };
        $send(array_replace($data, ['amount' => 24000]))->assertOk();
        $send(array_replace($data, ['paymentLinkId' => 'other-link']))->assertOk();
        $this->assertDatabaseHas('payments', ['order_id' => 123, 'status' => 'pending']);
        $send($data)->assertOk();
        $send(array_replace($data, ['reference' => 'DUPLICATE']))->assertOk();
        $this->assertDatabaseHas('payments', ['order_id' => 123, 'status' => 'completed', 'transaction_id' => 'TEST-REF']);
    }
}
