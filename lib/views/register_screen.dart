import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text("REGISTER",
                style: mainTextTheme.displayLarge, textAlign: TextAlign.center),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Username"),
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  try {
                    if (_passwordController.text ==
                        _confirmPasswordController.text) {
                      auth.register(_emailController.text,
                          _passwordController.text, _usernameController.text);
                      Navigator.pop(context);
                    } else if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: AwesomeSnackbarContent(
                          title: "Warning",
                          message: "Passwords do not match.",
                          contentType: ContentType.warning,
                        ),
                      );
                    }
                  } catch (ex) {
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: AwesomeSnackbarContent(
                        title: "Error",
                        message: ex.toString(),
                        contentType: ContentType.failure,
                      ),
                    );
                  }
                },
                child: Text('Register')),
            TextButton(
                onPressed: () {},
                child: Text("Already have an account? Login here")),
            ElevatedButton.icon(
                onPressed: () {},
                label: Text("Sign in with Google"),
                icon: Icon(Icons.g_mobiledata)),
          ],
        ),
      ),
    );
  }
}
