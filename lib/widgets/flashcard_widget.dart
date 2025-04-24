import 'dart:io';

import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashcardWidget extends StatelessWidget {
  const FlashcardWidget({super.key, required this.content, this.img});
  final dynamic img;
  final String? content;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FlashcardViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          img != null
              ? Image.file(File(img), width: 300, height: 300)
              : Container(),
          Center(child: Text(content!, style: mainTextTheme.displayMedium)),
          IconButton(
              onPressed: () {
                viewModel.speak(content!);
              },
              icon: Icon(Icons.speaker)),
        ]),
      ),
    );
  }
}
