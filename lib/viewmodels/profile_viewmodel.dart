import 'dart:io';

import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewmodel extends ChangeNotifier {
  String? _profileImg;
  String? get profileImg => _profileImg;

  String _bio = "";
  String get bio => _bio;

  Future<void> updateProfileImg(File img, String userID) async {
    _profileImg = await FirebaseDb.setProfileImg(userID, img);
    notifyListeners();
  }

  Future<void> galleryImg(String userID) async {
    final XFile? pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImg == null) return;

    final img = File(pickedImg.path);

    await updateProfileImg(img, userID);
    notifyListeners();
  }

  Future<void> saveNewBio(String bio, String userID) async {
    await FirebaseDb.setProfileBio(userID, bio);
    await getBio(userID);
  }

  Future<void> getBio(String userID) async {
    _bio = await FirebaseDb.fetchBio(userID);
    notifyListeners();
  }
}
