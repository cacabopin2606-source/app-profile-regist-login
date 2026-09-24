# Flutter Authentication - Laravel API

Project ini merupakan aplikasi autentikasi sederhana yang terdiri dari fitur **registrasi** dan **login** menggunakan Flutter sebagai frontend, Laravel sebagai backend/API, dan MySQL sebagai database.

---

## 📌 Teknologi yang Digunakan

| Teknologi | Fungsi |
|-----------|--------|
| Flutter | Frontend aplikasi |
| Dart | Bahasa pemrograman Flutter |
| Laravel | Backend dan REST API |
| PHP | Bahasa pemrograman Laravel |
| MySQL | Database |
| Postman | Testing API |
| JSON | Format pertukaran data |

---

## 🏗️ Arsitektur Sistem

Project menggunakan konsep **client-server**, di mana Flutter tidak berkomunikasi langsung dengan MySQL.

```text
┌──────────────┐
│    Flutter   │
│   Frontend   │
└──────┬───────┘
       │
       │ HTTP / JSON
       ▼
┌──────────────┐
│    Laravel   │
│  REST API    │
└──────┬───────┘
       │
       │ Eloquent
       ▼
┌──────────────┐
│    MySQL     │
│   Database   │
└──────────────┘
````

### Alur komunikasi

```text
Flutter
   ↓
HTTP Request
   ↓
Laravel API
   ↓
Controller
   ↓
Model
   ↓
MySQL
   ↓
JSON Response
   ↓
Flutter
```

Laravel berfungsi sebagai perantara antara aplikasi Flutter dan database MySQL.

---

# 📁 Struktur Project

## Flutter

```text
lib/
├── main.dart
│
├── models/
│   └── user_model.dart
│
├── pages/
│   ├── register_page.dart
│   ├── login_page.dart
│   └── home_page.dart
│
└── services/
    └── api_service.dart
```

### Penjelasan Folder

| Folder/File          | Fungsi                          |
| -------------------- | ------------------------------- |
| `main.dart`          | Titik awal aplikasi             |
| `models/`            | Menyimpan struktur data         |
| `pages/`             | Menyimpan halaman aplikasi      |
| `services/`          | Menangani komunikasi dengan API |
| `user_model.dart`    | Model data pengguna             |
| `register_page.dart` | Halaman registrasi              |
| `login_page.dart`    | Halaman login                   |
| `home_page.dart`     | Halaman utama                   |
| `api_service.dart`   | Mengirim request ke Laravel     |

---

# 🧩 Konsep OOP

Project Flutter menggunakan konsep **Object-Oriented Programming (OOP)**.

Contoh class:

```dart
class UserModel {
  String nama;
  String email;
  String nomorHp;
  String gender;
  String tanggalLahir;
  String alamat;
  String username;
  String password;

  UserModel({
    required this.nama,
    required this.email,
    required this.nomorHp,
    required this.gender,
    required this.tanggalLahir,
    required this.alamat,
    required this.username,
    required this.password,
  });
}
```

`UserModel` digunakan untuk merepresentasikan data pengguna dalam bentuk object.

Contoh pembuatan object:

```dart
final user = UserModel(
  nama: namaController.text,
  email: emailController.text,
  nomorHp: hpController.text,
  gender: selectedGender!,
  tanggalLahir: tanggalLahir,
  alamat: alamatController.text,
  username: usernameController.text,
  password: passwordController.text,
);
```

Dengan menggunakan model, data pengguna menjadi lebih terstruktur dan mudah dikirim ke service/API.

---

# 📝 Fitur Registrasi

Halaman registrasi digunakan untuk membuat akun baru.

Data yang dikirim:

* Nama
* Email
* Nomor HP
* Gender
* Tanggal lahir
* Alamat
* Username
* Password

### Alur Registrasi

```text
User mengisi form
        ↓
Validasi Flutter
        ↓
Membuat UserModel
        ↓
ApiService
        ↓
POST /api/register
        ↓
AuthController Laravel
        ↓
Validasi Laravel
        ↓
User Model
        ↓
MySQL
        ↓
Response JSON
        ↓
Flutter
        ↓
Registrasi berhasil
        ↓
Login Page
```

---

# 🔍 Validasi Form

Validasi dilakukan di dua sisi.

### 1. Flutter

Validasi digunakan untuk memberikan feedback langsung kepada pengguna.

Contohnya:

```text
Nama tidak boleh kosong
Email harus memiliki format email
Password minimal 8 karakter
Gender harus dipilih
```

### 2. Laravel

Laravel melakukan validasi kembali sebelum data disimpan ke database.

Contoh:

```php
$validator = Validator::make($request->all(), [
    'name' => 'required|string|max:255',
    'email' => 'required|email|unique:users,email',
    'username' => 'required|string|max:50|unique:users,username',
    'password' => 'required|string|min:8',
]);
```

Validasi backend tetap diperlukan karena request ke API tidak hanya dapat berasal dari aplikasi Flutter.

---

# 🌐 REST API

Laravel menyediakan endpoint untuk komunikasi dengan Flutter.

File:

```text
routes/api.php
```

Endpoint registrasi:

```php
Route::post('/register', [AuthController::class, 'register']);
```

Sehingga Flutter mengirim request ke:

```text
POST http://127.0.0.1:8000/api/register
```

---

# 🔄 ApiService

File:

```text
lib/services/api_service.dart
```

ApiService digunakan sebagai penghubung antara halaman Flutter dengan API Laravel.

Contoh request:

```dart
final response = await http.post(
  Uri.parse('$baseUrl/register'),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
  body: jsonEncode(data),
);
```

### Fungsi utama

1. Menentukan alamat API.
2. Membuat HTTP request.
3. Mengirim data dalam format JSON.
4. Menerima response dari Laravel.

---

# 📦 Format Data JSON

Flutter mengirim data ke Laravel dalam format JSON.

Contoh:

```json
{
  "name": "Nadia",
  "email": "nadia@email.com",
  "nomor_hp": "08123456789",
  "gender": "Perempuan",
  "tanggal_lahir": "2008-01-01",
  "alamat": "Jember",
  "username": "nadia",
  "password": "********"
}
```

Laravel menerima JSON tersebut melalui `Request`.

---

# ⚙️ Backend Laravel

Controller:

```text
app/Http/Controllers/Api/AuthController.php
```

Method registrasi:

```php
public function register(Request $request)
{
    ...
}
```

Controller bertugas untuk:

1. Menerima request.
2. Melakukan validasi.
3. Membuat data user.
4. Menyimpan data melalui model.
5. Mengirim response JSON.

---

# 🗄️ Database

Database yang digunakan:

```text
flutter_auth
```

Tabel utama:

```text
users
```

Struktur data:

| Field           | Keterangan                  |
| --------------- | --------------------------- |
| `id`            | ID pengguna                 |
| `name`          | Nama                        |
| `email`         | Email                       |
| `nomor_hp`      | Nomor HP                    |
| `gender`        | Gender                      |
| `tanggal_lahir` | Tanggal lahir               |
| `alamat`        | Alamat                      |
| `username`      | Username                    |
| `password`      | Password yang sudah di-hash |
| `created_at`    | Waktu pembuatan             |
| `updated_at`    | Waktu perubahan             |

---

# 🔐 Password Hashing

Password tidak disimpan dalam bentuk teks biasa.

Laravel menggunakan:

```php
Hash::make($request->password)
```

Alurnya:

```text
Password User
      ↓
Hash::make()
      ↓
Password Hash
      ↓
MySQL
```

Hal ini bertujuan agar password yang tersimpan di database tidak berupa password asli pengguna.

---

# 🧪 Testing dengan Postman

Sebelum menghubungkan Flutter, API dapat diuji menggunakan Postman.

Contoh request:

```text
POST
http://127.0.0.1:8000/api/register
```

Body menggunakan format JSON.

```json
{
    "name": "Nadia",
    "email": "nadia@email.com",
    "nomor_hp": "08123456789",
    "gender": "Perempuan",
    "tanggal_lahir": "2008-01-01",
    "alamat": "Jember",
    "username": "nadia",
    "password": "12345678"
}
```

Jika berhasil, Laravel mengembalikan response:

```text
201 Created
```

Kemudian data dapat diperiksa pada tabel:

```text
flutter_auth
└── users
```

> Postman digunakan untuk menguji API, bukan sebagai database.

---

# 🔔 Response Flutter

Setelah registrasi berhasil, Laravel mengirim response JSON.

Flutter membaca response menggunakan:

```dart
final data = jsonDecode(response.body);
```

Kemudian status response diperiksa:

```dart
if (response.statusCode == 201) {
    // Registrasi berhasil
}
```

Flutter kemudian menampilkan `AlertDialog`:

```text
Registrasi Berhasil

Akun berhasil dibuat.
Silakan login.
```

Setelah tombol **OK** ditekan, pengguna diarahkan ke halaman Login.

---

# 🔀 Navigasi Setelah Registrasi

Setelah registrasi berhasil:

```text
Register Page
      ↓
Alert Dialog
      ↓
Tombol OK
      ↓
Login Page
```

Digunakan:

```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const LoginPage(),
  ),
);
```

`pushReplacement()` digunakan agar halaman Register tidak menjadi halaman sebelumnya dalam stack navigasi.

---

# 🔑 Konsep Login

Login memiliki alur yang mirip dengan registrasi, tetapi tujuannya berbeda.

### Registrasi

Membuat akun baru:

```text
Flutter
   ↓
POST /register
   ↓
Validasi
   ↓
Create User
   ↓
MySQL
```

### Login

Memeriksa akun yang sudah ada:

```text
Flutter
   ↓
POST /login
   ↓
Laravel
   ↓
Cari User
   ↓
Periksa Password
   ↓
Berhasil / Gagal
```

---

# 🛠️ Urutan Pengerjaan

Project dikerjakan secara bertahap:

```text
1. Membuat Project Flutter
        ↓
2. Membuat Register Page
        ↓
3. Membuat UserModel
        ↓
4. Membuat Project Laravel
        ↓
5. Membuat Database MySQL
        ↓
6. Membuat Migration Users
        ↓
7. Menjalankan Migration
        ↓
8. Membuat API Register
        ↓
9. Testing API dengan Postman
        ↓
10. Membuat ApiService Flutter
        ↓
11. Menghubungkan Register Page
        ↓
12. Testing Registrasi dari Flutter
        ↓
13. Membuat Login API
        ↓
14. Membuat Login Page
        ↓
15. Menghubungkan Login dengan API
        ↓
16. Mengarahkan User ke Home Page
```

---

# 📌 Kesimpulan

Project ini menerapkan konsep **client-server** dengan Flutter sebagai frontend, Laravel sebagai backend/API, dan MySQL sebagai database.

Flutter bertugas menerima input dan menampilkan informasi kepada pengguna. Laravel menangani request, validasi, proses autentikasi, serta komunikasi dengan database. MySQL digunakan untuk menyimpan data pengguna.

Komunikasi Flutter dan Laravel dilakukan melalui **REST API menggunakan HTTP dan JSON**.

Alur utama aplikasi:

```text
User
 ↓
Flutter
 ↓
REST API
 ↓
Laravel
 ↓
MySQL
```

Dengan struktur ini, frontend, backend, dan database memiliki tanggung jawab masing-masing sehingga kode lebih terorganisir dan lebih mudah dikembangkan.

````

### Supaya README-nya makin enak dilihat di GitHub

Aku sarankan **jangan memasukkan semua kode lengkap** ke README. README cukup menjelaskan **konsep dan fungsi**, sedangkan kode tetap berada di folder project.

Struktur repo-nya nanti kira-kira:

```text
project/
│
├── flutter_app/
│   ├── lib/
│   │   ├── models/
│   │   ├── pages/
│   │   └── services/
│   └── pubspec.yaml
│
├── laravel_api/
│   ├── app/
│   ├── routes/
│   ├── database/
│   └── .env.example
│
└── README.md
````

**Catatan penting:** kalau project ini mau di-upload ke GitHub, **jangan upload `.env` Laravel asli**, karena biasanya berisi konfigurasi database dan informasi sensitif. Buat `.env.example` sebagai contoh konfigurasi saja.
