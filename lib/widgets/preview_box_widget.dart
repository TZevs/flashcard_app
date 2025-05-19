import 'dart:io';

import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';

class PreviewBoxWidget extends StatelessWidget {
  final FlashcardModel card;
  const PreviewBoxWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (card.frontImgPath != null || card.frontImgUrl != null) 
            Image.file(File(card.frontImgPath ?? '')),
            
          Text("Front:", style: mainTextTheme.displayMedium),
          Text(card.cardFront ?? ''),

          SizedBox(height: 10),

          if (card.backImgPath != null || card.backImgUrl != null) 
            Image.file(File(card.backImgPath ?? '')),
            
          Text("Back:", style: mainTextTheme.displayMedium),
          Text(card.cardBack ?? ''),
        ]
      );
  }
}
