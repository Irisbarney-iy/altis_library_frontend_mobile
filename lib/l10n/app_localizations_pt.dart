// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'BibliotecaBooks';

  @override
  String get loginTitle => 'Bem-vindo de volta!';

  @override
  String get email => 'E-mail';

  @override
  String get emailHint => 'Ex: exemplo@gmail.com';

  @override
  String get password => 'Senha';

  @override
  String get passwordHint => 'Digite sua senha';

  @override
  String get rememberMe => 'Lembrar-me';

  @override
  String get forgotPassword => 'Esqueci minha senha';

  @override
  String get clear => 'Limpar';

  @override
  String get loginButton => 'Entrar';

  @override
  String get dontHaveAccount => 'Não tem uma conta? ';

  @override
  String get signUpHere => 'Cadastre-se aqui';

  @override
  String get emailRequired => 'O e-mail é obrigatório';

  @override
  String get passwordRequired => 'A senha é obrigatória';

  @override
  String get registerTitle => 'Bem-vindo!';

  @override
  String get fullName => 'Nome completo';

  @override
  String get fullNameHint => 'Digite seu nome completo';

  @override
  String get cpf => 'CPF';

  @override
  String get cpfHint => '000.000.000-00';

  @override
  String get phone => 'Telefone';

  @override
  String get phoneHint => '(85) 99737-7275';

  @override
  String get birthDate => 'Data de nascimento';

  @override
  String get birthDateHint => 'AAAA-MM-DD';

  @override
  String get address => 'Endereço';

  @override
  String get addressHint => 'Rua, Nº - Bairro, Cidade';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get confirmPasswordHint => 'Confirme sua senha';

  @override
  String get signUpButton => 'Cadastrar';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta? ';

  @override
  String get loginHere => 'Faça login aqui';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get registerSuccess =>
      'Cadastro realizado com sucesso! Faça login para continuar.';

  @override
  String get invalidNameLength => 'O nome deve ter entre 3 e 100 caracteres';

  @override
  String get invalidEmailGmail => 'O e-mail deve ser @gmail.com';

  @override
  String get cpfRequired => 'O CPF é obrigatório';

  @override
  String get phoneRequired => 'O telefone é obrigatório';

  @override
  String get addressRequired => 'O endereço é obrigatório';

  @override
  String get birthDateRequired => 'A data de nascimento é obrigatória';

  @override
  String get minimumAgeRequired =>
      'É necessário ter no mínimo 6 anos para se cadastrar';

  @override
  String get passwordRequirements =>
      'A senha deve ter entre 8 e 15 caracteres, com letras, números e símbolos';
}
