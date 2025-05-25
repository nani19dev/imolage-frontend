import 'dart:convert';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/features/transaction/data/models/transaction.dart';
import 'package:http/http.dart' as http;

class TransactionRepository {
  final String _baseUrl = '$apiUrl/transaction';
  final http.Client _client;

  TransactionRepository({http.Client? client}) : _client = client ?? http.Client();

  Future getAllTransactions(String accessToken, String contractId) async {
    final url = '$_baseUrl/contracts/$contractId/transactions/';
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<TransactionModel> list = [];
      for (var object in data) {
        TransactionModel transaction = TransactionModel.fromJson(object);
        list.add(transaction);
      }
      return list; 
    } else {
      return data; 
    }
  }

  Future createTransaction(String accessToken, TransactionModel transaction) async {
    final url = '$_baseUrl/contracts/${transaction.contractId}/transactions/';
    final response = await _client.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(transaction.toJson()),
    );
    return response;
  }

  Future getTransaction(String accessToken, String transactionId) async {
    final url = '$_baseUrl/transactions/$transactionId/';
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken'
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      TransactionModel transaction = TransactionModel.fromJson(data);
      return transaction;
    }
    return data;
  }

  Future updateTransaction(String accessToken, TransactionModel transaction) async {
    final url = '$_baseUrl/transactions/${transaction.id}/';
    final response = await _client.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(transaction.toJson()),
    );
    return response; 
  }

  Future deleteTransaction(String accessToken, String transactionId) async {
    final url = '$_baseUrl/transactions/$transactionId/';
    final response = await _client.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return response;  
  }

}