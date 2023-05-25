class AppUser {
  String? id;
  String name;
  String last_name;
  String? birth_date;
  String? phone_number;
  String email;
  String? password;
  String role;
  String profile;

  AppUser({
    this.id,
    required this.name,
    required this.profile,
    required this.last_name,
    this.birth_date,
    this.phone_number,
    required this.email,
    this.password,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      last_name: json['last_name'],
      birth_date: json['birth_date'],
      phone_number: json['phone_number'],
      email: json['email'],
      password: json['password'],
      profile: json['profile'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_name': last_name,
      'birth_date': birth_date,
      'phone_number': phone_number,
      'email': email,
      'role': role,
      'profile': profile,
    };
  }
}
