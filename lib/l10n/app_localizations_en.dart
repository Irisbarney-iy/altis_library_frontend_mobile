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

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'settings';

  @override
  String get menuDashboard => 'Dashboard';

  @override
  String get menuLoans => 'Loans';

  @override
  String get menuUsers => 'Users';

  @override
  String get menuBooks => 'Books';

  @override
  String get menuPublishers => 'Publishers';

  @override
  String get searchPublishers => 'Search publishers...';

  @override
  String get newPublisher => 'New Publisher';

  @override
  String get editPublisher => 'Edit Publisher';

  @override
  String get publisherName => 'Publisher Name';

  @override
  String get website => 'Website';

  @override
  String get actions => 'Actions';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirmTitle => 'Confirm Deletion';

  @override
  String get deletePublisherConfirm =>
      'Are you sure you want to delete publisher';

  @override
  String get publisherCreated => 'Publisher created successfully!';

  @override
  String get publisherUpdated => 'Publisher updated successfully!';

  @override
  String get publisherDeleted => 'Publisher deleted successfully!';

  @override
  String get searchBooks => 'Search books...';

  @override
  String get newBook => 'New Book';

  @override
  String get editBook => 'Edit Book';

  @override
  String get bookTitle => 'Title';

  @override
  String get author => 'Author';

  @override
  String get releaseYear => 'Release Year';

  @override
  String get total => 'Total';

  @override
  String get totalQuantity => 'Total Quantity';

  @override
  String get inUse => 'In Use';

  @override
  String get publisher => 'Publisher';

  @override
  String get invalidBookTitle => 'Title must be between 2 and 150 characters';

  @override
  String get invalidAuthorLength =>
      'Author must be between 2 and 100 characters';

  @override
  String get invalidReleaseYear => 'Minimum year: 1500';

  @override
  String get invalidQuantity => 'Invalid quantity';

  @override
  String get publisherRequired => 'Select a publisher';

  @override
  String get deleteBookConfirm => 'Are you sure you want to delete book';

  @override
  String get bookCreated => 'Book created successfully!';

  @override
  String get bookUpdated => 'Book updated successfully!';

  @override
  String get bookDeleted => 'Book deleted successfully!';

  @override
  String get searchUsers => 'Search users...';

  @override
  String get filter => 'Filter';

  @override
  String get filterAll => 'All';

  @override
  String get status => 'Status';

  @override
  String get statusActive => 'Active';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get userActivated => 'User activated successfully!';

  @override
  String get userDeactivated => 'User deactivated successfully!';

  @override
  String get sortAZ => 'A to Z';

  @override
  String get sortZA => 'Z to A';

  @override
  String get sortMostRecent => 'Most recent';

  @override
  String get searchLoans => 'Search loans...';

  @override
  String get newRental => 'New Rental';

  @override
  String get renter => 'Renter';

  @override
  String get book => 'Book';

  @override
  String get rentalDate => 'Rental Date';

  @override
  String get limitDate => 'Limit Date';

  @override
  String get returnedDate => 'Returned Date';

  @override
  String get renew => 'Renew';

  @override
  String get returnBook => 'Return';

  @override
  String get renewLoanTitle => 'Renew Loan';

  @override
  String get newLimitDate => 'New Limit Date';

  @override
  String get returnBookTitle => 'Confirm Return';

  @override
  String get returnBookConfirm => 'Do you want to register the return of';

  @override
  String get confirm => 'Confirm';

  @override
  String get renterRequired => 'Select a renter';

  @override
  String get bookRequired => 'Select a book';

  @override
  String get loanCreated => 'Loan created successfully!';

  @override
  String get loanRenewed => 'Loan renewed successfully!';

  @override
  String get loanReturned => 'Book returned successfully!';

  @override
  String get loanStatusOnTime => 'On Time';

  @override
  String get loanStatusOverdue => 'Overdue';

  @override
  String get loanStatusRtdOnTime => 'Rtd.OnTime';

  @override
  String get loanStatusRtdDelayed => 'Rtd.Delayed';

  @override
  String get totalBooksMetric => 'Total Books';

  @override
  String get activeLoansMetric => 'Active Loans';

  @override
  String get monthlyLoansMetric => 'Monthly Loans';

  @override
  String get criticalDelayAlerts => 'Critical Delay Alerts';

  @override
  String get noCriticalDelays => 'No critical overdue loans at the moment.';

  @override
  String get userColumn => 'User';

  @override
  String get daysOverdueColumn => 'Days Overdue';

  @override
  String get daySingular => 'day';

  @override
  String get daysPlural => 'days';

  @override
  String get tryAgain => 'Try again';
}
