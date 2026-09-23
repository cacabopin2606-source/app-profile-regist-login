import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<http.Response> register(UserModel user) async {
  final data = {
    'name': user.nama,
    'email': user.email,
    'nomor_hp': user.nomorHp,
    'gender': user.gender,
    'tanggal_lahir': user.tanggalLahir,
    'alamat': user.alamat,
    'username': user.username,
    'password': user.password,
  };

  final response = await http.post(
    Uri.parse('$baseUrl/register'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(data),
  );

  return response;
  }
  Future<http.Response> login(String username, String password) async {
  final data = {
    'username': username,
    'password': password,
  };

  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode(data),
  );

  return response;
}
}