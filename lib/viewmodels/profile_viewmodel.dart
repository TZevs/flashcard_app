import 'dart:io';

import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewmodel extends ChangeNotifier {
  late String userID;

  String? _profileImg;
  String? get profileImg => _profileImg;

  Future<void> updateProfileImg(File img) async {
    _profileImg = await FirebaseDb.setProfileImg(userID, img);
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
}
