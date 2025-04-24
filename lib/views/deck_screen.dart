import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/viewmodels/deck_viewmodel.dart';
import 'package:flashcard_app/views/create_deck_screen.dart';
import 'package:flashcard_app/views/edit_deck_screen.dart';
import 'package:flashcard_app/views/flashcard_screen.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flashcard_app/widgets/navbar_widget.dart';
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
  void initState() {
    super.initState();
    Provider.of<DeckViewModel>(context, listen: false).fetchDecks();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DeckViewModel>(context);
    final userID = Provider.of<AuthViewModel>(context, listen: false).userId;

    return Scaffold(
      appBar: AppbarWidget(title: "Decks"),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  viewModel.currentCategory == DeckCategory.myDecks
                      ? "My Decks"
                      : "Saved Decks",
                  style: mainTextTheme.displayMedium,
                ),
                Switch(
                    value: viewModel.currentCategory == DeckCategory.savedDecks,
                    onChanged: (value) {
                      viewModel.switchCategory(
                        value ? DeckCategory.savedDecks : DeckCategory.myDecks,
                        userId: userID,
                      );
                    })
              ],
            ),
          ),
          Expanded(
              child: Consumer<DeckViewModel>(builder: (context, viewModel, _) {
            if (viewModel.currentCategory == DeckCategory.myDecks) {
              if (viewModel.decks.isEmpty) {
                return Center(
                  child: Text(
                    "No Decks Available",
                    style: mainTextTheme.displaySmall,
                  ),
                );
              }
              return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.decks.length,
                  itemBuilder: (context, index) {
                    final deck = viewModel.decks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        leading: deck.isPublic
                            ? Icon(Icons.public)
                            : Icon(Icons.lock_outline),
                        title: Text(deck.title),
                        subtitle: Text("${deck.cardCount} Cards"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  final updated = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            EditDeckScreen(deck: deck)),
                                  );
                                  if (updated == true) {
                                    viewModel.fetchDecks();
                                  }
                                }),
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
            } else {
              if (viewModel.savedDecks.isEmpty) {
                return Center(
                  child: Text(
                    "No Decks Saved",
                    style: mainTextTheme.displaySmall,
                  ),
                );
              }
              return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.savedDecks.length,
                  itemBuilder: (context, index) {
                    final deck = viewModel.savedDecks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ListTile(
                        leading: Text("${deck.cardCount}"),
                        title: Text(deck.title),
                        subtitle: Text("By ${deck.username}"),
                        trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                viewModel.unSaveDeck(deck.id, userID!)),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => FlashcardScreen(deck: deck))),
                      ),
                    );
                  });
            }
          }))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => CreateDeckScreen()))
              .then((_) => viewModel.fetchDecks());
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
