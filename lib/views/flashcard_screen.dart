import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:provider/provider.dart';

class FlashcardScreen extends StatefulWidget {
  final DeckModel deck;
  const FlashcardScreen({super.key, required this.deck});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<FlashcardViewModel>(context, listen: false);
    viewModel.fetchDeckFlashcards(widget.deck.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<FlashcardViewModel>(
        builder: (context, viewModel, child) {
          final DeckModel selectedDeck = widget.deck;
          final cards = viewModel.flashcards;

          if (cards.isEmpty) {
            return Center(
              child: CircularProgressIndicator(), // Show loading spinner
            );
          }

          // Show a message if no flashcards are found
          if (cards.isEmpty) {
            return Center(
              child: Text(
                'No flashcards available for this deck.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  viewModel.getDeckTitle(selectedDeck),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Center(
                child: FlipCard(
                  frontWidget: FlashcardWidget(
                      content: cards[viewModel.currentIndex].cardFront),
                  backWidget: FlashcardWidget(
                      content: cards[viewModel.currentIndex].cardBack),
                  controller: FlipCardController(),
                  rotateSide: RotateSide.left,
                  onTapFlipping: true,
                  axis: FlipAxis.horizontal,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
