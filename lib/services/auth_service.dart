// frontend/lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthService {
  final String baseUrl = 'http://localhost::3000/api';
  final storage = FlutterSecureStorage();

  Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final token = json.decode(response.body)['token'];
      await storage.write(key: 'auth_token', value: token);
      return true;
    }
    return false;
  }
  //   

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      await storage.write(key: 'auth_token', value: token);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
    // with the use of the SharedPeference thing we make changes

  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'auth_token');
    return token != null;
  }
}