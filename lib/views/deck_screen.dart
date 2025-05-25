import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/viewmodels/deck_viewmodel.dart';
import 'package:flashcard_app/views/create_deck_screen.dart';
import 'package:flashcard_app/views/flashcard_screen.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flashcard_app/widgets/deck_widget.dart';
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
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authVm = Provider.of<AuthViewModel>(context, listen: false);
      await authVm.waitUntilLoaded(); // wait for user & username to be ready

      Provider.of<DeckViewModel>(context, listen: false).fetchDecks();
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DeckViewModel>(context, listen: false);

    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    final crossAxisCount = isWideScreen ? 2 : 1;

    return SafeArea(
      child: Scaffold(
        appBar: AppbarWidget(
          title: viewModel.currentCategory == DeckCategory.myDecks
              ? "My Decks"
              : "Saved Decks",
          actions: [
            Switch(
                activeColor: Color(0xFFEEA83B),
                inactiveTrackColor: Color(0xFFEEA83B),
                inactiveThumbColor: Color(0xFF30253e),
                trackOutlineColor: WidgetStatePropertyAll(Color(0xFFEEA83B)),
                value: viewModel.currentCategory == DeckCategory.savedDecks,
                onChanged: (value) {
                  viewModel.switchCategory(
                    value ? DeckCategory.savedDecks : DeckCategory.myDecks,
                  );
                })
          ],
        ),
        body: Column(
          children: [
            Expanded(child:
                Consumer<DeckViewModel>(builder: (context, viewModel, _) {
              if (viewModel.currentCategory == DeckCategory.myDecks) {
                if (viewModel.decks.isEmpty) {
                  return Center(
                    child: Text(
                      "No Decks Available",
                      style: mainTextTheme.displaySmall,
                    ),
                  );
                }
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isWideScreen ? 3.5 : 2.8,
                    ),
                    itemCount: viewModel.decks.length,
                    itemBuilder: (context, index) {
                      final deck = viewModel.decks[index];
                      return DeckWidget(
                          deckListTile: ListTile(
                            leading: deck.isPublic
                                ? Icon(Icons.public)
                                : Icon(Icons.lock_outline),
                            title: Text(deck.title),
                            subtitle: Text("${deck.cardCount} Cards"),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        FlashcardScreen(deck: deck))),
                          ),
                          deck: deck,
                          deckIndex: index);
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
                viewModel.fetchSavedDecks();
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isWideScreen ? 3.5 : 2.8,
                    ),
                    itemBuilder: (context, index) {
                      final deck = viewModel.savedDecks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ListTile(
                          title: Text(deck.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text("By ${deck.username}"),
                              SizedBox(height: 3),
                              Text("${deck.cardCount} Cards"),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              viewModel.unSaveDeck(deck.id);
                              viewModel.fetchSavedDecks();
                            },
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      FlashcardScreen(deck: deck))),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreateDeckScreen()),
            ).then((_) {
              Provider.of<DeckViewModel>(context, listen: false).fetchDecks();
            });
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: NavbarWidget(),
      ),
    );
  }
}
