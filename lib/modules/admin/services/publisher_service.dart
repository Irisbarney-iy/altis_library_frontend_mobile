import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/service/auth_service.dart';
import '../models/publisher_model.dart';

class PublisherService {
  static const String _baseUrl = 'http://10.0.2.2:8080/publishers';

  Future<List<PublisherModel>> getAllPublishers({String? term}) async {
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
      return list.map((item) => PublisherModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar editoras (${response.statusCode})');
    }
  }

  Future<void> createPublisher(PublisherModel publisher) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: headers,
          body: jsonEncode(publisher.toRequestJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response, 'Erro ao cadastrar editora'));
    }
  }

  Future<void> updatePublisher(int id, PublisherModel publisher) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .patch(
          Uri.parse('$_baseUrl/$id'),
          headers: headers,
          body: jsonEncode(publisher.toRequestJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response, 'Erro ao atualizar editora'));
    }
  }

  Future<void> deletePublisher(int id) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .delete(Uri.parse('$_baseUrl/$id'), headers: headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response, 'Erro ao excluir editora'));
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