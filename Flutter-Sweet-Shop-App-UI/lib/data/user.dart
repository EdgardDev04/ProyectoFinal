class User {
  final int? id;
  final String name;
  final String email;
  final String passwordHash;
  final String salt;
  final String createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.salt,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> m) => User(
    id: m['id'] as int?,
    name: m['name'],
    email: m['email'],
    passwordHash: m['password_hash'],
    salt: m['salt'],
    createdAt: m['created_at'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'password_hash': passwordHash,
    'salt': salt,
    'created_at': createdAt,
  };

  
}

extension UserCopy on User {
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? passwordHash,
    String? salt,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
