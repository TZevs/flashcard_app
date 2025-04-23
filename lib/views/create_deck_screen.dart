import 'dart:io';

import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flashcard_app/viewmodels/auth_viewmodel.dart';
import 'package:flashcard_app/viewmodels/new_deck_viewmodel.dart';
import 'package:flashcard_app/widgets/appbar_widget.dart';
import 'package:flashcard_app/widgets/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDeckScreen extends StatefulWidget {
  const CreateDeckScreen({super.key});

  @override
  State<CreateDeckScreen> createState() => _CreateDeckScreenState();
}

class _CreateDeckScreenState extends State<CreateDeckScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cardFrontController = TextEditingController();
  final TextEditingController _cardBackController = TextEditingController();

  void _showEditBox(BuildContext context, int index, FlashcardModel card,
      NewDeckViewmodel viewModel) {
    _cardFrontController.text = card.cardFront ?? '';
    _cardBackController.text = card.cardBack ?? '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Edit Flashcard",
                style: mainTextTheme.displayMedium,
              ),
              icon: IconButton(
                  color: Color(0xFFEBE4C2),
                  alignment: Alignment.topRight,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _cardFrontController.clear();
                    _cardBackController.clear();
                    Navigator.pop(context);
                  }),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style: TextStyle(color: Color(0xFFEBE4C2)),
                    controller: _cardFrontController,
                    decoration: InputDecoration(
                      labelText: "Card Front",
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    color: Color(0xFF5c8966),
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
                    style: TextStyle(color: Color(0xFFEBE4C2)),
                    controller: _cardBackController,
                    decoration: InputDecoration(
                      labelText: "Card Back",
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    color: Color(0xFF5c8966),
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
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        viewModel.editFlashcard(
                            index,
                            _cardFrontController.text,
                            _cardBackController.text);

                        _cardFrontController.clear();
                        _cardBackController.clear();
                        Navigator.pop(context);
                      },
                      child: Text("Save"))
                ],
              ),
            ));
  }

  void _ShowPreview(
      BuildContext context, FlashcardModel card, NewDeckViewmodel viewModel) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Preview",
                style: mainTextTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: card.frontImgPath != null
                              ? Image.file(File(card.frontImgPath!),
                                  width: 200, height: 200)
                              : Container(),
                        ),
                        Text(card.cardFront ?? '',
                            style: mainTextTheme.displaySmall),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: card.backImgPath != null
                              ? Image.file(File(card.backImgPath!),
                                  width: 200, height: 200)
                              : Container(),
                        ),
                        Text(card.cardBack ?? '',
                            style: mainTextTheme.displaySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ));
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
    final viewModel = Provider.of<NewDeckViewmodel>(context);

    return Scaffold(
      appBar: AppbarWidget(title: "New Deck"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(7.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      style: TextStyle(color: Color(0xFFEBE4C2)),
                      controller: _titleController,
                      decoration: InputDecoration(labelText: "Deck Title"),
                      onChanged: viewModel.setDeckTitle,
                    ),
                    SizedBox(height: 10),
                    SwitchListTile(
                      title: Text(viewModel.publicOrPrivateLabel),
                      value: viewModel.isPublic,
                      onChanged: viewModel.setIsPublic,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(color: Color(0xFFEBE4C2)),
                      controller: _cardFrontController,
                      decoration: InputDecoration(labelText: "Card Front"),
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
                      decoration: InputDecoration(labelText: "Card Back"),
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
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.addFlashcard(_cardFrontController.text,
                              _cardBackController.text);

                          _cardFrontController.clear();
                          _cardBackController.clear();
                        },
                        child: Text("Add Flashcard"),
                      ),
                    ),
                    Consumer<NewDeckViewmodel>(
                        builder: (context, viewModel, child) {
                      return Column(
                        children: [
                          ...viewModel.flashcards.map((item) {
                            int index = viewModel.flashcards.indexOf(item);
                            return Padding(
                              padding: const EdgeInsets.all(7.5),
                              child: ListTile(
                                onTap: () =>
                                    _ShowPreview(context, item, viewModel),
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
                          }),
                        ],
                      );
                    }),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () {
                viewModel.addNewDeck(userID!);
                Navigator.pop(context);
              },
              child: Text("Save Deck"),
            ),
          ),
        ],
      ),
    );
  }
}
