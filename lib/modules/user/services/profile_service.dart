import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/user_model.dart';
import '../../auth/service/auth_service.dart';

class ProfileService {
  static const String _baseUrl = 'http://10.0.2.2:8080/users';

  Future<UserModel> getMe() async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .get(Uri.parse('$_baseUrl/me'), headers: headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return UserModel.fromJson(decoded as Map<String, dynamic>);
    } else {
      throw Exception(_extractErrorMessage(response, 'Erro ao carregar perfil'));
    }
  }

  Future<UserModel> updateMe({
    required String name,
    required String email,
    required String phone,
    String? address,
  }) async {
    final headers = await AuthService.getAuthHeaders();

    final body = <String, dynamic>{
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      if (address != null && address.trim().isNotEmpty) 'address': address.trim(),
    };

    final response = await http
        .patch(
          Uri.parse('$_baseUrl/me'),
          headers: headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return UserModel.fromJson(decoded as Map<String, dynamic>);
    } else {
      throw Exception(_extractErrorMessage(response, 'Erro ao atualizar perfil'));
    }
  }

  String _extractErrorMessage(http.Response response, String fallback) {
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] != null) return decoded['message'].toString();
        if (decoded['error'] != null) return decoded['error'].toString();
      }
    } catch (_) {}
    return '$fallback (${response.statusCode})';
  }
}