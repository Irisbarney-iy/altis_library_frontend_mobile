import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/service/auth_service.dart';
import '../models/book_model.dart';

class BookService {
  static const String _baseUrl = 'http://10.0.2.2:8080/books';

  Future<List<BookModel>> getAllBooks({String? term}) async {
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
      return list.map((item) => BookModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar livros (${response.statusCode})');
    }
  }

  Future<void> createBook(BookModel book) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: headers,
          body: jsonEncode(book.toRequestJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response, 'Erro ao cadastrar livro'));
    }
  }

  Future<void> updateBook(int id, BookModel book) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .patch(
          Uri.parse('$_baseUrl/$id'),
          headers: headers,
          body: jsonEncode(book.toRequestJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response, 'Erro ao atualizar livro'));
    }
  }

  Future<void> deleteBook(int id) async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .delete(Uri.parse('$_baseUrl/$id'), headers: headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response, 'Erro ao excluir livro'));
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