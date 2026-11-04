import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/auth/recover-password/reset';

  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminPublishers = '/admin/publishers';
  static const String adminBooks = '/admin/books';
  static const String adminLoans = '/admin/loans';

  static const String userDashboard = '/user/dashboard';
  static const String userProfile = '/user/profile';

  static Map<String, WidgetBuilder> get routes {
    return{
      login: (context) => Scaffold(
        body: Center(
          child: Text('Tela delogin')
          ),
      ),
      register: (context) => Scaffold(
        body: Center(
          child: Text('Tela de cadastro')
        ),
      ),
      forgotPassword: (context) => Scaffold(
        body: Center(
          child: Text('Tela de recuperação de senha')
        ),
      ),
      resetPassword: (context) => Scaffold(
        body: Center(
          child: Text('Tela de redefinição de senha')
        ),
      ),
      adminDashboard: (context) => Scaffold(
        body: Center(
          child: Text('Tela de dashboard do administrador')
        ),
      ),
      adminUsers: (context) => Scaffold(
        body: Center(
          child: Text('Tela de gerenciamento de usuários')
        ),
      ),
      adminPublishers: (context) => Scaffold(
        body: Center(
          child: Text('Tela de gerenciamento de editoras')
        ),
      ),
      adminBooks: (context) => Scaffold(
        body: Center(
          child: Text('Tela de gerenciamento de livros')
        ),
      ),
      adminLoans: (context) => Scaffold(
        body: Center(
          child: Text('Tela de gerenciamento de empréstimos')
        ),
      ),
      userDashboard: (context) => Scaffold(
        body: Center(
          child: Text('Tela de dashboard do usuário')
        ),
      ),
      userProfile: (context) => Scaffold(
        body: Center(
          child: Text('Tela de perfil do usuário')
        ),
      ),
    };
  }
}