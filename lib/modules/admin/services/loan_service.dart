import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/service/auth_service.dart';
import '../models/loan_model.dart';

class LoanService {
  static const String _baseUrl = 'http://10.0.2.2:8080/loans';

  Future<List<LoanModel>> getAllLoans({String? term}) async {
    final headers = await AuthService.getAuthHeaders();

    final queryParams = <String, String>{
      'page': '0',
      'size': '100',
      if (term != null && term.trim().isNotEmpty) 'term': term.trim(),
    };

    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: queryParams);
    final response = await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> list =
          decoded is List ? decoded : (decoded['content'] ?? []);
      return list.map((item) => LoanModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar empréstimos (${response.statusCode})');
    }
  }

  Future<void> createLoan({
    required int userId,
    required int bookId,
    required DateTime termLimit,
  }) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: headers,
          body: jsonEncode({
            'userId': userId,
            'bookId': bookId,
            'termLimit': LoanModel.formatApiDate(termLimit),
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response, 'Erro ao registrar empréstimo'));
    }
  }

  Future<void> renewLoan(int id, DateTime newTerm) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .patch(
          Uri.parse('$_baseUrl/$id/renew'),
          headers: headers,
          body: jsonEncode({
            'newTerm': LoanModel.formatApiDate(newTerm),
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response, 'Erro ao renovar empréstimo'));
    }
  }

  Future<void> returnLoan(int id) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .patch(
          Uri.parse('$_baseUrl/$id/return'),
          headers: headers,
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response, 'Erro ao registrar devolução'));
    }
  }

  String _extractErrorMessage(http.Response response, String fallback) {
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      return body['message'] ?? body['error'] ?? fallback;
    } catch (_) {
      return '$fallback (${response.statusCode})';
    }
  }
}