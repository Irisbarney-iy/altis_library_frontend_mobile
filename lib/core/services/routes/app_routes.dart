import 'package:flutter/material.dart';
import '../../../modules/auth/presentation/pages/login_page.dart';
import '../../../modules/auth/presentation/pages/register_page.dart';
import '../../../modules/auth/presentation/pages/forgot_password_page.dart';
import '../../../modules/admin/pages/admin_publishers_page.dart';
import '../../../modules/admin/pages/admin_dashboard_page.dart';
import '../../../modules/admin/pages/admin_books_page.dart';
import '../../../modules/admin/pages/admin_users_page.dart';
import '../../../modules/admin/pages/admin_loans_page.dart';
import '../../../modules/user/pages/user_dashboard_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminPublishers = '/admin/publishers';
  static const String adminBooks = '/admin/books';
  static const String adminLoans = '/admin/loans';

  static const String userDashboard = '/user/dashboard';
  static const String userProfile = '/user/profile';

  static Map<String, WidgetBuilder> get routes {
    return{
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      adminDashboard: (context) => const AdminDashboardPage(),
      adminUsers: (context) => AdminUsersPage(),
      adminPublishers: (context) => const AdminPublishersPage(),
      adminBooks: (context) => const AdminBooksPage(),
      adminLoans: (context) => const AdminLoansPage(),
      userDashboard: (context) => const UserDashboardPage(),
      userProfile: (context) => Scaffold(
        body: Center(
          child: Text('Tela de perfil do usuário')
        ),
      ),
    };
  }
}