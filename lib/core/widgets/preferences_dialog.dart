import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../services/locale_controller.dart';
import '../theme/app_colors.dart';

Future<void> showPreferencesDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;

  await showDialog(
    context: context,
    builder: (ctx) {
      return ValueListenableBuilder<Locale>(
        valueListenable: LocaleController.localeNotifier,
        builder: (ctx, currentLocale, _) {
          return AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                const Icon(Icons.language_rounded, color: AppColors.primary),
                const SizedBox(width: 10),
                Text(
                  l10n.preferences,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.selectLanguage,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                _LanguageOptionTile(
                  label: 'Português (BR)',
                  code: 'pt',
                  isSelected: currentLocale.languageCode == 'pt',
                  onTap: () async {
                    await LocaleController.setLocale('pt');
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 8),
                _LanguageOptionTile(
                  label: 'English (US)',
                  code: 'en',
                  isSelected: currentLocale.languageCode == 'en',
                  onTap: () async {
                    await LocaleController.setLocale('en');
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 8),
                _LanguageOptionTile(
                  label: 'Español',
                  code: 'es',
                  isSelected: currentLocale.languageCode == 'es',
                  onTap: () async {
                    await LocaleController.setLocale('es');
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  l10n.cancel,
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class _LanguageOptionTile extends StatelessWidget {
  final String label;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionTile({
    required this.label,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}