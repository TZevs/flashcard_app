import 'package:flashcard_app/viewmodels/profile_viewmodel.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';

class BioEditBox extends StatefulWidget {
  final ProfileViewmodel vm;
  const BioEditBox({super.key, required this.vm});

  @override
  State<BioEditBox> createState() => _BioEditBoxState();
}

class _BioEditBoxState extends State<BioEditBox> {
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Edit Bio", style: mainTextTheme.displayMedium),
        SizedBox(height: 2),
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
              widget.vm.saveNewBio(_bioController.text);
              Navigator.pop(context);
            },
            child: Text(
              "Update",
              style: mainTextTheme.displaySmall,
            )),
      ],
    );
  }
}
