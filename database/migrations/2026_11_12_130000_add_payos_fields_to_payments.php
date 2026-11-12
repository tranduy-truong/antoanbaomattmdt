<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('payments', function (Blueprint $table) {
            $table->string('payment_method', 32)->change();
            $table->unsignedInteger('payos_order_code')->nullable()->unique();
            $table->string('payos_link_id', 64)->nullable()->unique();
            $table->text('payos_checkout_url')->nullable();
        });
    }
};
