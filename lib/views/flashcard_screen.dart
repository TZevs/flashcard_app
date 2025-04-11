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
    // Delay to make sure context is available
    Future.microtask(() {
      final viewModel = Provider.of<FlashcardViewModel>(context, listen: false);
      viewModel.fetchDeckFlashcards(widget.deck.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FlashcardViewModel>(
        builder: (context, viewModel, child) {
          final cards = viewModel.flashcards;
          print(cards.length);
          print(cards);
          print(cards[0].cardFront);
          final DeckModel selctedDeck = widget.deck;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  viewModel.getDeckTitle(selctedDeck),
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
        },
      ),
    );
  }
}
