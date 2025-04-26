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
                        color: Color(0xFF30253e),
                      ),
                      width: 105,
                      height: 105,
                      alignment: Alignment.center,
                      child: ClipOval(
                        child: viewModel.profileImg != null
                            ? Image.network(viewModel.profileImg!,
                                width: 95, height: 95, fit: BoxFit.cover)
                            : Image.asset("imgs/profileDefaultImg.jpg",
                                width: 95, height: 95, fit: BoxFit.cover),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          viewModel.galleryImg();
                        },
                        icon: Icon(Icons.add_a_photo, color: Color(0xFFEEA83B)))
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
