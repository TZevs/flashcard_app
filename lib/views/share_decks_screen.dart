import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/viewmodels/share_decks_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareDecksScreen extends StatelessWidget {
  const ShareDecksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<AuthViewModel>(context).userId;
    final viewModel = Provider.of<ShareDecksViewmodel>(context);

    viewModel.fetchPublicDecks();
    return Scaffold(
      appBar: AppbarWidget(title: "Community"),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(10),
            child: SearchBar(
              leading: Icon(Icons.search),
              hintText: 'Search Decks',
              onSubmitted: (value) => viewModel.queryDecks(value),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Consumer<ShareDecksViewmodel>(
                builder: (context, viewModel, child) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.getPublicDecks.length,
                itemBuilder: (context, index) {
                  final deck = viewModel.getPublicDecks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(deck.title),
                      subtitle: Text("By ${deck.username}"),
                      trailing: Stack(
                        children: [
                          IconButton(
                              onPressed: () {
                                viewModel.saveDeck(deck.id, userID!);
                              },
                              icon: Icon(Icons.favorite_border)),
                          Container(
                            height: 5,
                            width: 5,
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.all(2),
                            child: Text(deck.savedCount.toString()),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
