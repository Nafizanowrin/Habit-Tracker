import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.dateOfBirth,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth']) : null,
      bio: map['bio'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null) {
    _loadProfile();
  }

  static const String _profileKey = 'user_profile';

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      
      if (profileJson != null) {
        // create a default profile
        state = UserProfile(
          id: 'user_1',
          name: prefs.getString('user_name') ?? 'User',
          email: prefs.getString('user_email') ?? 'user@example.com',
          bio: prefs.getString('user_bio'),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        // Create default profile
        state = UserProfile(
          id: 'user_1',
          name: 'User',
          email: 'user@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      //create default profile
      state = UserProfile(
        id: 'user_1',
        name: 'User',
        email: 'user@example.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? bio,
  }) async {
    if (state == null) return;

    final updatedProfile = state!.copyWith(
      name: name,
      email: email,
      bio: bio,
      updatedAt: DateTime.now(),
    );

    state = updatedProfile;
    await _saveProfile();
  }

  Future<void> _saveProfile() async {
    if (state == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', state!.name);
      await prefs.setString('user_email', state!.email);
      if (state!.bio != null) {
        await prefs.setString('user_bio', state!.bio!);
      }
    } catch (e) {
      // Handle save error 
    }
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier();
});
