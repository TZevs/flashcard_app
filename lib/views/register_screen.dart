import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
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

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Username"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_passwordController.text ==
                      _confirmPasswordController.text) {
                    auth.register(_emailController.text,
                        _passwordController.text, _usernameController.text);
                    Navigator.pop(context);
                  } else {
                    print("Passwords do not match");
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
