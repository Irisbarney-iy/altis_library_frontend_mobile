class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? cpf;
  final String? phone;
  final String? address;
  final DateTime? birthDate;
  final String role;
  final bool active;
  final String? token;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.cpf,
    this.phone,
    this.address,
    this.birthDate,
    required this.role,
    this.active = true,
    this.token,
  });

  bool get isAdmin {
    final formattedRole = role.toUpperCase().trim();
    return formattedRole == 'ADMIN' || formattedRole == 'ROLE_ADMIN';
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? cpf,
    String? phone,
    String? address,
    DateTime? birthDate,
    String? role,
    bool? active,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      role: role ?? this.role,
      active: active ?? this.active,
      token: token ?? this.token,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    String resolvedRole = 'USER';
    if (json['role'] != null) {
      resolvedRole = json['role'].toString();
    } else if (json['isAdmin'] == true) {
      resolvedRole = 'ROLE_ADMIN';
    }

    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'],
      phone: json['phone'],
      address: json['address'],
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'].toString())
          : null,
      role: resolvedRole,
      active: json['active'] ?? true,
      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cpf': cpf,
      'phone': phone,
      'address': address,
      'birthDate': birthDate?.toIso8601String().split('T').first,
      'role': role,
      'active': active,
      'token': token,
    };
  }

  Map<String, dynamic> toCreateJson({required String password}) {
    return {
      'name': name,
      'email': email,
      'cpf': cpf,
      'password': password,
      'phone': phone,
      'address': address,
      'birthDate': birthDate?.toIso8601String().split('T').first,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}