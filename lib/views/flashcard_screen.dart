import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:provider/provider.dart';

class FlashcardScreen extends StatelessWidget {
  final String deckID;
  // const FlashcardScreen({Key? key, required this.deckID}) : super(key: key);
  const FlashcardScreen({super.key, required this.deckID});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardViewModel>(builder: (context, viewModel, child) {
      final deckTitle = viewModel.getDeckTitle(deckID);
      viewModel.fetchDeckFlashcards(deckID);
      final deckFlashcards = viewModel.currentCards;
      int cardIndex = 0;

      return SafeArea(
          child: Scaffold(
        body: Column(
          children: [
            Text(deckTitle),
            SizedBox(height: 25),
            Center(
              child: FlipCard(
                frontWidget: FlashcardWidget(
                    content: deckFlashcards[cardIndex].cardFront),
                backWidget: FlashcardWidget(
                    content: deckFlashcards[cardIndex].cardBack),
                controller: FlipCardController(),
                rotateSide: RotateSide.left,
                onTapFlipping: true,
                axis: FlipAxis.horizontal,
              ),
            ),
            SizedBox(height: 10),
            Text("${cardIndex + 1} / ${viewModel.deckLength}"),
          ],
        ),
      ));
    });
  }
}
