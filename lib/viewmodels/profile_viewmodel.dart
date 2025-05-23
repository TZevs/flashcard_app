import 'dart:io';

import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewmodel extends ChangeNotifier {
  late AuthViewModel _auth;

  void updateAuth(AuthViewModel auth) {
    _auth = auth;
    notifyListeners(); // Could add a question about the login status in views.
  }

  String? get userId => _auth.userId;
  String? get username => _auth.username;

  String? _profileImg;
  String? get profileImg => _profileImg;

  String _bio = "";
  String get bio => _bio;

  Future<void> updateProfileImg(File img) async {
    _profileImg = await FirebaseDb.setProfileImg(userId!, img);
    notifyListeners();
  }

  Future<void> galleryImg() async {
    final XFile? pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImg == null) return;

    final img = File(pickedImg.path);

    await updateProfileImg(img);
    notifyListeners();
  }

  Future<void> saveNewBio(String bio) async {
    await FirebaseDb.setProfileBio(userId!, bio);
    await getBio();
  }

  Future<void> getBio() async {
    _bio = await FirebaseDb.fetchBio(userId!);
    notifyListeners();
  }
}
