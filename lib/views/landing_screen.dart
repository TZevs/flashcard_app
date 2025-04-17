import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/views/deck_screen.dart';
import 'package:flashcard_app/views/login_screen.dart';
import 'package:flashcard_app/views/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    if (auth.isLoggedIn) {
      return DeckScreen();
    }

    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => LoginScreen()));
              },
              child: Text("Login")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => RegisterScreen()));
              },
              child: Text("Register")),
        ],
      ),
    );
  }
}
