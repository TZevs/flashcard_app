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
  final TextEditingController _goalController = TextEditingController();

  RegisterScreen({super.key});

  void _forGoogleRegister(BuildContext context, AuthViewModel viewModel) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Fill Fields in:",
          style: mainTextTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        content: Column(
          children: [
            Text("Email: ${viewModel.userEmail}"),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(color: Color(0xFFEBE4C2)),
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(color: Color(0xFFEBE4C2)),
              controller: _goalController,
              decoration: InputDecoration(
                labelText: "Daily Goal (Minutes)",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  int? dailyGoal;
                  final username = _usernameController.text.trim();

                  try {
                    dailyGoal = int.tryParse(_goalController.text);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: "Warning",
                        message: "Invalid Goal. Must be a number.",
                        contentType: ContentType.help,
                      ),
                    ));
                    return;
                  }

                  if (username.isEmpty || _goalController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: "Warning",
                        message: "All Fields Must be Filled.",
                        contentType: ContentType.help,
                      ),
                    ));
                    return;
                  }

                  viewModel.completeGoogleRegister(
                      _usernameController.text.trim(), dailyGoal!);

                  Navigator.pop(context);
                },
                child: Text("SignIn")),
          ],
        ),
      ),
    );
  }

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
                "REGISTER",
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
              TextField(
                style: TextStyle(color: Color(0xFFEBE4C2)),
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(color: Color(0xFFEBE4C2)),
                controller: _goalController,
                decoration: InputDecoration(labelText: "Daily Goals (Minutes)"),
              ),
              ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;
                    final confirmPassword = _confirmPasswordController.text;
                    final username = _usernameController.text.trim();
                    final goal = _goalController.text.trim();
                    int? dailyGoal;

                    final validEmail =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(email);

                    try {
                      dailyGoal = int.tryParse(goal);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: "Warning",
                          message: "Invalid Goal. Must be a number.",
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

                    if (email.isEmpty ||
                        password.isEmpty ||
                        username.isEmpty ||
                        goal.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: "Warning",
                          message: "All fields must be filled.",
                          contentType: ContentType.help,
                        ),
                      ));
                      return;
                    }

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: "Warning",
                          message: "Passwords do not match.",
                          contentType: ContentType.help,
                        ),
                      ));
                      return;
                    }

                    try {
                      auth.register(email, password, username, dailyGoal!);
                    } catch (ex) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 0,
                        content: AwesomeSnackbarContent(
                          title: "Error",
                          message: ex.toString(),
                          contentType: ContentType.failure,
                        ),
                      ));
                    }
                  },
                  child: Text('Register')),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "Already have an account? Login here",
                    style: mainTextTheme.displaySmall,
                  )),
              ElevatedButton.icon(
                  onPressed: () async {
                    bool isNewUser = await auth.signInWithGoogle();

                    if (auth.errorMsg != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 0,
                        content: AwesomeSnackbarContent(
                          title: "Error",
                          message: auth.errorMsg!,
                          contentType: ContentType.failure,
                        ),
                      ));
                    }

                    if (isNewUser) {
                      _forGoogleRegister(context, auth);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 0,
                        content: AwesomeSnackbarContent(
                          title: "Account Exists",
                          message: "Account Alreay Exists Please Login",
                          contentType: ContentType.help,
                        ),
                      ));

                      await Future.delayed(Duration(seconds: 3));
                      Navigator.pop(context);
                    }
                  },
                  label: Text("Register with Google"),
                  icon: Icon(Icons.g_mobiledata)),
            ],
          ),
        ),
      ),
    );
  }
}
