import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
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

    // So that multiple notifierListeners() can be used in the same function.
    Future.microtask(() {
      final viewModel = Provider.of<FlashcardViewModel>(context, listen: false);
      viewModel.fetchDeckFlashcards(widget.deck.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<FlashcardViewModel>(
        builder: (context, viewModel, child) {
          final DeckModel selectedDeck = widget.deck;
          final cards = viewModel.flashcards;

          if (viewModel.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (cards.isEmpty) {
            return Center(
              child: Text(
                'No flashcards available for this deck.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // FlashcardModel currentCard = cards[viewModel.currentIndex];

          bool isSwiping = false;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  viewModel.getDeckTitle(selectedDeck),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Expanded(
                  child: GestureDetector(
                onHorizontalDragStart: (_) {
                  isSwiping = true;
                },
                onHorizontalDragEnd: (_) {
                  isSwiping = false;
                },
                child: PageView.builder(
                    controller:
                        PageController(initialPage: viewModel.currentIndex),
                    itemCount: viewModel.deckLength,
                    onPageChanged: viewModel.updateCurrentIndex,
                    itemBuilder: (context, index) {
                      FlashcardModel currentCard = cards[index];

                      return Center(
                        child: FlipCard(
                          frontWidget:
                              FlashcardWidget(content: currentCard.cardFront),
                          backWidget:
                              FlashcardWidget(content: currentCard.cardBack),
                          controller: FlipCardController(),
                          rotateSide: RotateSide.left,
                          onTapFlipping: !isSwiping,
                          axis: FlipAxis.horizontal,
                        ),
                      );
                    }),
              )),
            ],
          );
        },
      ),
    );
  }
}
