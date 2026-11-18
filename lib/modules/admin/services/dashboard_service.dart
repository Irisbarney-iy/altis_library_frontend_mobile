import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../modules/auth/service/auth_service.dart';
import '../../user/models/user_dashboard_model.dart';
import '../models/admin_dashboard_model.dart';

class DashboardService {
  static const String _baseUrl = 'http://10.0.2.2:8080/dashboard';

  Future<AdminDashboardModel> getAdminDashboard() async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .get(Uri.parse('$_baseUrl/admin'), headers: headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return AdminDashboardModel.fromJson(decoded as Map<String, dynamic>);
    } else {
      throw Exception('Erro ao carregar dados do dashboard (${response.statusCode})');
    }
  }

  Future<UserDashboardModel> getUserDashboard() async {
    final headers = await AuthService.getAuthHeaders();
    final response = await http
        .get(Uri.parse('$_baseUrl/user'), headers: headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return UserDashboardModel.fromJson(decoded as Map<String, dynamic>);
    } else {
      throw Exception('Erro ao carregar dados do dashboard (${response.statusCode})');
    }
  }
}