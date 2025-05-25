import 'dart:convert';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/features/contract/data/models/contract.dart';
import 'package:http/http.dart' as http;


class ContractRepository {
  final String _baseUrl = '$apiUrl/contract';
  final http.Client _client;

  ContractRepository({http.Client? client}) : _client = client ?? http.Client();

  Future getAllContracts(String accessToken, String apartmentId) async {
    final url = '$_baseUrl/apartments/$apartmentId/contracts/';
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<ContractModel> list = [];
      for (var object in data) {
        ContractModel contract = ContractModel.fromJson(object);
        list.add(contract);
      }
      return list; 
    } else {
      return data; 
    }
  }

  Future createContract(String accessToken, ContractModel contract) async {
    final url = '$_baseUrl/apartments/${contract.apartmentId}/contracts/';
    final response = await _client.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(contract.toJson()),
    );
    return response;
  }

  Future getContract(String accessToken, String contractId) async {
    final url = '$_baseUrl/contracts/$contractId/';
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ContractModel contract = ContractModel.fromJson(data);
      return contract;
    } 
    return data;
  }

  Future getBalance(String accessToken, String contractId) async {
    final url = '$_baseUrl/contracts/$contractId/balance/';
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      double balance = data['balance'];
      return balance;
    } 
    return data;
  }

  Future updateContract(String accessToken, ContractModel contract) async {
    final url = '$_baseUrl/contracts/${contract.id}/';
    final response = await _client.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(contract.toJson()),
    );
    return response;
  }

  Future deleteContract(String accessToken, String contractId) async {
    final url = '$_baseUrl/contracts/$contractId/';
    final response = await _client.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return response; 
  }
  
}