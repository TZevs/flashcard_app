import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:provider/provider.dart';

class FlashcardScreen extends StatelessWidget {
  final DeckModel deck;
  const FlashcardScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FlashcardViewModel>(context);
    viewModel.setOpenDeck(deck);
    viewModel.fetchDeckFlashcards(deck.id);
    final List<FlashcardModel> cards = viewModel.flashcards;

    return Scaffold(
      body: Consumer<FlashcardViewModel>(builder: (context, viewModel, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                viewModel.getDeckTitle,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Center(
              child: FlipCard(
                frontWidget: FlashcardWidget(content: cards[0].cardFront),
                backWidget: FlashcardWidget(content: cards[0].cardBack),
                controller: FlipCardController(),
                rotateSide: RotateSide.left,
                onTapFlipping: true,
                axis: FlipAxis.horizontal,
              ),
            ),
          ],
        );
      }),
    );
  }
}
