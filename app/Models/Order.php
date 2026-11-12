<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;
    protected $fillable = ['user_id', 'total_price', 'status', 'shipping_address_id'];

    public function canCancel(): bool
    {
        return $this->status === 'pending'
            && in_array($this->payment?->payment_method, ['cash', 'payos'], true)
            && $this->payment?->status === 'pending';
    }

    public function user(){
        return $this->belongsTo(User::class);
    }

    public function orderItems(){
        return $this->hasMany(OrderItem::class);
    }

    public function shippingAddress(){
        return $this->belongsTo(ShippingAddress::class)->withTrashed();
    }

    public function payment(){
        return $this->hasOne(Payment::class);
    }

    public function orderStatusHistory(){
        return $this->hasMany(OrderStatusHistory::class);
    }
}
