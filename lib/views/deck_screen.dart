import 'package:flashcard_app/viewmodels/flashcard_viewmodel.dart';
import 'package:flashcard_app/views/create_deck_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeckScreen extends StatelessWidget {
  const DeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardViewModel>(builder: (context, viewModel, child) {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("Decks"),
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: viewModel.currentDecks.length,
                    itemBuilder: (context, index) {
                      final deck = viewModel.currentDecks[index];
                      return ListTile(
                        title: Text(deck.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(Icons.edit), onPressed: () {}),
                            IconButton(
                                icon: Icon(Icons.delete), onPressed: () {}),
                          ],
                        ),
                        onTap: () {},
                      );
                    })),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => CreateDeckScreen()))),
          ],
        ),
      ));
    });
  }
}
