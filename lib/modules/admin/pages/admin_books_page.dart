import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../models/book_model.dart';
import '../models/publisher_model.dart';
import '../../admin/services/book_service.dart';
import '../../admin/services/publisher_service.dart';
import '../widgets/admin_scaffold.dart';

class AdminBooksPage extends StatefulWidget {
  const AdminBooksPage({super.key});

  @override
  State<AdminBooksPage> createState() => _AdminBooksPageState();
}

class _AdminBooksPageState extends State<AdminBooksPage> {
  final _bookService = BookService();
  final _publisherService = PublisherService();
  final _searchController = TextEditingController();

  List<BookModel> _allBooks = [];
  List<BookModel> _filteredBooks = [];
  List<PublisherModel> _publishers = [];
  bool _isLoading = true;

  int _currentPage = 1;
  static const int _itemsPerPage = 9;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _bookService.getAllBooks(),
        _publisherService.getAllPublishers(),
      ]);

      if (!mounted) return;
      setState(() {
        _allBooks = results[0] as List<BookModel>;
        _publishers = results[1] as List<PublisherModel>;
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
        _filteredBooks = List.from(_allBooks);
      } else {
        _filteredBooks = _allBooks.where((b) {
          return b.title.toLowerCase().contains(q) ||
              b.author.toLowerCase().contains(q) ||
              b.publisherName.toLowerCase().contains(q) ||
              b.releaseYear.toString().contains(q);
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

  Future<void> _openBookFormDialog({BookModel? book}) async {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = book != null;
    final formKey = GlobalKey<FormState>();

    final titleCtrl = TextEditingController(text: book?.title ?? '');
    final authorCtrl = TextEditingController(text: book?.author ?? '');
    final yearCtrl = TextEditingController(
      text: book != null ? book.releaseYear.toString() : '',
    );
    final totalCtrl = TextEditingController(
      text: book != null ? book.totalQuantity.toString() : '',
    );

    int? selectedPublisherId =
        _publishers.any((p) => p.id == book?.publisherId) ? book?.publisherId : null;

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
                isEditing ? l10n.editBook : l10n.newBook,
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
                        controller: titleCtrl,
                        maxLength: 150,
                        decoration: InputDecoration(
                          labelText: l10n.bookTitle,
                          counterText: '',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().length < 2 || v.trim().length > 150) {
                            return l10n.invalidBookTitle;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: authorCtrl,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: l10n.author,
                          counterText: '',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().length < 2 || v.trim().length > 100) {
                            return l10n.invalidAuthorLength;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: yearCtrl,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                labelText: l10n.releaseYear,
                                hintText: '2024',
                                counterText: '',
                              ),
                              validator: (v) {
                                final year = int.tryParse(v ?? '');
                                if (year == null || year < 1500) {
                                  return l10n.invalidReleaseYear;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: totalCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                labelText: l10n.totalQuantity,
                              ),
                              validator: (v) {
                                final qty = int.tryParse(v ?? '');
                                if (qty == null || (!isEditing && qty <= 0) || (isEditing && qty < 0)) {
                                  return l10n.invalidQuantity;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: selectedPublisherId,
                        isExpanded: true,
                        dropdownColor: AppColors.background,
                        decoration: InputDecoration(
                          labelText: l10n.publisher,
                        ),
                        items: _publishers
                            .where((p) => p.id != null)
                            .map((pub) => DropdownMenuItem<int>(
                                  value: pub.id!,
                                  child: Text(
                                    pub.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setDialogState(() => selectedPublisherId = val);
                        },
                        validator: (v) {
                          if (v == null) return l10n.publisherRequired;
                          return null;
                        },
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

                          final payload = BookModel(
                            id: book?.id,
                            title: titleCtrl.text,
                            author: authorCtrl.text,
                            releaseYear: int.parse(yearCtrl.text),
                            totalQuantity: int.parse(totalCtrl.text),
                            publisherId: selectedPublisherId!,
                          );

                          try {
                            if (isEditing) {
                              await _bookService.updateBook(book.id!, payload);
                            } else {
                              await _bookService.createBook(payload);
                            }
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            _showSnackBar(
                              isEditing ? l10n.bookUpdated : l10n.bookCreated,
                            );
                            _loadInitialData();
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

  Future<void> _confirmDelete(BookModel book) async {
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
        content: Text('${l10n.deleteBookConfirm} "${book.title}"?'),
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

    if (confirmed == true && book.id != null) {
      try {
        await _bookService.deleteBook(book.id!);
        _showSnackBar(l10n.bookDeleted);
        _loadInitialData();
      } catch (e) {
        _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final totalItems = _filteredBooks.length;
    final totalPages = totalItems == 0 ? 1 : (totalItems / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, totalItems);
    final pageItems = totalItems == 0
        ? <BookModel>[]
        : _filteredBooks.sublist(startIndex, endIndex);

    return AdminScaffold(
      title: l10n.menuBooks,
      currentRoute: AppRoutes.adminBooks,
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
                    hintText: l10n.searchBooks,
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
                onPressed: () => _openBookFormDialog(),
                icon: const Icon(Icons.add, size: 20),
                label: Text(l10n.newBook),
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
                                  DataColumn(label: _headerText(l10n.bookTitle)),
                                  DataColumn(label: _headerText(l10n.author)),
                                  DataColumn(label: _headerText(l10n.releaseYear)),
                                  DataColumn(label: _headerText(l10n.total)),
                                  DataColumn(label: _headerText(l10n.inUse)),
                                  DataColumn(label: _headerText(l10n.publisher)),
                                  DataColumn(label: _headerText(l10n.actions)),
                                ],
                                rows: pageItems.map((book) {
                                  return DataRow(
                                    cells: [
                                      DataCell(_cellText(book.title, isBold: true)),
                                      DataCell(_cellText(book.author)),
                                      DataCell(_cellText(book.releaseYear.toString())),
                                      DataCell(_cellText(book.totalQuantity.toString())),
                                      DataCell(_cellText(book.inUseQuantity.toString())),
                                      DataCell(_cellText(book.publisherName)),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _actionIconButton(
                                              icon: Icons.edit_outlined,
                                              onTap: () => _openBookFormDialog(book: book),
                                            ),
                                            const SizedBox(width: 8),
                                            _actionIconButton(
                                              icon: Icons.delete_outline,
                                              onTap: () => _confirmDelete(book),
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