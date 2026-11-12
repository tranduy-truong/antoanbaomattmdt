<?php

namespace App\Http\Controllers\Clients;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\Wishlist;

class WishlistController extends Controller
{
    public function index()
    {
        $wishlists = Wishlist::with('product')->where('user_id', Auth::id())->get();
        return view('clients.pages.wishlist', compact('wishlists'));
    }

    public function addToWishList(Request $request)
    {
        $request->validate(['product_id' => 'required|integer|exists:products,id']);
        \Illuminate\Support\Facades\DB::transaction(function () use ($request) {
            \App\Models\User::whereKey(Auth::id())->lockForUpdate()->firstOrFail();
            Wishlist::firstOrCreate([
                'user_id' => Auth::id(),
                'product_id' => $request->product_id,
            ]);
        }, 3);
        return response()->json([
            'status' => true,
        ], 200);
    }

    public function removeWishListItem(Request $request){
        Wishlist::where('user_id', Auth::id())->where('product_id', $request->product_id)->delete();

        return response()->json([
            'status' => true,
        ], 200);
    }
}
