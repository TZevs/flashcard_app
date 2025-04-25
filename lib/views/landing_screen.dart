import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/views/deck_screen.dart';
import 'package:flashcard_app/views/login_screen.dart';
import 'package:flashcard_app/views/register_screen.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    // if (auth.isLoggedIn) {
    //   return DeckScreen();
    // }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF30253e),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "WELCOME TO THE",
                      style: mainTextTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "FLASHCARD",
                      style: mainTextTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Revision App",
                      style: mainTextTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => LoginScreen()));
                    },
                    child: Text("Login")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => RegisterScreen()));
                    },
                    child: Text("Register")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
