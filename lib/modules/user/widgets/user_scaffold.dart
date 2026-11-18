import 'package:flutter/material.dart';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/service/auth_service.dart';

class UserScaffold extends StatelessWidget {
  final String title;
  final String currentRoute;
  final Widget body;
  final Widget? trailingHeader;

  const UserScaffold({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.body,
    this.trailingHeader,
  });

  Future<void> _handleLogout(BuildContext context) async {
    await AuthService.logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.menu_book_rounded, color: Colors.white, size: 26),
            const SizedBox(width: 10),
            Text(
              l10n.appName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 48),
            color: AppColors.background,
            onSelected: (value) {
              if (value == 'dashboard' && currentRoute != AppRoutes.userDashboard) {
                Navigator.pushReplacementNamed(context, AppRoutes.userDashboard);
              } else if (value == 'profile' && currentRoute != AppRoutes.userProfile) {
                Navigator.pushReplacementNamed(context, AppRoutes.userProfile);
              } else if (value == 'logout') {
                _handleLogout(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'dashboard',
                child: Row(
                  children: [
                    const Icon(Icons.dashboard_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.menuDashboard,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: currentRoute == AppRoutes.userDashboard
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.menuProfile,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: currentRoute == AppRoutes.userProfile
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: AppColors.error, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.logout,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.menuProfile.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        l10n.settings,
                        style: const TextStyle(fontSize: 10, color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.surface,
                    child: Icon(Icons.person, color: AppColors.primary, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 4),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.primary, width: 3),
                      ),
                    ),
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (trailingHeader != null) trailingHeader!,
                ],
              ),
              const SizedBox(height: 16),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}