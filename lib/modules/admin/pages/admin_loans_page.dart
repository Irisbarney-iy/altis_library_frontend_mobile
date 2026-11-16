import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../models/book_model.dart';
import '../models/loan_model.dart';
import '../../admin/services/book_service.dart';
import '../../admin/services/loan_service.dart';
import '../../admin/services/user_service.dart';
import '../widgets/admin_scaffold.dart';

enum _LoanSortOption { mostRecent, aToZ, zToA }

class AdminLoansPage extends StatefulWidget {
  const AdminLoansPage({super.key});

  @override
  State<AdminLoansPage> createState() => _AdminLoansPageState();
}

class _AdminLoansPageState extends State<AdminLoansPage> {
  final _loanService = LoanService();
  final _userService = UserService();
  final _bookService = BookService();
  final _searchController = TextEditingController();

  List<LoanModel> _allLoans = [];
  List<LoanModel> _filteredLoans = [];
  List<UserModel> _users = [];
  List<BookModel> _books = [];

  bool _isLoading = true;
  bool _isPreparingDialog = false;
  _LoanSortOption _sortOption = _LoanSortOption.mostRecent;

  int _currentPage = 1;
  static const int _itemsPerPage = 9;

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLoans() async {
    setState(() => _isLoading = true);
    try {
      final loans = await _loanService.getAllLoans();
      if (!mounted) return;
      setState(() {
        _allLoans = loans;
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
        ? List<LoanModel>.from(_allLoans)
        : _allLoans.where((loan) {
            return loan.userName.toLowerCase().contains(q) ||
                loan.bookTitle.toLowerCase().contains(q) ||
                LoanModel.formatDisplayDate(loan.loanDate).contains(q) ||
                LoanModel.formatDisplayDate(loan.limitTerm).contains(q);
          }).toList();

    switch (_sortOption) {
      case _LoanSortOption.aToZ:
        result.sort((a, b) => a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
        break;
      case _LoanSortOption.zToA:
        result.sort((a, b) => b.userName.toLowerCase().compareTo(a.userName.toLowerCase()));
        break;
      case _LoanSortOption.mostRecent:
        result.sort((a, b) {
          final dateCmp = b.loanDate.compareTo(a.loanDate);
          if (dateCmp != 0) return dateCmp;
          return (b.id ?? 0).compareTo(a.id ?? 0);
        });
        break;
    }

    setState(() {
      _currentPage = 1;
      _filteredLoans = result;
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

  Future<void> _openNewLoanDialog() async {
    if (_isPreparingDialog) return;

    setState(() => _isPreparingDialog = true);
    try {
      final results = await Future.wait([
        _userService.getAllUsers(),
        _bookService.getAllBooks(),
      ]);
      if (!mounted) return;
      _users = results[0] as List<UserModel>;
      _books = results[1] as List<BookModel>;
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
      return;
    } finally {
      if (mounted) setState(() => _isPreparingDialog = false);
    }

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();

    final activeUsers = _users.where((u) => u.active && u.id != null).toList();
    final availableBooks = _books
        .where((b) => b.id != null && (b.totalQuantity - b.inUseQuantity) > 0)
        .toList();

    int? selectedUserId;
    int? selectedBookId;
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
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
                l10n.newRental,
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
                      DropdownButtonFormField<int>(
                        value: selectedUserId,
                        isExpanded: true,
                        dropdownColor: AppColors.background,
                        decoration: InputDecoration(
                          labelText: l10n.renter,
                        ),
                        items: activeUsers.map((user) {
                          return DropdownMenuItem<int>(
                            value: user.id!,
                            child: Text(
                              user.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => setDialogState(() => selectedUserId = val),
                        validator: (v) => v == null ? l10n.renterRequired : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: selectedBookId,
                        isExpanded: true,
                        dropdownColor: AppColors.background,
                        decoration: InputDecoration(
                          labelText: l10n.book,
                        ),
                        items: availableBooks.map((book) {
                          final available = book.totalQuantity - book.inUseQuantity;
                          return DropdownMenuItem<int>(
                            value: book.id!,
                            child: Text(
                              '${book.title} ($available)',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => setDialogState(() => selectedBookId = val),
                        validator: (v) => v == null ? l10n.bookRequired : null,
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final now = DateTime.now();
                          final today = DateTime(now.year, now.month, now.day);
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: selectedDate,
                            firstDate: today,
                            lastDate: today.add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedDate = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: l10n.limitDate,
                            suffixIcon: const Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          child: Text(
                            LoanModel.formatDisplayDate(selectedDate),
                            style: const TextStyle(color: AppColors.textPrimary),
                          ),
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

                          try {
                            await _loanService.createLoan(
                              userId: selectedUserId!,
                              bookId: selectedBookId!,
                              termLimit: selectedDate,
                            );
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            _showSnackBar(l10n.loanCreated);
                            _loadLoans();
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

  Future<void> _openRenewDialog(LoanModel loan) async {
    if (loan.id == null || loan.isReturned) return;

    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final baseDate = loan.limitTerm.isAfter(today) ? loan.limitTerm : today;
    DateTime newTerm = baseDate.add(const Duration(days: 7));
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
                l10n.renewLoanTitle,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${loan.userName} — ${loan.bookTitle}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: newTerm,
                        firstDate: today,
                        lastDate: today.add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setDialogState(() => newTerm = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.newLimitDate,
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      child: Text(
                        LoanModel.formatDisplayDate(newTerm),
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                ],
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
                          setDialogState(() => isSaving = true);
                          try {
                            await _loanService.renewLoan(loan.id!, newTerm);
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            _showSnackBar(l10n.loanRenewed);
                            _loadLoans();
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
                      : Text(l10n.renew),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmReturn(LoanModel loan) async {
    if (loan.id == null || loan.isReturned) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          l10n.returnBookTitle,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '${l10n.returnBookConfirm} "${loan.bookTitle}" (${loan.userName})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _loanService.returnLoan(loan.id!);
        _showSnackBar(l10n.loanReturned);
        _loadLoans();
      } catch (e) {
        _showSnackBar(e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final totalItems = _filteredLoans.length;
    final totalPages = totalItems == 0 ? 1 : (totalItems / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, totalItems);
    final pageItems = totalItems == 0
        ? <LoanModel>[]
        : _filteredLoans.sublist(startIndex, endIndex);

    return AdminScaffold(
      title: l10n.menuLoans,
      currentRoute: AppRoutes.adminLoans,
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
                    hintText: l10n.searchLoans,
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
              PopupMenuButton<_LoanSortOption>(
                initialValue: _sortOption,
                color: AppColors.background,
                onSelected: (selected) {
                  _sortOption = selected;
                  _applyFilters();
                },
                itemBuilder: (context) => [
                  _buildSortMenuItem(_LoanSortOption.aToZ, l10n.sortAZ),
                  _buildSortMenuItem(_LoanSortOption.zToA, l10n.sortZA),
                  _buildSortMenuItem(_LoanSortOption.mostRecent, l10n.sortMostRecent),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
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
                onPressed: _isPreparingDialog ? null : _openNewLoanDialog,
                icon: _isPreparingDialog
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.add, size: 20),
                label: Text(l10n.newRental),
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
                                  DataColumn(label: _headerText(l10n.renter)),
                                  DataColumn(label: _headerText(l10n.book)),
                                  DataColumn(label: _headerText(l10n.rentalDate)),
                                  DataColumn(label: _headerText(l10n.limitDate)),
                                  DataColumn(label: _headerText(l10n.returnedDate)),
                                  DataColumn(label: _headerText(l10n.status)),
                                  DataColumn(label: _headerText(l10n.actions)),
                                ],
                                rows: pageItems.map((loan) {
                                  final disabled = loan.isReturned;
                                  final borderColor =
                                      disabled ? AppColors.border : AppColors.primary;

                                  return DataRow(
                                    cells: [
                                      DataCell(_cellText(loan.userName, isBold: true)),
                                      DataCell(_cellText(loan.bookTitle)),
                                      DataCell(_cellText(LoanModel.formatDisplayDate(loan.loanDate))),
                                      DataCell(_cellText(LoanModel.formatDisplayDate(loan.limitTerm))),
                                      DataCell(_cellText(LoanModel.formatDisplayDate(loan.returnDate))),
                                      DataCell(_buildStatusBadge(loan.status, l10n)),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: disabled
                                                  ? null
                                                  : () => _openRenewDialog(loan),
                                              borderRadius: BorderRadius.circular(6),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: borderColor),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  l10n.renew,
                                                  style: TextStyle(
                                                    color: borderColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            InkWell(
                                              onTap: disabled
                                                  ? null
                                                  : () => _confirmReturn(loan),
                                              borderRadius: BorderRadius.circular(6),
                                              child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: borderColor),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Icon(
                                                  Icons.download_rounded,
                                                  size: 18,
                                                  color: borderColor,
                                                ),
                                              ),
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

  PopupMenuItem<_LoanSortOption> _buildSortMenuItem(_LoanSortOption value, String label) {
    final isSelected = _sortOption == value;
    return PopupMenuItem<_LoanSortOption>(
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

  Widget _buildStatusBadge(String rawStatus, AppLocalizations l10n) {
    final s = rawStatus.toUpperCase().trim();

    late String label;
    late Color bgColor;
    late Color textColor;

    if (s.contains('ATRASO') || s.contains('DELAYED')) {
      label = l10n.loanStatusRtdDelayed;
      bgColor = const Color(0xFFFDF2B3);
      textColor = const Color(0xFF9A7D0A);
    } else if (s.contains('ENTREGUE') ||
        s.contains('DEVOLVIDO') ||
        s.contains('RETURNED') ||
        s.contains('RTD')) {
      label = l10n.loanStatusRtdOnTime;
      bgColor = const Color(0xFFD5F5E3);
      textColor = const Color(0xFF1E8449);
    } else if (s.contains('ATRASADO') || s.contains('OVERDUE')) {
      label = l10n.loanStatusOverdue;
      bgColor = const Color(0xFFFADBD8);
      textColor = AppColors.error;
    } else {
      label = l10n.loanStatusOnTime;
      bgColor = const Color(0xFFD5F5E3);
      textColor = const Color(0xFF1E8449);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
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
}