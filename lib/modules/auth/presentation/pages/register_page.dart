import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../service/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedBirthDate;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final _authService = AuthService();

  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
  final _passwordRegex = RegExp(
      r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&.#_\-])[A-Za-z\d@$!%*?&.#_\-]{8,15}$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final maxDateAllowed = DateTime(now.year - 6, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1920),
      lastDate: maxDateAllowed,
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newUser = UserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        cpf: _cpfController.text.trim(),
        phone: _phoneController.text.trim(),
        birthDate: _selectedBirthDate,
        address: _addressController.text.trim(),
        role: 'USER',
      );

      await _authService.register(newUser, _passwordController.text);

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.registerSuccess),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _cpfController.clear();
    _phoneController.clear();
    _birthDateController.clear();
    _addressController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() => _selectedBirthDate = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                color: AppColors.primary,
                child: Column(
                  children: [
                    const Icon(Icons.menu_book_rounded,
                        size: 52, color: Colors.white),
                    const SizedBox(height: 4),
                    Text(
                      l10n.appName,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.registerTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      const SizedBox(height: 18),

                      _buildLabel(l10n.fullName),
                      TextFormField(
                        controller: _nameController,
                        maxLength: 100,
                        decoration: InputDecoration(
                            hintText: l10n.fullNameHint, counterText: ''),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l10n.invalidNameLength;
                          }
                          if (v.trim().length < 3 || v.trim().length > 100) {
                            return l10n.invalidNameLength;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      _buildLabel(l10n.email),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 100,
                        decoration: InputDecoration(
                            hintText: l10n.emailHint, counterText: ''),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l10n.emailRequired;
                          }
                          if (!_emailRegex.hasMatch(v.trim())) {
                            return l10n.invalidEmailGmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(l10n.cpf),
                                TextFormField(
                                  controller: _cpfController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CpfInputFormatter(),
                                  ],
                                  decoration:
                                      InputDecoration(hintText: l10n.cpfHint),
                                  validator: (v) => v == null || v.trim().isEmpty
                                      ? l10n.cpfRequired
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(l10n.phone),
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    PhoneInputFormatter(),
                                  ],
                                  decoration:
                                      InputDecoration(hintText: l10n.phoneHint),
                                  validator: (v) => v == null || v.trim().isEmpty
                                      ? l10n.phoneRequired
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      _buildLabel(l10n.birthDate),
                      TextFormField(
                        controller: _birthDateController,
                        readOnly: true,
                        onTap: _selectBirthDate,
                        decoration: InputDecoration(
                          hintText: l10n.birthDateHint,
                          suffixIcon: const Icon(Icons.calendar_today,
                              color: AppColors.primary),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l10n.birthDateRequired;
                          }
                          if (_selectedBirthDate != null) {
                            final now = DateTime.now();
                            final minAgeDate =
                                DateTime(now.year - 6, now.month, now.day);
                            if (_selectedBirthDate!.isAfter(minAgeDate)) {
                              return l10n.minimumAgeRequired;
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      _buildLabel(l10n.address),
                      TextFormField(
                        controller: _addressController,
                        maxLength: 255,
                        decoration: InputDecoration(
                            hintText: l10n.addressHint, counterText: ''),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? l10n.addressRequired
                            : null,
                      ),
                      const SizedBox(height: 14),

                      _buildLabel(l10n.password),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: l10n.passwordHint,
                          errorMaxLines: 3,
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return l10n.passwordRequired;
                          }
                          if (!_passwordRegex.hasMatch(v)) {
                            return l10n.passwordRequirements;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      _buildLabel(l10n.confirmPassword),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: l10n.confirmPasswordHint,
                          errorMaxLines: 3,
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(() =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword),
                          ),
                        ),
                        validator: (v) {
                          if (v != _passwordController.text) {
                            return l10n.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _clearFields,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.primary),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                l10n.clear,
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2),
                                    )
                                  : Text(l10n.signUpButton),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.alreadyHaveAccount,
                              style: const TextStyle(
                                  color: AppColors.textSecondary)),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                                context, AppRoutes.login),
                            child: Text(
                              l10n.loginHere,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontSize: 13),
      ),
    );
  }
}