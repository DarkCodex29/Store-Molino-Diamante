import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/routes/routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controladores para iniciar sesión
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  // Controladores para registrarse
  TextEditingController registerEmail = TextEditingController();
  TextEditingController registerPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();
  String? role;

  var isLoggedIn = false.obs;
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      User? user = userCredential.user;
      if (user != null) {
        isLoggedIn(true);
        Get.offNamed(RoutesClass.getHome());
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Future<void> register() async {
    try {
      isLoading(true);
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: registerEmail.text.trim(),
        password: registerPassword.text.trim(),
      );
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': registerEmail.text.trim(),
          'name': name.text.trim(),
          'lastName': lastName.text.trim(),
          'phone': phone.text.trim(),
          'role': role,
        });
        Get.offNamed(RoutesClass.getHome());
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  void logout() async {
    await _auth.signOut();
    isLoggedIn(false);
    Get.offAllNamed(RoutesClass.getLogin());
  }
}
