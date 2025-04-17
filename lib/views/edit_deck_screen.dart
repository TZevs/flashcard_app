import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/viewmodels/edit_deck_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDeckScreen extends StatefulWidget {
  final DeckModel deck;
  const EditDeckScreen({super.key, required this.deck});

  @override
  State<EditDeckScreen> createState() => _EditDeckScreenState();
}

class _EditDeckScreenState extends State<EditDeckScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cardFrontController = TextEditingController();
  final TextEditingController _cardBackController = TextEditingController();

  void _showEditBox(BuildContext context, int index, FlashcardModel card,
      EditDeckViewmodel viewModel) {
    _cardFrontController.text = card.cardFront;
    _cardBackController.text = card.cardBack;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Edit Flashcard"),
              icon: IconButton(
                  alignment: Alignment.topRight,
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: _cardFrontController,
                      decoration: InputDecoration(
                        labelText: "Card Front",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: _cardBackController,
                      decoration: InputDecoration(
                        labelText: "Card Back",
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        viewModel.editFlashcard(
                            index,
                            _cardFrontController.text.isEmpty
                                ? card.cardFront
                                : _cardFrontController.text,
                            _cardBackController.text.isEmpty
                                ? card.cardBack
                                : _cardBackController.text);
                        Navigator.pop(context);
                      },
                      child: Text("Save"))
                ],
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<EditDeckViewmodel>(context, listen: false);
    viewModel.fetchDeckFlashcards(widget.deck.id);
    viewModel.deckToEdit = widget.deck;
    viewModel.deckTitle = widget.deck.title;
    viewModel.isPublic = widget.deck.isPublic;
    _titleController.text = viewModel.deckTitle;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cardFrontController.dispose();
    _cardBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditDeckViewmodel>(builder: (context, viewModel, child) {
      return SafeArea(
          child: Scaffold(
        appBar: AppbarWidget(
          title: "Edit Deck",
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(7.5),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Deck Title",
                  border: OutlineInputBorder(),
                ),
                onChanged: viewModel.setDeckTitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: SwitchListTile(
                  value: viewModel.isPublic,
                  title: Text(viewModel.setIsPublicLabel()),
                  onChanged: viewModel.setIsPublic),
            ),
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: TextField(
                controller: _cardFrontController,
                decoration: InputDecoration(
                  labelText: "Card Front",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: TextField(
                controller: _cardBackController,
                decoration: InputDecoration(
                  labelText: "Card Back",
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_cardFrontController.text.isNotEmpty &&
                      _cardBackController.text.isNotEmpty) {
                    viewModel.addFlashcard(
                        _cardFrontController.text, _cardBackController.text);

                    _cardFrontController.clear();
                    _cardBackController.clear();
                  }
                },
                child: Text("Add Flashcard")),
            Expanded(
                child: ListView.builder(
                    itemCount: viewModel.getFlashcards.length,
                    itemBuilder: (context, index) {
                      final item = viewModel.getFlashcards[index];
                      return Padding(
                        padding: const EdgeInsets.all(7.5),
                        child: ListTile(
                          title: Text(item.cardFront),
                          subtitle: Text(item.cardBack),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _showEditBox(
                                      context, index, item, viewModel)),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      viewModel.removeFlashcard(index)),
                            ],
                          ),
                        ),
                      );
                    })),
            ElevatedButton(
                onPressed: () {
                  viewModel.updateDeck();
                  viewModel.updateCards();
                  Navigator.pop(context);
                },
                child: Text("Update Deck")),
          ],
        ),
      ));
    });
  }
}
