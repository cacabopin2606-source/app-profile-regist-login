<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    
public function register(Request $request)
{
    $validator = Validator::make($request->all(), [
        'name' => 'required|string|max:255',
        'email' => 'required|email|unique:users,email',
        'nomor_hp' => 'required|string|max:20',
        'gender' => 'required|string',
        'tanggal_lahir' => 'required|date',
        'alamat' => 'required|string',
        'username' => 'required|string|max:50|unique:users,username',
        'password' => 'required|string|min:8',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'message' => 'Validasi gagal',
            'errors' => $validator->errors(),
        ], 422);
    }

    $user = User::create([
        'name' => $request->name,
        'email' => $request->email,
        'nomor_hp' => $request->nomor_hp,
        'gender' => $request->gender,
        'tanggal_lahir' => $request->tanggal_lahir,
        'alamat' => $request->alamat,
        'username' => $request->username,
        'password' => Hash::make($request->password),
    ]);

    return response()->json([
        'message' => 'Registrasi berhasil',
        'user' => $user,
    ], 201);
}
public function login(Request $request)
{
    $request->validate([
        'username' => 'required',
        'password' => 'required',
    ]);

    // Cari user berdasarkan username atau email
    $user = User::where('username', $request->username)
                ->orWhere('email', $request->username)
                ->first();

    // Cek user dan password
    if (!$user || !Hash::check($request->password, $user->password)) {
        return response()->json([
            'message' => 'Username atau password salah',
        ], 401);
    }

    return response()->json([
        'message' => 'Login berhasil',
        'user' => $user,
    ], 200);
}
}
