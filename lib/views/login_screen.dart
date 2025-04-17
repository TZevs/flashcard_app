import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/views/register_screen.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  // const LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Column(
        children: [
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
                    print("Please fill in all fields");
                    return;
                  } else {
                    auth.login(_emailController.text, _passwordController.text);
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Login', style: mainTextTheme.displayMedium)),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => RegisterScreen()));
              },
              child: Text("Don't have an account? Register here")),
          ElevatedButton.icon(
              onPressed: () {},
              label: Text("Login with Google"),
              icon: Icon(Icons.g_mobiledata)),
        ],
      ),
    );
  }
}
