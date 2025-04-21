import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashcardWidget extends StatelessWidget {
  const FlashcardWidget({required this.content});
  final dynamic content;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FlashcardViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(child: Text(content, style: mainTextTheme.displayMedium)),
          IconButton(
              onPressed: () {
                viewModel.speak(content);
              },
              icon: Icon(Icons.speaker))
        ]),
      ),
    );
  }
}
