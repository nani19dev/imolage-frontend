import 'dart:convert';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/features/auth/data/models/appuser.dart';
import 'package:http/http.dart' as http;

class AuthenticationRepository {
  final String _baseUrl = apiUrl;
  final http.Client _client;

  AuthenticationRepository({http.Client? client}) : _client = client ?? http.Client();

  Future signUp(AppUserModel appUser, String password) async {
    final url = '$_baseUrl/user/register/';
    final response = await _client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': appUser.username,
        'email': appUser.email,
        'password': password,
      }),
    );
    final data = jsonDecode(response.body);
    return data;
  }

  Future signIn(String username, String password) async {
    final url = '$_baseUrl/token/';
    final response = await _client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    final data = jsonDecode(response.body);
    return data;
  }

}