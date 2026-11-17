import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../models/book_model.dart';
import '../models/publisher_model.dart';
import '../services/book_service.dart';
import '../services/publisher_service.dart';
import '../widgets/admin_scaffold.dart';

enum _BookSortOption { aToZ, zToA, mostRecent }

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
  _BookSortOption _sortOption = _BookSortOption.aToZ;

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
        ? List<BookModel>.from(_allBooks)
        : _allBooks.where((b) {
            return b.title.toLowerCase().contains(q) ||
                b.author.toLowerCase().contains(q) ||
                b.publisherName.toLowerCase().contains(q) ||
                b.releaseYear.toString().contains(q);
          }).toList();

    switch (_sortOption) {
      case _BookSortOption.aToZ:
        result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case _BookSortOption.zToA:
        result.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case _BookSortOption.mostRecent:
        result.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        break;
    }

    setState(() {
      _currentPage = 1;
      _filteredBooks = result;
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
                                if (qty == null ||
                                    (!isEditing && qty <= 0) ||
                                    (isEditing && qty < 0)) {
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
                width: 240,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _applyFilters(),
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
              PopupMenuButton<_BookSortOption>(
                initialValue: _sortOption,
                color: AppColors.background,
                onSelected: (selected) {
                  _sortOption = selected;
                  _applyFilters();
                },
                itemBuilder: (context) => [
                  _buildSortMenuItem(_BookSortOption.aToZ, l10n.sortAZ),
                  _buildSortMenuItem(_BookSortOption.zToA, l10n.sortZA),
                  _buildSortMenuItem(_BookSortOption.mostRecent, l10n.sortMostRecent),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _sortOption != _BookSortOption.aToZ
                          ? AppColors.primary
                          : AppColors.border,
                      width: _sortOption != _BookSortOption.aToZ ? 1.5 : 1,
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
                : Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 12),
                          itemCount: pageItems.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final book = pageItems[index];

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
                                          book.title,
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
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          book.releaseYear.toString(),
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
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
                                            fontWeight: FontWeight.w500,
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
                                        Icons.business_outlined,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          book.publisherName,
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
                                          child: _buildStatItem(
                                            l10n.total,
                                            book.totalQuantity.toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: _buildStatItem(
                                            l10n.inUse,
                                            book.inUseQuantity.toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => _openBookFormDialog(book: book),
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
                                                  l10n.editBook,
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
                                          onTap: () => _confirmDelete(book),
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

  Widget _buildStatItem(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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

  PopupMenuItem<_BookSortOption> _buildSortMenuItem(_BookSortOption value, String label) {
    final isSelected = _sortOption == value;
    return PopupMenuItem<_BookSortOption>(
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