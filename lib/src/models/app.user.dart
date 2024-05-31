import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_molino_diamante/src/routes/routes.dart';

class AppUser {
  String id;
  String accessToken;
  String email;
  String name;
  String lastName;
  String phone;
  int role;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  AppUser({
    required this.id,
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

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'],
        accessToken: json['accessToken'],
        email: json['email'],
        name: json['name'],
        lastName: json['lastName'],
        phone: json['phone'],
        role: json['role'],
        status: json['status'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'accessToken': accessToken,
        'email': email,
        'name': name,
        'lastName': lastName,
        'phone': phone,
        'role': role,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  // Local storage
  static final _user = GetStorage();

  static void saveUser(AppUser user) {
    _user.write('user', json.encode(user.toJson()));
  }

  static AppUser? getUser() {
    String? userJson = _user.read('user');
    if (userJson != null) {
      return AppUser.fromJson(json.decode(userJson));
    }
    return null;
  }

  static void removeUser() => _user.remove('user');

  static void logout() {
    removeUser();
    Get.offAllNamed(RoutesClass.getLogin());
  }

  // Firestore functionality
  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  Future<void> saveToFirestore() async {
    final docRef = userCollection.doc(id.isEmpty ? null : id);
    id = docRef.id;
    await docRef.set(toJson());
  }

  static Future<AppUser?> getFromFirestore(String id) async {
    final docRef = userCollection.doc(id);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return AppUser.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateInFirestore() async {
    final docRef = userCollection.doc(id);
    await docRef.update(toJson());
  }

  Future<void> deleteFromFirestore() async {
    final docRef = userCollection.doc(id);
    await docRef.delete();
  }
}
