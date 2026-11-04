// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'BibliotecaBooks';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get loginButton => 'Entrar';

  @override
  String get forgotPassword => 'Olvidé mi contraseña';

  @override
  String get register => 'Registrarse';
}
