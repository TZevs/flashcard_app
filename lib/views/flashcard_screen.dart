import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashcardScreen extends StatelessWidget {
  final String deckID;
  const FlashcardScreen({Key? key, required this.deckID}) : super(key: key);

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
            Center(
              child: Card(),
            ),
            Text("${cardIndex + 1} / ${viewModel.deckLength}"),
          ],
        ),
      ));
    });
  }
}
