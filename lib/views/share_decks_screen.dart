import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/viewmodels/share_decks_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareDecksScreen extends StatelessWidget {
  const ShareDecksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<AuthViewModel>(context).userId;
    final viewModel = Provider.of<ShareDecksViewmodel>(context);
    viewModel.getSavedIDs(userID!);
    viewModel.fetchPublicDecks();

    return SafeArea(
      child: Scaffold(
        appBar: AppbarWidget(title: "Share"),
        body:
            Consumer<ShareDecksViewmodel>(builder: (context, viewModel, child) {
          final tags = ['History', 'Psychology'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: SearchBar(
                    leading: Icon(Icons.search),
                    hintText: 'Search Decks',
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        viewModel.searchDecks(value.trim());
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                if (viewModel.isSearching || viewModel.selectedTag.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            viewModel.isSearching
                                ? "Search Results"
                                : "${viewModel.selectedTag} Decks",
                            style: mainTextTheme.displayMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            viewModel.clearFilterAndSearch();
                          },
                          child:
                              Text("Clear", style: mainTextTheme.displaySmall),
                        ),
                      ],
                    ),
                  ),
                if (viewModel.isSearching)
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: viewModel.searchResults.length,
                      itemBuilder: (context, index) {
                        final deck = viewModel.searchResults[index];
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: ListTile(
                            title: Text(deck.title),
                            subtitle: Text("By ${deck.username}"),
                            trailing: Stack(
                              children: [
                                Container(
                                  height: 3,
                                  width: 3,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    deck.savedCount != null
                                        ? deck.savedCount.toString()
                                        : "0",
                                    style: mainTextTheme.displaySmall,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      viewModel.toggleSavedDeck(
                                          deck.id, userID);
                                    },
                                    icon: Icon(
                                        viewModel.savedIDs.contains(deck.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border)),
                              ],
                            ),
                          ),
                        );
                      }),
                if (!viewModel.isSearching && viewModel.selectedTag.isNotEmpty)
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: viewModel
                          .getDecksForTag(viewModel.selectedTag)
                          .length,
                      itemBuilder: (context, index) {
                        final deck = viewModel
                            .getDecksForTag(viewModel.selectedTag)[index];
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: ListTile(
                            title: Text(deck.title),
                            subtitle: Text("By ${deck.username}"),
                            trailing: Stack(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      viewModel.toggleSavedDeck(
                                          deck.id, userID);
                                    },
                                    icon: Icon(
                                        viewModel.savedIDs.contains(deck.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border)),
                                Container(
                                  height: 3,
                                  width: 3,
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.all(2),
                                  child: Text(
                                      deck.savedCount != null
                                          ? deck.savedCount.toString()
                                          : "0",
                                      style: mainTextTheme.displaySmall),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                if (!viewModel.isSearching && viewModel.selectedTag.isEmpty)
                  ...tags.map((tag) {
                    final decks = viewModel.getDecksForTag(tag);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tag,
                                style: mainTextTheme.displaySmall,
                              ),
                              TextButton(
                                onPressed: () {
                                  viewModel.filterByTag(tag);
                                },
                                child: Text("View All",
                                    style: mainTextTheme.displaySmall),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: decks.length,
                            itemBuilder: (context, index) {
                              final deck = decks[index];
                              return Container(
                                width: 300,
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xFF5c8966),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        deck.title,
                                        style: mainTextTheme.displayMedium,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "By ${deck.username}",
                                        style: mainTextTheme.displaySmall,
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          viewModel.toggleSavedDeck(
                                            deck.id,
                                            userID,
                                          );
                                        },
                                        icon: Icon(
                                            viewModel.savedIDs.contains(deck.id)
                                                ? Icons.favorite
                                                : Icons.favorite_border),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
