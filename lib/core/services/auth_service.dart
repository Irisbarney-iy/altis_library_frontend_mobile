import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/user_model.dart';

class AuthService{
  static const String _baseUrl = 'http://10.0.2.2:8000';

  Future<UserModel> login(String email, String password) async{
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if(response.statusCode == 200){
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String? token = data['token'];
      final Map<String, dynamic> UserData = data['user'];

      return UserModel.fromJson(UserData, token: token);
    }else if(response.statusCode == 401){
      throw Exception('Email ou senha incorretos');
    }else{
      throw Exception('Falha ao realizar login. Tente novamente.');
    }
  }

  Future<UserModel> register(UserModel user, String password) async{
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode(user.toCreateJson(password: password)),
    );

    if(response.statusCode == 201 || response.statusCode == 200){
      final Map<String, dynamic> data = jsonDecode(response.body);

      return UserModel.fromJson(data);
    }else{
      throw Exception('Erro ao cadastrar usuário. Verifique os dados');
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