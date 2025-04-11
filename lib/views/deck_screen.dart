import 'package:flashcard_app/viewmodels/deck_viewmodel.dart';
import 'package:flashcard_app/views/create_deck_screen.dart';
import 'package:flashcard_app/views/flashcard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeckScreen extends StatefulWidget {
  const DeckScreen({super.key});

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<DeckViewModel>(context, listen: false);
    viewModel.fetchDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Decks"),
      ),
      body: Consumer<DeckViewModel>(builder: (context, viewModel, child) {
        if (viewModel.decks.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
            itemCount: viewModel.decks.length,
            itemBuilder: (context, index) {
              final deck = viewModel.decks[index];
              return ListTile(
                title: Text(deck.title),
                subtitle: Text("${deck.cardCount} Flashcards"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                    IconButton(icon: Icon(Icons.delete), onPressed: () {}),
                  ],
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => FlashcardScreen(deck: deck))),
              );
            });
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => CreateDeckScreen())),
      ),
    );
  }
}
