class User {
  final String id;
  final String email;
  final String? displayName;
  final String? gender;
  final DateTime? dateOfBirth;
  final double? height;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool termsAccepted;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.gender,
    this.dateOfBirth,
    this.height,
    required this.createdAt,
    this.lastLoginAt,
    this.termsAccepted = false,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'] != null 
          ? DateTime.parse(map['dateOfBirth']) 
          : null,
      height: map['height']?.toDouble(),
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] is String 
              ? DateTime.parse(map['createdAt'])
              : DateTime.now())
          : DateTime.now(),
      lastLoginAt: map['lastLoginAt'] != null 
          ? (map['lastLoginAt'] is String 
              ? DateTime.parse(map['lastLoginAt'])
              : null)
          : null,
      termsAccepted: map['termsAccepted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'height': height,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'termsAccepted': termsAccepted,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? gender,
    DateTime? dateOfBirth,
    double? height,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? termsAccepted,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }
}
