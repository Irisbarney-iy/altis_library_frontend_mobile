class MyBookModel{
  final String bookTitle;
  final String author;
  final DateTime loanDate;
  final DateTime limitTerm;
  final int daysOverdue;

  MyBookModel({
    required this.bookTitle,
    required this.author,
    required this.loanDate,
    required this.limitTerm,
    required this.daysOverdue,
  });

  factory MyBookModel.fromJson(Map<String, dynamic> json){
    return MyBookModel(
      bookTitle: json['bookTitle'] ?? '',
      author: json['author'] ?? '',
      loanDate: _parseLocalDate(json['loanDate']),
      limitTerm: _parseLocalDate(json['limitTerm']),
      daysOverdue: (json['daysOverdue'] as num?)?.toInt() ?? 0,
    );
  }

  static DateTime _parseLocalDate(dynamic raw){
    if(raw is String && raw.isNotEmpty){
      return DateTime.tryParse(raw) ?? DateTime.now();
    }
    if(raw is List && raw.length >= 3){
      return DateTime(
        (raw[0] as num).toInt(),
        (raw[1] as num).toInt(),
        (raw[2] as num).toInt(),
      );
    }
    return DateTime.now();
  }

  static String formatDate(DateTime date){
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}

class UserDashboardModel {
  final int activeLoans;
  final int totalDelays;
  final int totalReturned;
  final List<MyBookModel> myBooks;

  UserDashboardModel({
    required this.activeLoans,
    required this.totalDelays,
    required this.totalReturned,
    required this.myBooks,
  });

  factory UserDashboardModel.fromJson(Map<String, dynamic> json){
    final rawBooks = json['myBooks'] as List<dynamic>? ?? [];
    return UserDashboardModel(
      activeLoans: (json['activeLoans'] as num?)?.toInt() ?? 0,
      totalDelays: (json['totalDelays'] as num?)?.toInt() ?? 0,
      totalReturned: (json['totalReturned'] as num?)?.toInt() ?? 0,
      myBooks: rawBooks
      .map((item) => MyBookModel.fromJson(item as Map<String, dynamic>))
      .toList(),
    );
  }
}