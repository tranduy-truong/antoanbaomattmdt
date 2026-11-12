<?php

namespace App\Http\Controllers\Clients;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Contact;

class ContactController extends Controller
{
    public function index()
    {
        return view('clients.pages.contact');
    }

    public function sendContact(Request $request)
    {
        $this->storeContact($request);
        toastr()->success(message: 'Gửi thành công! Quản trị viên sẽ sớm liên hệ với bạn.');

        return redirect()->back();
    }

    public function sendMobileContact(Request $request): \Illuminate\Http\JsonResponse
    {
        $contact = $this->storeContact($request);

        return response()->json(['id' => $contact->getKey()], 201);
    }

    private function storeContact(Request $request): Contact
    {
        $data = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255',
            'phone' => ['required', 'regex:/^[0-9]{10,15}$/D'],
            'message' => 'required|string|max:4000',
        ], [
            'name.required' => 'Tên là bắt buộc.',
            'email.required' => 'Email là bắt buộc.',
            'email.email' => 'Email không hợp lệ.',
            'phone.required' => 'Số điện thoại là bắt buộc.',
            'phone.regex' => 'Số điện thoại phải có từ 10 đến 15 chữ số.',
            'message.required' => 'Nội dung phản hồi là bắt buộc.',
            'message.max' => 'Nội dung phản hồi tối đa 4000 ký tự.',
        ]);

        return Contact::create([
            'full_name' => $data['name'],
            'phone_number' => $data['phone'],
            'email' => $data['email'],
            'message' => $data['message'],
        ]);
    }
}
