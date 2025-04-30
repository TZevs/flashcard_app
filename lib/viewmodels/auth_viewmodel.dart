import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/services/firebase_db.dart';
import 'package:flashcard_app/services/notifications.dart';
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

  Future<bool> register(String email, String password, String username) async {
    _errorMsg = null;
    notifyListeners();
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = newUser.user!.uid;

      await _firestore.collection('users').doc(user).set({
        'username': username,
        'email': email,
        'profileBio': "",
        'profilePic': "",
        'createdAt': FieldValue.serverTimestamp(),
      });

      await sendVerifyEmail();

      await Notifications.displayUserRegisteredNotification(
          notificationTitle: "Congrats $username you are a registered user!",
          notificationBody: "Click here to got to the login page");

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _errorMsg = "Account already exists. Please Login";
      } else {
        _errorMsg = "Registration failed. Please try again";
      }
      notifyListeners();
      return false;
    } catch (e) {
      _errorMsg = "Unable to Login";
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _errorMsg = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await getUsername();
      notifyListeners();
      await sendVerifyEmail();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMsg = "User Not Found";
      } else if (e.code == 'wrong-password') {
        _errorMsg = "Incorrect password. Please try again.";
      } else {
        _errorMsg = "Login Failed. Please Try Again.";
      }
      notifyListeners();
      return false;
    } catch (e) {
      _errorMsg = "Unable to Login";
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      _user = null;
      _username = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMsg = "Failed to Logout";
      notifyListeners();
      return false;
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
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      notifyListeners();

      return userCredential.additionalUserInfo?.isNewUser ?? false;
    } catch (e) {
      _errorMsg = "Failed to Sign-In with Google";
      notifyListeners();
      return false;
    }
  }

  Future<void> completeGoogleRegister(String username) async {
    if (_user == null) return;

    await _firestore.collection('users').doc(_user?.uid).set({
      'username': username,
      'email': _user!.email ?? '',
      'profileBio': "",
      'profilePic': "",
      'createdAt': FieldValue.serverTimestamp(),
    });

    await sendVerifyEmail();
    await Notifications.displayUserRegisteredNotification(
        notificationTitle: "Congrats $username you are a registered user!",
        notificationBody: "Click here to got to the login page");
  }

  Future<void> getUsername() async {
    _username = await FirebaseDb.fetchUsername(userId!);
    notifyListeners();
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendVerifyEmail() async {
    final user = _auth.currentUser;
    if (user != null && user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}
