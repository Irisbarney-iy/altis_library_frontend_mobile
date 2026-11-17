import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../l10n/app_localizations.dart';
import '../models/publisher_model.dart';
import '../services/publisher_service.dart';
import '../widgets/admin_scaffold.dart';

enum _PublisherSortOption { aToZ, zToA, mostRecent }

class AdminPublishersPage extends StatefulWidget {
  const AdminPublishersPage({super.key});

  @override
  State<AdminPublishersPage> createState() => _AdminPublishersPageState();
}

class _AdminPublishersPageState extends State<AdminPublishersPage> {
  final _service = PublisherService();
  final _searchController = TextEditingController();

  List<PublisherModel> _allPublishers = [];
  List<PublisherModel> _filteredPublishers = [];
  bool _isLoading = true;
  _PublisherSortOption _sortOption = _PublisherSortOption.aToZ;

  int _currentPage = 1;
  static const int _itemsPerPage = 9;

  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

  @override
  void initState() {
    super.initState();
    _fetchPublishers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPublishers() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getAllPublishers();
      if (!mounted) return;
      setState(() {
        _allPublishers = data;
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
        ? List<PublisherModel>.from(_allPublishers)
        : _allPublishers.where((p) {
            return p.name.toLowerCase().contains(q) ||
                p.email.toLowerCase().contains(q) ||
                p.phone.contains(q) ||
                (p.site?.toLowerCase().contains(q) ?? false);
          }).toList();

    switch (_sortOption) {
      case _PublisherSortOption.aToZ:
        result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case _PublisherSortOption.zToA:
        result.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case _PublisherSortOption.mostRecent:
        result.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        break;
    }

    setState(() {
      _currentPage = 1;
      _filteredPublishers = result;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  Future<void> _openPublisherFormDialog({PublisherModel? publisher}) async {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = publisher != null;
    final formKey = GlobalKey<FormState>();

    final nameCtrl = TextEditingController(text: publisher?.name ?? '');
    final emailCtrl = TextEditingController(text: publisher?.email ?? '');
    final phoneCtrl = TextEditingController(text: publisher?.phone ?? '');
    final siteCtrl = TextEditingController(text: publisher?.site ?? '');
    bool isSaving = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              title: Text(
                isEditing ? l10n.editPublisher : l10n.newPublisher,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: l10n.publisherName,
                          counterText: '',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().length < 3 || v.trim().length > 100) {
                            return l10n.invalidNameLength;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          hintText: l10n.emailHint,
                          counterText: '',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return l10n.emailRequired;
                          if (!_emailRegex.hasMatch(v.trim())) return l10n.invalidEmailGmail;
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          PhoneInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          labelText: l10n.phone,
                          hintText: l10n.phoneHint,
                        ),
                        validator: (v) {
                          final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                          if (digits.length < 8 || digits.length > 20) {
                            return l10n.phoneRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: siteCtrl,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: l10n.website,
                          hintText: 'www.editora.com',
                          counterText: '',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(ctx),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setDialogState(() => isSaving = true);

                          final payload = PublisherModel(
                            id: publisher?.id,
                            name: nameCtrl.text,
                            email: emailCtrl.text,
                            phone: phoneCtrl.text,
                            site: siteCtrl.text,
                          );

                          try {
                            if (isEditing) {
                              await _service.updatePublisher(publisher.id!, payload);
                            } else {
                              await _service.createPublisher(payload);
                            }
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            _showSnackBar(
                              isEditing ? l10n.publisherUpdated : l10n.publisherCreated,
                            );
                            _fetchPublishers();
                          } catch (e) {
                            setDialogState(() => isSaving = false);
                            _showSnackBar(
                              e.toString().replaceAll('Exception: ', ''),
                              isError: true,
                            );
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(PublisherModel publisher) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          l10n.deleteConfirmTitle,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text('${l10n.deletePublisherConfirm} "${publisher.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && publisher.id != null) {
      try {
        await _service.deletePublisher(publisher.id!);
        _showSnackBar(l10n.publisherDeleted);
        _fetchPublishers();
      } catch (e) {
        _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final totalItems = _filteredPublishers.length;
    final totalPages = totalItems == 0 ? 1 : (totalItems / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, totalItems);
    final pageItems = totalItems == 0
        ? <PublisherModel>[]
        : _filteredPublishers.sublist(startIndex, endIndex);

    return AdminScaffold(
      title: l10n.menuPublishers,
      currentRoute: AppRoutes.adminPublishers,
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
                    hintText: l10n.searchPublishers,
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
              PopupMenuButton<_PublisherSortOption>(
                initialValue: _sortOption,
                color: AppColors.background,
                onSelected: (selected) {
                  _sortOption = selected;
                  _applyFilters();
                },
                itemBuilder: (context) => [
                  _buildSortMenuItem(_PublisherSortOption.aToZ, l10n.sortAZ),
                  _buildSortMenuItem(_PublisherSortOption.zToA, l10n.sortZA),
                  _buildSortMenuItem(_PublisherSortOption.mostRecent, l10n.sortMostRecent),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _sortOption != _PublisherSortOption.aToZ
                          ? AppColors.primary
                          : AppColors.border,
                      width: _sortOption != _PublisherSortOption.aToZ ? 1.5 : 1,
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
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _openPublisherFormDialog(),
                icon: const Icon(Icons.add, size: 20),
                label: Text(l10n.newPublisher),
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
                            final publisher = pageItems[index];
                            final hasSite =
                                publisher.site != null && publisher.site!.trim().isNotEmpty;

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
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.business_rounded,
                                          color: AppColors.primary,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          publisher.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
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
                                          publisher.email,
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
                                        publisher.phone,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (hasSite) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.language_outlined,
                                          size: 16,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            publisher.site!,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () =>
                                              _openPublisherFormDialog(publisher: publisher),
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.primary),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.edit_outlined,
                                                  size: 16,
                                                  color: AppColors.primary,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  l10n.editPublisher,
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => _confirmDelete(publisher),
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.error),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.delete_outline,
                                                  size: 16,
                                                  color: AppColors.error,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  l10n.delete,
                                                  style: const TextStyle(
                                                    color: AppColors.error,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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

  PopupMenuItem<_PublisherSortOption> _buildSortMenuItem(
      _PublisherSortOption value, String label) {
    final isSelected = _sortOption == value;
    return PopupMenuItem<_PublisherSortOption>(
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
}