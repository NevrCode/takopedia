import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/model/user_model.dart';

import 'user_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadPic(String uid, String filePath) async {
    try {
      Reference storageRef = _storage.ref().child('profile_pic/$uid');
      UploadTask uploadTask = storageRef.putFile(File(filePath));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<User?> registerWithEmailandDetail(String email, String password,
      String name, String address, String profilePicPath, String telp) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        log('masuk');
        String picUrl = await uploadPic(user.uid, profilePicPath);
        await _db.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'address': address,
          'profile_pic': picUrl,
          'telp': telp,
        });
      }
      return user;
    } catch (e) {
      log('user null ${e.toString()}');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      return user;
    } catch (e) {
      log('e');
      return null;
    }
  }

  Future<User?> signinWithGoogle() async {
    try {
      UserCredential result =
          await _auth.signInWithProvider(GoogleAuthProvider());

      User? user = result.user;
      return user;
    } catch (e) {
      log('e');
      return null;
    }
  }

  Future<void> sendEmailforResetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Map<String, dynamic>?> getData(String uid) async {
    final data =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (data.exists) {
      return data as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> fetchUserData(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (currentUser != null) {
      String uid = currentUser.uid;
      Map<String, dynamic>? userData = await getData(uid);

      if (userData != null) {
        UserModel userModel = UserModel.fromMap(userData);
        userProvider.setUser(userModel);
      }
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      log('e');
      return null;
    }
  }
}
