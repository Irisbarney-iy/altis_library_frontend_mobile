import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../l10n/app_localizations.dart';
import '../models/publisher_model.dart';
import '../services/publisher_service.dart';
import '../widgets/admin_scaffold.dart';

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
        _applySearch(_searchController.text);
      });
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applySearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _currentPage = 1;
      if (q.isEmpty) {
        _filteredPublishers = List.from(_allPublishers);
      } else {
        _filteredPublishers = _allPublishers.where((p) {
          return p.name.toLowerCase().contains(q) ||
              p.email.toLowerCase().contains(q) ||
              p.phone.contains(q) ||
              (p.site?.toLowerCase().contains(q) ?? false);
        }).toList();
      }
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
                width: 260,
                child: TextField(
                  controller: _searchController,
                  onChanged: _applySearch,
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
                : Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(AppColors.surface),
                                dataRowColor: WidgetStateProperty.all(AppColors.background),
                                dividerThickness: 1,
                                columns: [
                                  DataColumn(label: _headerText(l10n.publisherName)),
                                  DataColumn(label: _headerText(l10n.email)),
                                  DataColumn(label: _headerText(l10n.phone)),
                                  DataColumn(label: _headerText(l10n.website)),
                                  DataColumn(label: _headerText(l10n.actions)),
                                ],
                                rows: pageItems.map((pub) {
                                  return DataRow(
                                    cells: [
                                      DataCell(_cellText(pub.name, isBold: true)),
                                      DataCell(_cellText(pub.email)),
                                      DataCell(_cellText(pub.phone)),
                                      DataCell(_cellText(pub.site ?? '---')),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _actionIconButton(
                                              icon: Icons.edit_outlined,
                                              onTap: () => _openPublisherFormDialog(publisher: pub),
                                            ),
                                            const SizedBox(width: 8),
                                            _actionIconButton(
                                              icon: Icons.delete_outline,
                                              onTap: () => _confirmDelete(pub),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
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
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _cellText(String text, {bool isBold = false}) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _actionIconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}