import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_molino_diamante/src/routes/routes.dart';

class User extends GetxController {
  String accessToken;
  String email;
  String name;
  String lastName;
  String phone;
  int role;
  int status;
  Timestamp createdAt;
  Timestamp updatedAt;

  User({
    required this.accessToken,
    required this.email,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        accessToken: json['accessToken'],
        email: json['email'],
        name: json['name'],
        lastName: json['lastName'],
        phone: json['phone'],
        role: json['role'],
        status: json['status'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'email': email,
        'name': name,
        'lastName': lastName,
        'phone': phone,
        'role': role,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static final _user = GetStorage();

  static void saveUser(User user) {
    _user.write('user', json.encode(user.toJson()));
  }

  static User? getUser() {
    String? userJson = _user.read('user');
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  static void removeUser() => _user.remove('user');
  static void logout() {
    removeUser();
    Get.offAllNamed(RoutesClass.getLogin());
  }
}
