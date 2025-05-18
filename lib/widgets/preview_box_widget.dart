import 'dart:io';

import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';

class PreviewBoxWidget extends StatelessWidget {
  final FlashcardModel card;
  const PreviewBoxWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Preview", style: mainTextTheme.displayMedium, textAlign: TextAlign.center,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                  child: card.frontImgPath != null
                      ? Image.file(File(card.frontImgPath!),
                          width: 200, height: 200)
                      : Container(),
                ),
                Text(card.cardFront ?? '',
                    style: mainTextTheme.displaySmall),
              ],
            ),
          ),
          SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                  child: card.backImgPath != null
                      ? Image.file(File(card.backImgPath!),
                          width: 200, height: 200)
                      : Container(),
                ),
                Text(card.cardBack ?? '',
                    style: mainTextTheme.displaySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}