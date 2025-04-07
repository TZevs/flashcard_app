import 'package:flashcard_app/models/flashcard_model.dart';
import 'package:flutter/material.dart';

class AddDeckScreen extends StatefulWidget {
  const AddDeckScreen({super.key});

  @override
  State<AddDeckScreen> createState() => _AddDeckScreen();
}

class _AddDeckScreen extends State<AddDeckScreen> {
  final _titleController = TextEditingController();
  final _cardFrontController = TextEditingController();
  final _cardBackController = TextEditingController();
  bool _isPublic = false;
  List<FlashcardModel> _tempFlashcards = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("New Deck"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Deck Title',
            ),
          ),
          SwitchListTile(
            title: Text("Make Public?"),
            value: _isPublic,
            onChanged: (bool value) => setState(() {
              _isPublic = value;
            }),
          ),
          TextField(
            controller: _cardFrontController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Card Front',
            ),
          ),
          TextField(
            controller: _cardBackController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Card Back',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (_cardFrontController.text.isNotEmpty &&
                    _cardBackController.text.isNotEmpty) {
                  setState(() {
                    _tempFlashcards.add(FlashcardModel(
                        deckId: 0,
                        cardFront: _cardFrontController.text,
                        cardBack: _cardBackController.text));
                  });
                  _cardFrontController.clear();
                  _cardBackController.clear();
                }
              },
              child: Text("Add Flashcard")),
          Expanded(
              child: ListView.builder(
                  itemCount: _tempFlashcards.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_tempFlashcards[index].cardFront),
                      subtitle: Text(_tempFlashcards[index].cardBack),
                      trailing: Row(
                        children: [
                          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _tempFlashcards.removeAt(index);
                                });
                              }),
                        ],
                      ),
                    );
                  })),
          ElevatedButton(onPressed: () {}, child: Text("Save Deck"))
        ],
      ),
    ));
  }
}
