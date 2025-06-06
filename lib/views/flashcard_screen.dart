import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flashcard_app/widgets/flashcard_widget.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

class FlashcardScreen extends StatefulWidget {
  final dynamic deck;
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
      viewModel.deck = widget.deck;
      viewModel.fetchDeckFlashcards(widget.deck.id);
      viewModel.fetchSavedFlashcards(widget.deck.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppbarWidget(),
        body: Consumer<FlashcardViewModel>(
          builder: (context, viewModel, child) {
            final dynamic selectedDeck = widget.deck;
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
                  style: mainTextTheme.displaySmall,
                ),
              );
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    viewModel.getDeckTitle(selectedDeck),
                    style: mainTextTheme.displayLarge,
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                  onHorizontalDragStart: (_) {
                    viewModel.isSwiping = true;
                  },
                  onHorizontalDragEnd: (_) {
                    viewModel.isSwiping = false;
                  },
                  child: PageView.builder(
                      controller:
                          PageController(initialPage: viewModel.currentIndex),
                      itemCount: viewModel.getDeckCardCount,
                      onPageChanged: viewModel.updateCurrentIndex,
                      itemBuilder: (context, index) {
                        FlashcardModel currentCard = cards[index];

                        return FlipCard(
                          frontWidget: FlashcardWidget(
                              content: currentCard.cardFront,
                              img: currentCard.frontImgPath ??
                                  currentCard.frontImgUrl),
                          backWidget: FlashcardWidget(
                              content: currentCard.cardBack,
                              img: currentCard.backImgPath ??
                                  currentCard.backImgUrl),
                          controller: FlipCardController(),
                          rotateSide: RotateSide.left,
                          onTapFlipping: !viewModel.isSwiping,
                          axis: FlipAxis.horizontal,
                        );
                      }),
                )),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Text(
                          "${viewModel.currentIndex + 1} / ${viewModel.getDeckCardCount}",
                          style: mainTextTheme.displaySmall),
                      LinearProgressBar(
                        maxSteps: viewModel.getDeckCardCount,
                        currentStep: viewModel.currentIndex + 1,
                        progressType: LinearProgressBar.progressTypeLinear,
                        backgroundColor: Color(0xFF30253e),
                        progressColor: Color(0xFFEEA83B),
                        minHeight: 15,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
