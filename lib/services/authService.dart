import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:takopedia/model/pengguna.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<User?> registerWithEmailandDetail(String email, String password,
      String name, String address, String profilePicPath) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        String picUrl = await uploadPic(user.uid, profilePicPath);

        await _db.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'address': address,
          'profile_pic': profilePicPath,
        });
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> uploadPic(String uid, String filePath) async {
    try {
      Reference storageRef = _storage.ref().child('profile_pic/$uid');
      UploadTask uploadTask = storageRef.putFile(File(filePath));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
