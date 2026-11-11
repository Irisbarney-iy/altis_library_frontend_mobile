import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appName.
  ///
  /// In pt, this message translates to:
  /// **'BibliotecaBooks'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo de volta!'**
  String get loginTitle;

  /// No description provided for @email.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: exemplo@gmail.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite sua senha'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In pt, this message translates to:
  /// **'Lembrar-me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueci minha senha'**
  String get forgotPassword;

  /// No description provided for @clear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// No description provided for @loginButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @dontHaveAccount.
  ///
  /// In pt, this message translates to:
  /// **'Não tem uma conta? '**
  String get dontHaveAccount;

  /// No description provided for @signUpHere.
  ///
  /// In pt, this message translates to:
  /// **'Cadastre-se aqui'**
  String get signUpHere;

  /// No description provided for @emailRequired.
  ///
  /// In pt, this message translates to:
  /// **'O e-mail é obrigatório'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In pt, this message translates to:
  /// **'A senha é obrigatória'**
  String get passwordRequired;

  /// No description provided for @registerTitle.
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo!'**
  String get registerTitle;

  /// No description provided for @fullName.
  ///
  /// In pt, this message translates to:
  /// **'Nome completo'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite seu nome completo'**
  String get fullNameHint;

  /// No description provided for @cpf.
  ///
  /// In pt, this message translates to:
  /// **'CPF'**
  String get cpf;

  /// No description provided for @cpfHint.
  ///
  /// In pt, this message translates to:
  /// **'000.000.000-00'**
  String get cpfHint;

  /// No description provided for @phone.
  ///
  /// In pt, this message translates to:
  /// **'Telefone'**
  String get phone;

  /// No description provided for @phoneHint.
  ///
  /// In pt, this message translates to:
  /// **'(85) 99737-7275'**
  String get phoneHint;

  /// No description provided for @birthDate.
  ///
  /// In pt, this message translates to:
  /// **'Data de nascimento'**
  String get birthDate;

  /// No description provided for @birthDateHint.
  ///
  /// In pt, this message translates to:
  /// **'AAAA-MM-DD'**
  String get birthDateHint;

  /// No description provided for @address.
  ///
  /// In pt, this message translates to:
  /// **'Endereço'**
  String get address;

  /// No description provided for @addressHint.
  ///
  /// In pt, this message translates to:
  /// **'Rua, Nº - Bairro, Cidade'**
  String get addressHint;

  /// No description provided for @confirmPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar senha'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In pt, this message translates to:
  /// **'Confirme sua senha'**
  String get confirmPasswordHint;

  /// No description provided for @signUpButton.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar'**
  String get signUpButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In pt, this message translates to:
  /// **'Já tem uma conta? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginHere.
  ///
  /// In pt, this message translates to:
  /// **'Faça login aqui'**
  String get loginHere;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In pt, this message translates to:
  /// **'As senhas não coincidem'**
  String get passwordsDoNotMatch;

  /// No description provided for @registerSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Cadastro realizado com sucesso! Faça login para continuar.'**
  String get registerSuccess;

  /// No description provided for @invalidNameLength.
  ///
  /// In pt, this message translates to:
  /// **'O nome deve ter entre 3 e 100 caracteres'**
  String get invalidNameLength;

  /// No description provided for @invalidEmailGmail.
  ///
  /// In pt, this message translates to:
  /// **'O e-mail deve ser @gmail.com'**
  String get invalidEmailGmail;

  /// No description provided for @cpfRequired.
  ///
  /// In pt, this message translates to:
  /// **'O CPF é obrigatório'**
  String get cpfRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In pt, this message translates to:
  /// **'O telefone é obrigatório'**
  String get phoneRequired;

  /// No description provided for @addressRequired.
  ///
  /// In pt, this message translates to:
  /// **'O endereço é obrigatório'**
  String get addressRequired;

  /// No description provided for @birthDateRequired.
  ///
  /// In pt, this message translates to:
  /// **'A data de nascimento é obrigatória'**
  String get birthDateRequired;

  /// No description provided for @minimumAgeRequired.
  ///
  /// In pt, this message translates to:
  /// **'É necessário ter no mínimo 6 anos para se cadastrar'**
  String get minimumAgeRequired;

  /// No description provided for @passwordRequirements.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve ter entre 8 e 15 caracteres, com letras, números e símbolos'**
  String get passwordRequirements;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
