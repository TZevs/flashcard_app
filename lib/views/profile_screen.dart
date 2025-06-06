import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/viewmodels/profile_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _editBio(BuildContext context, ProfileViewmodel viewModel, String uid) {
    final TextEditingController _bioController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Edit Bio", style: mainTextTheme.displayMedium),
              icon: IconButton(
                  color: Color(0xFFEBE4C2),
                  alignment: Alignment.topRight,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _bioController.clear();
                    Navigator.pop(context);
                  }),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style: TextStyle(color: Color(0xFFEBE4C2)),
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: "Bio",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        viewModel.saveNewBio(_bioController.text, uid);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Update",
                        style: mainTextTheme.displaySmall,
                      )),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final viewModel = Provider.of<ProfileViewmodel>(context);
    viewModel.getBio;

    return SafeArea(
      child: Scaffold(
          appBar: AppbarWidget(
            title: "Profile",
            actions: [
              IconButton(
                  onPressed: () {
                    authViewModel.logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/landing_screen',
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          body:
              Consumer<ProfileViewmodel>(builder: (context, viewModel, child) {
            return Column(
              children: [
                Row(
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
                                        width: 95,
                                        height: 95,
                                        fit: BoxFit.cover)
                                    : Image.asset("imgs/profileDefaultImg.jpg",
                                        width: 95,
                                        height: 95,
                                        fit: BoxFit.cover),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  viewModel.galleryImg(authViewModel.userId!);
                                },
                                icon: Icon(Icons.add_a_photo,
                                    color: Color(0xFFEEA83B)))
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
                            Text(
                                viewModel.bio != "" ? viewModel.bio : "Add Bio",
                                style: mainTextTheme.displaySmall),
                            IconButton(
                                onPressed: () {
                                  _editBio(context, viewModel,
                                      authViewModel.userId!);
                                },
                                icon:
                                    Icon(Icons.edit, color: Color(0xFFEEA83B)))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFFEEA83B)),
                    foregroundColor: WidgetStatePropertyAll(Color(0xFF30253e)),
                    elevation: WidgetStatePropertyAll(10),
                  ),
                  onPressed: () async {
                    final email = authViewModel.userEmail;

                    if (email != null) {
                      await authViewModel.sendPasswordReset(email);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 0,
                        content: AwesomeSnackbarContent(
                          title: "Success",
                          message: "Password Reset Email Sent",
                          contentType: ContentType.success,
                        ),
                      ));
                    }
                  },
                  child: Text("Reset Password"),
                ),
              ],
            );
          })),
    );
  }
}
