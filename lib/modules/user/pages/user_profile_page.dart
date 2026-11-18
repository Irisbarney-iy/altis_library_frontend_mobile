import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/service/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/user_scaffold.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _service = ProfileService();
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  UserModel? _user;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  String? _errorMessage;

  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _service.getMe();
      if (!mounted) return;
      setState(() {
        _user = user;
        _syncControllers(user);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _syncControllers(UserModel user) {
    _nameCtrl.text = user.name;
    _emailCtrl.text = user.email;
    _phoneCtrl.text = user.phone ?? '';
    _addressCtrl.text = user.address ?? '';
  }

  void _enterEditMode() {
    if (_user == null) return;
    _syncControllers(_user!);
    setState(() => _isEditing = true);
  }

  void _cancelEditMode() {
    if (_user != null) {
      _syncControllers(_user!);
    }
    setState(() => _isEditing = false);
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate() || _user == null) return;

    final l10n = AppLocalizations.of(context)!;
    final previousEmail = _user!.email.trim().toLowerCase();
    final newEmail = _emailCtrl.text.trim().toLowerCase();

    setState(() => _isSaving = true);

    try {
      final updated = await _service.updateMe(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
        address: _addressCtrl.text,
      );

      if (!mounted) return;

      if (previousEmail != newEmail) {
        _showSnackBar(l10n.emailChangedRelogin);
        await AuthService.logout();
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
        return;
      }

      setState(() {
        _user = updated;
        _syncControllers(updated);
        _isEditing = false;
      });

      _showSnackBar(l10n.profileUpdated);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return UserScaffold(
      title: l10n.menuProfile,
      currentRoute: AppRoutes.userProfile,
      trailingHeader: TextButton.icon(
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.userDashboard);
        },
        icon: const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.primary),
        label: Text(
          l10n.menuDashboard,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _errorMessage != null
              ? _buildErrorState(l10n)
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: _isEditing
                        ? _buildEditForm(l10n)
                        : _buildReadOnlyView(l10n),
                  ),
                ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 42),
          const SizedBox(height: 12),
          Text(
            _errorMessage ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: _loadProfile,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyView(AppLocalizations l10n) {
    final user = _user!;
    final initial = user.name.trim().isNotEmpty
        ? user.name.trim()[0].toUpperCase()
        : '?';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.surface,
              child: Text(
                initial,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.border, height: 28),
        _buildInfoTile(
          icon: Icons.person_outline,
          label: l10n.fullName,
          value: user.name,
        ),
        const SizedBox(height: 14),
        _buildInfoTile(
          icon: Icons.email_outlined,
          label: l10n.email,
          value: user.email,
        ),
        const SizedBox(height: 14),
        _buildInfoTile(
          icon: Icons.phone_outlined,
          label: l10n.phone,
          value: (user.phone != null && user.phone!.isNotEmpty) ? user.phone! : '---',
        ),
        const SizedBox(height: 14),
        _buildInfoTile(
          icon: Icons.location_on_outlined,
          label: l10n.address,
          value: (user.address != null && user.address!.isNotEmpty) ? user.address! : '---',
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _enterEditMode,
          icon: const Icon(Icons.edit_outlined, size: 20),
          label: Text(
            l10n.editProfile,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.editProfile,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameCtrl,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: l10n.fullName,
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
              counterText: '',
            ),
            validator: (v) {
              if (v == null || v.trim().length < 3 || v.trim().length > 100) {
                return l10n.invalidNameLength;
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: l10n.email,
              hintText: l10n.emailHint,
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
              counterText: '',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.emailRequired;
              if (!_emailRegex.hasMatch(v.trim())) return l10n.invalidEmailGmail;
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              PhoneInputFormatter(),
            ],
            decoration: InputDecoration(
              labelText: l10n.phone,
              hintText: l10n.phoneHint,
              prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
            ),
            validator: (v) {
              final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
              if (digits.length < 8 || digits.length > 20) {
                return l10n.phoneRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _addressCtrl,
            maxLength: 255,
            decoration: InputDecoration(
              labelText: l10n.address,
              hintText: l10n.addressHint,
              prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
              counterText: '',
            ),
            validator: (v) {
              if (v != null && v.trim().length > 255) {
                return l10n.invalidAddressLength;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isSaving ? null : _cancelEditMode,
                  child: Text(l10n.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isSaving ? null : _saveChanges,
                  child: _isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          l10n.save,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}