import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/user_model.dart';

class AuthService{
  static const String _baseUrl = 'http://10.0.2.2:8080';
  Future<UserModel> login(String email, String password) async{
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    ).timeout(
      const Duration(seconds: 20),
      onTimeout: (){
        throw Exception("Tempo de conexão esgotado. Verifique a internet!");
      }
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String? token = data['token'];
      final Map<String, dynamic> UserData = (data['user'] != null && data['user'] is Map<String, dynamic>) ? data['user'] : data;

      return UserModel.fromJson(UserData, token: token);
    }else if(response.statusCode == 401){
      throw Exception('Email ou senha incorretos');
    }else{
      throw Exception('Falha ao realizar login. Tente novamente.');
    }
  }

  Future<void> register(UserModel user, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toCreateJson(password: password)),
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Não foi possível conectar ao servidor. Verifique se a API está rodando.');
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      throw Exception('Dados inválidos. Verifique os campos e os requisitos do formulário.');
    } else if (response.statusCode == 409) {
      throw Exception('E-mail ou CPF já cadastrados.');
    } else {
      throw Exception('Falha ao realizar cadastro. Código: ${response.statusCode}');
    }
  }

  Future<String> validatePasswordReset(String email, String cpf) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/recover-password/validate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'cpf': cpf,
      }),
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('Tempo limite excedido ao conectar ao servidor.'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['recoveryToken'] ?? data['token'] ?? '';
    } else if (response.statusCode == 404 || response.statusCode == 400) {
      throw Exception('E-mail ou CPF não encontrados.');
    } else {
      throw Exception('Falha ao validar dados. Código: ${response.statusCode}');
    }
  }

  Future<void> resetPassword(String recoveryToken, String newPassword, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/recover-password/reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'recoveryToken': recoveryToken,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      }),
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('Tempo limite excedido ao conectar ao servidor.'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else if (response.statusCode == 400) {
      throw Exception('Dados inválidos ou token expirado.');
    } else {
      throw Exception('Falha ao redefinir senha. Código: ${response.statusCode}');
    }
  }
}