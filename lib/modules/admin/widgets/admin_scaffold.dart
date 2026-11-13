import 'package:flutter/material.dart';
import '../../auth/service/auth_service.dart';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class AdminScaffold extends StatelessWidget {
  final String title;
  final String currentRoute;
  final Widget body;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.body,
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
        title: Text(
          l10n.appName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 48),
            onSelected: (value) {
              if (value == 'logout') _handleLogout(context);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.logout),
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
                      const Text(
                        'ADMIN',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
      drawer: Drawer(
        backgroundColor: AppColors.primary,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, color: Colors.white, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      l10n.appName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 8),
              _buildNavItem(context, l10n.menuDashboard, AppRoutes.adminDashboard),
              _buildNavItem(context, l10n.menuLoans, AppRoutes.adminLoans),
              _buildNavItem(context, l10n.menuUsers, AppRoutes.adminUsers),
              _buildNavItem(context, l10n.menuBooks, AppRoutes.adminBooks),
              _buildNavItem(context, l10n.menuPublishers, AppRoutes.adminPublishers),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String route) {
    final isActive = currentRoute == route;

    return Container(
      margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.background : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: ListTile(
        title: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isActive ? AppColors.primary : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (!isActive) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }
}