import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/viewmodels/profile_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final viewModel = Provider.of<ProfileViewmodel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppbarWidget(
          title: "Profile",
          actions: [
            IconButton(
                onPressed: () {
                  authViewModel.logout();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEEA83B),
                      ),
                      width: 105,
                      height: 105,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.upload))
                  ],
                ),
                Text(
                  "@${authViewModel.username}",
                  style: mainTextTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Add Bio", style: mainTextTheme.displaySmall),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit, color: Color(0xFFEEA83B)))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
