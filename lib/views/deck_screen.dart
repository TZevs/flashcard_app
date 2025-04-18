import 'package:flashcard_app/viewmodels/deck_viewmodel.dart';
import 'package:flashcard_app/views/create_deck_screen.dart';
import 'package:flashcard_app/views/edit_deck_screen.dart';
import 'package:flashcard_app/views/flashcard_screen.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeckScreen extends StatefulWidget {
  const DeckScreen({super.key});

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<DeckViewModel>(context, listen: false);
    viewModel.fetchDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: "Decks"),
      body: Consumer<DeckViewModel>(builder: (context, viewModel, child) {
        if (viewModel.decks.isEmpty) {
          return Center(
              child: Text(
            "No Decks Added",
            style: mainTextTheme.bodyMedium,
          ));
        }

        return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.decks.length,
            itemBuilder: (context, index) {
              final deck = viewModel.decks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: viewModel.isDeckPublic(index)
                      ? Icon(Icons.public)
                      : Icon(Icons.lock_outline),
                  title: Text(deck.title),
                  subtitle: Text("${viewModel.getCardCount(index)} Cards"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              EditDeckScreen(deck: deck)))
                                  .then((_) {
                                Provider.of<DeckViewModel>(context,
                                        listen: false)
                                    .fetchDecks();
                              })),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => viewModel.removeDeck(index)),
                    ],
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => FlashcardScreen(deck: deck))),
                ),
              );
            });
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => CreateDeckScreen())).then((_) {
          Provider.of<DeckViewModel>(context, listen: false).fetchDecks();
        }),
      ),
    );
  }
}
