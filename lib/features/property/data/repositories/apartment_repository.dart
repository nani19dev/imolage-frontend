import 'dart:convert';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/features/property/data/models/apartment.dart';
import 'package:http/http.dart' as http;

class ApartmentRepository {
  final String _baseUrl = '$apiUrl/property';
  final http.Client _client;

  ApartmentRepository({http.Client? client}) : _client = client ?? http.Client();

  Future getAllApartments(String accessToken, String propertyId) async {
    final url = '$_baseUrl/properties/$propertyId/apartments/';
    final response = await _client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<ApartmentModel> list = [];
      for (var object in data) {
        ApartmentModel apartment = ApartmentModel.fromJson(object);
        list.add(apartment);
      }
      return list; 
    } else {
      return data; 
    }
  }

  Future createApartment(String accessToken, ApartmentModel apartment) async {
    final url = '$_baseUrl/properties/${apartment.propertyId}/apartments/';
    final response = await _client.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(apartment.toJson()),
    );
    return response;
  }

  Future<ApartmentModel> getApartment(String accessToken, String apartmentId) async {
    final url = '$_baseUrl/apartments/$apartmentId/';
    final response = await _client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApartmentModel apartment = ApartmentModel.fromJson(data);
      return apartment;
    } 
    return data;
  }

  Future updateApartment(String accessToken, ApartmentModel apartment) async {
    final url = '$_baseUrl/apartments/${apartment.id}/';
    final response = await _client.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(apartment.toJson()),
    );
    final data = jsonDecode(response.body);
    return data; 
  }

  Future deleteApartment(String accessToken, String apartmentId) async {
    final url = '$_baseUrl/apartments/$apartmentId/';
    final response = await _client.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = jsonDecode(response.body);
    return data;
  }

}