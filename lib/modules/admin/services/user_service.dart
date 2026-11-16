import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/user_model.dart';
import '../../auth/service/auth_service.dart';

class UserService {
  static const String _baseUrl = 'http://10.0.2.2:8080/users';

  Future<List<UserModel>> getAllUsers({String? term}) async {
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
      return list.map((item) => UserModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar usuários (${response.statusCode})');
    }
  }

  Future<void> toggleUserStatus(int id, {required bool activate}) async {
    final headers = await AuthService.getAuthHeaders();
    final action = activate ? 'activate' : 'inactive';

    final response = await http
        .patch(Uri.parse('$_baseUrl/$id/$action'), headers: headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response, 'Erro ao alterar status do usuário'));
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