import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String username;
  final String email;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
  });

  factory UserModel.fromAuthFirebase(User user) {
    return UserModel(
      id: user.uid,
      username: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  toJson() => {'id': id, 'username': username, 'email': email};
}
