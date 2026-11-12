// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'BibliotecaBooks';

  @override
  String get loginTitle => 'Welcome back!';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Ex: example@gmail.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get clear => 'Clear';

  @override
  String get loginButton => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUpHere => 'Sign up here';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get registerTitle => 'Welcome!';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get cpf => 'CPF';

  @override
  String get cpfHint => '000.000.000-00';

  @override
  String get phone => 'Phone';

  @override
  String get phoneHint => '(85) 99737-7275';

  @override
  String get birthDate => 'Birth date';

  @override
  String get birthDateHint => 'YYYY-MM-DD';

  @override
  String get address => 'Address';

  @override
  String get addressHint => 'Street, No. - Neighborhood, City';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Confirm your password';

  @override
  String get signUpButton => 'Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginHere => 'Login here';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get registerSuccess =>
      'Registration successful! Please login to continue.';

  @override
  String get invalidNameLength => 'Name must be between 3 and 100 characters';

  @override
  String get invalidEmailGmail => 'Email must be a @gmail.com address';

  @override
  String get cpfRequired => 'CPF is required';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get addressRequired => 'Address is required';

  @override
  String get birthDateRequired => 'Birth date is required';

  @override
  String get minimumAgeRequired =>
      'You must be at least 6 years old to register';

  @override
  String get passwordRequirements =>
      'Password must be 8-15 characters, including letters, numbers, and symbols';

  @override
  String get forgotPasswordTitle => 'Recover Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and CPF to validate your account';

  @override
  String get validateButton => 'Validate Info';

  @override
  String get resetPasswordTitle => 'New Password';

  @override
  String get resetPasswordSubtitle =>
      'Create a new password from 8 to 15 characters';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordHint => 'Enter your new password';

  @override
  String get resetPasswordButton => 'Reset Password';

  @override
  String get passwordResetSuccess =>
      'Password reset successfully! Please login with your new password.';

  @override
  String get validationSuccess =>
      'Data validated successfully! Set your new password.';

  @override
  String get tokenRequired => 'Recovery token is required';
}
