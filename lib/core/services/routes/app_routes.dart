import 'package:flutter/material.dart';

class AppRoutes{
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String publishers = '/publishers';
  static const String books = '/books';
  static const String rentals = '/rentals';
  static const String users = '/users';

  static Map<String, WidgetBuilder> get routes {
    return{
      login: (context) => Scaffold(
        body: Center(
          child: Text('login')
          ),
      ),
      dashboard: (context) => Scaffold(
        body: Center(
          child: Text('dashboard')
        ),
      ),
      publishers: (context) => Scaffold(
        body: Center(
          child: Text('publishers')
        ),
      ),
      books: (context) => Scaffold(
        body: Center(
          child: Text('books')
        ),
      ),
      rentals: (context) => Scaffold(
        body: Center(
          child: Text('rentals')
        ),
      ),
      users: (context) => Scaffold(
        body: Center(
          child: Text('users')
        ),
      ),
    };
  }
}