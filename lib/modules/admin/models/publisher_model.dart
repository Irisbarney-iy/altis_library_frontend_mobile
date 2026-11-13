class PublisherModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? site;

  PublisherModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.site,
  });

  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    return PublisherModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      site: json['site'],
    );
  }

  Map<String, dynamic> toRequestJson() {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    return {
      'name': name.trim(),
      'email': email.trim(),
      'phone': cleanPhone,
      'site': (site == null || site!.trim().isEmpty) ? null : site!.trim(),
    };
  }
}