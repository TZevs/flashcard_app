import 'package:flashcard_app/models/deck_model.dart';
import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/viewmodels/edit_deck_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDeckScreen extends StatefulWidget {
  final DeckModel deck;
  const EditDeckScreen({super.key, required this.deck});

  @override
  State<EditDeckScreen> createState() => _EditDeckScreenState();
}

class _EditDeckScreenState extends State<EditDeckScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cardFrontController = TextEditingController();
  final TextEditingController _cardBackController = TextEditingController();

  void _showEditBox(BuildContext context, int index, FlashcardModel card,
      EditDeckViewmodel viewModel) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Edit Flashcard"),
              icon: IconButton(
                  alignment: Alignment.topRight,
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: _cardFrontController,
                      decoration: InputDecoration(
                        labelText: "Card Front",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: _cardBackController,
                      decoration: InputDecoration(
                        labelText: "Card Back",
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        viewModel.editFlashcard(
                            index,
                            _cardFrontController.text.isEmpty
                                ? card.cardFront!
                                : _cardFrontController.text,
                            _cardBackController.text.isEmpty
                                ? card.cardBack!
                                : _cardBackController.text);
                        Navigator.pop(context);
                      },
                      child: Text("Save"))
                ],
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<EditDeckViewmodel>(context, listen: false);
    viewModel.fetchDeckFlashcards(widget.deck.id);
    viewModel.deckToEdit = widget.deck;
    viewModel.deckTitle = viewModel.deckToEdit.title;
    viewModel.isPublic = viewModel.deckToEdit.isPublic;
    _titleController.text = viewModel.deckToEdit.title;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cardFrontController.dispose();
    _cardBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<AuthViewModel>(context).userId;
    final viewModel = Provider.of<EditDeckViewmodel>(context);

    return Scaffold(
      appBar: AppbarWidget(
        title: "Edit Deck",
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(7.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    style: TextStyle(color: Color(0xFFEBE4C2)),
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Deck Title",
                    ),
                    onChanged: viewModel.setDeckTitle,
                  ),
                  SizedBox(height: 10),
                  SwitchListTile(
                      value: viewModel.isPublic,
                      title: Text(viewModel.setIsPublicLabel()),
                      onChanged: viewModel.setIsPublic),
                  SizedBox(height: 10),
                  TextField(
                    controller: _cardFrontController,
                    decoration: InputDecoration(
                      labelText: "Card Front",
                    ),
                  ),
                  Container(
                    decoration: addImgContainer,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            color: Color(0xFFEEA83B),
                            onPressed: () {
                              viewModel.captureImg(isFront: true);
                            },
                            icon: Icon(Icons.camera_alt)),
                        IconButton(
                            color: Color(0xFFEEA83B),
                            onPressed: () {
                              viewModel.galleryImg(isFront: true);
                            },
                            icon: Icon(Icons.image)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _cardBackController,
                    decoration: InputDecoration(
                      labelText: "Card Back",
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: addImgContainer,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            color: Color(0xFFEEA83B),
                            onPressed: () {
                              viewModel.captureImg(isFront: false);
                            },
                            icon: Icon(Icons.camera_alt)),
                        IconButton(
                            color: Color(0xFFEEA83B),
                            onPressed: () {
                              viewModel.galleryImg(isFront: false);
                            },
                            icon: Icon(Icons.image)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        viewModel.addFlashcard(_cardFrontController.text,
                            _cardBackController.text);

                        _cardFrontController.clear();
                        _cardBackController.clear();
                      },
                      child: Text("Add Flashcard")),
                  Consumer<EditDeckViewmodel>(
                      builder: (context, viewModel, child) {
                    return Column(
                      children: [
                        ...viewModel.getFlashcards.map((item) {
                          int index = viewModel.getFlashcards.indexOf(item);
                          return Padding(
                            padding: const EdgeInsets.all(7.5),
                            child: ListTile(
                              title: Text(item.cardFront ?? ''),
                              subtitle: Text(item.cardBack ?? ''),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => _showEditBox(
                                          context, index, item, viewModel)),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () =>
                                          viewModel.removeFlashcard(index)),
                                ],
                              ),
                            ),
                          );
                        })
                      ],
                    );
                  }),
                  SizedBox(height: 80),
                ],
              ),
            ),
          )),
          Container(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
                onPressed: () async {
                  await viewModel.updateDeck(userID!);
                  viewModel.reset();
                  Navigator.pop(context, true);
                },
                child: Text("Update Deck")),
          ),
        ],
      ),
    );
  }
}
