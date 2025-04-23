import 'package:flashcard_app/viewmodels/deck_viewmodel.dart';
import 'package:flashcard_app/views/create_deck_screen.dart';
import 'package:flashcard_app/views/share_decks_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(
        label: "",
        icon: IconButton(onPressed: () {}, icon: Icon(Icons.favorite_outline)),
      ),
      BottomNavigationBarItem(
        label: "",
        icon: IconButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => CreateDeckScreen()))
                  .then((_) =>
                      Provider.of<DeckViewModel>(context, listen: false)
                          .fetchDecks());
            },
            icon: Icon(Icons.add)),
      ),
      BottomNavigationBarItem(
        label: "",
        icon: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => ShareDecksScreen()));
            },
            icon: Icon(Icons.search)),
      ),
    ]);
  }
}
