import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/app.user.dart';
import 'package:store_molino_diamante/src/routes/routes.dart';

class AuthController extends GetxController {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
      firebase_auth.UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      firebase_auth.User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        String? accessToken = await firebaseUser.getIdToken();
        AppUser? user = await AppUser.getFromFirestore(firebaseUser.uid);
        if (user != null && accessToken != null) {
          user.accessToken = accessToken;
          AppUser.saveUser(user);
          isLoggedIn(true);
          Get.offNamed(RoutesClass.getHome());
        } else {
          // Handle the case where user is not found in Firestore
          Get.snackbar('Error', 'User not found in Firestore',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
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
      List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(registerEmail.text.trim());
      if (signInMethods.isNotEmpty) {
        Get.snackbar(
            'Error', 'The email address is already in use by another account.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      firebase_auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: registerEmail.text.trim(),
        password: registerPassword.text.trim(),
      );
      firebase_auth.User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        String? accessToken = await firebaseUser.getIdToken();
        AppUser newUser = AppUser(
          id: firebaseUser.uid,
          accessToken: accessToken ?? '',
          email: registerEmail.text.trim(),
          name: name.text.trim(),
          lastName: lastName.text.trim(),
          phone: phone.text.trim(),
          role: role == 'admin' ? 1 : 0,
          status: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await newUser.saveToFirestore();
        AppUser.saveUser(newUser);
        isLoggedIn(true);
        Get.offNamed(RoutesClass.getHome());
      }
    } catch (e) {
      log(e.toString());
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
    AppUser.removeUser();
    isLoggedIn(false);
    Get.offAllNamed(RoutesClass.getLogin());
  }
}
