class BookModel {
  final int? id;
  final String title;
  final String author;
  final int releaseYear;
  final int totalQuantity;
  final int inUseQuantity;
  final int publisherId;
  final String publisherName;

  BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.releaseYear,
    required this.totalQuantity,
    this.inUseQuantity = 0,
    required this.publisherId,
    this.publisherName = '',
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      releaseYear: json['releaseYear'] ?? 0,
      totalQuantity: json['totalQuantity'] ?? 0,
      inUseQuantity: json['inUseQuantity'] ?? 0,
      publisherId: json['publisherId'] ?? 0,
      publisherName: json['publisherName'] ?? '',
    );
  }

  Map<String, dynamic> toRequestJson() {
    return {
      'title': title.trim(),
      'author': author.trim(),
      'releaseYear': releaseYear,
      'totalQuantity': totalQuantity,
      'publisherId': publisherId,
    };
  }
}