class Merchant {
  final String id;
  final String name;
  final String createdAtHuman;
  final User user;

  Merchant({
    required this.id,
    required this.name,
    required this.createdAtHuman,
    required this.user,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      createdAtHuman: json['created_at_human'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at_human': createdAtHuman,
      'user': user.toJson(),
    };
  }
}

class User {
  final String id;
  final String name;

  User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
