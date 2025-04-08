import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDeckScreen extends StatelessWidget {
  const CreateDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController();
    final _cardFrontController = TextEditingController();
    final _cardBackController = TextEditingController();

    return Consumer<NewDeckViewmodel>(
      builder: (context, viewModel, child) {
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: Text("New Deck"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Deck Title",
                ),
                onChanged: viewModel.setDeckTitle,
              ),
              SwitchListTile(
                  title: Text("Make Public?"),
                  value: viewModel.isPublic,
                  onChanged: viewModel.setIsPublic),
              TextField(
                controller: _cardFrontController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Card Front",
                ),
              ),
              TextField(
                controller: _cardBackController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Card Back",
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
                      itemCount: viewModel.newFlashcards.length,
                      itemBuilder: (context, index) {
                        final item = viewModel.newFlashcards[index];
                        return ListTile(
                          title: Text(item.cardFront),
                          subtitle: Text(item.cardBack),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit), onPressed: () {}),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      viewModel.removeFlashcard(index)),
                            ],
                          ),
                        );
                      })),
              ElevatedButton(
                  onPressed: () {
                    viewModel.addNewDeck();
                    viewModel.reset();
                  },
                  child: Text("Save Deck")),
            ],
          ),
        ));
      },
    );
  }
}
