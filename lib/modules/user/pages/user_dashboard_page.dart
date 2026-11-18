import 'package:flutter/material.dart';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../admin/models/admin_dashboard_model.dart';
import '../../admin/services/dashboard_service.dart';
import '../models/user_dashboard_model.dart';
import '../widgets/user_scaffold.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  final _service = DashboardService();

  UserDashboardModel? _dashboardData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _service.getUserDashboard();
      if (!mounted) return;
      setState(() {
        _dashboardData = data;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final todayFormatted = MyBookModel.formatDate(DateTime.now());

    return UserScaffold(
      title: l10n.menuDashboard,
      currentRoute: AppRoutes.userDashboard,
      trailingHeader: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            todayFormatted,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _errorMessage != null
              ? _buildErrorState(l10n)
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _loadDashboard,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMetricsSection(l10n),
                        const SizedBox(height: 20),
                        _buildMyBooksSection(l10n),
                      ],
                    ),
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
            onPressed: _loadDashboard,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.tryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(AppLocalizations l10n) {
    final data = _dashboardData!;

    final cards = [
      _UserMetricCard(
        icon: Icons.book_rounded,
        label: l10n.activeLoansMetric,
        value: AdminDashboardModel.formatCount(data.activeLoans),
        subtitle: l10n.booksWithYou,
      ),
      _UserMetricCard(
        icon: Icons.receipt_long_rounded,
        label: l10n.delaysMetric,
        value: AdminDashboardModel.formatCount(data.totalDelays),
        subtitle: l10n.overdueBooksSubtitle,
        isAlert: true,
      ),
      _UserMetricCard(
        icon: Icons.event_available_rounded,
        label: l10n.withdrawalsMetric,
        value: AdminDashboardModel.formatCount(data.totalReturned),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 680) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 16),
              Expanded(child: cards[1]),
              const SizedBox(width: 16),
              Expanded(child: cards[2]),
            ],
          );
        }

        return Column(
          children: [
            cards[0],
            const SizedBox(height: 12),
            cards[1],
            const SizedBox(height: 12),
            cards[2],
          ],
        );
      },
    );
  }

  Widget _buildMyBooksSection(AppLocalizations l10n) {
    final books = _dashboardData?.myBooks ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_stories_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.myBooksSection,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (books.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                l10n.noBorrowedBooks,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: books.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final book = books[index];
                final isOverdue = book.daysOverdue > 0;
                final daysText = book.daysOverdue == 1
                    ? '1 ${l10n.daySingular}'
                    : '${book.daysOverdue} ${l10n.daysPlural}';

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isOverdue ? AppColors.error.withValues(alpha: 0.6) : AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              book.bookTitle,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isOverdue
                                  ? const Color(0xFFFADBD8)
                                  : const Color(0xFFD5F5E3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              daysText,
                              style: TextStyle(
                                color: isOverdue
                                    ? AppColors.error
                                    : const Color(0xFF1E8449),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              book.author,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildDateItem(
                                l10n.rentalDate,
                                MyBookModel.formatDate(book.loanDate),
                              ),
                            ),
                            Expanded(
                              child: _buildDateItem(
                                l10n.dueDateColumn,
                                MyBookModel.formatDate(book.limitTerm),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String label, String value) {
    return Column(
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
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _UserMetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final bool isAlert;

  const _UserMetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isAlert ? AppColors.error : AppColors.primary;
    final borderColor = isAlert ? AppColors.error : AppColors.border;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: isAlert ? 1.5 : 1),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: accentColor,
            size: 40,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    height: 1.1,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}