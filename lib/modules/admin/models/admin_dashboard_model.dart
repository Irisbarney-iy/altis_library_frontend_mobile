class CriticalDelayModel {
  final String userName;
  final String bookTitle;
  final int daysOverdue;

  CriticalDelayModel({
    required this.userName,
    required this.bookTitle,
    required this.daysOverdue,
  });

  factory CriticalDelayModel.fromJson(Map<String, dynamic> json) {
    return CriticalDelayModel(
      userName: json['userName'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      daysOverdue: (json['daysOverdue'] as num?)?.toInt() ?? 0,
    );
  }
}

class AdminDashboardModel {
  final int totalBooks;
  final int activeLoans;
  final int monthlyLoans;
  final List<CriticalDelayModel> criticalDelays;

  AdminDashboardModel({
    required this.totalBooks,
    required this.activeLoans,
    required this.monthlyLoans,
    required this.criticalDelays,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    final rawDelays = json['criticalDelays'] as List<dynamic>? ?? [];
    return AdminDashboardModel(
      totalBooks: (json['totalBooks'] as num?)?.toInt() ?? 0,
      activeLoans: (json['activeLoans'] as num?)?.toInt() ?? 0,
      monthlyLoans: (json['monthlyLoans'] as num?)?.toInt() ?? 0,
      criticalDelays: rawDelays
          .map((item) => CriticalDelayModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  static String formatCount(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final reverseIndex = str.length - i;
      if (i > 0 && reverseIndex % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}