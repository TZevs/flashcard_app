import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDeckScreen extends StatefulWidget {
  const CreateDeckScreen({super.key});

  @override
  State<CreateDeckScreen> createState() => _CreateDeckScreenState();
}

class _CreateDeckScreenState extends State<CreateDeckScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cardFrontController = TextEditingController();
  final TextEditingController _cardBackController = TextEditingController();

  void _showEditBox(BuildContext context, int index, FlashcardModel card,
      NewDeckViewmodel viewModel) {
    _cardFrontController.text = card.cardFront;
    _cardBackController.text = card.cardBack;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Edit Flashcard"),
              icon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _cardFrontController,
                    decoration: InputDecoration(
                      labelText: "Card Front",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _cardBackController,
                    decoration: InputDecoration(
                      labelText: "Card Back",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        viewModel.editFlashcard(
                            index,
                            _cardFrontController.text,
                            _cardBackController.text);
                        Navigator.pop(context);
                      },
                      child: Text("Save"))
                ],
              ),
            ));
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
    return Consumer<NewDeckViewmodel>(
      builder: (context, viewModel, child) {
        return SafeArea(
            child: Scaffold(
          appBar: AppbarWidget(title: "New Deck"),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(7.5),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Deck Title",
                  ),
                  onChanged: viewModel.setDeckTitle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.5),
                child: SwitchListTile(
                    title: Text(viewModel.publicOrPrivateLabel),
                    value: viewModel.isPublic,
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
                      itemCount: viewModel.flashcards.length,
                      itemBuilder: (context, index) {
                        final item = viewModel.flashcards[index];
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
                    viewModel.addNewDeck();
                    Navigator.pop(context);
                  },
                  child: Text("Save Deck")),
            ],
          ),
        ));
      },
    );
  }
}
