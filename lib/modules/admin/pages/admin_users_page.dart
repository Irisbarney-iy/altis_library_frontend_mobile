import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../admin/services/user_service.dart';
import '../widgets/admin_scaffold.dart';

enum _UserSortOption { aToZ, zToA, mostRecent }

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final _service = UserService();
  final _searchController = TextEditingController();

  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];
  final Set<int> _togglingUserIds = {};

  bool _isLoading = true;
  _UserSortOption _sortOption = _UserSortOption.aToZ;

  int _currentPage = 1;
  static const int _itemsPerPage = 9;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getAllUsers();
      if (!mounted) return;
      setState(() {
        _allUsers = data;
        _applyFilters();
      });
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    final q = _searchController.text.trim().toLowerCase();

    final result = q.isEmpty
        ? List<UserModel>.from(_allUsers)
        : _allUsers.where((u) {
            return u.name.toLowerCase().contains(q) ||
                u.email.toLowerCase().contains(q) ||
                (u.phone?.contains(q) ?? false);
          }).toList();

    switch (_sortOption) {
      case _UserSortOption.aToZ:
        result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case _UserSortOption.zToA:
        result.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case _UserSortOption.mostRecent:
        result.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        break;
    }

    setState(() {
      _currentPage = 1;
      _filteredUsers = result;
    });
  }

  Future<void> _handleToggleStatus(UserModel user, bool newValue) async {
    final userId = user.id;
    if (userId == null || _togglingUserIds.contains(userId)) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _togglingUserIds.add(userId));

    try {
      await _service.toggleUserStatus(userId, activate: newValue);
      if (!mounted) return;

      setState(() {
        final index = _allUsers.indexWhere((u) => u.id == userId);
        if (index != -1) {
          _allUsers[index] = _allUsers[index].copyWith(active: newValue);
        }
        _applyFilters();
      });

      _showSnackBar(
        newValue ? l10n.userActivated : l10n.userDeactivated,
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
    } finally {
      if (mounted) {
        setState(() => _togglingUserIds.remove(userId));
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

    final totalItems = _filteredUsers.length;
    final totalPages = totalItems == 0 ? 1 : (totalItems / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, totalItems);
    final pageItems = totalItems == 0
        ? <UserModel>[]
        : _filteredUsers.sublist(startIndex, endIndex);

    return AdminScaffold(
      title: l10n.menuUsers,
      currentRoute: AppRoutes.adminUsers,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 240,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _applyFilters(),
                  decoration: InputDecoration(
                    hintText: l10n.searchUsers,
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              PopupMenuButton<_UserSortOption>(
                initialValue: _sortOption,
                color: AppColors.background,
                onSelected: (selected) {
                  _sortOption = selected;
                  _applyFilters();
                },
                itemBuilder: (context) => [
                  _buildSortMenuItem(_UserSortOption.aToZ, l10n.sortAZ),
                  _buildSortMenuItem(_UserSortOption.zToA, l10n.sortZA),
                  _buildSortMenuItem(_UserSortOption.mostRecent, l10n.sortMostRecent),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _sortOption != _UserSortOption.aToZ
                          ? AppColors.primary
                          : AppColors.border,
                      width: _sortOption != _UserSortOption.aToZ ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        l10n.filter,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 12),
                          itemCount: pageItems.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final user = pageItems[index];
                            final isToggling = _togglingUserIds.contains(user.id);
                            final initial = user.name.trim().isNotEmpty
                                ? user.name.trim()[0].toUpperCase()
                                : '?';

                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: AppColors.surface,
                                        child: Text(
                                          initial,
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          user.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildStatusBadge(user.active, l10n),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.email_outlined,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          user.email,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone_outlined,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        user.phone ?? '---',
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: AppColors.border, height: 18),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        l10n.status,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        child: Switch(
                                          value: user.active,
                                          activeThumbColor: Colors.white,
                                          activeTrackColor: const Color(0xFF1976D2),
                                          onChanged: isToggling
                                              ? null
                                              : (val) => _handleToggleStatus(user, val),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      _buildPaginationFooter(
                        totalItems: totalItems,
                        startIndex: startIndex,
                        endIndex: endIndex,
                        totalPages: totalPages,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter({
    required int totalItems,
    required int startIndex,
    required int endIndex,
    required int totalPages,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            totalItems == 0
                ? '0 items'
                : '${startIndex + 1} - $endIndex / $totalItems',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                color: AppColors.primary,
                onPressed: _currentPage > 1
                    ? () => setState(() => _currentPage--)
                    : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$_currentPage / $totalPages',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: AppColors.primary,
                onPressed: _currentPage < totalPages
                    ? () => setState(() => _currentPage++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<_UserSortOption> _buildSortMenuItem(_UserSortOption value, String label) {
    final isSelected = _sortOption == value;
    return PopupMenuItem<_UserSortOption>(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            const Icon(Icons.check, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD5F5E3) : const Color(0xFFFADBD8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? l10n.statusActive : l10n.statusInactive,
        style: TextStyle(
          color: isActive ? const Color(0xFF1E8449) : AppColors.error,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}