import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';

class FlashcardWidget extends StatelessWidget {
  const FlashcardWidget({required this.content});
  final dynamic content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        child: Center(child: Text(content, style: mainTextTheme.displayMedium)),
      ),
    );
  }
}
