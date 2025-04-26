import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  User? get user => _user;

  String? get userId => _user?.uid;
  String? get userEmail => _user?.email;
  bool get isLoggedIn => _user != null;

  late String? _username;
  String? get username => _username;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  AuthViewModel() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (_user != null) {
        await getUsername();
      } else {
        _username = null;
      }
      notifyListeners();
    });
  }

  Future<void> register(
      String email, String password, String username, int dailyGoal) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = newUser.user!.uid;

      await _firestore.collection('users').doc(user).set({
        'username': username,
        'email': email,
        'dailyGoal': dailyGoal,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await getUsername();
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _errorMsg = null;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _errorMsg = "Google Sign-In Cancelled";
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _user = userCredential.user;
      notifyListeners();

      _errorMsg = "Account Already Exists";
      notifyListeners();
      return userCredential.additionalUserInfo?.isNewUser ?? false;
    } catch (e) {
      _errorMsg = "Failed to Sign-In with Google";
      notifyListeners();
      return false;
    }
  }

  Future<void> completeGoogleRegister(String username, int dailyGoal) async {
    if (_user == null) return;

    await _firestore.collection('users').doc(_user?.uid).set({
      'username': username,
      'email': _user!.email ?? '',
      'dailyGoal': dailyGoal,
      'createdAt': FieldValue.serverTimestamp(),
    });
    notifyListeners();
  }

  Future<void> getUsername() async {
    _username = await FirebaseDb.fetchUsername(userId!);
    notifyListeners();
  }
}
