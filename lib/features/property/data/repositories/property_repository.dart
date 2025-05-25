import 'dart:convert';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/features/property/data/models/property.dart';
import 'package:http/http.dart' as http;

class PropertyRepository {
  final String _baseUrl = '$apiUrl/property/properties/';
  final http.Client _client;

  PropertyRepository({http.Client? client}) : _client = client ?? http.Client();

  Future getAllProperties(String accessToken) async {
    final url = _baseUrl;
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<PropertyModel> list = [];
      for (var object in data) {
        PropertyModel property = PropertyModel.fromJson(object);
        list.add(property);
      }
      return list; 
    } else {
      return data;
    }
  }

  Future createProperty(String accessToken, PropertyModel property) async {
    final url = _baseUrl;
    final response = await _client.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(property.toJson()),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      PropertyModel property = PropertyModel.fromJson(data);
      return property;
    }
    return data;
  }

  Future getProperty(String accessToken, String propertyId) async {
    final url = '$_baseUrl$propertyId/';
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      PropertyModel property = PropertyModel.fromJson(data);
      return property;
    }
    return data;
  }

  Future updateProperty(String accessToken, PropertyModel property) async {
    final url = '$_baseUrl${property.id}/';
    final response = await _client.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(property.toJson()),
    );
    return response; 
  }

  Future deleteProperty(String accessToken, String propertyId) async {
    final url = '$_baseUrl$propertyId/';
    final response = await _client.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return response; 
  }

}