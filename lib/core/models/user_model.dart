class UserModel{
  final int? id;
  final String name;
  final String email;
  final String? cpf;
  final String? phone;
  final String? address;
  final DateTime? birthDate;
  final String role;
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
    this.token,
  });

  bool get isAdmin {
    if(role == null) return false;
    final formattedRole = role!.toUpperCase().trim();
    return formattedRole == 'ADMIN' || formattedRole == 'ROLE_ADMIN';
  }

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}){
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'],
      phone: json['phone'],
      address: json['address'],
      birthDate: json['birthDate'] != null ? DateTime.tryParse(json['birthDate'].toString()) : null,
      role: json['role'] ?? 'USER',
      token: token,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'email': email,
      'cpf': cpf,
      'phone': phone,
      'address': address,
      'birthDate': birthDate?.toIso8601String().split('T').first,
      'role': role,
      'token': token,
    };
  }

  Map<String, dynamic> toCreateJson({required String password}){
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

  Map<String, dynamic> toUpdateJson(){
    return{
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

}