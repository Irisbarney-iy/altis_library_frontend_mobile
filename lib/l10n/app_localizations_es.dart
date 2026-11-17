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

  @override
  String get forgotPasswordTitle => 'Recuperar Contraseña';

  @override
  String get forgotPasswordSubtitle =>
      'Ingrese su correo y CPF para validar su cuenta';

  @override
  String get validateButton => 'Validar Datos';

  @override
  String get resetPasswordTitle => 'Nueva Contraseña';

  @override
  String get resetPasswordSubtitle =>
      'Cree una nueva contraseña de 8 a 15 caracteres';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get newPasswordHint => 'Ingrese su nueva contraseña';

  @override
  String get resetPasswordButton => 'Restablecer Contraseña';

  @override
  String get passwordResetSuccess =>
      '¡Contraseña restablecida con éxito! Inicie sesión con la nueva contraseña.';

  @override
  String get validationSuccess =>
      '¡Datos validados con éxito! Defina su nueva contraseña.';

  @override
  String get tokenRequired => 'El token de recuperación es obligatorio';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get settings => 'ajustes';

  @override
  String get menuDashboard => 'Panel';

  @override
  String get menuLoans => 'Préstamos';

  @override
  String get menuUsers => 'Usuarios';

  @override
  String get menuBooks => 'Libros';

  @override
  String get menuPublishers => 'Editoriales';

  @override
  String get searchPublishers => 'Buscar editoriales...';

  @override
  String get newPublisher => 'Nueva Editorial';

  @override
  String get editPublisher => 'Editar Editorial';

  @override
  String get publisherName => 'Nombre de la Editorial';

  @override
  String get website => 'Sitio web';

  @override
  String get actions => 'Acciones';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteConfirmTitle => 'Confirmar Eliminación';

  @override
  String get deletePublisherConfirm => '¿Realmente desea eliminar la editorial';

  @override
  String get publisherCreated => '¡Editorial creada con éxito!';

  @override
  String get publisherUpdated => '¡Editorial actualizada con éxito!';

  @override
  String get publisherDeleted => '¡Editorial eliminada con éxito!';

  @override
  String get searchBooks => 'Buscar libros...';

  @override
  String get newBook => 'Nuevo Libro';

  @override
  String get editBook => 'Editar Libro';

  @override
  String get bookTitle => 'Título';

  @override
  String get author => 'Autor';

  @override
  String get releaseYear => 'Año de Lanzamiento';

  @override
  String get total => 'Total';

  @override
  String get totalQuantity => 'Cantidad Total';

  @override
  String get inUse => 'En Uso';

  @override
  String get publisher => 'Editorial';

  @override
  String get invalidBookTitle =>
      'El título debe tener entre 2 y 150 caracteres';

  @override
  String get invalidAuthorLength =>
      'El autor debe tener entre 2 y 100 caracteres';

  @override
  String get invalidReleaseYear => 'Año mínimo: 1500';

  @override
  String get invalidQuantity => 'Cantidad inválida';

  @override
  String get publisherRequired => 'Seleccione una editorial';

  @override
  String get deleteBookConfirm => '¿Realmente desea eliminar el libro';

  @override
  String get bookCreated => '¡Libro creado con éxito!';

  @override
  String get bookUpdated => '¡Libro actualizado con éxito!';

  @override
  String get bookDeleted => '¡Libro eliminado con éxito!';

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
  String get sortAZ => 'De A a Z';

  @override
  String get sortZA => 'De Z a A';

  @override
  String get sortMostRecent => 'Más reciente';

  @override
  String get searchLoans => 'Buscar préstamos...';

  @override
  String get newRental => 'Nuevo Alquiler';

  @override
  String get renter => 'Arrendatario';

  @override
  String get book => 'Libro';

  @override
  String get rentalDate => 'Fecha Alquiler';

  @override
  String get limitDate => 'Plazo';

  @override
  String get returnedDate => 'Entrega';

  @override
  String get renew => 'Renovar';

  @override
  String get returnBook => 'Devolver';

  @override
  String get renewLoanTitle => 'Renovar Préstamo';

  @override
  String get newLimitDate => 'Nuevo Plazo Límite';

  @override
  String get returnBookTitle => 'Confirmar Devolución';

  @override
  String get returnBookConfirm => '¿Desea registrar la devolución del libro';

  @override
  String get confirm => 'Confirmar';

  @override
  String get renterRequired => 'Seleccione un arrendatario';

  @override
  String get bookRequired => 'Seleccione un libro';

  @override
  String get loanCreated => '¡Préstamo registrado con éxito!';

  @override
  String get loanRenewed => '¡Préstamo renovado con éxito!';

  @override
  String get loanReturned => '¡Devolución registrada con éxito!';

  @override
  String get loanStatusOnTime => 'A Tiempo';

  @override
  String get loanStatusOverdue => 'Atrasado';

  @override
  String get loanStatusRtdOnTime => 'Entr.AT';

  @override
  String get loanStatusRtdDelayed => 'Entr.CR';

  @override
  String get totalBooksMetric => 'Total de Libros';

  @override
  String get activeLoansMetric => 'Préstamos Activos';

  @override
  String get monthlyLoansMetric => 'Préstamos del Mes';

  @override
  String get criticalDelayAlerts => 'Alertas Críticas de Retraso';

  @override
  String get noCriticalDelays =>
      'No hay préstamos con retraso crítico por el momento.';

  @override
  String get userColumn => 'Usuario';

  @override
  String get daysOverdueColumn => 'Días de Retraso';

  @override
  String get daySingular => 'día';

  @override
  String get daysPlural => 'días';

  @override
  String get tryAgain => 'Intentar de nuevo';
}
