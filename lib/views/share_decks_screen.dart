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
          final topTags = viewModel.getTopTags();
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
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: viewModel.tags.length,
                          itemBuilder: (context, index) {
                            final tag = viewModel.tags[index];
                            final isSelected = viewModel.selectedTag == tag;

                            return GestureDetector(
                              onTap: () {
                                viewModel.filterByTag(tag);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 6),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xFFEEA83B)
                                      : Color(0xFF30253e),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(2, 2)),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Color(0xFF30253e)
                                          : Color(0xFFEEA83B),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )),
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
                              alignment: AlignmentDirectional.center,
                              children: [
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
                                        : Icons.favorite_border,
                                    size: 40,
                                  ),
                                ),
                                Text(
                                  "${deck.savedCount}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
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
                              alignment: AlignmentDirectional.center,
                              children: [
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
                                        : Icons.favorite_border,
                                    size: 40,
                                  ),
                                ),
                                Text(
                                  "${deck.savedCount}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                if (!viewModel.isSearching && viewModel.selectedTag.isEmpty)
                  ...topTags.map((tag) {
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
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                    color: Color(0xFFEEA83B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: decks.length,
                            itemBuilder: (context, index) {
                              final deck = decks[index];
                              return Container(
                                width: 350,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xFF5c8966),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        deck.title,
                                        style: mainTextTheme.displayMedium,
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "By ${deck.username}",
                                        style: mainTextTheme.displaySmall,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Stack(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    viewModel.toggleSavedDeck(
                                                      deck.id,
                                                      userID,
                                                    );
                                                  },
                                                  icon: Icon(
                                                    viewModel.savedIDs
                                                            .contains(deck.id)
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text(
                                                  "${deck.savedCount}",
                                                  style: mainTextTheme
                                                      .displaySmall,
                                                ),
                                              ],
                                            ),
                                          ]),
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
