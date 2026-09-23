import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedGender;
  DateTime? selectedDate;
  bool isObscure = true;
  bool isLoading = false;

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    hpController.dispose();
    tanggalController.dispose();
    alamatController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.indigo,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        tanggalController.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  String formatTanggal(String tanggal) {
    final bagian = tanggal.split('/');
    return '${bagian[2]}-${bagian[1]}-${bagian[0]}';
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final user = UserModel(
          nama: namaController.text,
          email: emailController.text,
          nomorHp: hpController.text,
          gender: selectedGender!,
          tanggalLahir: formatTanggal(tanggalController.text),
          alamat: alamatController.text,
          username: usernameController.text,
          password: passwordController.text,
        );

        final response = await apiService.register(user);
        final data = jsonDecode(response.body);

        if (response.statusCode == 201) {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text('Registrasi Berhasil'),
                content: const Text('Akun berhasil dibuat. Silakan login.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Registrasi gagal'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan koneksi ke server'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  String? wajibDiisi(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kolom ini wajib diisi';
    }
    return null;
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon, color: Colors.indigo),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.indigo, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Registrasi'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 44,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Silakan lengkapi data diri Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Username
                TextFormField(
                  controller: usernameController,
                  decoration: _buildInputDecoration(
                    label: 'Username',
                    prefixIcon: Icons.account_circle_outlined,
                  ),
                  validator: wajibDiisi,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: isObscure,
                  decoration: _buildInputDecoration(
                    label: 'Password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password wajib diisi';
                    }
                    if (value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Nama Lengkap
                TextFormField(
                  controller: namaController,
                  decoration: _buildInputDecoration(
                    label: 'Nama Lengkap',
                    prefixIcon: Icons.person_outline,
                  ),
                  validator: wajibDiisi,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration(
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }
                    if (!value.contains('@')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Nomor HP
                TextFormField(
                  controller: hpController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(
                    label: 'Nomor HP',
                    prefixIcon: Icons.phone_outlined,
                  ),
                  validator: wajibDiisi,
                ),
                const SizedBox(height: 16),

                // Gender
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: _buildInputDecoration(
                    label: 'Gender',
                    prefixIcon: Icons.people_outline,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Laki-laki',
                      child: Text('Laki-laki'),
                    ),
                    DropdownMenuItem(
                      value: 'Perempuan',
                      child: Text('Perempuan'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Gender wajib dipilih';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Tanggal Lahir
                TextFormField(
                  controller: tanggalController,
                  readOnly: true,
                  onTap: pilihTanggal,
                  decoration: _buildInputDecoration(
                    label: 'Tanggal Lahir',
                    prefixIcon: Icons.calendar_today_outlined,
                    suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ),
                  validator: wajibDiisi,
                ),
                const SizedBox(height: 16),

                // Alamat
                TextFormField(
                  controller: alamatController,
                  maxLines: 2,
                  decoration: _buildInputDecoration(
                    label: 'Alamat',
                    prefixIcon: Icons.home_outlined,
                  ),
                  validator: wajibDiisi,
                ),
                const SizedBox(height: 28),

                // Tombol Submit
                ElevatedButton(
                  onPressed: isLoading ? null : submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Submit Registrasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // Tombol ke LoginPage
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}