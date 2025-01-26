// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ticket_wise_admin/Model/user_model.dart';
import 'package:ticket_wise_admin/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final userCollection = FirebaseFirestore.instance.collection('users');
  final _authService = AuthService();

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _authService.signInWithEmailAndPassword(email, password);

      // Fetch user details from Firestore
      final userDoc = await userCollection.doc(userCredential.user!.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final userRole = userData['role'];

        // Check if the user role is admin
        if (userRole == 'admin') {
          return userCredential;
        } else {
          throw Exception('User is not an admin');
        }
      } else {
        throw Exception('User not found in Firestore');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserDatatoFirestore(String uid) async {
    await userCollection.doc(uid).delete();
    notifyListeners();
  }

  Future<UserModel> getUserFromFirestore(String uid) async {
    final user = await userCollection.doc(uid).get();
    return UserModel.fromJson(user.data()!);
  }

  Future<List<UserModel>> fetchAllUsers() async {
    final querySnapshot = await userCollection.get();
    return querySnapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateUserImage(String uid, String imageUrl) async {
    await userCollection.doc(uid).update({'profileImage': imageUrl});
    notifyListeners();
  }

  Future<UserCredential> signInWithGoogle() async {
    final res = await _authService.signInWithGoogle();

    return res;

    // debugPrint('Profile Info: ${res.additionalUserInfo?.profile}');
  }
}
