class LoanModel {
  final int? id;
  final int userId;
  final String userName;
  final int bookId;
  final String bookTitle;
  final DateTime loanDate;
  final DateTime limitTerm;
  final DateTime? returnDate;
  final String status;

  LoanModel({
    this.id,
    required this.userId,
    required this.userName,
    required this.bookId,
    required this.bookTitle,
    required this.loanDate,
    required this.limitTerm,
    this.returnDate,
    required this.status,
  });

  bool get isReturned {
    if (returnDate != null) return true;
    final s = status.toUpperCase().trim();
    return s.contains('ENTREGUE') ||
        s.contains('DEVOLVIDO') ||
        s.contains('RETURNED') ||
        s.contains('RTD');
  }

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'],
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      bookId: json['bookId'] ?? 0,
      bookTitle: json['bookTitle'] ?? '',
      loanDate: _parseDate(json['loanDate']) ?? DateTime.now(),
      limitTerm: _parseDate(json['limitTerm']) ?? DateTime.now(),
      returnDate: _parseDate(json['returnDate']),
      status: (json['status'] ?? 'ALUGADO').toString(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static String formatDisplayDate(DateTime? date) {
    if (date == null) return '---';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  static String formatApiDate(DateTime date) {
    final y = date.year.toString();
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}