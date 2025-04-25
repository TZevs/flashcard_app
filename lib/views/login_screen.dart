import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/views/register_screen.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("LOGIN",
              style: mainTextTheme.displayLarge, textAlign: TextAlign.center),
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                try {
                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: AwesomeSnackbarContent(
                        title: "Warning",
                        message: "Both fields must be filled.",
                        contentType: ContentType.warning,
                      ),
                    );
                    return;
                  } else {
                    auth.login(_emailController.text, _passwordController.text);
                  }
                } catch (e) {
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: AwesomeSnackbarContent(
                      title: "Error",
                      message: e.toString(),
                      contentType: ContentType.failure,
                    ),
                  );
                }
              },
              child: Text('Login', style: mainTextTheme.displayMedium)),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => RegisterScreen()));
              },
              child: Text(
                "Don't have an account? Register here",
                style: mainTextTheme.displaySmall,
              )),
          ElevatedButton.icon(
              onPressed: () {},
              label: Text("Login with Google"),
              icon: Icon(Icons.g_mobiledata)),
        ],
      ),
    );
  }
}
