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
  String get loginTitle => '¡Bienvenido de nuevo!';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailHint => 'Ej: ejemplo@gmail.com';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordHint => 'Ingrese su contraseña';

  @override
  String get rememberMe => 'Recordarme';

  @override
  String get forgotPassword => 'Olvidé mi contraseña';

  @override
  String get clear => 'Limpiar';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta? ';

  @override
  String get signUpHere => 'Regístrate aquí';

  @override
  String get emailRequired => 'El correo es obligatorio';

  @override
  String get passwordRequired => 'La contraseña es obligatoria';

  @override
  String get registerTitle => '¡Bienvenido!';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get fullNameHint => 'Ingrese su nombre completo';

  @override
  String get cpf => 'CPF';

  @override
  String get cpfHint => '000.000.000-00';

  @override
  String get phone => 'Teléfono';

  @override
  String get phoneHint => '(85) 99737-7275';

  @override
  String get birthDate => 'Fecha de nacimiento';

  @override
  String get birthDateHint => 'AAAA-MM-DD';

  @override
  String get address => 'Dirección';

  @override
  String get addressHint => 'Calle, Nº - Barrio, Ciudad';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get confirmPasswordHint => 'Confirme su contraseña';

  @override
  String get signUpButton => 'Registrarse';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get loginHere => 'Inicia sesión aquí';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get registerSuccess =>
      '¡Registro realizado con éxito! Inicie sesión para continuar.';

  @override
  String get invalidNameLength =>
      'El nombre debe tener entre 3 y 100 caracteres';

  @override
  String get invalidEmailGmail => 'El correo debe terminar en @gmail.com';

  @override
  String get cpfRequired => 'El CPF es obligatorio';

  @override
  String get phoneRequired => 'El teléfono es obligatorio';

  @override
  String get addressRequired => 'La dirección es obligatoria';

  @override
  String get birthDateRequired => 'La fecha de nacimiento es obligatoria';

  @override
  String get minimumAgeRequired =>
      'Debe tener al menos 6 años para registrarse';

  @override
  String get passwordRequirements =>
      'La contraseña debe tener de 8 a 15 caracteres, con letras, números y símbolos';
}
