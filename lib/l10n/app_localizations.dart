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

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In pt, this message translates to:
  /// **'Recuperar Senha'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Informe seu e-mail e CPF para validar sua conta'**
  String get forgotPasswordSubtitle;

  /// No description provided for @validateButton.
  ///
  /// In pt, this message translates to:
  /// **'Validar Dados'**
  String get validateButton;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova Senha'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Crie uma nova senha de 8 a 15 caracteres'**
  String get resetPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In pt, this message translates to:
  /// **'Nova senha'**
  String get newPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite sua nova senha'**
  String get newPasswordHint;

  /// No description provided for @resetPasswordButton.
  ///
  /// In pt, this message translates to:
  /// **'Redefinir Senha'**
  String get resetPasswordButton;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Senha redefinida com sucesso! Faça login com a nova senha.'**
  String get passwordResetSuccess;

  /// No description provided for @validationSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Dados validados com sucesso! Defina sua nova senha.'**
  String get validationSuccess;

  /// No description provided for @tokenRequired.
  ///
  /// In pt, this message translates to:
  /// **'O token de recuperação é obrigatório'**
  String get tokenRequired;

  /// No description provided for @logout.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'configurações'**
  String get settings;

  /// No description provided for @menuDashboard.
  ///
  /// In pt, this message translates to:
  /// **'Dashboard'**
  String get menuDashboard;

  /// No description provided for @menuLoans.
  ///
  /// In pt, this message translates to:
  /// **'Empréstimos'**
  String get menuLoans;

  /// No description provided for @menuUsers.
  ///
  /// In pt, this message translates to:
  /// **'Usuários'**
  String get menuUsers;

  /// No description provided for @menuBooks.
  ///
  /// In pt, this message translates to:
  /// **'Livros'**
  String get menuBooks;

  /// No description provided for @menuPublishers.
  ///
  /// In pt, this message translates to:
  /// **'Editoras'**
  String get menuPublishers;

  /// No description provided for @searchPublishers.
  ///
  /// In pt, this message translates to:
  /// **'Buscar editoras...'**
  String get searchPublishers;

  /// No description provided for @newPublisher.
  ///
  /// In pt, this message translates to:
  /// **'Nova Editora'**
  String get newPublisher;

  /// No description provided for @editPublisher.
  ///
  /// In pt, this message translates to:
  /// **'Editar Editora'**
  String get editPublisher;

  /// No description provided for @publisherName.
  ///
  /// In pt, this message translates to:
  /// **'Nome da Editora'**
  String get publisherName;

  /// No description provided for @website.
  ///
  /// In pt, this message translates to:
  /// **'Site'**
  String get website;

  /// No description provided for @actions.
  ///
  /// In pt, this message translates to:
  /// **'Ações'**
  String get actions;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar Exclusão'**
  String get deleteConfirmTitle;

  /// No description provided for @deletePublisherConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Deseja realmente excluir a editora'**
  String get deletePublisherConfirm;

  /// No description provided for @publisherCreated.
  ///
  /// In pt, this message translates to:
  /// **'Editora cadastrada com sucesso!'**
  String get publisherCreated;

  /// No description provided for @publisherUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Editora atualizada com sucesso!'**
  String get publisherUpdated;

  /// No description provided for @publisherDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Editora excluída com sucesso!'**
  String get publisherDeleted;

  /// No description provided for @searchBooks.
  ///
  /// In pt, this message translates to:
  /// **'Buscar livros...'**
  String get searchBooks;

  /// No description provided for @newBook.
  ///
  /// In pt, this message translates to:
  /// **'Novo Livro'**
  String get newBook;

  /// No description provided for @editBook.
  ///
  /// In pt, this message translates to:
  /// **'Editar Livro'**
  String get editBook;

  /// No description provided for @bookTitle.
  ///
  /// In pt, this message translates to:
  /// **'Título'**
  String get bookTitle;

  /// No description provided for @author.
  ///
  /// In pt, this message translates to:
  /// **'Autor'**
  String get author;

  /// No description provided for @releaseYear.
  ///
  /// In pt, this message translates to:
  /// **'Ano de Lançamento'**
  String get releaseYear;

  /// No description provided for @total.
  ///
  /// In pt, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade Total'**
  String get totalQuantity;

  /// No description provided for @inUse.
  ///
  /// In pt, this message translates to:
  /// **'Em Uso'**
  String get inUse;

  /// No description provided for @publisher.
  ///
  /// In pt, this message translates to:
  /// **'Editora'**
  String get publisher;

  /// No description provided for @invalidBookTitle.
  ///
  /// In pt, this message translates to:
  /// **'O título deve ter entre 2 e 150 caracteres'**
  String get invalidBookTitle;

  /// No description provided for @invalidAuthorLength.
  ///
  /// In pt, this message translates to:
  /// **'O autor deve ter entre 2 e 100 caracteres'**
  String get invalidAuthorLength;

  /// No description provided for @invalidReleaseYear.
  ///
  /// In pt, this message translates to:
  /// **'Ano mínimo: 1500'**
  String get invalidReleaseYear;

  /// No description provided for @invalidQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade inválida'**
  String get invalidQuantity;

  /// No description provided for @publisherRequired.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma editora'**
  String get publisherRequired;

  /// No description provided for @deleteBookConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Deseja realmente excluir o livro'**
  String get deleteBookConfirm;

  /// No description provided for @bookCreated.
  ///
  /// In pt, this message translates to:
  /// **'Livro cadastrado com sucesso!'**
  String get bookCreated;

  /// No description provided for @bookUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Livro atualizado com sucesso!'**
  String get bookUpdated;

  /// No description provided for @bookDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Livro excluído com sucesso!'**
  String get bookDeleted;

  /// No description provided for @searchUsers.
  ///
  /// In pt, this message translates to:
  /// **'Buscar usuários...'**
  String get searchUsers;

  /// No description provided for @filter.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar'**
  String get filter;

  /// No description provided for @filterAll.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get filterAll;

  /// No description provided for @status.
  ///
  /// In pt, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @statusActive.
  ///
  /// In pt, this message translates to:
  /// **'Ativo'**
  String get statusActive;

  /// No description provided for @statusInactive.
  ///
  /// In pt, this message translates to:
  /// **'Inativo'**
  String get statusInactive;

  /// No description provided for @userActivated.
  ///
  /// In pt, this message translates to:
  /// **'Usuário ativado com sucesso!'**
  String get userActivated;

  /// No description provided for @userDeactivated.
  ///
  /// In pt, this message translates to:
  /// **'Usuário desativado com sucesso!'**
  String get userDeactivated;

  /// No description provided for @sortAZ.
  ///
  /// In pt, this message translates to:
  /// **'De A a Z'**
  String get sortAZ;

  /// No description provided for @sortZA.
  ///
  /// In pt, this message translates to:
  /// **'De Z a A'**
  String get sortZA;

  /// No description provided for @sortMostRecent.
  ///
  /// In pt, this message translates to:
  /// **'Mais recente'**
  String get sortMostRecent;

  /// No description provided for @searchLoans.
  ///
  /// In pt, this message translates to:
  /// **'Buscar empréstimos...'**
  String get searchLoans;

  /// No description provided for @newRental.
  ///
  /// In pt, this message translates to:
  /// **'Novo Aluguel'**
  String get newRental;

  /// No description provided for @renter.
  ///
  /// In pt, this message translates to:
  /// **'Locatário'**
  String get renter;

  /// No description provided for @book.
  ///
  /// In pt, this message translates to:
  /// **'Livro'**
  String get book;

  /// No description provided for @rentalDate.
  ///
  /// In pt, this message translates to:
  /// **'Data Aluguel'**
  String get rentalDate;

  /// No description provided for @limitDate.
  ///
  /// In pt, this message translates to:
  /// **'Prazo'**
  String get limitDate;

  /// No description provided for @returnedDate.
  ///
  /// In pt, this message translates to:
  /// **'Entrega'**
  String get returnedDate;

  /// No description provided for @renew.
  ///
  /// In pt, this message translates to:
  /// **'Renovar'**
  String get renew;

  /// No description provided for @returnBook.
  ///
  /// In pt, this message translates to:
  /// **'Devolver'**
  String get returnBook;

  /// No description provided for @renewLoanTitle.
  ///
  /// In pt, this message translates to:
  /// **'Renovar Empréstimo'**
  String get renewLoanTitle;

  /// No description provided for @newLimitDate.
  ///
  /// In pt, this message translates to:
  /// **'Novo Prazo Limite'**
  String get newLimitDate;

  /// No description provided for @returnBookTitle.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar Devolução'**
  String get returnBookTitle;

  /// No description provided for @returnBookConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Deseja registrar a devolução do livro'**
  String get returnBookConfirm;

  /// No description provided for @confirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @renterRequired.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um locatário'**
  String get renterRequired;

  /// No description provided for @bookRequired.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um livro'**
  String get bookRequired;

  /// No description provided for @loanCreated.
  ///
  /// In pt, this message translates to:
  /// **'Empréstimo registrado com sucesso!'**
  String get loanCreated;

  /// No description provided for @loanRenewed.
  ///
  /// In pt, this message translates to:
  /// **'Empréstimo renovado com sucesso!'**
  String get loanRenewed;

  /// No description provided for @loanReturned.
  ///
  /// In pt, this message translates to:
  /// **'Devolução registrada com sucesso!'**
  String get loanReturned;

  /// No description provided for @loanStatusOnTime.
  ///
  /// In pt, this message translates to:
  /// **'No Prazo'**
  String get loanStatusOnTime;

  /// No description provided for @loanStatusOverdue.
  ///
  /// In pt, this message translates to:
  /// **'Atrasado'**
  String get loanStatusOverdue;

  /// No description provided for @loanStatusRtdOnTime.
  ///
  /// In pt, this message translates to:
  /// **'Entre.NP'**
  String get loanStatusRtdOnTime;

  /// No description provided for @loanStatusRtdDelayed.
  ///
  /// In pt, this message translates to:
  /// **'Entre.CA'**
  String get loanStatusRtdDelayed;

  /// No description provided for @totalBooksMetric.
  ///
  /// In pt, this message translates to:
  /// **'Total de Livros'**
  String get totalBooksMetric;

  /// No description provided for @activeLoansMetric.
  ///
  /// In pt, this message translates to:
  /// **'Empréstimos Ativos'**
  String get activeLoansMetric;

  /// No description provided for @monthlyLoansMetric.
  ///
  /// In pt, this message translates to:
  /// **'Empréstimos ao Mês'**
  String get monthlyLoansMetric;

  /// No description provided for @criticalDelayAlerts.
  ///
  /// In pt, this message translates to:
  /// **'Alertas Críticos de Atraso'**
  String get criticalDelayAlerts;

  /// No description provided for @noCriticalDelays.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum empréstimo com atraso crítico no momento.'**
  String get noCriticalDelays;

  /// No description provided for @userColumn.
  ///
  /// In pt, this message translates to:
  /// **'Usuário'**
  String get userColumn;

  /// No description provided for @daysOverdueColumn.
  ///
  /// In pt, this message translates to:
  /// **'Dias de Atraso'**
  String get daysOverdueColumn;

  /// No description provided for @daySingular.
  ///
  /// In pt, this message translates to:
  /// **'dia'**
  String get daySingular;

  /// No description provided for @daysPlural.
  ///
  /// In pt, this message translates to:
  /// **'dias'**
  String get daysPlural;

  /// No description provided for @tryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get tryAgain;

  /// No description provided for @menuProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get menuProfile;

  /// No description provided for @booksWithYou.
  ///
  /// In pt, this message translates to:
  /// **'Livros com você'**
  String get booksWithYou;

  /// No description provided for @delaysMetric.
  ///
  /// In pt, this message translates to:
  /// **'Atrasos'**
  String get delaysMetric;

  /// No description provided for @overdueBooksSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Livros em atraso'**
  String get overdueBooksSubtitle;

  /// No description provided for @withdrawalsMetric.
  ///
  /// In pt, this message translates to:
  /// **'Retiradas'**
  String get withdrawalsMetric;

  /// No description provided for @myBooksSection.
  ///
  /// In pt, this message translates to:
  /// **'Meus livros'**
  String get myBooksSection;

  /// No description provided for @noBorrowedBooks.
  ///
  /// In pt, this message translates to:
  /// **'Você não possui livros emprestados no momento.'**
  String get noBorrowedBooks;

  /// No description provided for @dueDateColumn.
  ///
  /// In pt, this message translates to:
  /// **'Prazo'**
  String get dueDateColumn;

  /// No description provided for @preferences.
  ///
  /// In pt, this message translates to:
  /// **'Preferências'**
  String get preferences;

  /// No description provided for @selectLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Selecione o idioma do aplicativo:'**
  String get selectLanguage;

  /// No description provided for @viewProfile.
  ///
  /// In pt, this message translates to:
  /// **'Visualizar Perfil'**
  String get viewProfile;

  /// No description provided for @editProfile.
  ///
  /// In pt, this message translates to:
  /// **'Editar Perfil'**
  String get editProfile;

  /// No description provided for @profileUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Perfil atualizado com sucesso!'**
  String get profileUpdated;

  /// No description provided for @emailChangedRelogin.
  ///
  /// In pt, this message translates to:
  /// **'E-mail alterado! Faça login novamente para continuar.'**
  String get emailChangedRelogin;

  /// No description provided for @invalidAddressLength.
  ///
  /// In pt, this message translates to:
  /// **'O endereço deve ter no máximo 255 caracteres.'**
  String get invalidAddressLength;

  /// No description provided for @changePassword.
  ///
  /// In pt, this message translates to:
  /// **'Alterar Senha'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha atual'**
  String get currentPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar nova senha'**
  String get confirmNewPassword;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe sua senha atual.'**
  String get currentPasswordRequired;

  /// No description provided for @newPasswordMinLength.
  ///
  /// In pt, this message translates to:
  /// **'A nova senha deve ter pelo menos 6 caracteres.'**
  String get newPasswordMinLength;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Senha alterada com sucesso!'**
  String get passwordChangedSuccess;
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
