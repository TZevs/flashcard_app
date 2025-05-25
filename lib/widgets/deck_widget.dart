import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/viewmodels/deck_viewmodel.dart';
import 'package:flashcard_app/views/edit_deck_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DeckWidget extends StatelessWidget {
  final DeckModel deck;
  final int deckIndex;
  final Widget deckListTile;
  const DeckWidget(
      {super.key,
      required this.deckListTile,
      required this.deck,
      required this.deckIndex});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DeckViewModel>(context);

    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.blueAccent,
            spacing: 2,
            onPressed: (context) async {
              final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => EditDeckScreen(deck: deck)));

              if (updated == true) {
                viewModel.fetchDecks();
              }
            },
            icon: Icons.edit,
          ),
          SlidableAction(
            backgroundColor: Colors.redAccent,
            spacing: 2,
            onPressed: (context) => viewModel.removeDeck(deckIndex),
            icon: Icons.delete,
          ),
        ],
      ),
      child: deckListTile,
    );
  }
}
