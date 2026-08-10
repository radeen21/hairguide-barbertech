class RegisterEntity {
  final String id;
  final String email;
  final String phone;
  final String fullName;
  final String dob;
  final String role;
  final String sessionToken;

  RegisterEntity({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.dob,
    required this.role,
    required this.sessionToken,
  });

  factory RegisterEntity.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return RegisterEntity(
      id: user['id'],
      email: user['email'],
      phone: user['phone'],
      fullName: user['full_name'],
      dob: user['dob'],
      role: user['role'],
      sessionToken: json['session_token'],
    );
  }
}
