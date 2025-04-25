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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF30253e),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "LOGIN",
                style: mainTextTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(color: Color(0xFFEBE4C2)),
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(color: Color(0xFFEBE4C2)),
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;

                    final validEmail =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(email);

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: "Warning",
                          message: "Both fields must be filled.",
                          contentType: ContentType.help,
                        ),
                      ));
                      return;
                    }

                    if (!validEmail) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: "Warning",
                          message: "Invalid Email Address",
                          contentType: ContentType.help,
                        ),
                      ));
                      return;
                    }

                    try {
                      auth.login(email, password);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: "Error",
                          message: e.toString(),
                          contentType: ContentType.failure,
                        ),
                      ));
                    }
                  },
                  child: Text('Login')),
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
        ),
      ),
    );
  }
}
