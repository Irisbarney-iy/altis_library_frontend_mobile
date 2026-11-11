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

  Future<void> recoverPassword(String email) async{
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/recover-password'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'email': email}),
    );

    if(response.statusCode != 200){
      throw Exception('Erro ao recuperar senha. Verifique o email');
    }
  }
}