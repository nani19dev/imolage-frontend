import 'dart:convert';
import 'package:frontend/commun/constant/constant.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

String baseUrl = apiUrl; 

class TokenRepository {
  static const _storage = FlutterSecureStorage();
  bool isAuthorized = false;

  Future<void> storeAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: 'access_token');
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
  }

  static Future<void> clearAllTokens() async {
    await _storage.deleteAll();
  }

  Future refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    final response = await http.post(
      Uri.parse('$baseUrl/token/refresh/'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'refresh': refreshToken}),
    );
    final data = jsonDecode(response.body);
    return data;
  }

  Future<bool> isTokenValid() async {
    final token = await getAccessToken();

    if (token == null) {
      return false;
    }

    final tokenExpiration = JwtDecoder.getExpirationDate(token);
    final now = DateTime.now();

    // Consider token valid if it has at least 5 minutes remaining
    return tokenExpiration.isAfter(now.add(const Duration(minutes: 5)));
    /*if (tokenExpiration.isBefore(now)){
      return false;
    } else {
      return true;
    }*/
  }
}